Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaB1PDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:03:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23102 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaB1PBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:01:35 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e4-5310a4cc5469
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/8] ima: fix erronous removal of security.ima xattr
Date: Fri, 28 Feb 2014 16:59:25 +0200
Message-id: <26fce2ad8be7c65be3bfe972f91c7a1dbe8ae668.1393599538.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1393599538.git.d.kasatkin@samsung.com>
References: <cover.1393599538.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xa7pnlggEG/yeZG1xY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugStj0plTTAXXuCvOzXvG3sB4nrOLkYNDQsBE4s380C5GTiBT
	TOLCvfVsXYxcHEICSxkl9m6/DuV0MklcvHCMHaSKTUBPYkPzDzBbRMBZYtGtdlaQImaBqYwS
	r25NYwFJCAu4SNyftg3MZhFQlVi5dBYTiM0rECdxb/kNdoh1ChLLvqxlBrE5Bawktly+xwpi
	CwlYSlx9NpcNl/gERv4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKC8csOxsXHrA4x
	CnAwKvHwSiwSCBZiTSwrrsw9xCjBwawkwjt9PlCINyWxsiq1KD++qDQntfgQIxMHp1QDo1L6
	XbZnu++wtW6+wsnnfqlf7Myf7xJSE/ivMuk+VRWdJHNq1ue2IjWPJjnvW7/33S+MyQxxmCy8
	SmbqN/cFhW1F7LtiN1gd+1SfY9bc8t0qzenvpSvTfa1qjSeUH3ulyRquxa2WtJ9942ytywbb
	YiW8zt94mXbww54diYm/9gZnV9stM3/focRSnJFoqMVcVJwIAKCc6LgkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ima_inode_post_setattr() calls ima_must_appraise() to check if
file needs to be appraised. If it is not then it removes security.ima
xattr. With original policy matching code it might happen that even
file needs to be appraised with FILE_CHECK hook, it might not be
for POST_SETATTR hook. 'security.ima' might be erronously removed.

This patch treats POST_SETATTR as special wildcard function and will
cause ima_must_appraise() to be true if any of the hooks rules matches.
security.ima will not be removed if any of the hooks would require
appraisal.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/ima/ima_policy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d7c97a4..947cdbe 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -167,9 +167,11 @@ static bool ima_match_rules(struct ima_rule_entry *rule,
 	const struct cred *cred = current_cred();
 	int i;
 
-	if ((rule->flags & IMA_FUNC) && rule->func != func)
+	if ((rule->flags & IMA_FUNC) &&
+		    (rule->func != func && func != POST_SETATTR))
 		return false;
-	if ((rule->flags & IMA_MASK) && rule->mask != mask)
+	if ((rule->flags & IMA_MASK) &&
+		    (rule->mask != mask && func != POST_SETATTR))
 		return false;
 	if ((rule->flags & IMA_FSMAGIC)
 	    && rule->fsmagic != inode->i_sb->s_magic)
-- 
1.8.3.2

