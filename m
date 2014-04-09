Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbaDISIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:08:53 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:55569
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933440AbaDISIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:08:50 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
 issues
Thread-Topic: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
 issues
Thread-Index: AQHPU1uXnPiEDJtl6E20Y4v9ie8cnpsJg+aAgAAN2TA=
Date: Wed, 9 Apr 2014 18:08:47 +0000
Message-ID: <4ae24ae5c6ea45c399e7be03c69dc442@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1396986332-12098-1-git-send-email-kys@microsoft.com>
	<1396986371-12137-1-git-send-email-kys@microsoft.com>
	<1396986371-12137-4-git-send-email-kys@microsoft.com>
 <20140409.130111.1002891296248446198.davem@davemloft.net>
In-Reply-To: <20140409.130111.1002891296248446198.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ed43::3]
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(13464003)(189002)(199002)(51704005)(20776003)(76576001)(86362001)(77982001)(99396002)(81342001)(83072002)(4396001)(76482001)(19580395003)(33646001)(46102001)(74662001)(92566001)(80976001)(19580405001)(31966008)(79102001)(81542001)(85852003)(74502001)(74316001)(83322001)(87936001)(80022001)(2656002)(50986999)(76176999)(54356999)(77096999)(3826001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:FAFCC834.A813471A.F1D35BE6.C2D5DBD9.202D4;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, April 9, 2014 10:01 AM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum
> issues
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Tue,  8 Apr 2014 12:46:11 -0700
> 
> >  	} else if (net_trans_info & INFO_UDP) {
> > -		csum_info->transmit.udp_checksum = 1;
> > +		/* UDP checksum offload is not supported on ws2008r2.
> > +		 * Furthermore, on ws2012 and ws2012r2, there are some
> > +		 * issues with udp checksum offload from Linux guests.
> > +		 * (these are host issues).
> > +		 * For now compute the checksum here.
> > +		 */
> > +		struct udphdr *uh = udp_hdr(skb);
> > +		u16 udp_len = ntohs(uh->len);
> > +
> > +		uh->check = 0;
> > +		uh->check = csum_tcpudp_magic(ip_hdr(skb)->saddr,
> > +					      ip_hdr(skb)->daddr,
> > +					      udp_len, IPPROTO_UDP,
> > +					      csum_partial(uh, udp_len, 0));
> > +		if (uh->check == 0)
> > +			uh->check = CSUM_MANGLED_0;
> > +
> > +		csum_info->transmit.udp_checksum = 0;
> 
> You absolutely cannot mangle packet header contents without first COW'ing
> the SKB to make sure it's writable.
> 
> Otherwise network taps like tcpdump, and any other entity with a reference
> to the packet, can see inconsistent state.

Thanks Dave. I will COW the SKB before changing the checksum value. I do have a question though.
I looked at a bunch of hardware drivers and they modify the header information, specially checksum
field and I could not see where they had COWed the skb. I was grepping for skb_cow in these drivers.


Regards,

K. Y
