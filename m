Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaDZCkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 22:40:43 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:24500
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaDZCkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 22:40:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
Thread-Topic: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
Thread-Index: AQHPYK69zRY2bKGNPUekzRg75l4abpsjD68AgAAI94CAABMRYIAABCSQ
Date: Sat, 26 Apr 2014 02:40:20 +0000
Message-ID: <47a133e9d77a48919a60816b146ac745@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398451514-25593-1-git-send-email-kys@microsoft.com>
 <20140425174322.589ed9f1@samsung-9>
 <1398474927.29914.100.camel@edumazet-glaptop2.roam.corp.google.com>
 <ab8c51e4f124498486104a4a25514dea@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <ab8c51e4f124498486104a4a25514dea@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:7d9e:a813:4d30:6320]
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(13464003)(377454003)(199002)(189002)(51704005)(377424004)(79102001)(74502001)(15975445006)(1511001)(86362001)(74662001)(46102001)(83072002)(15202345003)(20776003)(85852003)(33646001)(80022001)(50986999)(77096999)(76176999)(54356999)(77982001)(81542001)(87936001)(81342001)(19580395003)(2656002)(76482001)(83322001)(74316001)(80976001)(99396002)(76576001)(92566001)(4396001)(19580405001)(31966008)(86612001)(99286001)(101416001)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB300;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:BC9FC216.B182E72A.31D3B3DC.80E5ABE0.20258;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: driverdev-devel-bounces@linuxdriverproject.org [mailto:driverdev-
> devel-bounces@linuxdriverproject.org] On Behalf Of KY Srinivasan
> Sent: Friday, April 25, 2014 7:24 PM
> To: Eric Dumazet; Stephen Hemminger
> Cc: olaf@aepfle.de; netdev@vger.kernel.org; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; stable@kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org; davem@davemloft.net
> Subject: RE: [PATCH net-next 1/1] hyperv: Properly handle checksum offload
> 
> 
> 
> > -----Original Message-----
> > From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> > Sent: Friday, April 25, 2014 6:15 PM
> > To: Stephen Hemminger
> > Cc: KY Srinivasan; davem@davemloft.net; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> > apw@canonical.com; jasowang@redhat.com; stable@kernel.org
> > Subject: Re: [PATCH net-next 1/1] hyperv: Properly handle checksum
> > offload
> >
> > On Fri, 2014-04-25 at 17:43 -0700, Stephen Hemminger wrote:
> > > On Fri, 25 Apr 2014 11:45:14 -0700
> > > "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> > >
> > > > @@ -474,6 +477,9 @@ static int netvsc_start_xmit(struct sk_buff
> > > > *skb,
> > struct net_device *net)
> > > >  	csum_info = (struct ndis_tcp_ip_checksum_info *)((void *)ppi +
> > > >  			ppi->ppi_offset);
> > > >
> > > > +	ip_hdr(skb)->check = 0;
> > > > +	csum_info->transmit.ip_header_checksum = 1;
> > > > +
> > > >  	if (net_trans_info & (INFO_IPV4 << 16))
> > > >  		csum_info->transmit.is_ipv4 = 1;
> > > >  	else
> > >
> > > Linux doesn't need or want IP checksum offload.
> > > It will not have any performance gain.
> >
> >
> > BTW, was this patch even tested with IPv6 packets ???
> 
> No; I only tested this on ipv4.
Oops; this would not work on ipv6. I am going to resend this patch.

K. Y
> 
> K. Y
> >
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
