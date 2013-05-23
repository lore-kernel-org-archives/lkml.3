Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab3EWPHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:07:34 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:33736 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759203Ab3EWPHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:07:33 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 May 2013 11:07:32 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Richard Genoud <richard.genoud@gmail.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "stable (stable@kernel.org)" <stable@kernel.org>
Subject: RE: [PATCH net, 1/2] hyperv: Fix a kernel warning from
 netvsc_linkstatus_callback()
Thread-Topic: [PATCH net, 1/2] hyperv: Fix a kernel warning from
 netvsc_linkstatus_callback()
Thread-Index: AQHOV5Hi/jMrLCPn2UWqXuCfwjGAfJkS2YHA
Date: Thu, 23 May 2013 14:51:57 +0000
Message-ID: <ed50df23ce9a4fb785faa0082ff79c95@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
References: <1365198280-23270-1-git-send-email-haiyangz@microsoft.com>
 <CACQ1gAi0JfJFAc822YT5xVfW8HkB8r_4rf0dXTNsi-1oChsPsQ@mail.gmail.com>
In-Reply-To: <CACQ1gAi0JfJFAc822YT5xVfW8HkB8r_4rf0dXTNsi-1oChsPsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(164054003)(377454002)(189002)(199002)(479174002)(13464003)(51704005)(23676002)(47736001)(53806001)(79102001)(44976003)(49866001)(47976001)(81542001)(54316002)(56776001)(74366001)(76482001)(56816002)(50986001)(4396001)(63696002)(74706001)(20776003)(77982001)(65816001)(33646001)(47446002)(59766001)(51856001)(47776003)(6806003)(46102001)(50466002)(74876001)(74662001)(69226001)(74502001)(54356001)(31966008)(81342001)(66066001)(80022001)(16406001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB607;H:hybrid.exchange.microsoft.com;CLIP:131.107.1.17;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 085551F5A8
X-OriginatorOrg: DuplicateDomain-b1291ffc-369c-4c2a-9225-e2908f70a426.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4NF7eZu005507



> -----Original Message-----
> From: Richard Genoud [mailto:richard.genoud@gmail.com]
> Sent: Thursday, May 23, 2013 4:44 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net, 1/2] hyperv: Fix a kernel warning from
> netvsc_linkstatus_callback()
> 
> 2013/4/5 Haiyang Zhang <haiyangz@microsoft.com>:
> > The warning about local_bh_enable inside IRQ happens when
> > disconnecting a virtual NIC.
> >
> > The reason for the warning is -- netif_tx_disable() is called when the
> > NIC is disconnected. And it's called within irq context.
> > netif_tx_disable() calls
> > local_bh_enable() which displays warning if in irq.
> >
> > The fix is to remove the unnecessary netif_tx_disable & wake_queue()
> > in the netvsc_linkstatus_callback().
> >
> > Reported-by: Richard Genoud <richard.genoud@gmail.com>
> > Tested-by: Long Li <longli@microsoft.com>
> > Tested-by: Richard Genoud <richard.genoud@gmail.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> >
> > ---
> >  drivers/net/hyperv/netvsc_drv.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index 5f85205..8341b62 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -241,13 +241,11 @@ void netvsc_linkstatus_callback(struct hv_device
> > *device_obj,
> >
> >         if (status == 1) {
> >                 netif_carrier_on(net);
> > -               netif_wake_queue(net);
> >                 ndev_ctx = netdev_priv(net);
> >                 schedule_delayed_work(&ndev_ctx->dwork, 0);
> >                 schedule_delayed_work(&ndev_ctx->dwork,
> msecs_to_jiffies(20));
> >         } else {
> >                 netif_carrier_off(net);
> > -               netif_tx_disable(net);
> >         }
> >  }
> >
> > --
> > 1.7.4.1
> 
> This should also go to the stable tree, shouldn't it ?
> At least 3.8, 3.7 and 3.4 (the 3.2 version is different, and it's in staging. (at not
> used by distros anyway))

Cc: stable <stable@kernel.org>

I agree. Adding stable@kernel.org to Cc list.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
