Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3HVTg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:36:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38387 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab3HVTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:36:28 -0400
Message-ID: <52166839.80004@linaro.org>
Date: Thu, 22 Aug 2013 12:36:25 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] ntp: Make periodic RTC update more reliable
References: <1375378295-3858-1-git-send-email-mlichvar@redhat.com>
In-Reply-To: <1375378295-3858-1-git-send-email-mlichvar@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 10:31 AM, Miroslav Lichvar wrote:
> The current code requires that the scheduled update of the RTC happens
> in the closest tick to the half of the second. This seems to be
> difficult to achieve reliably. The scheduled work may be missing the
> target time by a tick or two and be constantly rescheduled every second.
>
> Relax the limit to 10 ticks. As a typical RTC drifts in the 11-minute
> update interval by several milliseconds, this shouldn't affect the
> overall accuracy of the RTC much.
>
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
> ---
>  kernel/time/ntp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 8f5b3b9..ab1fa7c 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -475,6 +475,7 @@ static void sync_cmos_clock(struct work_struct *work)
>  	 * called as close as possible to 500 ms before the new second starts.
>  	 * This code is run on a timer.  If the clock is set, that timer
>  	 * may not expire at the correct time.  Thus, we adjust...
> +	 * We want the clock to be within a couple of ticks from the target.
>  	 */
>  	if (!ntp_synced()) {
>  		/*
> @@ -485,7 +486,7 @@ static void sync_cmos_clock(struct work_struct *work)
>  	}
>  
>  	getnstimeofday(&now);
> -	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
> +	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
>  		struct timespec adjust = now;
>  
>  		fail = -ENODEV;

Applied to my 3.12 branch.

thanks
-john
