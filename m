Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaEEHgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:36:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43150 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaEEHgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:36:08 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-19-53673f652bc5
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux@arm.linux.org.uk
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] arm: memset: zero out upper bytes in r1
Date: Mon, 05 May 2014 11:11:13 +0400
Message-id: <1399273875-8403-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xq7qp9unBBmdmmFhs+/WIzWLT42us
	Fpd3zWGzuH2Z14HFo6W5h81j85J6j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mpo/V9XMJe9
	4t+Kq+wNjHdYuxg5OSQETCRWNF1ggrDFJC7cW8/WxcjFISSwlFHi56p+Rginh0li6ovbYB1s
	AnoS/2ZtZwOxRQSkJGbsXMoOYjMLzGKUePgpAsQWFrCQOHnmD1gNi4CqxP1905lBbF4BV4kX
	208zQmxTkFj2ZS3zBEbuBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCPP91B+PSY1aH
	GAU4GJV4eD28U4KFWBPLiitzDzFKcDArifDOYkwPFuJNSaysSi3Kjy8qzUktPsTIxMEp1cC4
	o893vuZSb5dzZ+btl78gn1F3ouxB3uWK2uy/m+rnWxetOigQs8vQWFBDcPnFyB/izK1fls7x
	lZ97KqbpcPJHg5fGJhfObDsd3/opXZvXJWfBtCcL93/+dj7VIDPwjhvrg+v7ivj/zNI4tvz5
	6UOnlnWkbfVSWhcZayG16NqvJYsXJF7c9EJLWYmlOCPRUIu5qDgRANXMZq7aAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memset doesn't work right for following example:

	signed char c = 0xF0;
	memset(addr, c, size);

Variable c is signed, so after typcasting to int the value will be 0xFFFFFFF0.
This value will be passed through r1 regitster to memset function.
memset doesn't zero out upper bytes in r1, so memory will be filled
with 0xFFFFFFF0 instead of expected 0xF0F0F0F0.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/lib/memset.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
index 94b0650..a010f76 100644
--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -22,7 +22,8 @@ ENTRY(memset)
 /*
  * we know that the pointer in ip is aligned to a word boundary.
  */
-1:	orr	r1, r1, r1, lsl #8
+1:	and	r1, r1, #0xff
+	orr	r1, r1, r1, lsl #8
 	orr	r1, r1, r1, lsl #16
 	mov	r3, r1
 	cmp	r2, #16
-- 
1.8.3.2

