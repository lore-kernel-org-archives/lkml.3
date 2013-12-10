Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3LJOnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:43:40 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:43516 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3LJOnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:43:39 -0500
Date: Tue, 10 Dec 2013 15:43:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        jacob.w.shin@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20131210144333.GC10633@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20131108194122.GA14606@localhost.localdomain>
 <20131109151156.GA14249@redhat.com>
 <20131109153236.GE26079@localhost.localdomain>
 <20131109155428.GA15649@redhat.com>
 <20131111154417.GD26853@localhost.localdomain>
 <20131111175131.GA14906@redhat.com>
 <CAFTL4hwS9FHNvK8A-wqSNzzjSW2OsicxrRh=XT7nRo0=Kw1s=g@mail.gmail.com>
 <20131204135743.GB7251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204135743.GB7251@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:57:43PM +0100, Oleg Nesterov wrote:
> On 12/03, Frederic Weisbecker wrote:
> >
> > 2013/11/11 Oleg Nesterov <oleg@redhat.com>:
> > > On 11/11, Frederic Weisbecker wrote:
> > >>
> > >> On Sat, Nov 09, 2013 at 04:54:28PM +0100, Oleg Nesterov wrote:
> > >> >
> > >> > Up to you and Suravee, but can't we cleanup this later?
> > >> >
> > >> > This series was updated many times to address a lot of (sometimes
> > >> > contradictory) complaints.
> > >>
> > >> Sure. But I'm confident that we can solve the conflicting mask / len issue easily beside.
> > >> I mean, I don't feel confident with merging things as is, otoh it should be easy to fix up.
> > >
> > > I do not really understand where do you see the conflict...
> > >
> > > I can be easily wrong, but afaics currently mask / len issue is simply
> > > the implementation detail.
> >
> > I think it's like we have an object that has a length, and to create
> > this object we pass both kilometers and miles. Ok it's a bit different
> > here because a mask can apply on top of a len. But here it's used to
> > define essentially the same thing (ie: a range of address)
> 
> Yes. perf/etc uses length, the current imlementation uses ->mask to
> actually set the range.
> 
> > > Actually, mask is more powerfull. And initial versions of this patches
> > > (iirc) tried to use mask as an argument which comes from the userspace
> > > (tools/perf, perf_event_attr, etc). But one of reviewers nacked this
> > > interfacer, so we still use len.
> >
> > Well, we can still reconsider it if needed but to me it seems that
> > mask is only interesting if we may deal with non contiguous range of
> > addresses.
> 
> And this is what this mask can actually do. Just there is no way (currently)
> to pass the mask from userpace.

Ok but are we interested in non contiguous range?

> 
> > >> Right but what if we want breakpoints having a size below 8? Like break on instructions
> > >> from 0x1000 to 0x1008 ?
> > >>
> > >> Or should we ignore range instruction breakpoints when len < 8?
> > >
> > > In this case the new code has no effect (iirc), we simply use
> > > X86_BREAKPOINT_LEN_* and "tell the hardware about extended range/mask"
> > > code is never called. IIRC, currently we simply check bp_mask != 0
> > > to distinguish.
> >
> > I'm not sure I understand correctly. Do you mean that range below 8
> > don't rely on extended breakpoint range?
> 
> IIRC - yes.
> 
> > Ideally it would be nice if we drop bp_mask and use extended ranges
> > only when len > 8. How does that sound?
> 
> Again, iirc, this is what the code does. except (in essence) it checks
> mask != 0 instead of len > 8.

Ok.

> 
> And yes, we can probably drop bp_mask (unless we are going to support
> the contiguous ranges), just I think we can do this later.

The problem is that once we push the bp_mask interface, we won't be able
to remove it later. It's a user ABI.

So I really want to be careful with that and extend bp_len for range breakpoints
then if we find out limitations, only then we can introduce bp_mask.

Suravee, any thought about this?
