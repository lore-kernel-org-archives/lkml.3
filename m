Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3DVQFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:05:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42387 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3DVQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:05:45 -0400
Message-ID: <51755FD5.6070109@linaro.org>
Date: Mon, 22 Apr 2013 09:05:41 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Resume does not work after timekeeping change
References: <5172B86C.5030606@suse.cz>
In-Reply-To: <5172B86C.5030606@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2013 08:46 AM, Jiri Slaby wrote:
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
>      timekeeping: Delay update of clock->cycle_last
>
>
> Reverting that one on the top of -next-20130419 makes it work again.
>
>
> I also tried it inside a VM using suspend to disk. There, it behaves
> like it takes a minute or so to wake up. So I tried to wait on the real
> HW too, but it never resumes there.

Thanks for chasing this down! Sorry for the trouble, does the following fix resolve this?

thanks
-john

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 675f720..94041a9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -952,6 +952,7 @@ static void timekeeping_resume(void)
  
  	/* Re-base the last cycle value */
  	clock->cycle_last = cycle_now;
+	tk->cycle_last = cycle_now;
  	tk->ntp_error = 0;
  	timekeeping_suspended = 0;
  	timekeeping_update(tk, false, true);

