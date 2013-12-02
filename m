Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LBKH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:07:28 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44634 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751232Ab3LBKHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:07:25 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/4] pch_gbe: Fix transmit queue management
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Mon, 2 Dec 2013 10:04:49 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B744F@saturn3.aculab.com>
In-Reply-To: <20131129.164229.2292905485668904870.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4] pch_gbe: Fix transmit queue management
Thread-Index: Ac7tS75vSbXKqESzSbCZgksZa4csfAB9imVg
References: <20131127.203929.1379316258754767343.davem@davemloft.net><1385631882-12827-2-git-send-email-puzman@gmail.com> <20131129.164229.2292905485668904870.davem@davemloft.net>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "David Miller" <davem@davemloft.net>, <puzman@gmail.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Miller
> 
> > According to Documentation/networking/driver.txt the ndo_start_xmit
> > method should not return NETDEV_TX_BUSY under normal circumstances.
> > Stop the transmit queue when tx_ring is full.
... 
> You should be instead preventing the transmit method from being invoked
> when it might be possible that a request cannot be satisfied.
> 
> This means that at the end of a transmit request, you must stop the
> queue if a packet with the maximum number of possible descriptors
> cannot be satisfied.  Then it is impossible for the transmit function
> to be invoked in a situation where it would need to fail for lack of
> available transmit descriptors.

I know you like ethernet drivers to work this way, but requiring enough
descriptors for a maximally fragmented packet requires a difficult
calculation and will cause the tx queue to be stopped unnecessarily.

IIRC a normal skb can have a maximum of 17 fragments, if these end up
being transmitted over USB using xhci they might need 34 descriptors
(because descriptors can't cross 64k boundaries).
However a typical 64k TCP packet just needs 4.
xhci has a further constraint that the ring end can only be at
specific alignments, in effect thus means that the descriptors for
a single packet cannot cross the end of a ring segment.
So if the available space in the xhci ring was used to stop the
ethernet tx queue (which it isn't at the moment) it would have to
be stopped very early.

Isn't there also a new skb structure that allows lists of fragments?
That might need even more descriptors for a worst case transmit.

I would have thought it would make sense for the ethernet driver
to stop the queue when there is a reasonable expectation that there
won't be enough descriptors for the next packet, but have a reasonable
code path when a packet with a large number of fragments won't fit
in the tx ring. This either requires the driver itself to hold the
skb, or to return NETDEV_TX_BUSY.
It might make sense to monitor recent traffic to find the 'expected
maximum number of fragments'.

	David




