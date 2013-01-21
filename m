Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3AUS5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:57:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab3AUS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:57:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Soeren Moch <smoch@web.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
Date: Mon, 21 Jan 2013 18:55:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <201301192005.20093.arnd@arndb.de> <50FD5844.1010201@web.de>
In-Reply-To: <50FD5844.1010201@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211855.25455.arnd@arndb.de>
X-Provags-ID: V02:K0:/LP0VqQJLtvk23VVI/EdsoYgxokgASNxfxi1ecvrXHR
 kN/VsduAqz+8jaTpKCWTN1y5oshK57djscrv0YVatsvu9SCjrH
 Is9ZeZ3OKV5dlHhSlxP9pf2mYtCzQR/lQrhq2DEZqBZgRnCfqr
 tmZo+JPEvD8jaZHvYEkRtXxmNxz0IPkXPqtTbwbmNhPsznLZv6
 rXnhQqEDtAbPMW1w/UPvYw33yRDzo6Rw5M9adH58QwKKOk5Tl1
 JYfMeIlwhRmfjC8JMPXlGQ3Xr2P/ECsCR+YMQJmkXA972LPBtq
 EQ+Sd+s+ucDLhCD3jYVEGLGHvzO3L9PEDEQndgkEzKTs2z47kl
 EcNiKgsATRDynFg1gEUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Soeren Moch wrote:
> On 01/19/13 21:05, Arnd Bergmann wrote:
> > from the distribution of the numbers, it seems that there is exactly 1 MB
> > of data allocated between bus addresses 0x1f90000 and 0x1f9ffff, allocated
> > in individual pages. This matches the size of your pool, so it's definitely
> > something coming from USB, and no single other allocation, but it does not
> > directly point to a specific line of code.
> Very interesting, so this is no fragmentation problem nor something 
> caused by sata or ethernet.

Right.

> > One thing I found was that the ARM dma-mapping code seems buggy in the way
> > that it does a bitwise and between the gfp mask and GFP_ATOMIC, which does
> > not work because GFP_ATOMIC is defined by the absence of __GFP_WAIT.
> >
> > I believe we need the patch below, but it is not clear to me if that issue
> > is related to your problem or now.
> Out of curiosity I checked include/linux/gfp.h. GFP_ATOMIC is defined as 
> __GFP_HIGH (which means 'use emergency pool', and no wait), so this 
> patch should not make any difference for "normal" (GPF_ATOMIC / 
> GFP_KERNEL) allocations, only for gfp_flags accidentally set to zero. 

Yes, or one of the rare cases where someone intentionally does something like
(GFP_ATOMIC & !__GFP_HIGH) or (GFP_KERNEL || __GFP_HIGH), which are both
wrong.

> So, can a new test with this patch help to debug the pool exhaustion?

Yes, but I would not expect this to change much. It's a bug, but not likely
the one you are hitting.

> > So even for a GFP_KERNEL passed into usb_submit_urb, the ehci driver
> > causes the low-level allocation to be GFP_ATOMIC, because
> > qh_append_tds() is called under a spinlock. If we have hundreds
> > of URBs in flight, that will exhaust the pool rather quickly.
> >
> Maybe there are hundreds of URBs in flight in my application, I have no 
> idea how to check this.

I don't know a lot about USB, but I always assumed that this was not
a normal condition and that there are only a couple of URBs per endpoint
used at a time. Maybe Greg or someone else with a USB background can
shed some light on this.

> It seems to me that bad reception conditions 
> (lost lock / regained lock messages for some dvb channels) accelerate 
> the buffer exhaustion. But even with a 4MB coherent pool I see the 
> error. Is there any chance to fix this in the usb or dvb subsystem (or 
> wherever)? Should I try to further increase the pool size, or what else 
> can I do besides using an older kernel?

There are two things that I think can be done if hundreds of URBs is
indeed the normal working condition for this driver:

* change the locking in your driver so it can actually call usb_submit_urb
using GFP_KERNEL rather than GFP_ATOMIC
* after that is done, rework the ehci_hcd driver so it can do the
allocation inside of the submit_urb path to use the mem_flags rather
than unconditional GFP_ATOMIC.

Note that the problem you are seeing does not just exist in the case of
the atomic coherent pool getting exhausted, but also on any platform
that runs into an out-of-memory condition.

	Arnd
