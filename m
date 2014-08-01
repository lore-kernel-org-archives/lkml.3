Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaHARvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:51:49 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:29821
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751204AbaHARvr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:51:47 -0400
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of the
 sendbuf region
Thread-Topic: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of the
 sendbuf region
Thread-Index: AQHPrFcl/pZ15J3jR0S9Ym/gWYDpuJu7MfeAgADTGUA=
Date: Fri, 1 Aug 2014 17:51:44 +0000
Message-ID: <e19aea30a421423090ba63db9ff8e0af@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1406770549-29982-1-git-send-email-kys@microsoft.com>
 <20140731.215907.860867918938148695.davem@davemloft.net>
In-Reply-To: <20140731.215907.860867918938148695.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:ee31::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(13464003)(199002)(189002)(106116001)(106356001)(85306004)(79102001)(19580405001)(83322001)(64706001)(105586002)(33646002)(110136001)(19580395003)(80022001)(20776003)(77096002)(107046002)(50986999)(99286002)(81342001)(99396002)(76176999)(95666004)(92566001)(31966008)(101416001)(4396001)(54356999)(74502001)(81542001)(74662001)(74316001)(86362001)(76576001)(87936001)(2656002)(77982001)(76482001)(46102001)(83072002)(85852003)(21056001)(24736002)(3826002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, July 31, 2014 9:59 PM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: net-next: hyperv: Increase the size of the
> sendbuf region
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Wed, 30 Jul 2014 18:35:49 -0700
> 
> > For forwarding scenarios, it will be useful to allocate larger
> > sendbuf. Make the necessary adjustments to permit this.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> This needs more information.
> 
> You're increasing the size by 16 times, 1MB --> 16MB, thus less cache locality.
> 
> You're also now using vmalloc() memory, thus more TLB misses and
> thrashing.
> 
> This must have a negative impact on performance, and you have to test for
> that and quantify it when making a change as serious as this one.
> 
> You also haven't gone into detail as to why forwarding scenerios require
> more buffer space, than say thousands of local sockets sending bulk TCP
> data.

David,

Intel did some benchmarking on our network throughput when Linux on Hyper-V was used as a gateway.
This fix gave us almost a 1 Gbps additional throughput on about 5Gbps base throughput we had prior to
Increasing the sendbuf size. The sendbuf mechanism is a copy based transport that we have which is clearly
more optimal than the copy-free page flipping mechanism (for small packets). In the forwarding scenario, we deal
only with MTU sized packets, and increasing the size of the senbuf area gave us the additional performance.

For what it is worth, Windows guests on Hyper-V, I am told use similar sendbuf size as well.

The exact value of sendbuf I think is less important than the fact that it needs to be larger than what Linux can
allocate as physically contiguous memory. Thus the change over to allocating via vmalloc(). As you know we currently
allocate 16MB receive buffer and we use vmalloc there for allocation. Also the low level channel code has already been
modified to deal with physically dis-contiguous memory in the ringbuffer setup.

Again based on experimentation Intel did, they say there was some improvement in throughput as the sendbuf size was
Increased up to 16MB and there was no effect on throughput beyond 16MB. Thus I chose 16MB here.

Increasing the sendbuf value makes a material difference in small packet handling. Let me know what I should do to
make this patch acceptable.

Regards,

K. Y

 
> 
> I'm not applying this, it needs a lot more work.
