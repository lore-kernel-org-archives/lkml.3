Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3GIJ5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:57:11 -0400
Received: from multi.imgtec.com ([194.200.65.239]:53150 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab3GIJ5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:57:08 -0400
Message-ID: <51DBDE71.1000805@imgtec.com>
Date: Tue, 9 Jul 2013 10:57:05 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: James <james.hogan@imgtec.com>
Subject: [PATCH] metag: checksum.h: fix carry in csum_tcpudp_nofold
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_09_10_57_06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In csum_tcpudp_nofold, add 1 if the carry bit is set after adding the
destination IP address (32 bits) to the checksum (16 bits).

The lack of carry handling for this particular addition meant that a
destination address of *.*.255.255 (e.g. certain broadcasts) sometimes
resulted in an incorrect checksum. This bug has been present in the Meta
port since the code was written in the 2.4 days.

Reported-by: Marcin Nowakowski <Marcin.Nowakowski@pure.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
I'll add this patch to my arch/metag fixes branch for v3.11.

 arch/metag/include/asm/checksum.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/metag/include/asm/checksum.h b/arch/metag/include/asm/checksum.h
index 999bf76..08dd1cc 100644
--- a/arch/metag/include/asm/checksum.h
+++ b/arch/metag/include/asm/checksum.h
@@ -64,7 +64,8 @@ static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 					__wsum sum)
 {
 	unsigned long len_proto = (proto + len) << 8;
-	asm ("ADD    %0, %0, %1\n"
+	asm ("ADDS   %0, %0, %1\n"
+	     "ADDCS  %0, %0, #1\n"
 	     "ADDS   %0, %0, %2\n"
 	     "ADDCS  %0, %0, #1\n"
 	     "ADDS   %0, %0, %3\n"
-- 
1.8.1.2

