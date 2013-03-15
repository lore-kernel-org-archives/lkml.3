Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3COWvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:51:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:58857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754406Ab3COWvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:51:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,854,1355126400"; 
   d="scan'208";a="302977561"
From: "Abodunrin, Akeem G" <akeem.g.abodunrin@intel.com>
To: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: RE: [PATCH net-next] drivers:net: dma_alloc_coherent: use
 __GFP_ZERO instead of memset(, 0)
Thread-Topic: [PATCH net-next] drivers:net: dma_alloc_coherent: use
 __GFP_ZERO instead of memset(, 0)
Thread-Index: AQHOIaIG/V9F2MUwIEWXwS3jCvz7VZinWUIQ
Date: Fri, 15 Mar 2013 22:51:36 +0000
Message-ID: <CFEEE81102D91947B9CC368106979EBA3CF55939@ORSMSX102.amr.corp.intel.com>
References: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
In-Reply-To: <dbbfc5e66dba7d2b63549d218407fb0c4031f2ed.1363367992.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On Behalf Of Joe Perches
Sent: Friday, March 15, 2013 10:24 AM
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org; e1000-devel@lists.sourceforge.net; linux-wireless@vger.kernel.org; b43-dev@lists.infradead.org; users@rt2x00.serialmonkey.com
Subject: [PATCH net-next] drivers:net: dma_alloc_coherent: use __GFP_ZERO instead of memset(, 0)

Reduce the number of calls required to alloc a zeroed block of memory.

Trivially reduces overall object size.

Other changes around these removals
o Neaten call argument alignment
o Remove an unnecessary OOM message after dma_alloc_coherent failure o Remove unnecessary gfp_t stack variable

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/aeroflex/greth.c              |  8 ++------
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |  8 ++++----
 drivers/net/ethernet/broadcom/bnx2.c               |  5 ++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |  9 +++------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    | 14 ++++++-------
 drivers/net/ethernet/broadcom/tg3.c                | 11 +++--------
 drivers/net/ethernet/brocade/bna/bnad.c            |  5 ++---
 drivers/net/ethernet/emulex/benet/be_main.c        | 14 ++++++-------
 drivers/net/ethernet/faraday/ftgmac100.c           |  5 ++---
 drivers/net/ethernet/faraday/ftmac100.c            |  8 ++++----
 drivers/net/ethernet/ibm/emac/mal.c                |  3 +--
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |  6 ++----
 drivers/net/ethernet/intel/igbvf/netdev.c          |  2 --
 
snip...

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index d60cd43..bea46bb 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -447,7 +447,6 @@ int igbvf_setup_tx_resources(struct igbvf_adapter *adapter,
 
 	tx_ring->desc = dma_alloc_coherent(&pdev->dev, tx_ring->size,
 					   &tx_ring->dma, GFP_KERNEL);
-
 	if (!tx_ring->desc)
 		goto err;
 
@@ -488,7 +487,6 @@ int igbvf_setup_rx_resources(struct igbvf_adapter *adapter,
 
 	rx_ring->desc = dma_alloc_coherent(&pdev->dev, rx_ring->size,
 					   &rx_ring->dma, GFP_KERNEL);
-
 	if (!rx_ring->desc)
 		goto err;

Hi Joe,

Your changes did not seem to make it to igbvf/netdev.c - I think instead of removing an extra line added for code clarity, you want to add:
"tx_ring->desc = dma_alloc_coherent(&pdev->dev, tx_ring->size,
 					   &tx_ring->dma, GFP_KERNEL| __GFP_ZERO);"

Regards,
Akeem Abodunrin

 
--
1.8.1.2.459.gbcd45b4.dirty

--
To unsubscribe from this list: send the line "unsubscribe netdev" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
