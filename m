Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab3KMSLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:11:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab3KMSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:11:23 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 1/1] thermal: fix cpu_cooling max_level behavior
Date: Wed, 13 Nov 2013 14:11:09 -0400
Message-ID: <1384366269-1655-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Documentation/thermal/sysfs-api.txt, max_level
is an index, not a counter. Thus, in case a CPU has
3 valid frequencies, max_level is expected to be 2, for instance.

The current code makes max_level == number of valid frequencies,
which is bogus. This patch fix the cpu_cooling device by
ranging max_level properly.

Reported-by: Carlos Hernandez <ceh@ti.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/cpu_cooling.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index d179028..d0f8f8b5 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -173,6 +173,8 @@ static int get_property(unsigned int cpu, unsigned long input,
 		freq = table[i].frequency;
 		max_level++;
 	}
+	/* max_level is an index, not a counter */
+	max_level--;
 
 	/* get max level */
 	if (property == GET_MAXL) {
@@ -181,7 +183,7 @@ static int get_property(unsigned int cpu, unsigned long input,
 	}
 
 	if (property == GET_FREQ)
-		level = descend ? input : (max_level - input - 1);
+		level = descend ? input : (max_level - input);
 
 	for (i = 0, j = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		/* ignore invalid entry */
@@ -197,7 +199,7 @@ static int get_property(unsigned int cpu, unsigned long input,
 
 		if (property == GET_LEVEL && (unsigned int)input == freq) {
 			/* get level by frequency */
-			*output = descend ? j : (max_level - j - 1);
+			*output = descend ? j : (max_level - j);
 			return 0;
 		}
 		if (property == GET_FREQ && level == j) {
-- 
1.8.2.1.342.gfa7285d

