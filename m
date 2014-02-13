Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBMPFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:05:08 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:42112 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbaBMPFG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:05:06 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net,v3] hyperv: Fix the carrier status setting
Thread-Topic: [PATCH net,v3] hyperv: Fix the carrier status setting
Thread-Index: AQHPKE8RLdr//lHx80mo0wt5zxnQc5qzE0WAgAAxd7A=
Date: Thu, 13 Feb 2014 15:04:45 +0000
Message-ID: <900caa9031c345a6a21604ca7bb02174@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1392252867-21146-1-git-send-email-haiyangz@microsoft.com>
 <52FC4147.7060803@redhat.com>
In-Reply-To: <52FC4147.7060803@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(51704005)(13464003)(24454002)(164054003)(377454003)(479174003)(49866001)(86612001)(20776003)(6806004)(94946001)(69226001)(87936001)(23726002)(79102001)(87266001)(74876001)(44976005)(31966008)(19580395003)(85852003)(51856001)(47736001)(47776003)(63696002)(47976001)(50986001)(83072002)(74366001)(47446002)(19580405001)(74502001)(74662001)(4396001)(2656002)(59766001)(50466002)(77982001)(90146001)(95666001)(81686001)(46406003)(81816001)(81542001)(33646001)(66066001)(80022001)(93136001)(65816001)(56816005)(85306002)(54316002)(81342001)(93516002)(74706001)(80976001)(76482001)(95416001)(76786001)(83322001)(76796001)(56776001)(92566001)(46102001)(53806001)(94316002)(2201001)(54356001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.100;FPR:147E5A5E.BE004165.61E3ED4F.40B2BA61.20307;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0121F24F22
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Wednesday, February 12, 2014 10:52 PM
> To: Haiyang Zhang; davem@davemloft.net; netdev@vger.kernel.org
> Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net,v3] hyperv: Fix the carrier status setting
> 
> On 02/13/2014 08:54 AM, Haiyang Zhang wrote:
> > Without this patch, the "cat /sys/class/net/ethN/operstate" shows
> > "unknown", and "ethtool ethN" shows "Link detected: yes", when VM
> > boots up with or without vNIC connected.
> >
> > This patch fixed the problem.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c |   53
> ++++++++++++++++++++++++++++-----------
> >  1 files changed, 38 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index 7756118..7141a19 100644
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
> > +		netif_carrier_on(net);
> > +
> 
> Maybe you can just schedule the work here and then you can drop the
> rtnl_lock in netvsc_link_change() ?

The rtnl_lock will still be necessary in the netvsc_link_change(), because 
we want to prevent it getting wrong rdev pointer when netvsc_change_mtu
is removing/adding rndis device.

> > +
> > +	if (notify)
> > +		netdev_notify_peers(net);
> >  }
> >
> 
> Looks like this forces arp_notify here. Is it expected?

Yes, this is expected. It's required after live migration.

Thanks,
- Haiyang


