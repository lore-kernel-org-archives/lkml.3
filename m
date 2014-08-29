Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaH2RTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:19:06 -0400
Received: from [207.46.163.188] ([207.46.163.188]:9686 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753268AbaH2RTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:19:05 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, Dexuan Cui <decui@microsoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: RE: [hyperv] BUG: unable to handle kernel paging request at
 ffff8801f5bc7cbb (netvsc_select_queue)
Thread-Topic: [hyperv] BUG: unable to handle kernel paging request at
 ffff8801f5bc7cbb (netvsc_select_queue)
Thread-Index: AQHPw2wO6MHucssNGk6ZrACVaHo57Jvn01Ow
Date: Fri, 29 Aug 2014 17:18:51 +0000
Message-ID: <9b92bf4b20ea4fe7a6be0072e738da3c@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140829093141.GC11445@sucs.org>
In-Reply-To: <20140829093141.GC11445@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(51704005)(189002)(377454003)(199003)(108616004)(46102001)(20776003)(101416001)(64706001)(83322001)(19580405001)(85306004)(90102001)(2656002)(99396002)(105586002)(81342001)(2421001)(76176999)(19580395003)(31966008)(50986999)(1511001)(79102001)(74662001)(95666004)(86362001)(66066001)(77096002)(76482001)(80022001)(106356001)(4396001)(21056001)(85852003)(54356999)(107046002)(81542001)(76576001)(33646002)(106116001)(74316001)(83072002)(87936001)(99286002)(86612001)(92566001)(77982001)(74502001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0712;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Friday, August 29, 2014 2:32 AM
> To: Dexuan Cui
> Cc: KY Srinivasan; Greg Kroah-Hartman; Haiyang Zhang;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org; David Miller; Daniel Borkmann
> Subject: [hyperv] BUG: unable to handle kernel paging request at
> ffff8801f5bc7cbb (netvsc_select_queue)
> 
> While booting a 10 vcpu system with a post v3.17-rc2 kernel with the
> "Drivers: hv: vmbus: Eliminate calls to BUG_ON()",  "Drivers: hv: vmbus:
> Miscellaneous cleanup" patches and debugging/verification config options on
> I'm seeing the following:

Sitsofe,

Could you please try the following patch:

>From c8a6a5570f9a7f8b9a2b47f165848e5533091e79 Mon Sep 17 00:00:00 2001
From: K. Y. Srinivasan <kys@microsoft.com>
Date: Fri, 29 Aug 2014 11:18:18 -0700
Subject: [PATCH 1/1] Drivers: net: hyperv: Cleanup  netvsc_change_mtu ()


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index a9c5eaa..485f5b7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -696,6 +696,7 @@ static int netvsc_change_mtu(struct net_device *ndev, int mtu)
        struct netvsc_device *nvdev = hv_get_drvdata(hdev);
        struct netvsc_device_info device_info;
        int limit = ETH_DATA_LEN;
+       int ret;

        if (nvdev == NULL || nvdev->destroy)
                return -ENODEV;
@@ -716,7 +717,9 @@ static int netvsc_change_mtu(struct net_device *ndev, int mtu)
        ndevctx->device_ctx = hdev;
        hv_set_drvdata(hdev, ndev);
        device_info.ring_size = ring_size;
-       rndis_filter_device_add(hdev, &device_info);
+       ret = rndis_filter_device_add(hdev, &device_info);
+       if (ret)
+               return ret;
        netif_tx_wake_all_queues(ndev);

        return 0;
--
1.7.4.1
