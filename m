Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaDIB5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:57:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbaDIB5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:57:24 -0400
Date: Tue, 8 Apr 2014 21:56:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 07/15 V3] perf, c2c: Add in sort on physid
Message-ID: <20140409015652.GB8488@redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
 <1395689826-215033-8-git-send-email-dzickus@redhat.com>
 <87k3b0w8ye.fsf@sejong.aot.lge.com>
 <20140408141758.GU8488@redhat.com>
 <87a9bvuw4v.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9bvuw4v.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:30:56AM +0900, Namhyung Kim wrote:
> On Tue, 8 Apr 2014 10:17:58 -0400, Don Zickus wrote:
> > On Tue, Apr 08, 2014 at 04:56:25PM +0900, Namhyung Kim wrote:
> >> On Mon, 24 Mar 2014 15:36:58 -0400, Don Zickus wrote:
> >> > +static int perf_c2c__init(struct perf_c2c *c2c)
> >> > +{
> >> > +	sort__mode = SORT_MODE__PHYSID;
> >> > +	sort__wants_unique = 1;
> >> > +	sort_order = "daddr,iaddr,pid,tid";
> >> 
> >> Where are the SORT_MODE__PHYSID, sort__wants_unique and "daddr", "iaddr"
> >> sort keys defined?
> >
> > In a previous patchset that enables the mmap2 interface.
> 
> Ah, missed that.. will look at it soon.
> 
> >
> >> 
> >> Also, more importantly, I think the sort order should contain at least
> >> "mem" and "snoop" keys to group samples based on the exact hitm
> >> information.
> >
> > I can look into it, but after iaddr, pid and tid, sorting on snoop doesn't
> > really change anything if I recall.  The hitms are scattered across iaddr.
> 
> But it doesn't guarantee that all hitms are scattered, right?  Also if
> it's the case I guess adding more sort keys are not harmful since they
> don't even have a chance to test.
> 
> I think you can check hist_entry->stat.nr_events always being 1.
> 
> >
> >> 
> >> In my understanding, if two samples are captured at exactly same
> >> position with a same data access but different hitm info, they cannot be
> >> classified and just use the hitm info of first entry.
> >
> > Why?  If the first hitm access was local and the second one remote,
> > doesn't that indicate the accessed data is being pulled onto different
> > nodes?
> 
> But "hist_entry" won't have the information after calling
> __hists__add__entry() called unless it has 'mem' and 'snoop' sort keys.
> Since two samples have same daddr, iaddr, pid and tid, it'd think those
> two samples are same and then add stats of second one to the first and
> finally discard the second.  So first one will have a double weight for
> the local hitm case only.
> 
> This is the case what I worry about.  Am I missing something?

My patch 6/6 of the enable mmap2 support. :-)  It specifically forces all
the data to remain separate to avoid this issue.  We couldn't have the
data merged because it messed up our stats.

Cheers,
Don
