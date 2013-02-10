Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3BJOKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 09:10:17 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:56025 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab3BJOKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 09:10:15 -0500
MIME-Version: 1.0
In-Reply-To: <1359714465-6297-3-git-send-email-zhong@linux.vnet.ibm.com>
References: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
	<1359714465-6297-3-git-send-email-zhong@linux.vnet.ibm.com>
Date: Sun, 10 Feb 2013 15:10:13 +0100
Message-ID: <CAFTL4hzfXfCGDjwjW=Frcs5+jS_i3U_JHytNOEhEF5X7_Fw6Sg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] powerpc: Exception hooks for context tracking subsystem
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/1 Li Zhong <zhong@linux.vnet.ibm.com>:
> This is the exception hooks for context tracking subsystem, including
> data access, program check, single step, instruction breakpoint, machine check,
> alignment, fp unavailable, altivec assist, unknown exception, whose handlers
> might use RCU.
>
> This patch corresponds to
> [PATCH] x86: Exception hooks for userspace RCU extended QS
>   commit 6ba3c97a38803883c2eee489505796cb0a727122
>
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>

Looks good!

I guess we should move exception_enter/exit definition to the generic
code. They should be the same for all archs after all. Also we are
relying on user_mode(regs) but this may be buggy with some corner
cases. For example if an exception happen after a call to user_exit()
(on syscall exit) but before we actually resume in userspace, the
exception will exit in kernel mode from the context tracking POV.

So instead on relying on the regs, which are not sync with the context
tracking state, we should use something like:

prev_state = exception_enter();
...
exception_exit(prev_state);

Also preempt_schedule_irq() is concerned as well by this problem. So I
should convert it to that scheme as well. I'm going to prepare some
patches.

Feel free to merge this patch in the powerpc tree, I'll do the
conversion along the way.

Thanks.
