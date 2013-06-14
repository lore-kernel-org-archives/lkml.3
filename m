Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3FNQZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:25:19 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.27]:46830 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752375Ab3FNQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:25:17 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix vlan_proto setting in
 netvsc_recv_callback()
Thread-Topic: [PATCH net] hyperv: Fix vlan_proto setting in
 netvsc_recv_callback()
Thread-Index: AQHOW7n7uTEhs128HUOa46xcvWl/Q5k15ZmA//+Y/vA=
Date: Fri, 14 Jun 2013 16:24:16 +0000
Message-ID: <807a9b192c2d4ce1b0c6d037968ddf4c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1369757756-24572-1-git-send-email-haiyangz@microsoft.com>
 <20130614152843.GA11368@aepfle.de>
In-Reply-To: <20130614152843.GA11368@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(377454002)(164054003)(24454002)(13464003)(52604005)(51704005)(49866001)(81542001)(56776001)(79102001)(47736001)(47976001)(54316002)(63696002)(76786001)(76796001)(50986001)(77096001)(56816003)(74366001)(76482001)(4396001)(77982001)(20776003)(47776003)(74706001)(59766001)(50466002)(46102001)(74876001)(69226001)(47446002)(74502001)(74662001)(31966008)(80022001)(6806003)(53806001)(81342001)(51856001)(23676002)(33646001)(54356001)(65816001)(66066001)(44976003)(16406001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB598;H:hybrid.exchange.microsoft.com;CLIP:131.107.1.17;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 08770259B4
X-OriginatorOrg: DuplicateDomain-b1291ffc-369c-4c2a-9225-e2908f70a426.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5EGPS3H006169



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Friday, June 14, 2013 11:29 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; KY Srinivasan;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net] hyperv: Fix vlan_proto setting in
> netvsc_recv_callback()
> 
> On Tue, May 28, Haiyang Zhang wrote:
> 
> > Since the recent addition of 8021AD, we need to set the new field
> > vlan_proto in sk_buff. Otherwise, it will trigger BUG() call in
> vlan_proto_idx().
> 
> > @@ -284,7 +285,7 @@ int netvsc_recv_callback(struct hv_device
> > *device_obj,
> >
> >  	skb->protocol = eth_type_trans(skb, net);
> >  	skb->ip_summed = CHECKSUM_NONE;
> > -	skb->vlan_tci = packet->vlan_tci;
> > +	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), packet-
> >vlan_tci);
> 
> 
> Just curious:
> 
> Doesnt that change behaviour in the sense that __vlan_hwaccel_put_tag()
> now always adds VLAN_TAG_PRESENT to skb->vlan_tci, while before that
> change packet->vlan_tci may or may not had this flag?
> 
> In other words, should a variant of this patch be backported if it was a bug
> not not use __vlan_hwaccel_put_tag right from the start?
> 

Thanks for looking at this. Actually, the previous code was correct, because I 
add the VLAN_TAG_PRESENT if the packet comes from vlan in function
rndis_filter_receive_data():
        if (vlan) {
                pkt->vlan_tci = VLAN_TAG_PRESENT | vlan->vlanid |
                        (vlan->pri << VLAN_PRIO_SHIFT);
        } else {
                pkt->vlan_tci = 0;
        }

But, the new code should be updated below, so the VLAN_TAG_PRESENT won't be set
when it's not from a vlan:
If (VLAN_TAG_PRESENT & packet->vlan_tci)
	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), packet- vlan_tci);

I will submit a patch soon.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
