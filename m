Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbbAIMzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:55:12 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43791 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbbAIMzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:55:10 -0500
Date: Fri, 9 Jan 2015 12:55:07 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150109125507.GD495@console-pimps.org>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150107121617.GF25325@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107121617.GF25325@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan, at 01:16:17PM, Peter Zijlstra wrote:
> On Fri, Nov 14, 2014 at 09:15:11PM +0000, Matt Fleming wrote:
>  +	/*
> > +	 * A reasonable upper limit on the max threshold is the number
> > +	 * of lines tagged per RMID if all RMIDs have the same number of
> > +	 * lines tagged in the LLC.
> > +	 *
> > +	 * For a 35MB LLC and 56 RMIDs, this is ~1.8% of the LLC.
> > +	 */
> > +	__intel_cqm_max_threshold =
> > +		boot_cpu_data.x86_cache_size * 1024 / (cqm_max_rmid + 1);
> 
> Seeing how a percentage is without unit, the 35MB figure seems
> pointless.
 
It's only an example to demonstrate that this fudge calculation makes
sense on the current class of CQM-enabled hardware.

> Also, why would a flat distribution be a good measure for 'empty'? I
> would think that would in fact constitute in use.
 
It's not, it's a good measure for 'full'. This is the *max* threshold.
When searching for RMIDs to stabilize we'll stop searching if
__intel_cqm_threshold == __intel_cqm_max_threshold, since that indicates
all our RMIDs have *so* many lines tagged that it's unlikely increasing
__intel_cqm_threshold any further would be a win.

Suppose all our RMIDs associated cachelines, if any RMID (say, RMID_A)
has more lines tagged than the above flat distribution that means at
least one RMID must have less than the above value (RMID_B), so we'd
really hope for the lesser RMID to be become free sooner - we'd rather
pick RMID_B than bump the threshold value and risk picking RMID_A, since
the higher the threshold value, the "dirtier" we allow our RMIDs to be
when we reuse them.

And very dirty RMIDs skew your monitoring results because they introduce
noise into your data.

> Should we make this 1/16th of this figure or any other random fraction <
> 1 ?

I don't see how that'd be better than the above, but since I introduced
this code at your request, I'm not going to fight too hard.

-- 
Matt Fleming, Intel Open Source Technology Center
