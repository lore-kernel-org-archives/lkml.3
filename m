Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbaCDOgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:36:22 -0500
Received: from mx0.aculab.com ([213.249.233.131]:48981 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757243AbaCDOgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:36:21 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'hayeswang'" <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 08/12] r8152: support TSO
Thread-Topic: [PATCH net-next 08/12] r8152: support TSO
Thread-Index: AQHPN6ICLRomJZLUN0ak16x5aFoKeJrQ1RDAgAAOULCAABdMwA==
Date: Tue, 4 Mar 2014 14:35:54 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D0284@AcuExch.aculab.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
 <1393934464-23675-9-git-send-email-hayeswang@realtek.com>
 <063D6719AE5E284EB5DD2968C1650D6D0F6CFFE0@AcuExch.aculab.com>
 <CF9EF717568D49DB858D5363B1099FC0@realtek.com.tw>
In-Reply-To: <CF9EF717568D49DB858D5363B1099FC0@realtek.com.tw>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hayeswang 
>  David Laight [mailto:David.Laight@ACULAB.COM]
> > Sent: Tuesday, March 04, 2014 8:12 PM
> > To: 'Hayes Wang'; netdev@vger.kernel.org
> > Cc: nic_swsd@realtek.com; linux-kernel@vger.kernel.org;
> > linux-usb@vger.kernel.org
> > Subject: RE: [PATCH net-next 08/12] r8152: support TSO
> >
> > From: Hayes Wang
> > > Support scatter gather and TSO.
> > >
> > > Adjust the tx checksum function and set the max gso size to fix the
> > > size of the tx aggregation buffer.
> >
> > There is little point supporting TSO unless the usb host controller
> > supports arbitrary aligned scatter-gather.
> > All you do is require that a large skb be allocated (that may well
> > fail), and add it another data copy.
> 
> I think I have done it. For also working for EHCI usb host controller,
> I allocate 16 KB continuous buffer and copy the fragmented packets to
> it and bulk out the buffer.

Does that mean you are splitting the 64k 'ethernet packet' from TCP
is software? I've looked at the ax88179 where the hardware can do it.

Is there really a gain doing segmentation here if you have to do the
extra data copy?

It might be worth packing multiple short packets into a single USB bulk
data packet, but that might require a CBU (crystal ball unit).

I did measure a maximum transmit ethernet frame rate of (IIRC) 250000
frames/sec for the ax88179 - probably limited by the USB3 frame rate.
Exceeding that would probably require putting multiple tx packets into
a single URB. OTOH that limit probably doesn't matter

What might be more useful is to set the rx side up to receive into
page-aligned 2k (or 4k) buffers and then separate out the ethernet
frames into the required skb - probably as page list fragments
(I'm not entirely sure how such skb can be created).

I don't know what the r8152 does, but the usbnet code encourages it to
allocate long skb, pass them to the usb stack to fill, and then clone
them if they contain multiple frames.

This isn't really good use of memory or cpu cycles.
The ax88179 driver also lies badly about the skb's truesize.

	David



