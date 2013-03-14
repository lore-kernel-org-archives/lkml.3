Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3CNVdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:33:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35456 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752716Ab3CNVdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:33:08 -0400
Date: Thu, 14 Mar 2013 17:33:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Soeren Moch <smoch@web.de>
cc: Arnd Bergmann <arnd@arndb.de>, USB list <linux-usb@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <linux-mm@kvack.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
In-Reply-To: <5142383F.6010001@web.de>
Message-ID: <Pine.LNX.4.44L0.1303141719450.1194-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Soeren Moch wrote:

> > If the memory really is being leaked here in some sort of systematic
> > way, we may be able to see it in your debugging output after a few
> > seconds.
> >
> 
> OK, here are the first seconds of the log. But the buffer exhaustion 
> usually occurs after several hours of runtime...

The log shows a 1-1 match between allocations and deallocations, except
for three excess allocations about 45 lines before the end.  I have no
idea what's up with those.  They may be an artifact arising from where
you stopped copying the log data.

There are as many as 400 iTDs being allocated before any are freed.  
That seems like a lot.  Are they all for the same isochronous endpoint?  
What's the endpoint's period?  How often are URBs submitted?

In general, there shouldn't be more than a couple of millisecond's
worth of iTDs allocated for any endpoint, depending on how many URBs 
are in the pipeline at any time.

Maybe a better way to go about this is, instead of printing out every
allocation and deallocation, to keep a running counter.  You could have
the driver print out the value of this counter every minute or so.  Any 
time the device isn't in use, the counter should be 0.

Alan Stern

