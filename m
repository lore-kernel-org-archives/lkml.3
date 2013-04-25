Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3DYRcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:32:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab3DYR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
Subject: [PATCH 15/21] thermal: cooling: avoid uninitialied used gcc warning
Date: Thu, 25 Apr 2013 19:28:58 +0200
Message-Id: <1366910944-3033663-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rKDFEauA4/R4HXGmWx8UQ7UyZHXUICuFD5AY4H5dNI9
 2SRGqtLvYYhsB0be3wNVZj6CgHy/75REDoYmD7SoL5Fy6P30P5
 vukWw86p4SMj2EsczaJ4w/6gm2mrTReaavLTgsSHmfRsIG75JA
 9KjTodb69nqnq2qg3M1AwxCjRlJboM7hw3HOu3z1ruPNuGoKpB
 tr95EFiTfjldjNnHewV+qn2d0mMCRayrlG9hEezBObAMoR92vA
 NXht7OU8jBkbkNZOTmf0/7KBOEV7mi2iiQb6k5ixPpdFFWGWgN
 FhLrs9zSxj8r6U6MG6lhw21z0g+w/77OEIIaloU+Oqx4TWDIcS
 ysTWPBicZ0SNyLQ6b5bm1yY6iye/6UhkTmqiiAdpZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly rewritten get_property() function causes a bogus warning
from gcc-3.8, which cannot figure out that "level" is always
initialized at the point where it gets evaluated:

drivers/thermal/cpu_cooling.c: In function 'get_property':
drivers/thermal/cpu_cooling.c:189:37: warning: 'level' may be used uninitialized in this function [-Wmaybe-uninitialized]
   if (property == GET_FREQ && level == j) {
                                     ^

Slightly rearranging the code makes this more obvious and
avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/cpu_cooling.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 768b508..34878e6 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -165,10 +165,6 @@ static int get_property(unsigned int cpu, unsigned long input,
 		return 0;
 	}
 
-	if (property == GET_FREQ)
-		level = descend ? input : (max_level - input -1);
-
-
 	for (i = 0, j = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		/* ignore invalid entry */
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
@@ -186,10 +182,15 @@ static int get_property(unsigned int cpu, unsigned long input,
 			*output = descend ? j : (max_level - j - 1);
 			return 0;
 		}
-		if (property == GET_FREQ && level == j) {
-			/* get frequency by level */
-			*output = freq;
-			return 0;
+
+		if (property == GET_FREQ) {
+			level = descend ? input : (max_level - input -1);
+
+			if (level == j) {
+				/* get frequency by level */
+				*output = freq;
+				return 0;
+			}
 		}
 		j++;
 	}
-- 
1.8.1.2

