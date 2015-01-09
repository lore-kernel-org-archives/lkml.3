Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbbAIP67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:58:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:53833 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbbAIP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:58:56 -0500
Date: Fri, 9 Jan 2015 16:58:35 +0100
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
Message-ID: <20150109155835.GJ29390@twins.programming.kicks-ass.net>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150106171712.GH3337@twins.programming.kicks-ass.net>
 <20150109121401.GB495@console-pimps.org>
 <20150109130250.GH29390@twins.programming.kicks-ass.net>
 <20150109152442.GG495@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109152442.GG495@console-pimps.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:24:42PM +0000, Matt Fleming wrote:
> On Fri, 09 Jan, at 02:02:50PM, Peter Zijlstra wrote:
> > On Fri, Jan 09, 2015 at 12:14:01PM +0000, Matt Fleming wrote:
> > > On Tue, 06 Jan, at 06:17:12PM, Peter Zijlstra wrote:
> > > > 
> > > > afaict the again label will try and steal yet another rmid, if rmids
> > > > don't decay fast enough, we could end up with all rmids on the limbo
> > > > list and none active. Or am I missing something here?
> > > 
> > > You're not missing anything, that's true, we will try and steal more
> > > RMIDs. We could perhaps put a limit on how many RMIDs we're willing to
> > > steal, but I think it should definitely be > 1 because RMIDs can
> > > stabilize out of order.
> > > 
> > > It's worth pointing out that we only steal more RMIDs if the ones on the
> > > limbo list have been queued for the "minimum queue time" - it really is
> > > a last resort.
> > 
> > Do we really care? Why not just hold up everything until the one(s) we
> > have are low enough?
> > 
> > Yes it all blows, but would not some active be better than none active,
> > just because the stupid lines aren't clearing fast enough?
> 
> Right, but now we need a "steal limit", so we know when to stop stealing
> active RMIDs.
> 
> 	(cqm_max_rmid + 1) / 4 ?
> 
> I guess any limit is better than no limit.

Yeah, that'll work, when the free+limbo count is 1/4th the total we
should stop pulling more plugs.
