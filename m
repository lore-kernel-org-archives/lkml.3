Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935827Ab3BTPyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:54:55 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37384 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631Ab3BTPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:54:53 -0500
From: "Roberts, Lee A." <lee.roberts@hp.com>
To: "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] sctp: fix association hangs due to reassembly/ordering
 logic
Thread-Topic: [PATCH 1/3] sctp: fix association hangs due to
 reassembly/ordering logic
Thread-Index: AQHOD4Cv0TMB3JXjPEux7Xoyv2ti4ZiC5Itw
Date: Wed, 20 Feb 2013 15:54:00 +0000
Message-ID: <D64EC45690EF85409BA6C4730E0162244310ABA1@G4W3231.americas.hpqcorp.net>
References: <1361374860.3450.1.camel@laptop.lroberts>
In-Reply-To: <1361374860.3450.1.camel@laptop.lroberts>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.14]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1KFsvo4004440

From: Lee A. Roberts <lee.roberts@hp.com>

Resolve SCTP association hangs observed during SCTP stress
testing.  Observable symptoms include communications hangs
with data being held in the association lobby (ordering)
queue.  Close examination of reassembly/ordering queues shows
duplicated packets.

In sctp_tsnmap_grow(), correct off-by-one errors when copying
and resizing the tsnmap.  If max_tsn_seen is in the LSB of the
word, this bit can be lost, causing the corresponding packet
to be transmitted again and to be entered as a duplicate into
the SCTP reassembly/ordering queues.

Patch applies to linux-3.8 kernel.

Signed-off-by: Lee A. Roberts <lee.roberts@hp.com>
---
 net/sctp/tsnmap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -uprN -X linux-3.8-vanilla/Documentation/dontdiff
linux-3.8-vanilla/net/sctp/tsnmap.c linux-3.8-SCTP+1/net/sctp/tsnmap.c
--- linux-3.8-vanilla/net/sctp/tsnmap.c	2013-02-18 16:58:34.000000000
-0700
+++ linux-3.8-SCTP+1/net/sctp/tsnmap.c	2013-02-20 08:01:02.555223259
-0700
@@ -369,14 +369,15 @@ static int sctp_tsnmap_grow(struct sctp_
 	if (gap >= SCTP_TSN_MAP_SIZE)
 		return 0;
 
-	inc = ALIGN((gap - map->len),BITS_PER_LONG) + SCTP_TSN_MAP_INCREMENT;
+	inc = ALIGN((gap - map->len + 1), BITS_PER_LONG)
+		+ SCTP_TSN_MAP_INCREMENT;
 	len = min_t(u16, map->len + inc, SCTP_TSN_MAP_SIZE);
 
 	new = kzalloc(len>>3, GFP_ATOMIC);
 	if (!new)
 		return 0;
 
-	bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn);
+	bitmap_copy(new, map->tsn_map, map->max_tsn_seen - map->base_tsn + 1);
 	kfree(map->tsn_map);
 	map->tsn_map = new;
 	map->len = len;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
