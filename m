Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbaLJLE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:04:56 -0500
Received: from mx0.aculab.com ([213.249.233.131]:46989 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752466AbaLJLEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:04:54 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'David Miller'" <davem@davemloft.net>,
        "asolokha@kb.kras.ru" <asolokha@kb.kras.ru>
CC: "claudiu.manoil@freescale.com" <claudiu.manoil@freescale.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] gianfar: handle map error in gfar_start_xmit()
Thread-Topic: [PATCH 2/2] gianfar: handle map error in gfar_start_xmit()
Thread-Index: AQHQE/BC0CRXvBjDxE22zxrmpES7Z5yIp7ww
Date: Wed, 10 Dec 2014 11:03:51 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA09ED4@AcuExch.aculab.com>
References: <1417775874-17775-1-git-send-email-asolokha@kb.kras.ru>
	<1417775874-17775-3-git-send-email-asolokha@kb.kras.ru>
 <20141209.153903.1672471330337681259.davem@davemloft.net>
In-Reply-To: <20141209.153903.1672471330337681259.davem@davemloft.net>
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

From: David Miller
> From: Arseny Solokha <asolokha@kb.kras.ru>
> Date: Fri,  5 Dec 2014 17:37:54 +0700
> 
> > @@ -2296,6 +2296,12 @@ static int gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  						   0,
> >  						   frag_len,
> >  						   DMA_TO_DEVICE);
> > +			if (unlikely(dma_mapping_error(priv->dev, bufaddr))) {
> > +				/* As DMA mapping failed, pretend the TX path
> > +				 * is busy to retry later
> > +				 */
> > +				return NETDEV_TX_BUSY;
> > +			}
> 
> You are not "busy", you are dropping the packet due to insufficient system
> resources.
> 
> Therefore the appropriate thing to do is to free the SKB, increment
> the drop statistical counter, and return NETDEV_TX_OK.

Plausibly the error action could depend on the number of messages
in the transmit ring.

If the ring is empty you definitely want to drop the packet.

If mapping a ring full of packets takes more dma map space than
the system has available you may want to be "busy" - otherwise you
get systemic packet loss when transmitting large burst of data.

This could be a problem if all the available dma mapping resources
have been allocated to receive buffers.

Do any common systems actually have limited dma space (apart from
limited bounce buffers)?
If people are only testing on systems with unlimited dma space (eg x86)
then these paths will never be exercised unless an artificial limit
is applied.

	David



