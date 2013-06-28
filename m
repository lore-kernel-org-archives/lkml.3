Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3F1MWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:22:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:45962 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3F1MWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:22:19 -0400
Date: Fri, 28 Jun 2013 14:22:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
cc: prarit@redhat.com, john.stultz@linaro.org,
        hiroyuki.yokoyama.vx@renesas.com, takashi.yoshii.zj@renesas.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: hrtimer: one more expiry time overflow check in
 hrtimer_interrupt
In-Reply-To: <51B6D4C4.9080400@renesas.com>
Message-ID: <alpine.DEB.2.02.1306281416080.4013@ionos.tec.linutronix.de>
References: <51B6D4C4.9080400@renesas.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013, Shinya Kuribayashi wrote:

> When executing a date command to set the system date and time to a few
> seconds before the 2038 problem expiration time, we got a WARN_ON_ONCE()
> like this:
> 
>   root@renesas:~# date -s "2038-1-19 3:14:00"
>   Tue Jan 19 03:14:00 GMT 2038
>   (then wait for 7-8 seconds)
>   root@renesas:~# [   27.662658] ------------[ cut here ]------------
>   [   27.667297] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x3c/0x138()

> I found a similar issue fixed in v3.9 by Prarit Bhargava in commit
> 8f294b5a13 (hrtimer: Add expiry time overflow check in hrtimer_interrupt,
> 2013-04-08).  It tried to resolve a overflow issue detected around 1970
> + 100 seconds.
> 
> On the other hand, we have another call site of tick_program_event() at
> the bottom of hrtimer_interrupt().  The warning this time is triggered
> there, so we need to apply the same fix to it.

Well, the problem is that you are just papering over the underlying
issue of 32bit systems not being prepared for the year 2038 issue.

Just blindly silencing the warning is not going to make the system
survive 2038 in any sane way. All timespec/val related time functions
dealing with the clock realtime domain are simply broken in 2038 on
32bit, so it does not matter whether a warning triggers or not.
 
We really need to tackle the underlying problem and not bandaiding a
known to be broken system.

Thanks,

	tglx
