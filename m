Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaBMAFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:05:23 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.24]:34208 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbaBMAFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:05:21 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net,v2] hyperv: Fix the carrier status setting
Thread-Topic: [PATCH net,v2] hyperv: Fix the carrier status setting
Thread-Index: AQHPJoUG2fV9yRbeH0i+wCBewGwG7pqwVq2AgAH6bSA=
Date: Thu, 13 Feb 2014 00:05:01 +0000
Message-ID: <e1477cb2b75445248dcb9e31c0360eca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1392056129-29398-1-git-send-email-haiyangz@microsoft.com>
 <52F9F293.7080601@redhat.com>
In-Reply-To: <52F9F293.7080601@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(13464003)(24454002)(377454003)(479174003)(69226001)(94946001)(49866001)(6806004)(31966008)(87266001)(79102001)(20776003)(86612001)(74876001)(44976005)(19580395003)(87936001)(85852003)(51856001)(23676002)(47736001)(47776003)(47976001)(50986001)(63696002)(83072002)(74366001)(47446002)(74502001)(19580405001)(74662001)(4396001)(2656002)(59766001)(50466002)(77982001)(90146001)(95666001)(81686001)(81816001)(81542001)(33646001)(66066001)(80022001)(93136001)(65816001)(56816005)(85306002)(54316002)(74706001)(76482001)(80976001)(76786001)(95416001)(56776001)(76796001)(83322001)(46102001)(81342001)(93516002)(2201001)(94316002)(53806001)(92566001)(54356001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;CLIP:131.107.147.100;FPR:BCBE724E.BE004145.5B63214F.10507A22.2028B;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0121F24F22
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1D05UhC023779



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Tuesday, February 11, 2014 4:51 AM
> To: Haiyang Zhang; davem@davemloft.net; netdev@vger.kernel.org
> Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net,v2] hyperv: Fix the carrier status setting
> 
> On 02/11/2014 02:15 AM, Haiyang Zhang wrote:
> > Without this patch, the "cat /sys/class/net/ethN/operstate" shows
> > "unknown", and "ethtool ethN" shows "Link detected: yes", when VM
> > boots up with or without vNIC connected.
> >
> > This patch fixed the problem.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c |   24 +++++++++++++++---------
> >  1 files changed, 15 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index 7756118..18916f7 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -88,8 +88,12 @@ static int netvsc_open(struct net_device *net)  {
> >  	struct net_device_context *net_device_ctx = netdev_priv(net);
> >  	struct hv_device *device_obj = net_device_ctx->device_ctx;
> > +	struct netvsc_device *nvdev;
> > +	struct rndis_device *rdev;
> >  	int ret = 0;
> >
> > +	netif_carrier_off(net);
> > +
> >  	/* Open up the device */
> >  	ret = rndis_filter_open(device_obj);
> >  	if (ret != 0) {
> > @@ -99,6 +103,11 @@ static int netvsc_open(struct net_device *net)
> >
> >  	netif_start_queue(net);
> >
> > +	nvdev = hv_get_drvdata(device_obj);
> > +	rdev = nvdev->extension;
> > +	if (!rdev->link_state)
> 
> What if the link status interrupt comes here at this time?

Thank you for pointing this out. I have submitted an updated patch.
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
