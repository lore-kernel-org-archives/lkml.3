Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3FCQq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:46:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36292 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752663Ab3FCQqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:46:53 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 8/8] pktcdvd: Add struct pktcdvd_device * to pkt_dump_sense()
Date: Mon,  3 Jun 2013 09:45:41 -0700
Message-Id: <83005d9e3418b5cc4401ae1afb68f66c75f741a2.1370276576.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370276576.git.joe@perches.com>
References: <20130603125057.GB23987@mwanda> <cover.1370276576.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the device name to be emitted with pkt_err when
logging the sense data.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/pktcdvd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index f81648c..fabe270 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -755,17 +755,18 @@ static const char *sense_key_string(__u8 index)
  * A generic sense dump / resolve mechanism should be implemented across
  * all ATAPI + SCSI devices.
  */
-static void pkt_dump_sense(struct packet_command *cgc)
+static void pkt_dump_sense(struct pktcdvd_device *pd,
+			   struct packet_command *cgc)
 {
 	struct request_sense *sense = cgc->sense;
 
 	if (sense)
-		pr_err("%*ph - sense %02x.%02x.%02x (%s)\n",
-		       CDROM_PACKET_SIZE, cgc->cmd,
-		       sense->sense_key, sense->asc, sense->ascq,
-		       sense_key_string(sense->sense_key));
+		pkt_err(pd, "%*ph - sense %02x.%02x.%02x (%s)\n",
+			CDROM_PACKET_SIZE, cgc->cmd,
+			sense->sense_key, sense->asc, sense->ascq,
+			sense_key_string(sense->sense_key));
 	else
-		pr_err("%*ph - no sense\n", CDROM_PACKET_SIZE, cgc->cmd);
+		pkt_err(pd, "%*ph - no sense\n", CDROM_PACKET_SIZE, cgc->cmd);
 }
 
 /*
@@ -808,7 +809,7 @@ static noinline_for_stack int pkt_set_speed(struct pktcdvd_device *pd,
 	cgc.cmd[5] = write_speed & 0xff;
 
 	if ((ret = pkt_generic_packet(pd, &cgc)))
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 
 	return ret;
 }
@@ -1702,7 +1703,7 @@ static noinline_for_stack int pkt_set_write_settings(struct pktcdvd_device *pd)
 	init_cdrom_command(&cgc, buffer, sizeof(*wp), CGC_DATA_READ);
 	cgc.sense = &sense;
 	if ((ret = pkt_mode_sense(pd, &cgc, GPMODE_WRITE_PARMS_PAGE, 0))) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -1717,7 +1718,7 @@ static noinline_for_stack int pkt_set_write_settings(struct pktcdvd_device *pd)
 	init_cdrom_command(&cgc, buffer, size, CGC_DATA_READ);
 	cgc.sense = &sense;
 	if ((ret = pkt_mode_sense(pd, &cgc, GPMODE_WRITE_PARMS_PAGE, 0))) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -1759,7 +1760,7 @@ static noinline_for_stack int pkt_set_write_settings(struct pktcdvd_device *pd)
 
 	cgc.buflen = cgc.cmd[8] = size;
 	if ((ret = pkt_mode_select(pd, &cgc))) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -1971,7 +1972,7 @@ static noinline_for_stack int pkt_write_caching(struct pktcdvd_device *pd,
 	ret = pkt_mode_select(pd, &cgc);
 	if (ret) {
 		pkt_err(pd, "write caching control failed\n");
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 	} else if (!ret && set)
 		pkt_notice(pd, "enabled write caching\n");
 	return ret;
@@ -2009,7 +2010,7 @@ static noinline_for_stack int pkt_get_max_speed(struct pktcdvd_device *pd,
 			     sizeof(struct mode_page_header);
 		ret = pkt_mode_sense(pd, &cgc, GPMODE_CAPABILITIES_PAGE, 0);
 		if (ret) {
-			pkt_dump_sense(&cgc);
+			pkt_dump_sense(pd, &cgc);
 			return ret;
 		}
 	}
@@ -2068,7 +2069,7 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 	cgc.cmd[8] = 2;
 	ret = pkt_generic_packet(pd, &cgc);
 	if (ret) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 	size = ((unsigned int) buf[0]<<8) + buf[1] + 2;
@@ -2083,7 +2084,7 @@ static noinline_for_stack int pkt_media_speed(struct pktcdvd_device *pd,
 	cgc.cmd[8] = size;
 	ret = pkt_generic_packet(pd, &cgc);
 	if (ret) {
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 		return ret;
 	}
 
@@ -2138,7 +2139,7 @@ static noinline_for_stack int pkt_perform_opc(struct pktcdvd_device *pd)
 	cgc.cmd[0] = GPCMD_SEND_OPC;
 	cgc.cmd[1] = 1;
 	if ((ret = pkt_generic_packet(pd, &cgc)))
-		pkt_dump_sense(&cgc);
+		pkt_dump_sense(pd, &cgc);
 	return ret;
 }
 
-- 
1.8.1.2.459.gbcd45b4.dirty

