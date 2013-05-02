Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3EBXzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:55:13 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:33578 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3EBXzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:55:11 -0400
Date: Thu, 2 May 2013 16:55:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130502235505.GW19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
 <1367458508-9133-4-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367458508-9133-4-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 01, 2013 at 06:35:01PM -0700, Colin Cross wrote:
> To allow tasks to avoid running on every suspend/resume cycle,
> this patch adds additional freezable wrappers around blocking calls
> that call freezer_do_not_count().  Combined with the previous patch,
> these tasks will not run during suspend or resume unless they wake
> up for another reason, in which case they will run until they hit
> the try_to_freeze() in freezer_count(), and then continue processing
> the wakeup after tasks are thawed.  This patch also converts the
> existing wait_event_freezable* wrappers to use freezer_do_not_count().

I'd much prefer the latter part being a separate patch because the
change isn't really trivial and it isn't exactly equivalent - before
we prioritized meeting the condition over freezing, now it's the other
way around.  It's fine but does deserve description in the log so that
if something gets tracked down to the commit, it's easy to tell how
the behavior flipped and why.

> +/* Like schedule_timeout(), but should not block the freezer. */
> +#define freezable_schedule_timeout(timeout)				\
> +({									\
> +	long __retval;							\
> +	freezer_do_not_count();						\
> +	__retval = schedule_timeout(timeout);				\
> +	freezer_count();						\
> +	__retval;							\
> +})
> +
> +/* Like schedule_timeout_interruptible(), but should not block the freezer. */
> +#define freezable_schedule_timeout_interruptible(timeout)		\
> +({									\
> +	long __retval;							\
> +	freezer_do_not_count();						\
> +	__retval = schedule_timeout_interruptible(timeout);		\
> +	freezer_count();						\
> +	__retval;							\
> +})
...
> +/* Like schedule_hrtimeout_range(), but should not block the freezer. */
> +#define freezable_schedule_hrtimeout_range(expires, delta, mode)	\
> +({									\
> +	int __retval;							\
> +	freezer_do_not_count();						\
> +	__retval = schedule_hrtimeout_range(expires, delta, mode);	\
> +	freezer_count();						\
> +	__retval;							\
> +})

(cc'ing Jeff Layton)

So, one worry that I have about this is that freezer essentially
behaves like a huge lock that everyone grabs and while scattering
try_to_freeze() calls around might seem innocuous, it effectively
adding a dependency to that single giant lock to that place, so
whenever you're adding try_to_freeze() call while holding any kind of
locks, it substiantially increases the chance of possible deadlock
scenarios.  NFS recently got bitten by it and now is trying to get rid
of them as it's fundamentally broken.

So, the freezable interface can't be something that people can use
casually.  It is something which should be carefully and strategically
deployed where we *know* that lock dependency risks don't exist or at
least are acceptable.  I'm a bit weary that this patch is expanding
the interface a lot that they now look like the equivalents of normal
schedule calls.  Not exactly sure what to do here but can we please at
least have RED BOLD BLINKING comments which scream to people not to
use these unless they know what they're doing?

Thanks.

-- 
tejun
