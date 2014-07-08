Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaGHUD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:03:57 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:24312
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754005AbaGHUD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:03:56 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Richard Weinberger <richard@nod.at>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hyperv: Add netpoll support
Thread-Topic: [PATCH] hyperv: Add netpoll support
Thread-Index: AQHPmo+Sem0p3ifQZUi3cyqbFGXcHpuWd56AgAALCICAABbIkA==
Date: Tue, 8 Jul 2014 20:03:45 +0000
Message-ID: <b2835410139848be8811403e3d7fa708@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404811947-5174-1-git-send-email-richard@nod.at>
 <9fb91c2ee32a4a59a2bec54043a6b9fd@BY2PR03MB299.namprd03.prod.outlook.com>
 <53BC3AC5.6000203@nod.at>
In-Reply-To: <53BC3AC5.6000203@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.21]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0266491E90
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(51704005)(189002)(13464003)(377454003)(129404003)(80022001)(101416001)(64706001)(106116001)(4396001)(83072002)(76576001)(33646001)(86362001)(19580395003)(87936001)(1511001)(106356001)(92566001)(2656002)(54356999)(31966008)(46102001)(99396002)(19580405001)(76176999)(83322001)(50986999)(99286002)(81342001)(95666004)(76482001)(105586002)(74316001)(74502001)(85306003)(81542001)(107046002)(20776003)(85852003)(79102001)(74662001)(21056001)(77982001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Tuesday, July 8, 2014 11:39 AM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] hyperv: Add netpoll support
> 
> Am 08.07.2014 20:01, schrieb KY Srinivasan:
> >
> >
> >> -----Original Message-----
> >> From: Richard Weinberger [mailto:richard@nod.at]
> >> Sent: Tuesday, July 8, 2014 2:32 AM
> >> To: KY Srinivasan; Haiyang Zhang
> >> Cc: devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; Richard Weinberger
> >> Subject: [PATCH] hyperv: Add netpoll support
> >>
> >> In order to have at least a netconsole to debug kernel issues on
> >> Windows Azure this patch implements netpoll support.
> >> Sending packets is easy, netvsc_start_xmit() does already everything
> >> needed.
> >> To receive we need to trigger the channel callback which is usally
> >> called via tasklet_schedule().
> >>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> >> ---
> >>  drivers/net/hyperv/netvsc_drv.c | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/drivers/net/hyperv/netvsc_drv.c
> >> b/drivers/net/hyperv/netvsc_drv.c index 4fd71b7..367b71e 100644
> >> --- a/drivers/net/hyperv/netvsc_drv.c
> >> +++ b/drivers/net/hyperv/netvsc_drv.c
> >> @@ -736,6 +736,17 @@ static int netvsc_set_mac_addr(struct net_device
> >> *ndev, void *p)
> >>  	return err;
> >>  }
> >>
> >> +#ifdef CONFIG_NET_POLL_CONTROLLER
> >> +static void netvsc_poll_controller(struct net_device *net) {
> >> +	struct net_device_context *net_device_ctx = netdev_priv(net);
> >> +	struct hv_device *dev = net_device_ctx->device_ctx;
> >> +
> >> +	local_bh_disable();
> >> +	netvsc_channel_cb(dev->channel);
> >> +	local_bh_enable();
> >> +}
> >> +#endif
> >
> > Each channel is bound to a specific VCPU in the guest and the channel
> > callback is expected to be delivered on the VCPU the channel is bound to.
> This code is not satisfying that requirement.
> 
> But struct hv_device has only one channel attribute. How does this work with
> multiple VCPUs?
> 
> Anyways, what solution to you propose?

The VCPU the channel is bound to is available in the channel state. You could use the following code
Fragment to ensure that the call is made on the "right" cpu:

smp_call_function_single(dev->channel->target_cpu,
                                         netvsc_channel_cb, dev->channel, true);

Hope this helps.

K. Y
