Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaBSQmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:42:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:52969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaBSQmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:42:00 -0500
Date: Wed, 19 Feb 2014 17:42:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: henrik@austad.us
cc: LKML <linux-kernel@vger.kernel.org>, Henrik Austad <haustad@cisco.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH Resend] Expose do_timer CPU via sysctl to userspace as
 R/W
In-Reply-To: <1392813178-25095-1-git-send-email-henrik@austad.us>
Message-ID: <alpine.DEB.2.02.1402191730590.4468@ionos.tec.linutronix.de>
References: <1392813178-25095-1-git-send-email-henrik@austad.us>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, henrik@austad.us wrote:
> From: Henrik Austad <haustad@cisco.com>
> 
> Looks like this got dropped by vger a few days ago, resending.
> 
> This allows everybody in a system to read which core is currently
> running do_timer() as well as letting root change this.
> 
> A few things to keep in mind
> 
> - This is intended as a debug-feature, except for testing whether or not
>   the target CPU is present or not, the logic will not care -one- bit if
>   moving the do_timer to that particular CPU is a good idea.

Well at least it must check that the cpu is online and neither in
nohz idle nor nohz full mode.

And we probably want to have that in sysfs with two files:

    timekeeping/current_cpu
    timekeeping/forced_cpu

The latter contains -1 when the system boots and if you write to it,
the duty gets hard assigned to that core, which in turn makes it
blocked from NOHZ idle and NOHZ full modes. If the core goes offline,
then the value must got back to -1. Writing -1 to it undoes the hard
assignment.

> - It introduces more ifdeffery in the kernel.

There is no reason to do that.

Thanks,

	tglx
