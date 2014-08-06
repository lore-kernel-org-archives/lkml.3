Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaHFOcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:32:22 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:49765 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHFOcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:32:20 -0400
From: "Koehrer Mathias (ETAS/ESW5)" <mathias.koehrer@etas.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Nick Krause <xerofoify@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] Fix e1000e with Intel 82572EI that has no hardware
 timestamp support
Thread-Topic: [PATCH] Fix e1000e with Intel 82572EI that has no hardware
 timestamp support
Thread-Index: Ac+xgnCw6PdHzoE/S12kdgrkOgAeXA==
Date: Wed, 6 Aug 2014 14:32:16 +0000
Message-ID: <bbcbf584e3624059bf7a0d2186fec6b4@FE-MBX1012.de.bosch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.5.148.126]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the Intel 82527EI (driver: e1000e) there is an issue when running 
the ptpd2 program, that leads to a kernel oops.
The reason is here that in e1000_xmit_frame() a work queue will be 
scheduled that has not been initialized in this case.
The work queue "tx_hwstamp_work" will only be initialized if 
adapter->flags & FLAG_HAS_HW_TIMESTAMP set.
This check is missing in e1000_xmit_frame().

The following patch adds the missing check.

Signed-off-by: Mathias Koehrer <mathias.koehrer@etas.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-3.12.26/drivers/net/ethernet/intel/e1000e/netdev.c
===================================================================
--- linux-3.12.26.orig/drivers/net/ethernet/intel/e1000e/netdev.c	2014-08-04 10:56:56.000000000 +0200
+++ linux-3.12.26/drivers/net/ethernet/intel/e1000e/netdev.c	2014-08-06 16:22:10.000000000 +0200
@@ -5549,8 +5549,9 @@
 	count = e1000_tx_map(tx_ring, skb, first, adapter->tx_fifo_limit,
 			     nr_frags);
 	if (count) {
-		if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-			     !adapter->tx_hwtstamp_skb)) {
+		if ((adapter->flags & FLAG_HAS_HW_TIMESTAMP) && 
+		    unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+		    !adapter->tx_hwtstamp_skb)) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= E1000_TX_FLAGS_HWTSTAMP;
 			adapter->tx_hwtstamp_skb = skb_get(skb);

-- 

