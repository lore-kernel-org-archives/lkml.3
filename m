Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaFQJJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:09:24 -0400
Received: from wind.enjellic.com ([76.10.64.91]:40447 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbaFQJJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:09:23 -0400
Date: Tue, 17 Jun 2014 04:08:33 -0500
From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Message-Id: <201406170908.s5H98X8k018809@wind.enjellic.com>
In-Reply-To: Curtis <curtis@tinbrain.net>
       "Re: [Scst-devel] ANNOUNCE: Hugepage (HPD) block device driver." (Jun 15,  8:43pm)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.6-ESD1.0 03/31/2012)
To: Curtis <curtis@tinbrain.net>, scst-devel@lists.sourceforge.net
Subject: Re: [Scst-devel] ANNOUNCE: Hugepage (HPD) block device driver.
Cc: linux-kernel@vger.kernel.org
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [0.0.0.0]); Tue, 17 Jun 2014 04:08:34 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 15,  8:43pm, Curtis wrote:
} Subject: Re: [Scst-devel] ANNOUNCE: Hugepage (HPD) block device driver.

> Greg,

Hi Curtis, hope your is starting out well.

> this project looks quite interesting, and I hope to try it out soon,
> however I do have one question, though it may expose my ignorance of
> kernel internals...

Izzy will be pleased you are interested in it.

As to ignorance with respect to kernel internals I will have to plead
that as well, Izzy is our go to guy when it comes to those issues but
he is snoozing in front of the sunroom door so I will give your
question a try.

> Why did you opt for the explicit huge page API, and modifying it,
> instead of playing friendly with transparent hugepage?
>
> Was it simply so you could be certain of using hugepages, and not have 
> to tweak to match the current policy?  Or is it simply that this is the 
> surest approach from inside the kernel?

To answer that one needs to step back and look at how the hugepage
infrastructure is implemented in the kernel.

The hugepage infrastructure is composed of two pieces; the first and
lower order one is the extended page size (order 9) allocation and
magazine infrastructure with the second being the virtual memory
support for extended page sizes which rides on top of that
infrastructure.

HPD plugs into the first or lower order infrastructure.  The higher
order virtual memory support is where angels, Mel Gorman and AKPM
tread... :-)

HPD simply does raw kernel mappings of the extended pages which is a
pretty straight forward operation.  Transparent hugepage support,
simplistically, involves analysing the virtual memory areas (VMA's)
and determining where it is possible to replace multi-page mappings
with a single two megabyte mapping.

So simply put HPD is a consumer of physical page mappings rather then
a virtual memory solution.

The advantage of using pinned down physical allocation and mappings in
a block device implementation is that it takes away the uncertainty of
whether or not a memory allocation will fail.  It also takes issues
such as writeback etc. off the table.  HPD is obviously focused on a
situation, such as storage appliances or target servers, where you are
willing to pseudo-dynamically allocate a chunk of memory which is
going to be dedicated to creating a block device.

One of things we use HPD for is in combination with bcache (in
writethrough mode..:-) ) in order to implement caching for SCST
BLOCKIO devices.  Obviously one wants to avoid a situation where the
cache device throws an error if a page cannot be allocated due to
fragmentation issues.

> Curtis Maloney

Hopefully the above makes sense.

I can wake up Izz if you want to drill down deeper... :-)

Have a good day.

Greg

}-- End of excerpt from Curtis

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"You and Uncle Pete drank the whole thing?  That was a $250.00 bottle
 of whisky.

 Yeah, it was good."
                                -- Rick Engen
                                   Resurrection.
