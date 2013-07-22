Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab3GVTr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:47:59 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:29877 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3GVTr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:47:56 -0400
Message-ID: <1374522471.1635.48.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 1/1] TX throttling bug-fixing patch of AX88179_178A
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Grant Grundler <grundler@google.com>, Freddy Xin <freddy@asix.com.tw>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ASIX Louis =?UTF-8?Q?=5B=E8=98=87=E5=A8=81=E9=99=B8=5D?= 
	<louis@asix.com.tw>,
        "Allan Chou" <allan@asix.com.tw>
Date: Mon, 22 Jul 2013 20:47:51 +0100
In-Reply-To: <1374518841.4990.26.camel@edumazet-glaptop>
References: <1374311809-4155-1-git-send-email-freddy@asix.com.tw>
	 <1374512879.4990.19.camel@edumazet-glaptop>
	 <CANEJEGvPc56ePP=_bxfA4PZfsM3vw=MsRjbWwrFBC3eP-GtzZg@mail.gmail.com>
	 <1374518312.1635.29.camel@bwh-desktop.uk.level5networks.com>
	 <1374518841.4990.26.camel@edumazet-glaptop>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20030.005
X-TM-AS-Result: No--16.566800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 11:47 -0700, Eric Dumazet wrote:
> On Mon, 2013-07-22 at 19:38 +0100, Ben Hutchings wrote:
> > On Mon, 2013-07-22 at 11:29 -0700, Grant Grundler wrote:
> > > On Mon, Jul 22, 2013 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > ...
> > > > I guess that if a driver does not advertise NETIF_F_SG, this
> > > > skb_linearize() call is not needed : All frames reaching your xmit
> > > > function should already be linear
> > > 
> > > As Ben Hutchings pointed out, hw_features is still setting this...but
> > > I'm not sure how that matters.
> > > 
> > > ax88179_set_features() doesn't allow setting SG or TSO features.  But
> > > I expect it would be "not too difficult" to add such that ethtool
> > > could set those features after boot.
> > [...]
> > 
> > It already can.  That's what putting feature flags in hw_features does.
> 
> My original concern, that inspired this patch, was to remove SG support,
> as this driver does not have SG support at all.
> 
> Linearize a full TSO packet needs order-5 allocations, thats likely to
> fail and lead to very slow TCP performance, because it will only rely on
> retransmits.

The driver could set gso_max_size to reduce that problem.  But I rather
doubt that TSO followed by skb_linearize() significantly improves
throughput or CPU-efficiency.  (If the device has a 1G link but is
connected to the host through a USB 2.0 port, then USB is the bottleneck
and TSO could improve throughput a few percent.  But that's a silly
configuration.)

The real solution would be for someone to add SG support to the usbnet
core.  Trying to support 1GbE with only linear skbs is not a great
idea... and it can only be a matter of time before there is USB ultra
speed (or whatever comes after 'super') with 10GbE devices...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

