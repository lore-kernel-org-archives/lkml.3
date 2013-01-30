Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab3A3Vxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:53:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757017Ab3A3Vxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:53:46 -0500
Date: Wed, 30 Jan 2013 16:53:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ima: added policy support for 'security.ima' type
Message-ID: <20130130215340.GA4918@redhat.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1358892454-25045-2-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358892454-25045-2-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:07:31PM -0500, Mimi Zohar wrote:

[..]
>  /* iint cache flags */
> +#define IMA_ACTION_FLAGS	0xff00
>  #define IMA_DIGSIG		0x0100
> +#define IMA_DIGSIG_REQUIRED	0x0200

Hi Mimi,

IMA_DIGSIG_REQUIRED state does not really have to be stored in iint I guess.
This is needed only if we go on to appraise and then we want to make
sure digital signatures are present. Once appraisal is done, IMG_DIGSIG
will be set and saved in iint->flags but looks like we don't require
IMA_DIGSIG_REQUIRED to be saved.

If yes, will it make sense to not save it in iint. There are still 8
bits left unused. We can mark these 8 bits for temporary flags like
IMA_DIGSIG_REQUIRED. If that works, I can use same space for defining
additional temporary flags like IMA_DIGSIG_SIGNED_ONLY to handle the
case of appraise_type=imasig,signed_only. That flag also does not have
to be persistent in iint.

Here is a quick patch compile tested only.

Thanks
Vivek

---
 security/integrity/ima/ima.h          |    5 +++--
 security/integrity/ima/ima_appraise.c |    5 +++--
 security/integrity/ima/ima_main.c     |    8 ++++++--
 security/integrity/ima/ima_policy.c   |    2 +-
 security/integrity/integrity.h        |    5 ++++-
 5 files changed, 17 insertions(+), 8 deletions(-)

Index: linux-integrity/security/integrity/integrity.h
===================================================================
--- linux-integrity.orig/security/integrity/integrity.h	2013-01-30 16:22:04.000000000 -0500
+++ linux-integrity/security/integrity/integrity.h	2013-01-30 16:25:03.736892034 -0500
@@ -28,7 +28,10 @@
 /* iint cache flags */
 #define IMA_ACTION_FLAGS	0xff000000
 #define IMA_DIGSIG		0x01000000
-#define IMA_DIGSIG_REQUIRED	0x02000000
+
+/* Temp flags not stored in iint */
+#define IMA_TEMP_FLAGS		0x00ff0000
+#define IMA_DIGSIG_REQUIRED	0x00010000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_APPRAISE_SUBMASK)
Index: linux-integrity/security/integrity/ima/ima_main.c
===================================================================
--- linux-integrity.orig/security/integrity/ima/ima_main.c	2013-01-29 17:13:05.000000000 -0500
+++ linux-integrity/security/integrity/ima/ima_main.c	2013-01-30 16:39:09.414918012 -0500
@@ -146,7 +146,7 @@ static int process_measurement(struct fi
 	struct integrity_iint_cache *iint;
 	char *pathbuf = NULL;
 	const char *pathname = NULL;
-	int rc = -ENOMEM, action, must_appraise, _func;
+	int rc = -ENOMEM, action, must_appraise, _func, temp_flags;
 
 	if (!ima_initialized || !S_ISREG(inode->i_mode))
 		return 0;
@@ -174,6 +174,9 @@ static int process_measurement(struct fi
 	 * (IMA_MEASURE, IMA_MEASURED, IMA_XXXX_APPRAISE, IMA_XXXX_APPRAISED,
 	 *  IMA_AUDIT, IMA_AUDITED)
 	 */
+	/* Temp flags don't have to be stored in iint */
+	temp_flags = action & IMA_TEMP_FLAGS;
+	action &= ~IMA_TEMP_FLAGS;
 	iint->flags |= action;
 	action &= IMA_DO_MASK;
 	action &= ~((iint->flags & IMA_DONE_MASK) >> 1);
@@ -198,7 +201,8 @@ static int process_measurement(struct fi
 	if (action & IMA_MEASURE)
 		ima_store_measurement(iint, file, pathname);
 	if (action & IMA_APPRAISE_SUBMASK)
-		rc = ima_appraise_measurement(_func, iint, file, pathname);
+		rc = ima_appraise_measurement(_func, iint, file, pathname,
+					      temp_flags);
 	if (action & IMA_AUDIT)
 		ima_audit_measurement(iint, pathname);
 	kfree(pathbuf);
Index: linux-integrity/security/integrity/ima/ima_appraise.c
===================================================================
--- linux-integrity.orig/security/integrity/ima/ima_appraise.c	2013-01-30 16:22:04.000000000 -0500
+++ linux-integrity/security/integrity/ima/ima_appraise.c	2013-01-30 16:37:11.667914395 -0500
@@ -116,7 +116,8 @@ static void ima_cache_flags(struct integ
  * Return 0 on success, error code otherwise
  */
 int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
-			     struct file *file, const unsigned char *filename)
+			     struct file *file, const unsigned char *filename,
+			     int flags)
 {
 	struct dentry *dentry = file->f_dentry;
 	struct inode *inode = dentry->d_inode;
@@ -154,7 +155,7 @@ int ima_appraise_measurement(int func, s
 	}
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST:
-		if (iint->flags & IMA_DIGSIG_REQUIRED) {
+		if (flags & IMA_DIGSIG_REQUIRED) {
 			cause = "IMA signature required";
 			status = INTEGRITY_FAIL;
 			break;
Index: linux-integrity/security/integrity/ima/ima.h
===================================================================
--- linux-integrity.orig/security/integrity/ima/ima.h	2013-01-30 10:46:32.000000000 -0500
+++ linux-integrity/security/integrity/ima/ima.h	2013-01-30 16:38:40.800917133 -0500
@@ -143,7 +143,7 @@ void ima_delete_rules(void);
 
 #ifdef CONFIG_IMA_APPRAISE
 int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
-			     struct file *file, const unsigned char *filename);
+		struct file *file, const unsigned char *filename, int flags);
 int ima_must_appraise(struct inode *inode, int mask, enum ima_hooks func);
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file);
 enum integrity_status ima_get_cache_status(struct integrity_iint_cache *iint,
@@ -153,7 +153,8 @@ enum integrity_status ima_get_cache_stat
 static inline int ima_appraise_measurement(int func,
 					   struct integrity_iint_cache *iint,
 					   struct file *file,
-					   const unsigned char *filename)
+					   const unsigned char *filename,
+					   int flags)
 {
 	return INTEGRITY_UNKNOWN;
 }
Index: linux-integrity/security/integrity/ima/ima_policy.c
===================================================================
--- linux-integrity.orig/security/integrity/ima/ima_policy.c	2013-01-30 16:41:39.000000000 -0500
+++ linux-integrity/security/integrity/ima/ima_policy.c	2013-01-30 16:41:56.151923133 -0500
@@ -267,7 +267,7 @@ int ima_match_policy(struct inode *inode
 		if (!ima_match_rules(entry, inode, func, mask))
 			continue;
 
-		action |= entry->flags & IMA_ACTION_FLAGS;
+		action |= entry->flags & IMA_TEMP_FLAGS;
 
 		action |= entry->action & IMA_DO_MASK;
 		if (entry->action & IMA_APPRAISE)
