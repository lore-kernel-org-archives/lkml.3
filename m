Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaDDOHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbaDDOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:07:35 -0400
Date: Fri, 4 Apr 2014 16:06:15 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rt2x00: BUG: remove double loop on REGISTER_BUSY_COUNT
Message-ID: <20140404140614.GA2147@redhat.com>
References: <1396534327-12971-1-git-send-email-richard.genoud@gmail.com>
 <20140403173701.75c1f497@north>
 <20140404081908.GB1448@redhat.com>
 <20140404110106.6d249615@north>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140404110106.6d249615@north>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 11:01:06AM +0200, Jakub Kiciński wrote:
> On Fri, 4 Apr 2014 10:19:09 +0200, Stanislaw Gruszka wrote:
> > On Thu, Apr 03, 2014 at 05:37:01PM +0200, Jakub Kiciński wrote:
> > > On Thu,  3 Apr 2014 16:12:07 +0200, Richard Genoud wrote:
> > > > rt2x00usb_register_read_lock() calls rt2x00usb_vendor_req_buff_lock()
> > > > that calls rt2x00usb_vendor_request() which is already looping up to
> > > > REGISTER_BUSY_COUNT times.
> > > > 
> > > > So this loop is not needed.
> > > 
> > > Not true.  rt2x00usb_vendor_request() busy-waits for usb_control_msg()
> > > to succeed, rt2x00usb_register_read_lock() busy-waits for the register
> > > field itself to become 0.
> > 
> > Yeah, but still we are looping REGISTER_BUSY_COUNT*REGISTER_BUSY_COUNT
> > what seems to be far too long.
> 
> Yes, the busy waiting itself takes roughly 1s (100*100*100us) and then
> there are transfer times, so it might be too long indeed.  Vendor driver
> waits only 10 * 5ms in RTUSB_VendorRequest() so

We use "timeout" argument which is set to 500ms , so perhaps that
could be the reason why Richard sees "infinite" loop i.e.
100*100*(500ms + 100us)

> rt2x00usb_vendor_request() seems like a better place to cut down the
> number of loops.
>
> Alternatively we could make rt2x00usb_regbusy_read() check the retval
> from rt2x00usb_vendor_request() and exit early?

Make sense, but I think we should review the area and make some more
changes to fine tune the timeout of USB reg reading functions.

Stanislaw 
