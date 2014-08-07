Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaHGGfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:35:04 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:10021 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaHGGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:35:01 -0400
From: "Koehrer Mathias (ETAS/ESW5)" <mathias.koehrer@etas.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Richard Cochran <richardcochran@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v2] Fix e1000e with Intel 82572EI that has no hardware
 timestamp support
Thread-Topic: [PATCH v2] Fix e1000e with Intel 82572EI that has no hardware
 timestamp support
Thread-Index: Ac+yCaBvJGpPdt5VRfmsvwavaIQuKA==
Date: Thu, 7 Aug 2014 06:34:47 +0000
Message-ID: <6714867b045641e19fd37aa9dba66957@FE-MBX1012.de.bosch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.5.148.126]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s776ZBXr016062

With the Intel 82527EI (driver: e1000e) there is an issue when running
the ptpd2 program, that leads to a kernel oops.  The reason is here that
in e1000_xmit_frame() a work queue will be scheduled that has not been
initialized in this case.  The work queue "tx_hwstamp_work" will only be
initialized if adapter->flags & FLAG_HAS_HW_TIMESTAMP set.  This check
is missing in e1000_xmit_frame().

The following patch adds the missing check.

Signed-off-by: Mathias Koehrer <mathias.koehrer@etas.com>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-3.12.26/drivers/net/ethernet/intel/e1000e/netdev.c
===================================================================
--- linux-3.12.26.orig/drivers/net/ethernet/intel/e1000e/netdev.c	2014-08-04 10:56:56.000000000 +0200
+++ linux-3.12.26/drivers/net/ethernet/intel/e1000e/netdev.c	2014-08-07 08:27:09.000000000 +0200
@@ -5549,8 +5549,9 @@
 	count = e1000_tx_map(tx_ring, skb, first, adapter->tx_fifo_limit,
 			     nr_frags);
 	if (count) {
-		if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
-			     !adapter->tx_hwtstamp_skb)) {
+		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+		    (adapter->flags & FLAG_HAS_HW_TIMESTAMP) &&
+		    !adapter->tx_hwtstamp_skb) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= E1000_TX_FLAGS_HWTSTAMP;
 			adapter->tx_hwtstamp_skb = skb_get(skb);

-- 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
