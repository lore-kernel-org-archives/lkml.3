Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab3EBMsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:48:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35759 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab3EBMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:48:28 -0400
Date: Thu, 2 May 2013 14:48:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130502124826.GE22618@amd.pavel.ucw.cz>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-4-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367271946-7239-4-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-04-29 14:45:39, Colin Cross wrote:
> Freezing tasks will wake up almost every userspace task from
> where it is blocking and force it to run until it hits a
> call to try_to_sleep(), generally on the exit path from the syscall
> it is blocking in.  On resume each task will run again, usually
> restarting the syscall and running until it hits the same
> blocking call as it was originally blocked in.

Ok, so you are optimizing suspend at the cost of runtime operations,
right?

Would it make sense to do suspends entirely without freezer in your
configurations? With the right drivers, it should work ok.

Actually, would it make sense to simply enter deep idle and do runtime
powersaving in the drivers... n900 does that rather successfully and
it is certainly cleaner design.

> +/* Like schedule_timeout(), but should not block the freezer. */
> +#define freezable_schedule_timeout(timeout)				\
> +({									\
> +	long __retval;							\
> +	freezer_do_not_count();						\
> +	__retval = schedule_timeout(timeout);				\
> +	freezer_count();						\
> +	__retval;							\
> +})

You plan to use this a lot during normal operation, right? Is it going
to have some measureable impact?

Also, why not static inline?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
