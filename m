Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbbAIM6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:58:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:52586 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbAIM6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:58:49 -0500
Date: Fri, 9 Jan 2015 13:58:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150109125829.GF29390@twins.programming.kicks-ass.net>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150107121617.GF25325@worktop.programming.kicks-ass.net>
 <20150109125507.GD495@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109125507.GD495@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 12:55:07PM +0000, Matt Fleming wrote:
> On Wed, 07 Jan, at 01:16:17PM, Peter Zijlstra wrote:
> > On Fri, Nov 14, 2014 at 09:15:11PM +0000, Matt Fleming wrote:
> >  +	/*
> > > +	 * A reasonable upper limit on the max threshold is the number
> > > +	 * of lines tagged per RMID if all RMIDs have the same number of
> > > +	 * lines tagged in the LLC.
> > > +	 *
> > > +	 * For a 35MB LLC and 56 RMIDs, this is ~1.8% of the LLC.
> > > +	 */
> > > +	__intel_cqm_max_threshold =
> > > +		boot_cpu_data.x86_cache_size * 1024 / (cqm_max_rmid + 1);
> > 
> > Seeing how a percentage is without unit, the 35MB figure seems
> > pointless.
>  
> It's only an example to demonstrate that this fudge calculation makes
> sense on the current class of CQM-enabled hardware.
> 
> > Also, why would a flat distribution be a good measure for 'empty'? I
> > would think that would in fact constitute in use.
>  
> It's not, it's a good measure for 'full'. This is the *max* threshold.
> When searching for RMIDs to stabilize we'll stop searching if
> __intel_cqm_threshold == __intel_cqm_max_threshold, since that indicates
> all our RMIDs have *so* many lines tagged that it's unlikely increasing
> __intel_cqm_threshold any further would be a win.

Right, but we'll also consider RMIDs with less than this as fit for
reuse. So we'll re-use RMIDs that are effectively full.

Our aim is to acquire an 'empty' RMID, not give up and start reusing
full ones just because, right?
