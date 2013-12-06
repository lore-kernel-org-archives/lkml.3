Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162811Ab3LFNvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:51:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab3LFNCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pang Xunlei <pang.xunlei@zte.com.cn>, Zhang Yi <zhang.yi20@zte.com.cn>,
        Lu Zhongjun <lu.zhongjun@zte.com.cn>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/272] mtd: map: fixed bug in 64-bit systems
Date: Fri,  6 Dec 2013 12:56:39 +0000
Message-Id: <1386334761-25517-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Haitao <wang.haitao1@zte.com.cn>

commit a4d62babf988fe5dfde24437fa135ef147bc7aa0 upstream.

Hardware:
	CPU: XLP832,the 64-bit OS
	NOR Flash:S29GL128S 128M
Software:
	Kernel:2.6.32.41
	Filesystem:JFFS2
When writing files, errors appear:
	Write len 182  but return retlen 180
	Write of 182 bytes at 0x072c815c failed. returned -5, retlen 180
	Write len 186  but return retlen 184
	Write of 186 bytes at 0x072caff4 failed. returned -5, retlen 184
These errors exist only in 64-bit systems,not in 32-bit systems. After analysis, we
found that the left shift operation is wrong in map_word_load_partial. For instance:
	unsigned char buf[3] ={0x9e,0x3a,0xea};
	map_bankwidth(map) is 4;
	for (i=0; i < 3; i++) {
		int bitpos;
		bitpos = (map_bankwidth(map)-1-i)*8;
		orig.x[0] &= ~(0xff << bitpos);
		orig.x[0] |= buf[i] << bitpos;
	}

The value of orig.x[0] is expected to be 0x9e3aeaff, but in this situation(64-bit
System) we'll get the wrong value of 0xffffffff9e3aeaff due to the 64-bit sign
extension:
buf[i] is defined as "unsigned char" and the left-shift operation will convert it
to the type of "signed int", so when left-shift buf[i] by 24 bits, the final result
will get the wrong value: 0xffffffff9e3aeaff.

If the left-shift bits are less than 24, then sign extension will not occur. Whereas
the bankwidth of the nor flash we used is 4, therefore this BUG emerges.

Signed-off-by: Pang Xunlei <pang.xunlei@zte.com.cn>
Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Signed-off-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/mtd/map.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 4b02512..5f487d7 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -365,7 +365,7 @@ static inline map_word map_word_load_partial(struct map_info *map, map_word orig
 			bitpos = (map_bankwidth(map)-1-i)*8;
 #endif
 			orig.x[0] &= ~(0xff << bitpos);
-			orig.x[0] |= buf[i-start] << bitpos;
+			orig.x[0] |= (unsigned long)buf[i-start] << bitpos;
 		}
 	}
 	return orig;
@@ -384,7 +384,7 @@ static inline map_word map_word_ff(struct map_info *map)
 
 	if (map_bankwidth(map) < MAP_FF_LIMIT) {
 		int bw = 8 * map_bankwidth(map);
-		r.x[0] = (1 << bw) - 1;
+		r.x[0] = (1UL << bw) - 1;
 	} else {
 		for (i=0; i<map_words(map); i++)
 			r.x[i] = ~0UL;
-- 
1.8.3.2

