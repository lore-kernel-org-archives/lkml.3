Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab3CEDUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:20:42 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36153 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046Ab3CEDUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:20:41 -0500
Date: Mon, 4 Mar 2013 20:20:36 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Tang, Feng" <feng.tang@intel.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: FW: [RFC PATCH v2 0/4] Add support for S3 non-stop TSC support.
Message-ID: <20130305032036.GA24117@obsidianresearch.com>
References: <A74E4C03C808B649AF1F11527F2D4414034E0BE8@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A74E4C03C808B649AF1F11527F2D4414034E0BE8@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 02:34:25AM +0000, Tang, Feng wrote:
> Hi Jason,
> 
> Sorry, I forgot to add you in cc list in the first place. Please
> help to review the patch series, thanks!

Sure, I didn't get CC'd on the patches, so this is an imperfect reply,
but..

Did you consider an approach closer to the function I outlined to
Jonh:

// Drops some small precision along the way but is simple..
static inline u64 cyclecounter_cyc2ns_128(const struct cyclecounter *cc,
                                          cycle_t cycles)
{
    u64 max = U64_MAX/cc->mult;
    u64 num = cycles/max;
    u64 result = num * ((max * cc->mult) >> cc->shift);
    return result + cyclecounter_cyc2ns(cc, cycles - num*cc->mult);
}

Rather than the while loop, which, I suspect, drops more precision
that something like the above. (replace cyclecounter with clocksource)
At the very least, keeping it as a distinct inline will let someone
come by one day and implement a proper 128 bit multiply...

You may want to also CC the maintainers of all the ARM subsystems that
use read_persistent_clock and check with them to ensure this new
interface will let them migrate their implementations as well.

> 	    * Solve the problem of judging S3/S4, as the clocksource
> 	      counter will be reset after coming out S4.

Hrm, what if it wraps during suspend? This probably isn't a problem
for a 64 bit TSC though..

Is it impossible to track if S4 or S3 was entered in the clocksource?

Reagrds,
Jason
