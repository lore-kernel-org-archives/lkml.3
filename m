Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3CUSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:03:30 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54784 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3CUSD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:03:26 -0400
Date: Thu, 21 Mar 2013 19:03:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Russ Anderson <rja@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
Message-ID: <20130321180321.GB4185@gmail.com>
References: <20130318155619.GA18828@sgi.com>
 <20130321105516.GC18484@gmail.com>
 <20130321123505.GA6051@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321123505.GA6051@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 21-03-13 11:55:16, Ingo Molnar wrote:
> > 
> > * Russ Anderson <rja@sgi.com> wrote:
> > 
> > > When booting on a large memory system, the kernel spends
> > > considerable time in memmap_init_zone() setting up memory zones.
> > > Analysis shows significant time spent in __early_pfn_to_nid().
> > > 
> > > The routine memmap_init_zone() checks each PFN to verify the
> > > nid is valid.  __early_pfn_to_nid() sequentially scans the list of
> > > pfn ranges to find the right range and returns the nid.  This does
> > > not scale well.  On a 4 TB (single rack) system there are 308
> > > memory ranges to scan.  The higher the PFN the more time spent
> > > sequentially spinning through memory ranges.
> > > 
> > > Since memmap_init_zone() increments pfn, it will almost always be
> > > looking for the same range as the previous pfn, so check that
> > > range first.  If it is in the same range, return that nid.
> > > If not, scan the list as before.
> > > 
> > > A 4 TB (single rack) UV1 system takes 512 seconds to get through
> > > the zone code.  This performance optimization reduces the time
> > > by 189 seconds, a 36% improvement.
> > > 
> > > A 2 TB (single rack) UV2 system goes from 212.7 seconds to 99.8 seconds,
> > > a 112.9 second (53%) reduction.
> > 
> > Nice speedup!
> > 
> > A minor nit, in addition to Andrew's suggestion about wrapping 
> > __early_pfn_to_nid():
> > 
> > > Index: linux/mm/page_alloc.c
> > > ===================================================================
> > > --- linux.orig/mm/page_alloc.c	2013-03-18 10:52:11.510988843 -0500
> > > +++ linux/mm/page_alloc.c	2013-03-18 10:52:14.214931348 -0500
> > > @@ -4161,10 +4161,19 @@ int __meminit __early_pfn_to_nid(unsigne
> > >  {
> > >  	unsigned long start_pfn, end_pfn;
> > >  	int i, nid;
> > > +	static unsigned long last_start_pfn, last_end_pfn;
> > > +	static int last_nid;
> > 
> > Please move these globals out of function local scope, to make it more 
> > apparent that they are not on-stack. I only noticed it in the second pass.
> 
> Wouldn't this just add more confision with other _pfn variables? (e.g. 
> {min,max}_low_pfn and others)

I don't think so.

> IMO the local scope is more obvious as this is and should only be used 
> for caching purposes.

It's a pattern we actively avoid in kernel code.

Thanks,

	Ingo
