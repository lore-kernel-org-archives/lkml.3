Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3CEDyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:54:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:24537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542Ab3CEDyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:54:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="264390755"
Date: Tue, 5 Mar 2013 11:53:02 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 0/4] Add support for S3 non-stop TSC support.
Message-ID: <20130305035302.GA5239@feng-snb>
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362450426-4232-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Thanks for the review and suggestions!

On Mon, Mar 04, 2013 at 08:20:36PM -0700, Jason Gunthorpe wrote:
> On Tue, Mar 05, 2013 at 02:34:25AM +0000, Tang, Feng wrote:
> > Hi Jason,
> > 
> > Sorry, I forgot to add you in cc list in the first place. Please
> > help to review the patch series, thanks!
> 
> Sure, I didn't get CC'd on the patches, so this is an imperfect reply,
> but..

I've copied your comments back to the main thread.

> 
> Did you consider an approach closer to the function I outlined to
> Jonh:
> 
> // Drops some small precision along the way but is simple..
> static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
>                                           cycle_t cycles)
> {
>     u64 max = U64_MAX/cc->mult;
>     u64 num = cycles/max;
>     u64 result = num * ((max * cc->mult) >> cc->shift);
>     return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
> }

Your way is surely more accurate, if maintainers are ok with adding
the new API, I will use it.

> 
> Rather than the while loop, which, I suspect, drops more precision
> that something like the above. (replace cyclecounter with clocksource)
> At the very least, keeping it as a distinct inline will let someone
> come by one day and implement a proper 128 bit multiply...

> 
> You may want to also CC the maintainers of all the ARM subsystems that
> use read_persistent_clock and check with them to ensure this new
> interface will let them migrate their implementations as well.

Maybe I didn't get it well, my patches didn't change the read_persistent_clock(),
but inject a new way of counting suspended time. It should have no
functional changes to existing platforms.

 
> > 	    * Solve the problem of judging S3/S4, as the clocksource
> > 	      counter will be reset after coming out S4.
> 
> Hrm, what if it wraps during suspend? This probably isn't a problem
> for a 64 bit TSC though..

Nice catch! I've added a wrap check in the patch, and will stop to use it
if there is a wrap founded.

+	if ((clock->flags & CLOCK_SOURCE_SUSPEND_NOTSTOP) &&
+		cycle_now > clock->cycle_last) {

> 
> Is it impossible to track if S4 or S3 was entered in the clocksource?

Currently there is no easy way to check it.

Thanks,
Feng


