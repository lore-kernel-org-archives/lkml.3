Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3CUVMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:12:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38390 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753256Ab3CUVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:12:02 -0400
Date: Thu, 21 Mar 2013 17:12:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Soeren Moch <smoch@web.de>
cc: Arnd Bergmann <arnd@arndb.de>, USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <linux-mm@kvack.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <michael@amarulasolutions.com>
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
In-Reply-To: <Pine.LNX.4.44L0.1303211659080.1899-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1303211708470.1899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013, Alan Stern wrote:

> On Thu, 21 Mar 2013, Soeren Moch wrote:
> 
> > Now I found out what is going on here:
> > 
> > In itd_urb_transaction() we allocate 9 iTDs for each URB with 
> > number_of_packets == 64 in my case. The iTDs are added to 
> > sched->td_list. For a frame-aligned scheduling we need 8 iTDs, the 9th 
> > one is released back to the front of the streams free_list in 
> > iso_sched_free(). This iTD was cleared after allocation and has a frame 
> > number of 0 now. So for each allocation when now_frame == 0 we allocate 
> > from the dma_pool, not from the free_list.
> 
> Okay, that is a problem.  But it shouldn't be such a big problem,
> because now_frame should not be equal to 0 very often.

Oh, wait, now I get it.  We never reach a steady state, because the
free list never shrinks, but occasionally it does increase when
now_frame is equal to 0.  Even though that doesn't happen very often,
the effects add up.

Very good; tomorrow I will send your patch in.

Alan Stern

