Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaKZOSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:18:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaKZOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:17:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/5] PKCS#7: Allow detached data to be supplied for
 signature checking purposes [ver #2]
From: David Howells <dhowells@redhat.com>
To: rusty@rustcorp.com.au
Cc: mmarek@suse.cz, keyrings@linux-nfs.org, d.kasatkin@samsung.com,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Date: Wed, 26 Nov 2014 14:17:43 +0000
Message-ID: <20141126141743.3944.88962.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
References: <20141126141709.3944.66589.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for a PKCS#7 message to have detached data.  However, to verify
the signatures on a PKCS#7 message, we have to be able to digest the data.
Provide a function to supply that data.  An error is given if the PKCS#7
message included embedded data.

This is used in a subsequent patch to supply the data to module signing where
the signature is in the form of a PKCS#7 message with detached data, whereby
the detached data is the module content that is signed.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_verify.c |   25 +++++++++++++++++++++++++
 include/crypto/pkcs7.h                |    3 +++
 2 files changed, 28 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index 667064daf66b..ee506bdfea54 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -382,3 +382,28 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
 	return enopkg;
 }
 EXPORT_SYMBOL_GPL(pkcs7_verify);
+
+/**
+ * pkcs7_supply_detached_data - Supply the data needed to verify a PKCS#7 message
+ * @pkcs7: The PKCS#7 message
+ * @data: The data to be verified
+ * @datalen: The amount of data
+ *
+ * Supply the detached data needed to verify a PKCS#7 message.  Note that no
+ * attempt to retain/pin the data is made.  That is left to the caller.  The
+ * data will not be modified by pkcs7_verify() and will not be freed when the
+ * PKCS#7 message is freed.
+ *
+ * Returns -EINVAL if data is already supplied in the message, 0 otherwise.
+ */
+int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
+			       const void *data, size_t datalen)
+{
+	if (pkcs7->data) {
+		pr_debug("Data already supplied\n");
+		return -EINVAL;
+	}
+	pkcs7->data = data;
+	pkcs7->data_len = datalen;
+	return 0;
+}
diff --git a/include/crypto/pkcs7.h b/include/crypto/pkcs7.h
index 691c79172a26..e235ab4957ee 100644
--- a/include/crypto/pkcs7.h
+++ b/include/crypto/pkcs7.h
@@ -34,3 +34,6 @@ extern int pkcs7_validate_trust(struct pkcs7_message *pkcs7,
  * pkcs7_verify.c
  */
 extern int pkcs7_verify(struct pkcs7_message *pkcs7);
+
+extern int pkcs7_supply_detached_data(struct pkcs7_message *pkcs7,
+				      const void *data, size_t datalen);

