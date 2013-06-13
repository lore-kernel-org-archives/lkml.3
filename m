Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3FMP3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:29:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34275 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab3FMP3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:29:31 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-4a-51b9e55a1fa0
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 1/5] security: smack: avoid kmalloc allocations while loading a
 rule string
Date: Thu, 13 Jun 2013 17:29:08 +0200
Message-id: <1371137352-31273-2-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
References: <1371137352-31273-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e+xgG7U052BBmd2CVjc2/aLzeJs0xt2
	i8u75rBZfOh5xGax9shddou3k1YwW8xrf8nqwO7Rt2UVo8fR/YvYPD5vkgtgjuKySUnNySxL
	LdK3S+DK2Dq9m7ngtHDF5DkL2BsYn/B3MXJySAiYSEx6vZkRwhaTuHBvPRuILSSwiFHiw8mq
	LkYuILuLSeL0oUNgRWxADceWfAazRQQ0JY5NB2ng4mAW2MYo0fFiKhNIQlggWqJp7hJWEJtF
	QFWi5fs0sAZeAQ+JD+fPMkNsk5d4er8PbBungKfE21sbWSA2e0gcfbKYeQIj7wJGhlWMoqkF
	yQXFSem5hnrFibnFpXnpesn5uZsYwSH0TGoH48oGi0OMAhyMSjy8CRd2BgqxJpYVV+YeYpTg
	YFYS4VV/CBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXA
	aPJiW/6q7Lwl56cxr6idsE/mTZTdjNBFr7in26SIXGWPt2So3XhkT0Hk3y0F28vKb7msmhSY
	sfDIidVrAgvUqhY87dnsWNy+f8mrbTLfFZWbI6K0DnzWnPtLMD9387dgs+X5UQHOxyabJhSW
	Nv23aPg4h+3xgqonViLxyju9JzfP3b98QgnfPiWW4oxEQy3mouJEAJahRL8dAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximal length for a rule line for long format is introduced as
SMK_LOAD2LEN. This allows a buffer for a rule string to be allocated
on a stack instead of a heap (aka kmalloc cache).

Limiting the length of a rule line helps to avoid allocations of a very long
contiguous buffer from a heap if user calls write() for a very long chunk.
Such an allocation often causes a lot swapper/writeback havoc and it is very
likely to fails.

Moreover, stack allocation is slightly faster than from kmalloc.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 security/smack/smackfs.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 53a08b8..9a3cd0d 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -137,6 +137,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
  * SMK_ACCESS: Maximum possible combination of access permissions
  * SMK_ACCESSLEN: Maximum length for a rule access field
  * SMK_LOADLEN: Smack rule length
+ * SMK_LOAD2LEN: Smack maximal long rule length excluding \0
  */
 #define SMK_OACCESS	"rwxa"
 #define SMK_ACCESS	"rwxat"
@@ -144,6 +145,7 @@ const char *smack_cipso_option = SMACK_CIPSO_OPTION;
 #define SMK_ACCESSLEN	(sizeof(SMK_ACCESS) - 1)
 #define SMK_OLOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_OACCESSLEN)
 #define SMK_LOADLEN	(SMK_LABELLEN + SMK_LABELLEN + SMK_ACCESSLEN)
+#define SMK_LOAD2LEN	(2 * SMK_LONGLABEL + SMK_ACCESSLEN + 2)
 
 /*
  * Stricly for CIPSO level manipulation.
@@ -447,8 +449,7 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 {
 	struct smack_known *skp;
 	struct smack_parsed_rule *rule;
-	char *data;
-	int datalen;
+	char data[SMK_LOAD2LEN + 1];
 	int rc = -EINVAL;
 	int load = 0;
 
@@ -465,13 +466,10 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 		 */
 		if (count != SMK_OLOADLEN && count != SMK_LOADLEN)
 			return -EINVAL;
-		datalen = SMK_LOADLEN;
-	} else
-		datalen = count + 1;
+	}
 
-	data = kzalloc(datalen, GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
+	if (count > SMK_LOAD2LEN)
+		count = SMK_LOAD2LEN;
 
 	if (copy_from_user(data, buf, count) != 0) {
 		rc = -EFAULT;
@@ -522,7 +520,6 @@ static ssize_t smk_write_rules_list(struct file *file, const char __user *buf,
 out_free_rule:
 	kfree(rule);
 out:
-	kfree(data);
 	return rc;
 }
 
-- 
1.7.9.5

