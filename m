Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaI3Uip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:38:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35334 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaI3Uin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:38:43 -0400
Date: Tue, 30 Sep 2014 22:38:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joseph Swantek <joseph.swantek@motorola.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / suspend: Catch wake-up requests in suspend_again
Message-ID: <20140930203839.GA14283@amd>
References: <CACB9iXzNUA5+kLkDC=_w2PLB9TkLSXwxsesbL5pJbOrkYYYwLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACB9iXzNUA5+kLkDC=_w2PLB9TkLSXwxsesbL5pJbOrkYYYwLA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-09-26 17:44:24, Joseph Swantek wrote:
> It is possible during the processing of suspend_again() that a
> wake-up request (i.e. pm_stay_awake()) be made by a driver in response
> to an outside event (i.e. hw interrupt, etc.). Currently, when
> suspend_again() requests to re-enter suspend, suspend_enter() runs
> to re-enter suspend. The pm_wakeup_pending() function is called to check
> for any wake-up requests. However, this function is essentially disabled
> because the events_check_enabled flag is set to false by the previous
> run through suspend_enter(). This causes any wake-up request made
> during the processing of suspend_again() to be delayed until the next
> time the kernel resumes sometime in the future.
> 
> To resolve this issue, if suspend_again() votes to re-enter
> suspend_enter() the count of wake-up requests is re-evaluated
> and the events_check_enabled flag set correctly based on the
> presence of wake-up requests that occurred during suspend_again().
> 

> @@ -188,8 +188,25 @@ static void platform_suspend_recover(suspend_state_t
> state)
> 
>  static bool platform_suspend_again(suspend_state_t state)
>  {
> - return state != PM_SUSPEND_FREEZE && suspend_ops->suspend_again ?
> + int count;
> + bool suspend = state != PM_SUSPEND_FREEZE &&
> + suspend_ops->suspend_again ?
>   suspend_ops->suspend_again() : false;
> +
> + if (suspend) {
> + /*
> + * pm_get_wakeup_count() gets an updated count of wakeup events
> + * that have occured and will return false (i.e. abort suspend)
> + * if a wakeup event has been started during suspend_again() and
> + * is still active. pm_save_wakeup_count() stores the count
> + * and enables pm_wakeup_pending() to properly analyze wakeup
> + * events before entering suspend in suspend_enter().
> + */
> + suspend = pm_get_wakeup_count(&count, false) &&
> +  pm_save_wakeup_count(count);
> + }
> +
> + return suspend;
>  }

That seems rather whitespace damaged.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
