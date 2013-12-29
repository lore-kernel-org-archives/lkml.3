Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3L2CVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:21:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55647 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab3L2CLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wang Haitao" <wang.haitao1@zte.com.cn>,
        "Pang Xunlei" <pang.xunlei@zte.com.cn>,
        "Brian Norris" <computersforpeace@gmail.com>,
        "Lu Zhongjun" <lu.zhongjun@zte.com.cn>,
        "Zhang Yi" <zhang.yi20@zte.com.cn>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.206000971@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 034/185] mtd: map: fixed bug in 64-bit systems
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/mtd/map.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -361,7 +361,7 @@ static inline map_word map_word_load_par
 			bitpos = (map_bankwidth(map)-1-i)*8;
 #endif
 			orig.x[0] &= ~(0xff << bitpos);
-			orig.x[0] |= buf[i-start] << bitpos;
+			orig.x[0] |= (unsigned long)buf[i-start] << bitpos;
 		}
 	}
 	return orig;
@@ -380,7 +380,7 @@ static inline map_word map_word_ff(struc
 
 	if (map_bankwidth(map) < MAP_FF_LIMIT) {
 		int bw = 8 * map_bankwidth(map);
-		r.x[0] = (1 << bw) - 1;
+		r.x[0] = (1UL << bw) - 1;
 	} else {
 		for (i=0; i<map_words(map); i++)
 			r.x[i] = ~0UL;

