Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaJATuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:50:20 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:35873 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaJATuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net>
References: <cover.1412189265.git.luto@amacapital.net> <395749a5d39a29bd3e4b35899cf3a3c1340e5595.1412189265.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 Oct 2014 12:49:56 -0700
Message-ID: <CALCETrUPqT3WR9-B4mjS791i+nK0ApDyqf9dr0cB_vSRAbgDGQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
To: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 11:49 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> The NT flag doesn't do anything in long mode other than causing IRET
> to #GP.  Oddly, CPL3 code can still set NT using popf.
>

[...]

> +
> +       /*
> +        * Sysenter doesn't filter flags, so we need to clear NT
> +        * ourselves.  To save a few cycles, we can check whether
> +        * NT was set instead of doing an unconditional popfq.
> +        */
> +       testl $X86_EFLAGS_NT,EFLAGS(%rsp)       /* saved EFLAGS match cpu */
> +       jnz sysenter_fix_flags
> +sysenter_flags_fixed:
> +

Because this thread hasn't gone on long enough:

Do we need to clear IOPL here, too?  With patch 2 applied, an IOPL !=
0 program can leak IOPL into another task.  It should be cleared on
iret, sysexit (via popf) and sysret (directly), so this shouldn't
matter.  Am I missing something?

Adding IOPL to the test will add no overhead for non-iopl-using tasks,
but it will slighly slow down 32-bit tasks that use iopl.

--Andy
