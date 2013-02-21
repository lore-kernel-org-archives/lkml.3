Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3BURx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:53:56 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:63071 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3BURxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302202155320.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302202155320.22263@ionos>
Date: Thu, 21 Feb 2013 09:53:48 -0800
X-Google-Sender-Auth: 8eLozlU383Qbirs59xexqC7IblQ
Message-ID: <CA+55aFwTFOsRTX3pHeZ+664rAms-Liwco3scEPJum6=C3BCoEQ@mail.gmail.com>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 1:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>   */
>  void irq_exit(void)
>  {
> +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +#else
> +       BUG_ON(!irqs_disabled();
> +#endif

Guys, STOP DOING THIS!

Adding BUG_ON()'s just makes things much much much worse. There is
*never* a reason to add a BUG_ON(). And doing it in an interrupt path
is totally unacceptable. BUG_ON() makes it almost impossible to debug
something, because you just killed the machine. So using BUG_ON() for
"please notice this" is stupid as hell, because the most common end
result is: "Oh, the machine just hung with no messages".

Make it WARN_ON_ONCE() if you absolutely have to let people know, but
for something like this, why would you do even that?

                          Linus
