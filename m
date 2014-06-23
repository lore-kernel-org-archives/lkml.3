Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaFWWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:51:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaFWWvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:51:20 -0400
Date: Mon, 23 Jun 2014 15:51:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
Message-Id: <20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
In-Reply-To: <53A8ADEC.6070406@akamai.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>
	<20140623151121.44f17779004e94ab620b837c@linux-foundation.org>
	<53A8ADEC.6070406@akamai.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 17:45:00 -0500 Josh Hunt <johunt@akamai.com> wrote:

> On 06/23/2014 05:11 PM, Andrew Morton wrote:
> > On Tue,  3 Jun 2014 22:12:35 -0400 Josh Hunt <johunt@akamai.com> wrote:
> >
> >> This taint flag will be set if the system has ever entered a softlockup
> >> state. Similar to TAINT_WARN it is useful to know whether or not the system
> >> has been in a softlockup state when debugging.
> >>
> >> ...
> >>
> >> @@ -329,6 +329,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> >>
> >>   		if (softlockup_panic)
> >>   			panic("softlockup: hung tasks");
> >> +		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
> >>   		__this_cpu_write(soft_watchdog_warn, true);
> >>   	} else
> >>   		__this_cpu_write(soft_watchdog_warn, false);
> >
> > Would make more sense to have applied the taint *before* calling
> > panic()?
> 
> Andrew
> 
> Yep, that's a good call. Thanks. Do you want me to send a v2 or did you 
> take care of it?

I fixed it up.

> In addition to adding the softlockup taint flag, do you think it'd be 
> reasonable to add another flag for page allocation failures? I think 
> it'd be nice to be able to account for these conditions somehow without 
> having to parse dmesg, etc. As with the softlockup flag, it's helpful to 
> know if your system had encountered a page allocation failure at some 
> point before the crash or whatever you're debugging.

I don't know, really.  Allocation failures are often an expected thing
as drivers try to work out how much memory they can allocate.  Those
things can be screened out by testing __GFP_NOWARN.  GFP_ATOMIC
failures should probably be ignored, except for when they shouldn't. 
But even then, allocation failures are somewhat common.  And recency is
a concern: an allocation failure 10 minutes ago is unlikely to be
relevant.

But that's just me waving hands around.  I'd be interested to hear from
people whose kernels crash more often than mine, and from those whose
job is to support them (ie distro people?).

