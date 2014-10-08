Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaJHRrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:47:12 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:42850 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaJHRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:47:10 -0400
Date: Wed, 8 Oct 2014 12:47:05 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        yrl.pp-manager.tt@hitachi.com, Borislav Petkov <bpetkov@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141008124705.793d652d@as>
In-Reply-To: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2014 10:03:36 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> and adding that back into the current build, e.g.
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 3632743..48a8a69 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -87,6 +87,7 @@ config X86
>         select HAVE_USER_RETURN_NOTIFIER
>         select ARCH_BINFMT_ELF_RANDOMIZE_PIE
>         select HAVE_ARCH_JUMP_LABEL
> +       select STOP_MACHINE
>         select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>         select SPARSE_IRQ
>         select GENERIC_FIND_FIRST_BIT
> 
> fixes the regression.
> 

Looking closer at this, it seems most configs work by accident,
because they have MOD_UNLOAD and/or HOTPLUG_CPU enabled. I take it
you disabled both of those? stop_machine() is called from all kinds
of places and almost none of them make sure STOP_MACHINE is selected.

$ find -name Kconf\* | xargs grep STOP_MACHINE
./init/Kconfig:config STOP_MACHINE

All these places use stop_machine():

    mm/page_alloc.c, line 3886
    drivers/xen/manage.c, line 130
    drivers/char/hw_random/intel-rng.c, line 373
    arch/powerpc/mm/numa.c:
        line 1616
        line 1623 
    arch/powerpc/platforms/powernv/subcore.c, line 324
    arch/arm/kernel/kprobes.c, line 165
    arch/arm/kernel/patch.c:
        line 64
        line 71 
    arch/s390/kernel/jump_label.c, line 61
    arch/s390/kernel/kprobes.c:
        line 311
        line 320 
    arch/s390/kernel/time.c:
        line 820
        line 1590 
    arch/x86/kernel/cpu/mtrr/main.c, line 231
    arch/arm64/kernel/insn.c, line 181
    kernel/time/timekeeping.c, line 892
    kernel/trace/ftrace.c, line 2219
    kernel/module.c:
        line 770
        line 1861 
