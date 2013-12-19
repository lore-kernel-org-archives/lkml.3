Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3LSShF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:37:05 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.90]:14282 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab3LSShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:37:01 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
Thread-Topic: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
Thread-Index: AQHO/DjpLyfIXxkiYUqDQo2oHD6XuZpcUhsA//+GhuA=
Date: Thu, 19 Dec 2013 18:36:27 +0000
Message-ID: <ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
 <1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(377454003)(164054003)(377424004)(51704005)(189002)(199002)(24454002)(83072002)(47776003)(66066001)(63696002)(76482001)(74706001)(47736001)(2656002)(49866001)(54316002)(47446002)(20776003)(65816001)(80022001)(46102001)(47976001)(81686001)(59766001)(81342001)(77982001)(85306002)(80976001)(87266001)(85852003)(50986001)(56776001)(74662001)(76786001)(76796001)(81542001)(74876001)(50466002)(53806001)(4396001)(69226001)(79102001)(19580395003)(83322001)(19580405001)(54356001)(6806004)(74366001)(87936001)(90146001)(44976005)(81816001)(31966008)(51856001)(74502001)(33646001)(23676002)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.100;FPR:;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 006546F32A
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJIbCBJ006822



> -----Original Message-----
> From: Ben Hutchings [mailto:bhutchings@solarflare.com]
> Sent: Thursday, December 19, 2013 12:46 PM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; KY Srinivasan;
> olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
> Scaling (vRSS)
> 
> On Wed, 2013-12-18 at 14:21 -0800, Haiyang Zhang wrote:
> > This feature allows multiple channels to be used by each virtual NIC.
> > It is available on Hyper-V host 2012 R2.
> >  	} else if (ret == -EAGAIN) {
> > -		netif_stop_queue(ndev);
> > +		netif_tx_stop_all_queues(ndev);
> >  		if (atomic_read(&net_device->num_outstanding_sends) < 1) {
> > -			netif_wake_queue(ndev);
> > +			netif_tx_wake_all_queues(ndev);
> >  			ret = -ENOSPC;
> >  		}
> >  	} else {
> 
> This doesn't makes any sense to me.  How can you safely share the same
> channels between all TX queues?
> 
> I think you need to associate TX queues and channels 1-1.  If you are required to
> map packets to TX queues using the Toeplitz hash, you should implement
> ndo_select_queue and do the mapping there.  Then in
> netvsc_send() you would use the queue number from the skb to find which
> channel to use and which queue may need to be stopped/woken.
> 
> [...]
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> [...]
> > +/* Toeplitz hash function
> > + * data: network byte order
> > + * return: host byte order
> > + */
> 
> This looks incredibly slow.  I've seen software implementations that are likely to
> be more efficient, e.g.
> <http://thread.gmane.org/gmane.linux.network/284612/>
> 
> [...]
> > int netvsc_probe(struct hv_device *dev,
> >  		return ret;
> >  	}
> >  	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
> > +	nvdev = hv_get_drvdata(dev);
> > +	rtnl_lock();
> > +	netif_set_real_num_tx_queues(net, nvdev->num_chn);
> > +	netif_set_real_num_rx_queues(net, nvdev->num_chn);
> [...]
> 
> These functions can fail if called after registering the net device, so you should
> either call them with the final values earlier or handle failure here.
> 
> Also, I notice that dev_addr is only set after registering; that should be fixed.
> 

Thank you for the suggestions! I will re-write the send queue selection, enhance
the hash calculation, also fix the initialization sequence.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
