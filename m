Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaJCLla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:41:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60584 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaJCLk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:40:28 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-39-542e8b2936dd
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 2/4] ima: no need to allocate entry for comment
Date: Fri, 03 Oct 2014 14:40:19 +0300
Message-id: <115f415354083d858d8ea15fff52910d622f8caf.1412336062.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e/4VV3Nbr0QgyvnGS1u/d3LbPFlaZ3F
	yxnz2C0u75rDZvGh5xGbxacVk5gd2Dx2zrrL7vHg0GYWj90LPjN59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aerQ+ZCo5xVEy53MXSwPiVrYuRk0NCwETizK1zULaYxIV764FsLg4hgaWM
	EiunL2aBcDqZJFZu2MQCUsUmoCexofkHO4gtIpAjMenMBWYQm1kgXeLTpF6wuLCAk8Suqy/B
	6lkEVCUmTrgIVsMrECdxrGUj1DY5iZPHJrN2MXJwcApYSazr8wcJCwlYSnRefcCGQ3gCI/8C
	RoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFh92UH4+JjVocYBTgYlXh4P97QDRFiTSwr
	rsw9xCjBwawkwivdpBcixJuSWFmVWpQfX1Sak1p8iJGJg1OqgbFuZ5S905tTj/e2uq3LD1Wa
	WnH00AeNF1sDgn8lLfQ+l5+jFfQ7Vec+e/vF+1cv1Hu92uPWe0aDW0nzKm/hXe3tn5Q6lJPi
	59QcXHZbyob1U/b0F4YPtr1cYhUivCSrb22zz373YmbT41POZMiHWW5sPuvPcOj8ZaaF7eJ3
	xK1b9PWvr/5j9UKJpTgj0VCLuag4EQAY3lERGQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rule is a comment, there is no need to allocate entry.
Move checking for comment before allocating entry.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_policy.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index cdc620b..bf232b9 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -694,6 +694,12 @@ ssize_t ima_parse_add_rule(char *rule)
 		return -EACCES;
 	}
 
+	p = strsep(&rule, "\n");
+	len = strlen(p) + 1;
+
+	if (*p == '#')
+		return len;
+
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
 		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
@@ -703,14 +709,6 @@ ssize_t ima_parse_add_rule(char *rule)
 
 	INIT_LIST_HEAD(&entry->list);
 
-	p = strsep(&rule, "\n");
-	len = strlen(p) + 1;
-
-	if (*p == '#') {
-		kfree(entry);
-		return len;
-	}
-
 	result = ima_parse_rule(p, entry);
 	if (result) {
 		kfree(entry);
-- 
1.9.1

