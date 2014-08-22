Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaHVVGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:06:25 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.91]:28822 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbaHVVGX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:06:23 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add handling of IP header with option
 field in netvsc_set_hash()
Thread-Topic: [PATCH net-next] hyperv: Add handling of IP header with option
 field in netvsc_set_hash()
Thread-Index: AQHPu/AFjt4c2RGoMUq5qiWODsubiZvcgTSAgACgXXA=
Date: Fri, 22 Aug 2014 21:06:10 +0000
Message-ID: <0d7d4fd9cf1448f3a92b07b241d21a7e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1408481635-29639-1-git-send-email-haiyangz@microsoft.com>
 <20140821.213057.1438247518790500739.davem@davemloft.net>
In-Reply-To: <20140821.213057.1438247518790500739.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(164054003)(189002)(13464003)(199003)(377454003)(51704005)(85852003)(83072002)(74502001)(92566001)(106466001)(68736004)(99396002)(86612001)(31966008)(6806004)(83322001)(44976005)(74662001)(97756001)(2009001)(19580395003)(97736001)(2656002)(85306004)(110136001)(108616004)(87936001)(54356999)(90102001)(106116001)(76176999)(21056001)(50986999)(33646002)(107046002)(19580405001)(584604001)(50466002)(79102001)(47776003)(80022001)(20776003)(46406003)(64706001)(66066001)(46102001)(81342001)(23726002)(4396001)(81542001)(77982001)(76482001)(84676001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:CH1SR01MB599;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, August 22, 2014 12:31 AM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add handling of IP header with
> option field in netvsc_set_hash()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 19 Aug 2014 20:53:55 +0000
> 
> > @@ -200,12 +202,18 @@ static bool netvsc_set_hash(u32 *hash, struct
> sk_buff *skb)
> >  	iphdr = ip_hdr(skb);
> >
> >  	if (iphdr->version == 4) {
> > -		if (iphdr->protocol == IPPROTO_TCP)
> > +		data = (u8 *)&iphdr->saddr;
> > +		if (iphdr->protocol == IPPROTO_TCP) {
> >  			data_len = 12;
> > -		else
> > +			if (iphdr->ihl > 5) {
> > +				memcpy(dbuf, &iphdr->saddr, 8);
> > +				memcpy(&dbuf[8], &tcp_hdr(skb)->source, 4);
> 
> This is rediculous.
> 
> Make hash_comp() take a void pointer for the buffer.
> 
> Then your code is simply:
> 
> 	be32 dbuf[2];
> 
> 	dbuf[1] = iph->saddr;
> 	dbuf[2] = iph->daddr;
> 	dbuf[3] = *(be32 *)tcph->source;
> 
> 	*hash = comp_hash(netvsc_hash_key, HASH_KEYLEN, dbuf, 12);
> 
> No special cases for IP options or any garbage like that.

I have submitted a revised patch with the suggested changes.

Thanks,
- Haiyang

