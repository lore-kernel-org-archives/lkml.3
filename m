Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3AROf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:35:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:59095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AROf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:35:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 17/76] ARC: Process-creation/scheduling/idle-loop
Date: Fri, 18 Jan 2013 14:35:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Frederic Weisbecker" <fweisbec@gmail.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-18-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-18-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181435.15491.arnd@arndb.de>
X-Provags-ID: V02:K0:k0sXq+U3pG6A5lKco5sMDiv3fBafQr1ZZsYwd8d8KyU
 ccAzIQkoGKrT2wrXUgBcOWPswAJq5cT+YUNNZpAYWd6JnY5wa3
 ELEMtHKLg7nO+DbiDGjUDDRvTwpp45sI5vPcht6VCWJDnf0mIb
 2Jlo+c9HNf7By8YPbElYQ4PMvLkjHq+nMideeaABbOXhKlaEDU
 JvAma2K4IKFh2SI3a23lVN5o6BCKEUIjL5oRSzZ/vQT2lPIdil
 AgPqhSmuwZaQ8xVcn58yatUBrtjwoQxDq6dOwvVitfIMAuhxEU
 Edq1CbLoS6QvDhAxIELOjuBNXBdIeHyx+pa9HX0R2rJAJ1ir/m
 3V/48SOv+GaRt3KGU+W0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> +void cpu_idle(void)
> +{
> +       /* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
> +
> +       /* endless idle loop with no priority at all */
> +       while (1) {
> +               tick_nohz_idle_enter();
> +               rcu_idle_enter();
> +
> +               while (!need_resched())
> +                       arch_idle();
> +
> +               rcu_idle_exit();
> +               tick_nohz_idle_exit();
> +
> +               schedule_preempt_disabled();
> +       }
> +}

Unless I'm mistaken, you have introduced the classic sleep race
here, where an interrupt can happen between the check for
need_resched() and the sleep instruction in arch_idle().

To avoid that, you need to disable interrupts around
the inner loop. The sleep instruction should return with
interrupts implicitly enabled if ARC behaves like most
other architectures doing this.

	Arnd
