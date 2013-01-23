Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3AWJMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:12:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:27649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab3AWJMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:12:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,520,1355126400"; 
   d="scan'208";a="275546508"
Message-ID: <1358932355.12502.68.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Wed, 23 Jan 2013 11:12:35 +0200
In-Reply-To: <CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
	 <1358846546.12502.57.camel@smile>
	 <CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 15:10 +0530, Viresh Kumar wrote: 
> On 22 January 2013 14:52, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Tue, 2013-01-22 at 13:41 +0530, Viresh Kumar wrote:
> >> > +       spin_lock_irqsave(&dwc->lock, flags);
> >> > +       if (list_empty(&dwc->active_list)) {
> >>
> >> can this every happen?
> >
> > In the same way as in dwc_scan_descriptors().
> > For example when transfer is done.
> 
> My point was, because scan_descriptor() is just called, if the transfer
> is over by now, we must have returned back, else we reach this place
> and so this may never be true.

Ah, you mean the dma_cookie_status returns DMA_SUCCESS in case
active_list is empty, don't you?

> >> Over that, cyclic case can be handled before taking any locks.
> >
> > Does the user is responsible to follow specific workflow for cyclic API?
> 
> not sure.

I have no test cases against cyclic API, so I may assume that it doesn't
require locking for that bit.

> >> Just before above line got executed, we called dwc_scan_descriptors(), which
> >> also scans through the llis to see where we are.. What about updating
> >> first->residue
> >> there, so that we don't traverse it twice?
> >
> > The dwc_scan_descriptors traverses the chain and returns immediately if
> > it found a match. But to calculate residue we have to traverse from that
> > point to the end of the chain along with current DMA register check.
> 
> Hey, you can start subtracting individual lengths of descriptors from
> total length
> in scan descriptors() and that should give you what you want.

Yesterday I spent in testing of different approaches. First of all, the
calculation of the sent amount is nicer when ctlhi/ctllo is used and it
works fine. But the approach, when we substract length of sent
descriptors, is losing data. Namely, we have no information how big is
the master descriptor (it has total length of the entire chain). So, I'm
thinking how to solve this one. Otherwise it seems simpler than mine
first idea.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
