Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaJCOac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbaJCOa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:30:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/3] PKCS#7: Allow detached data to be supplied for
 signature checking purposes
From: David Howells <dhowells@redhat.com>
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 15:30:22 +0100
Message-ID: <20141003143021.26457.39948.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141003143012.26457.54004.stgit@warthog.procyon.org.uk>
References: <20141003143012.26457.54004.stgit@warthog.procyon.org.uk>
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

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_verify.c |   26 ++++++++++++++++++++++++++
 include/crypto/pkcs7.h                |    3 +++
 2 files changed, 29 insertions(+)

diff --git a/crypto/asymmetric_keys/pkcs7_verify.c b/crypto/asymmetric_keys/pkcs7_verify.c
index cd455450b069..c210f6f2334f 100644
--- a/crypto/asymmetric_keys/pkcs7_verify.c
+++ b/crypto/asymmetric_keys/pkcs7_verify.c
@@ -359,3 +359,29 @@ int pkcs7_verify(struct pkcs7_message *pkcs7)
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
+EXPORT_SYMBOL_GPL(pkcs7_supply_detached_data);
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

