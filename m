Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaKZObq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:31:46 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10663 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:31:16 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a9-5475e432ac20
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lukasz Pawelczyk <havner@gmail.com>,
        Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH 2/2] smack: fix logic in smack_inode_init_security function
Date: Wed, 26 Nov 2014 15:31:07 +0100
Message-id: <1417012267-21298-2-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1417012267-21298-1-git-send-email-l.pawelczyk@samsung.com>
References: <1417012267-21298-1-git-send-email-l.pawelczyk@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xq7pGT0pDDDpfK1rc2/aLzeL/ax2L
	vsdBFmcmLWSyuLxrDpvFh55HbBbnL5xjd2D32DnrLrvHtd2RHh+f3mLx6NuyitHj6P5FbB6f
	N8kFsEVx2aSk5mSWpRbp2yVwZbT0XmQqWMBZseNcbgPjFvYuRk4OCQETid7HC1ghbDGJC/fW
	s3UxcnEICSxllLj0dg4ThNPLJDH/QxMLSBWbgIHE9wt7mUESIgLHGSX6nu1kBEkwC4RKXJsx
	nRnEFhbwlth95CWYzSKgKnH26zSwGl4Bd4kDnWeZINbJSfRuewNWwyngIfH/yBGwk4SAap5O
	3M40gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ0Pq6g3HpMatDjAIcjEo8vDfi
	SkKEWBPLiitzDzFKcDArifCm3ikNEeJNSaysSi3Kjy8qzUktPsTIxMEp1cB4cs1bmQITpoVP
	a44LyC4wCPS7mnL3Q8brsKDEKb4J2mcNGctZXI7V2clp/EqwXxazZNELw/ezGh9fZP80+8Ox
	97PMEvr4rfJsXkuW5e6Zu8hn2yqD2wEeezbKBOpP+SInuLHJQ//X/unq6q9mecu//Wd/5Yvf
	F3tWsekrS1hU/Xd1ujeLFmxXYinOSDTUYi4qTgQAv5gHjgsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In principle if this function was called with "value" == NULL and "len"
not NULL it could return different results for the "len" compared to a
case where "name" was not NULL. This is a hypothetical case that does
not exist in the kernel, but it's a logic bug nonetheless.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 security/smack/smack_lsm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d1b14d5..e8bed86 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -800,7 +800,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	if (name)
 		*name = XATTR_SMACK_SUFFIX;
 
-	if (value) {
+	if (value && len) {
 		rcu_read_lock();
 		may = smk_access_entry(skp->smk_known, dsp->smk_known,
 				       &skp->smk_rules);
@@ -821,10 +821,9 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		*value = kstrdup(isp->smk_known, GFP_NOFS);
 		if (*value == NULL)
 			return -ENOMEM;
-	}
 
-	if (len)
 		*len = strlen(isp->smk_known);
+	}
 
 	return 0;
 }
-- 
1.9.3

