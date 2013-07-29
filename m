Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3G2KSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:18:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:45474 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3G2KSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:18:15 -0400
Date: Mon, 29 Jul 2013 12:18:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "ethan.zhao" <ethan.kernel@gmail.com>
cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        johlstei@codeaurora.org, yinghai@kernel.org, joe.jin@oracle.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer 
In-Reply-To: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
Message-ID: <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jul 2013, ethan.kernel@gmail.com wrote:

> commit 968320b hrtimer: Fix extra wakeups from __remove_hrtimer()
> introduced a significant scheduler performance regression,
> following is the test:

This is not a commit in Linus tree. Which kernel version are you
talking about?

> We found the performance has 1.87775S(average value) down introduced
> by commit 968320b hrtimer: Fix extra wakeups from
> __remove_hrtimer().  That is more than -35% !

The test case does not involve anything hrtimer related. Do you have
CONFIG_SCHED_HRTICK enabled?

> So reprogramming in remove_hrtimer() is not necessary-----If I am
> wrong, just point out.

The reason why we want to do that is: 

    timer      expiry time
    A	        100us -> programmed hardware event
    B	       2000us

Restart timer A with an expiry time of 3000us without reprogramming:

    timer      expiry time
    NONE       100us -> programmed hardware event
    B	       2000us
    A	       3000us

We take an extra wakeup for reprogramming the hardware, which is
counterproductive for power saving. So disabling it blindly will cause
a regresssion for other people. We need to be smarter than that.

First of all we want to know, which particular hrtimer is causing that
issue. If it is the hrtick one, then I really have to ask why you want
to use it at all in such a high performance scenario.

Thanks,

	tglx



