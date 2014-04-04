Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaDDJBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:01:16 -0400
Received: from mx4.wp.pl ([212.77.101.12]:31888 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaDDJBL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:01:11 -0400
Date: Fri, 4 Apr 2014 11:01:06 +0200
From: Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: BUG: remove double loop on REGISTER_BUSY_COUNT
Message-ID: <20140404110106.6d249615@north>
In-Reply-To: <20140404081908.GB1448@redhat.com>
References: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com>
	<20140403173701.75c1f497@north>
	<20140404081908.GB1448@redhat.com>
X-Mailer: Claws Mail 3.9.3-24-gf407e3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [QTOE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2014 10:19:09 +0200, Stanislaw Gruszka wrote:
> On Thu, Apr 03, 2014 at 05:37:01PM +0200, Jakub Kiciński wrote:
> > On Thu,  3 Apr 2014 16:12:07 +0200, Richard Genoud wrote:
> > > rt2x00usb_register_read_lock() calls rt2x00usb_vendor_req_buff_lock()
> > > that calls rt2x00usb_vendor_request() which is already looping up to
> > > REGISTER_BUSY_COUNT times.
> > > 
> > > So this loop is not needed.
> > 
> > Not true.  rt2x00usb_vendor_request() busy-waits for usb_control_msg()
> > to succeed, rt2x00usb_register_read_lock() busy-waits for the register
> > field itself to become 0.
> 
> Yeah, but still we are looping REGISTER_BUSY_COUNT*REGISTER_BUSY_COUNT
> what seems to be far too long.

Yes, the busy waiting itself takes roughly 1s (100*100*100us) and then
there are transfer times, so it might be too long indeed.  Vendor driver
waits only 10 * 5ms in RTUSB_VendorRequest() so
rt2x00usb_vendor_request() seems like a better place to cut down the
number of loops.

Alternatively we could make rt2x00usb_regbusy_read() check the retval
from rt2x00usb_vendor_request() and exit early?

	-- kuba

