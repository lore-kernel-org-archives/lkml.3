Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3GOSsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:48:06 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:54250 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283Ab3GOSsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:48:04 -0400
Message-ID: <1373914081.2591.40.camel@x61.thuisdomein>
Subject: [PATCH v2] [SCSI] scsi_debug: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 20:48:01 +0200
In-Reply-To: <1373879920.2591.13.camel@x61.thuisdomein>
References: <1373879920.2591.13.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2013 18:48:01.0914 (UTC) FILETIME=[D549BDA0:01CE818B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building scsi_debug.o triggers a GCC warning:
    drivers/scsi/scsi_debug.c: In function ‘dif_verify’:
    drivers/scsi/scsi_debug.c:1755:3: warning: ‘csum’ may be used uninitialized in this function [-Wmaybe-uninitialized]

This is a false positive. But if we transform the switch statement in
dif_compute_csum() to a straightforward if/else statement we supply GCC
with enough information to determine that csum will not be used
uninitialized.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2 because I started to worry whether v1 would change an interface
(ie, the way the "guard" module parameter behaves). This patch is much
simpler, and doesn't change any behavior.

1) Still only compile tested.

 drivers/scsi/scsi_debug.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..7565ec5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1735,14 +1735,11 @@ static u16 dif_compute_csum(const void *buf, int len)
 {
 	u16 csum;
 
-	switch (scsi_debug_guard) {
-	case 1:
+	if (scsi_debug_guard == 1)
 		csum = ip_compute_csum(buf, len);
-		break;
-	case 0:
+	else
 		csum = cpu_to_be16(crc_t10dif(buf, len));
-		break;
-	}
+
 	return csum;
 }
 
-- 
1.8.1.4

