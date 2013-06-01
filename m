Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3FAEM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:12:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47825 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755021Ab3FAEMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:12:22 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 6/8] pktcdvd: Convert pr_notice to pkt_notice
Date: Fri, 31 May 2013 21:11:27 -0700
Message-Id: <57c43b1b2fdcec5bc95d22654bd4f34df6cc1faf.1370048648.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722> <cover.1370048648.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new pkt_notice macro to prefix the name to the logging output.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 07ff878..3815f01 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -71,17 +71,19 @@
 
 #define DRIVER_NAME	"pktcdvd"
 
+#define pkt_err(pd, fmt, ...)						\
+	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
+#define pkt_notice(pd, fmt, ...)					\
+	pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
+
 #define pkt_dbg(level, pd, fmt, ...)					\
 do {									\
 	if (level == 2 && PACKET_DEBUG >= 2)				\
-		pr_notice("%s: %s():" fmt,				\
-			  pd->name, __func__, ##__VA_ARGS__);		\
+		pkt_notice(pd, "%s(): " fmt, __func__, ##__VA_ARGS__);	\
 	else if (level == 1 && PACKET_DEBUG >= 1)			\
-		pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__);		\
+		pkt_notice(pd, fmt, ##__VA_ARGS__);			\
 } while (0)
 
-#define pkt_err(pd, fmt, ...)						\
-	pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
 
 #define MAX_SPEED 0xffff
 
@@ -1821,7 +1823,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	 * but i'm not sure, should we leave this to user apps? probably.
 	 */
 	if (di->disc_type == 0xff) {
-		pr_notice("unknown disc - no track?\n");
+		pkt_notice(pd, "unknown disc - no track?\n");
 		return 0;
 	}
 
@@ -1831,7 +1833,7 @@ static int pkt_writable_disc(struct pktcdvd_device *pd, disc_information *di)
 	}
 
 	if (di->erasable == 0) {
-		pr_notice("disc not erasable\n");
+		pkt_notice(pd, "disc not erasable\n");
 		return 0;
 	}
 
@@ -1887,7 +1889,7 @@ static noinline_for_stack int pkt_probe_settings(struct pktcdvd_device *pd)
 	 */
 	pd->settings.size = be32_to_cpu(ti.fixed_packet_size) << 2;
 	if (pd->settings.size == 0) {
-		pr_notice("detected zero packet size!\n");
+		pkt_notice(pd, "detected zero packet size!\n");
 		return -ENXIO;
 	}
 	if (pd->settings.size > PACKET_MAX_SECTORS) {
@@ -1970,7 +1972,7 @@ static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
 		pkt_err(pd, "write caching control failed\n");
 		pkt_dump_sense(&cgc);
 	} else if (!ret && set)
-		pr_notice("enabled write caching on %s\n", pd->name);
+		pkt_notice(pd, "enabled write caching\n");
 	return ret;
 }
 
@@ -2085,11 +2087,11 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
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
 
@@ -2109,14 +2111,14 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
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
@@ -2382,8 +2384,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
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

