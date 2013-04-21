Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3DUOsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 10:48:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:54688 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3DUOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 10:48:52 -0400
Date: Sun, 21 Apr 2013 16:48:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Slaby <jslaby@suse.cz>
cc: John Stultz <john.stultz@linaro.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume does not work after timekeeping change
In-Reply-To: <5172B86C.5030606@suse.cz>
Message-ID: <alpine.LFD.2.02.1304211648150.21884@ionos>
References: <5172B86C.5030606@suse.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Apr 2013, Jiri Slaby wrote:
> Hi,
> 
> my machine does not wake from suspend to RAM on my box running the -next
> kernel. The last thing I see is "Disabling non-boot CPUs ...". I
> bisected it to this commit:
> 
> commit 7ec98e15aa049b7a2ca73485f31cf4f90c34e2dd
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Feb 21 22:51:39 2013 +0000
> 
>     timekeeping: Delay update of clock->cycle_last
> 
> 
> Reverting that one on the top of -next-20130419 makes it work again.

Does the patch below fix the issue?

Thanks,

	tglx
---
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 675f720..98cd470 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -951,7 +951,7 @@ static void timekeeping_resume(void)
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
 
 	/* Re-base the last cycle value */
-	clock->cycle_last = cycle_now;
+	tk->cycle_last = clock->cycle_last = cycle_now;
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, false, true);
