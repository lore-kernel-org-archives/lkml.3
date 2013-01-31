Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3AaTh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:37:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3AaThy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:37:54 -0500
Date: Thu, 31 Jan 2013 14:37:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ima: added policy support for 'security.ima' type
Message-ID: <20130131193729.GD2580@redhat.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1358892454-25045-2-git-send-email-zohar@linux.vnet.ibm.com>
 <20130130215340.GA4918@redhat.com>
 <1359585759.816.127.camel@falcor1.watson.ibm.com>
 <20130131184144.GC2580@redhat.com>
 <1359660311.816.173.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359660311.816.173.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 02:25:11PM -0500, Mimi Zohar wrote:

[..]
> With the following patches, which James pulled earlier this week, each
> hook can have a different appraise status.
> 
> 5a73fcf ima: differentiate appraise status only for hook specific rules
> d79d72e ima: per hook cache integrity appraisal status
> f578c08 ima: increase iint flag size
> 0e5a247 ima: added policy support for 'security.ima' type

Yes I understand that. I am not worried about appraise status of each hook.
I am only concerned about IMA_DIGSIG_REQUIRED flag which does not belong to
iint->flags.

As now I am trying to extend appraise_type to be able to appraise only
signed executables and I need one more extra flag to keep track of that
state.

If I just use one bit from IMA_ACTION_FLAGS (like IMA_DIGSIG_REQUIRED),
say IMA_DIGSIG_SIGNED_ONLY, then we can potentially run into the 
situation where two different appraise hooks set these two flags
separately causing some confusion.

To have written following patch which just uses one bit from
IMA_ACTION_FLAGS. But I am not too happy with it. That's why I wanted
to move temporary flags out of IMA_ACTION_FLAGS.

Thanks
Vivek

ima: Extend appraise policy to appraise only signed files

Currently appraise policy appraises every file. Allow to configure rules
such that one can specify that appraise only signed files and unsinged
ones just pass integrity test always.

This patch etends appraise type and one can specify
apprasie_type=imasig,signed_only to appraise only signed files.

I think there is one issue here. That is new flag IMA_DIGSIG_SIGNED_ONLY
is not hook specific. So if mmap hook says appraise_type=imasig
and bprm_check hook says appraise_type=ima_sig,signed_only, I think
mmap hook settings will be overidded. As both IMA_DIGSIG_REQUIRED and
IMA_DIGSIG_SIGNED_ONLY flags will be set (one from mmap hook and
other from bprm_check hook).

I guess to support it we require hook specific flags.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/ima/ima_appraise.c |   32 ++++++++++++++++++++++++++++----
 security/integrity/ima/ima_policy.c   |    2 ++
 security/integrity/integrity.h        |    2 ++
 3 files changed, 32 insertions(+), 4 deletions(-)

Index: linux-integrity/security/integrity/integrity.h
===================================================================
--- linux-integrity.orig/security/integrity/integrity.h	2013-01-30 10:46:32.793412454 -0500
+++ linux-integrity/security/integrity/integrity.h	2013-01-30 10:46:33.553412477 -0500
@@ -29,6 +29,8 @@
 #define IMA_ACTION_FLAGS	0xff000000
 #define IMA_DIGSIG		0x01000000
 #define IMA_DIGSIG_REQUIRED	0x02000000
+/* Appraise digital signature only, if present */
+#define IMA_DIGSIG_SIGNED_ONLY	0x04000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
Index: linux-integrity/security/integrity/ima/ima_policy.c
===================================================================
--- linux-integrity.orig/security/integrity/ima/ima_policy.c	2013-01-30 10:46:32.793412454 -0500
+++ linux-integrity/security/integrity/ima/ima_policy.c	2013-01-30 10:46:33.554412477 -0500
@@ -598,6 +598,8 @@ static int ima_parse_rule(char *rule, st
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if ((strcmp(args[0].from, "imasig")) == 0)
 				entry->flags |= IMA_DIGSIG_REQUIRED;
+			else if (!strcmp(args[0].from, "imasig,signed_only"))
+				entry->flags |= IMA_DIGSIG_SIGNED_ONLY;
 			else
 				result = -EINVAL;
 			break;
Index: linux-integrity/security/integrity/ima/ima_appraise.c
===================================================================
--- linux-integrity.orig/security/integrity/ima/ima_appraise.c	2013-01-30 10:46:32.793412454 -0500
+++ linux-integrity/security/integrity/ima/ima_appraise.c	2013-01-30 15:34:54.500286490 -0500
@@ -124,16 +124,27 @@ int ima_appraise_measurement(int func, s
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	const char *op = "appraise_data";
 	char *cause = "unknown";
-	int rc;
+	int rc, audit_info = 0;
 
 	if (!ima_appraise)
 		return 0;
-	if (!inode->i_op->getxattr)
+	if (!inode->i_op->getxattr) {
+		/* getxattr not supported. file couldn't have been signed */
+		if (iint->flags & IMA_DIGSIG_SIGNED_ONLY)
+			return INTEGRITY_PASS;
 		return INTEGRITY_UNKNOWN;
+	}
 
 	rc = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)&xattr_value,
 				0, GFP_NOFS);
 	if (rc <= 0) {
+		if (rc == -EOPNOTSUPP) {
+			/* File system does not have security label support */
+			if (iint->flags & IMA_DIGSIG_SIGNED_ONLY)
+				return INTEGRITY_PASS;
+			return INTEGRITY_UNKNOWN;
+		}
+
 		if (rc && rc != -ENODATA)
 			goto out;
 
@@ -159,6 +170,13 @@ int ima_appraise_measurement(int func, s
 			status = INTEGRITY_FAIL;
 			break;
 		}
+
+		if (iint->flags & IMA_DIGSIG_SIGNED_ONLY) {
+			/* Appraise happens only for digital signatures */
+			status = INTEGRITY_PASS;
+			break;
+		}
+
 		rc = memcmp(xattr_value->digest, iint->ima_xattr.digest,
 			    IMA_DIGEST_SIZE);
 		if (rc) {
@@ -197,8 +215,14 @@ out:
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
 		}
-		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
-				    op, cause, rc, 0);
+		if (status == INTEGRITY_NOLABEL &&
+		    iint->flags & IMA_DIGSIG_SIGNED_ONLY) {
+			status = INTEGRITY_PASS;
+			/* Don't flood audit logs with skipped appraise */
+			audit_info = 1;
+		}
+		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
+					filename, op, cause, rc, audit_info);
 	} else {
 		ima_cache_flags(iint, func);
 	}
