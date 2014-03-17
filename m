Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaCQU7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:59:47 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:49675 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbaCQU7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:59:45 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2,1/1] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v2,1/1] hyperv: Add support for virtual
 Receive Side Scaling (vRSS)
Thread-Index: AQHPQGtOCpW0rMAQ3kiLiwjAUkgWbJrmM0iA//+R8DA=
Date: Mon, 17 Mar 2014 20:59:33 +0000
Message-ID: <00f34d2e88ab447bb13e0a19af3cf816@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1394903887-30421-1-git-send-email-haiyangz@microsoft.com>
	 <1394903887-30421-2-git-send-email-haiyangz@microsoft.com>
 <1395088079.22343.6.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1395088079.22343.6.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(13464003)(24454002)(164054003)(377424004)(51704005)(377454003)(66066001)(56816005)(90146001)(54356001)(94316002)(2656002)(94946001)(84676001)(33646001)(81816001)(575784001)(56776001)(97186001)(87266001)(81686001)(87936001)(31966008)(74502001)(53806001)(47446002)(74662001)(80022001)(95416001)(86612001)(80976001)(95666003)(65816001)(4396001)(2009001)(76796001)(92566001)(79102001)(97336001)(6806004)(44976005)(23676002)(74876001)(49866001)(50986001)(93136001)(93516002)(76482001)(47976001)(47736001)(69226001)(97736001)(59766001)(77982001)(51856001)(20776003)(63696002)(47776003)(85306002)(74706001)(83072002)(74366001)(76786001)(85852003)(54316002)(81342001)(81542001)(46102001)(50466002)(19580395003)(19580405001)(83322001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB590;H:hybrid.exchange.microsoft.com;FPR:BAA9FFAA.2DD3B45A.205E3364.9C287ABB.20232;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-Test: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 0153A8321A
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2HKxvfe000563



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Monday, March 17, 2014 4:28 PM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; KY Srinivasan;
> olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v2,1/1] hyperv: Add support for virtual Receive
> Side Scaling (vRSS)
> 
> On Sat, 2014-03-15 at 10:18 -0700, Haiyang Zhang wrote:
> [...]
> >  #define RING_SIZE_MIN 64
> > -static int ring_size = 128;
> > +int ring_size = 128;
> >  module_param(ring_size, int, S_IRUGO);  MODULE_PARM_DESC(ring_size,
> > "Ring buffer size (# of pages)");
> 
> You have to add some driver-specific prefix to the variable name if it is going to
> be extern.  (And use module_param_named to avoid changing the parameter
> name too.)
> 
> [...]
> > +u8 hash_key[HASH_KEYLEN] = {
> > +	0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
> > +	0x41, 0x67, 0x25, 0x3d, 0x43, 0xa3, 0x8f, 0xb0,
> > +	0xd0, 0xca, 0x2b, 0xcb, 0xae, 0x7b, 0x30, 0xb4,
> > +	0x77, 0xcb, 0x2d, 0xa3, 0x80, 0x30, 0xf2, 0x0c,
> > +	0x6a, 0x42, 0xb7, 0x3b, 0xbe, 0xac, 0x01, 0xfa };
> [...]
> 
> Same for this one.
> 
I will do.

Thanks,
- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
