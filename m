Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab3FCQqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:46:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37382 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752663Ab3FCQqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:46:36 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 6/8] pktcdvd: Convert pr_notice to pkt_notice
Date: Mon,  3 Jun 2013 09:45:39 -0700
Message-Id: <5d7bc1dba2e9f63461241b5be75741488c189379.1370276576.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370276576.git.joe@perches.com>
References: <20130603125057.GB23987@mwanda> <cover.1370276576.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new pkt_notice macro to prefix the name to the logging output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index e71e23d..faae94c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -73,6 +73,8 @@
 
 #define pkt_err(pd, fmt, ...)						\
 	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
+#define pkt_notice(pd, fmt, ...)					\
+	pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
 
 #define pkt_dbg(level, pd, fmt, ...)					\
 do {									\
@@ -1820,7 +1822,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	 * but i'm not sure, should we leave this to user apps? probably.
 	 */
 	if (di->disc_type == 0xff) {
-		pr_notice("unknown disc - no track?\n");
+		pkt_notice(pd, "unknown disc - no track?\n");
 		return 0;
 	}
 
@@ -1830,7 +1832,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	}
 
 	if (di->erasable == 0) {
-		pr_notice("disc not erasable\n");
+		pkt_notice(pd, "disc not erasable\n");
 		return 0;
 	}
 
@@ -1886,7 +1888,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 	 */
 	pd->settings.size = be32_to_cpu(ti.fixed_packet_size) << 2;
 	if (pd->settings.size == 0) {
-		pr_notice("detected zero packet size!\n");
+		pkt_notice(pd, "detected zero packet size!\n");
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
@@ -1969,7 +1971,7 @@ static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
 		pkt_err(pd, "write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
-		pr_notice("enabled write caching on %s\n", pd->name);
+		pkt_notice(pd, "enabled write caching\n");
 	return ret;
 }
 
@@ -2084,11 +2086,11 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 	}
 
 	if (!(buf[6] & 0x40)) {
-		pr_notice("disc type is not CD-RW\n");
+		pkt_notice(pd, "disc type is not CD-RW\n");
 		return 1;
 	}
 	if (!(buf[6] & 0x4)) {
-		pr_notice("A1 values on media are not valid, maybe not CDRW?\n");
+		pkt_notice(pd, "A1 values on media are not valid, maybe not CDRW?\n");
 		return 1;
 	}
 
@@ -2108,14 +2110,14 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 			*speed = us_clv_to_speed[sp];
 			break;
 		default:
-			pr_notice("unknown disc sub-type %d\n", st);
+			pkt_notice(pd, "unknown disc sub-type %d\n", st);
 			return 1;
 	}
 	if (*speed) {
 		pr_info("maximum media speed: %d\n", *speed);
 		return 0;
 	} else {
-		pr_notice("unknown speed %d for sub-type %d\n", sp, st);
+		pkt_notice(pd, "unknown speed %d for sub-type %d\n", sp, st);
 		return 1;
 	}
 }
@@ -2381,8 +2383,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	if (!test_bit(PACKET_WRITABLE, &pd->flags)) {
-		pr_notice("WRITE for ro device %s (%llu)\n",
-			  pd->name, (unsigned long long)bio->bi_sector);
+		pkt_notice(pd, "WRITE for ro device (%llu)\n",
+			   (unsigned long long)bio->bi_sector);
 		goto end_io;
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

