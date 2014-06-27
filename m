Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaF0KP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:15:57 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:36133
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbaF0KP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:15:56 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2014 06:15:55 EDT
From: Aaron Wu <Aaron.wu@analog.com>
To: <linux-kernel@vger.kernel.org>, <aaron.wu@analog.com>,
        <sonic.zhang@analog.com>
CC: Aaron Wu <Aaron.wu@analog.com>
Subject: [PATCH] gpio_flash: fix the CPLB miss bug for gpio expanded flash
Date: Fri, 27 Jun 2014 17:57:19 +0800
Message-ID: <1403863039-7534-1-git-send-email-Aaron.wu@analog.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:137.71.25.55;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(77156001)(76482001)(86362001)(85852003)(46102001)(83072002)(77982001)(2201001)(50986999)(19580395003)(36756003)(19580405001)(81342001)(50466002)(50226001)(4396001)(6806004)(102836001)(81542001)(107046002)(44976005)(21056001)(80022001)(85306003)(20776003)(47776003)(105606002)(64706001)(62966002)(95666004)(89996001)(99396002)(106466001)(92726001)(79102001)(104166001)(83322001)(87936001)(74662001)(74502001)(48376002)(88136002)(87286001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB191;H:nwd2mta1.analog.com;FPR:;MLV:sfv;PTR:nwd2mail10.analog.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=fail (sender IP is 137.71.25.55)
 smtp.mailfrom=Aaron.Wu@analog.com; 
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this bug, the address operation range may exceed the
window size defined by gpio expanded flash MTD partition.

Signed-off-by: Aaron Wu <Aaron.wu@analog.com>
---
 drivers/mtd/maps/gpio-addr-flash.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index a4c477b..ca9282f 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -108,13 +108,24 @@ static void gf_copy_from(struct map_info *map, void *to, unsigned long from, ssi
 {
 	struct async_state *state = gf_map_info_to_state(map);
 
-	gf_set_gpios(state, from);
+	int this_len;
 
 	/* BUG if operation crosses the win_size */
 	BUG_ON(!((from + len) % state->win_size <= (from + len)));
 
-	/* operation does not cross the win_size, so one shot it */
-	memcpy_fromio(to, map->virt + (from % state->win_size), len);
+	while (len) {
+		if ((from % state->win_size) + len > state->win_size)
+			this_len = state->win_size - (from % state->win_size);
+		else
+			this_len = len;
+
+		gf_set_gpios(state, from);
+		memcpy_fromio(to, map->virt + (from % state->win_size)
+			, this_len);
+		len -= this_len;
+		from += this_len;
+		to += this_len;
+	}
 }
 
 /**
@@ -147,13 +158,24 @@ static void gf_copy_to(struct map_info *map, unsigned long to,
 {
 	struct async_state *state = gf_map_info_to_state(map);
 
-	gf_set_gpios(state, to);
+	int this_len;
 
 	/* BUG if operation crosses the win_size */
 	BUG_ON(!((to + len) % state->win_size <= (to + len)));
 
-	/* operation does not cross the win_size, so one shot it */
-	memcpy_toio(map->virt + (to % state->win_size), from, len);
+	while (len) {
+		if ((to % state->win_size) + len > state->win_size)
+			this_len = state->win_size - (to % state->win_size);
+		else
+			this_len = len;
+
+		gf_set_gpios(state, to);
+		memcpy_toio(map->virt + (to % state->win_size), from, len);
+
+		len -= this_len;
+		to += this_len;
+		from += this_len;
+	}
 }
 
 static const char * const part_probe_types[] = {
-- 
1.7.9.5

