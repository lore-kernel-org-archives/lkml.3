Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3BUTtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:49:02 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:50343 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3BUTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:49:00 -0500
MIME-Version: 1.0
In-Reply-To: <tip-630e7580f681475d92d87e78373e4136096e12f2@git.kernel.org>
References: <alpine.LFD.2.02.1302202155320.22263@ionos>
	<tip-630e7580f681475d92d87e78373e4136096e12f2@git.kernel.org>
Date: Thu, 21 Feb 2013 20:48:58 +0100
Message-ID: <CAFTL4hzCWpCdx0=8M5+VjNZvfCKb=9sGX=_9dU=20rW6nag6Dw@mail.gmail.com>
Subject: Re: [tip:irq/urgent] irq: Ensure irq_exit() code runs with interrupts disabled
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        torvalds@linuxfoundation.org, peterz@infradead.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/21 tip-bot for Thomas Gleixner <tipbot@zytor.com>:
> Commit-ID:  630e7580f681475d92d87e78373e4136096e12f2
> Gitweb:     http://git.kernel.org/tip/630e7580f681475d92d87e78373e4136096e12f2
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 20 Feb 2013 22:00:48 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Thu, 21 Feb 2013 18:32:44 +0100
>
> irq: Ensure irq_exit() code runs with interrupts disabled
>
> We had already a few problems with code called from irq_exit() when
> interrupted from a nesting interrupt. This can happen on architectures
> which do not define __ARCH_IRQ_EXIT_IRQS_DISABLED.
>
> __ARCH_IRQ_EXIT_IRQS_DISABLED should go away and we want to make it
> mandatory to call irq_exit() with interrupts disabled.
>
> As a temporary protection disable interrupts for those architectures
> which do not define __ARCH_IRQ_EXIT_IRQS_DISABLED and add a WARN_ONCE
> when an architecture which defines __ARCH_IRQ_EXIT_IRQS_DISABLED calls
> irq_exit() with interrupts enabled.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Linus Torvalds <torvalds@linuxfoundation.org>
> Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1302202155320.22263@ionos
>
> ---
>  kernel/softirq.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index f5cc25f..d1f7943 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -341,6 +341,14 @@ static inline void invoke_softirq(void)
>   */
>  void irq_exit(void)
>  {
> +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +#else
> +       WARN_ON_ONCE(!irqs_disabled();

Missing closing parenthesis.
