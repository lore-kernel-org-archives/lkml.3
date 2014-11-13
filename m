Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaKMCbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:31:25 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:56998 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaKMCbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:31:23 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAD2VFuW027433, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
Thread-Topic: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
Thread-Index: AQHP+nD06ZRj/kse50uRMFsgi72OwJxU1qgAgARRxyCAAqOJAIAAqX9g//9+RwCAAIdqwP//gQiAgACRGECAAFtcgIAA7vwg
Date: Thu, 13 Nov 2014 02:31:14 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ECE8EF@RTITMBSV03.realtek.com.tw>
References: <0835B3720019904CB8F7AA43166CEEB2ECE442@RTITMBSV03.realtek.com.tw>
	<20141112.004331.1112374574697663525.davem@davemloft.net>
	<0835B3720019904CB8F7AA43166CEEB2ECE46C@RTITMBSV03.realtek.com.tw>
 <20141112.144949.645590790916569141.davem@davemloft.net>
In-Reply-To: <20141112.144949.645590790916569141.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller [mailto:davem@davemloft.net] 
> Sent: Thursday, November 13, 2014 3:50 AM
[...]
> > According to the usbnet.c, it would make sure to submit the
> > number of min(10, RX_QLEN(dev)) rx buffers. If there are
> > not enough rx buffers, it schedule a tasklet for next try.
> > 
> > The brief flow is as following.
> > 1. Call open().
> >    - schedule a tasklet.
> > 2. Tasklet is called.
> >    if (dev->rxq.qlen < RX_QLEN(dev)) {
> > 	   - submit rx buffers util the number of
> > 	     min(10, RX_QLEN(dev)). If the error
> > 	     occurs, break the loop.
> > 	   - If the dev->rxq.qlen < RX_QLEN(dev),
> > 	     schedule the tasklet.
> >    }
> 
> That sounds like a better recovery model, why don't you mimick it?

My last method which I mentioned yesterday is similar to
this one. The difference is that I would re-use the rx
buffers, so I have to add them to the list for re-submitting,
not alwayes allocate new one.

Although one rx buffer could contain many packets, I don't
think the whole size of the rx buffer is alwayes used.
Therefore, I re-use the rx buffers to avoid allocating
the 16K bytes rx buffer alwayes. This also makes sure that
I always have the buffers to submit without allocating new
one.

If you could accept this, I would modify this patch by
this way.
 
Best Regards,
Hayes
