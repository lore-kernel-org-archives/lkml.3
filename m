Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3KDSYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:24:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3KDSYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:24:02 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 8/9] KEYS: Implement keyctl control for encrypted keys
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:23:14 +0000
Message-ID: <20131104162314.10177.68684.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement "keyctl control" for encrypted keys rather than trying to do this
with the update method (which won't function correctly when add_key() tries to
update an existing key).

Provide a command to change the master key:

	keyctl control <keyid> "encrypted change-master-key <m-key-id>"

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/encrypted-keys/encrypted.c |   56 ++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 9e1e005c7596..f9e7b808fa47 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -884,6 +884,61 @@ out:
 }
 
 /*
+ * encrypted_control - control an encrypted key in a type-specific way
+ */
+static long encrypted_control(struct key *key, char *command,
+			      char *reply, size_t reply_size)
+{
+	static const char expected_command[] = "encrypted change-master-key ";
+	struct encrypted_key_payload *epayload, *new_epayload;
+	char *new_master_desc = NULL;
+	const char *format = NULL;
+	size_t datalen;
+	int ret;
+
+	if (memcmp(command, expected_command, sizeof(expected_command) - 1) != 0)
+		return -EINVAL;
+	command += sizeof(expected_command) - 1;
+	datalen = strlen(command);
+
+	if (datalen <= 0 || datalen > 32767)
+		return -EINVAL;
+
+	ret = datablob_parse(command, &format, &new_master_desc, NULL, NULL);
+	if (ret < 0)
+		return ret;
+
+	down_write(&key->sem);
+	epayload = rcu_dereference_protected(key->payload.rcudata, &key->sem);
+
+	ret = valid_master_desc(new_master_desc, epayload->master_desc);
+	if (ret < 0) {
+		up_write(&key->sem);
+		return ret;
+	}
+
+	new_epayload = encrypted_key_alloc(key, epayload->format,
+					   new_master_desc, epayload->datalen);
+	if (IS_ERR(new_epayload)) {
+		up_write(&key->sem);
+		return PTR_ERR(new_epayload);
+	}
+
+	__ekey_init(new_epayload, epayload->format, new_master_desc,
+		    epayload->datalen);
+
+	memcpy(new_epayload->iv, epayload->iv, ivsize);
+	memcpy(new_epayload->payload_data, epayload->payload_data,
+	       epayload->payload_datalen);
+
+	rcu_assign_keypointer(key, new_epayload);
+
+	up_write(&key->sem);
+	call_rcu(&epayload->rcu, encrypted_rcu_free);
+	return 0;
+}
+
+/*
  * encrypted_read - format and copy the encrypted data to userspace
  *
  * The resulting datablob format is:
@@ -974,6 +1029,7 @@ struct key_type key_type_encrypted = {
 	.destroy = encrypted_destroy,
 	.describe = user_describe,
 	.read = encrypted_read,
+	.control = encrypted_control,
 };
 EXPORT_SYMBOL_GPL(key_type_encrypted);
 

