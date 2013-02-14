Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605Ab3BNT5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:57:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934895Ab3BNTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:55:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: [PATCH 2/6] ima: Return INTEGRITY_FAIL if digital signature can't be verified
Date: Thu, 14 Feb 2013 14:55:41 -0500
Message-Id: <1360871745-20616-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Digital signature verification happens using integrity_digsig_verify().
Curently we set integrity to FAIL for all error codes except -EOPNOTSUPP.
This sounds out of line.

- If appropriate kernel code is not compiled in to verify signature of
  a file, then prractically it is a failed signature.

- For so many other possible errors we are setting the status to fail.
  For example, -EINVAL, -ENOKEY, -ENOMEM, -EINVAL, -ENOTSUPP etc, it
  beats me that why -EOPNOTSUPP is special.

This patch should make the semantics more consistent. That is, if digital
signature is present in security.ima, then any error happened during
signature processing leads to status INTEGRITY_FAIL.

AFAICS, it should not have any user visible effect on existing
application. In some cases we will start returning INTEGRITY_FAIL
instead of INTEGRITY_UNKNOWN. And process_measurement() will deny access
to file both in case of INTEGRITY_UNKNOWN and INTEGRITY_FAIL.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/ima/ima_appraise.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 3710f44..6f1eeb8 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -178,9 +178,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
 					     xattr_value->digest, rc - 1,
 					     iint->ima_xattr.digest,
 					     IMA_DIGEST_SIZE);
-		if (rc == -EOPNOTSUPP) {
-			status = INTEGRITY_UNKNOWN;
-		} else if (rc) {
+		if (rc) {
 			cause = "invalid-signature";
 			status = INTEGRITY_FAIL;
 		} else {
-- 
1.7.7.6

