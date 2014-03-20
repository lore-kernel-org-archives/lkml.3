Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaCTMFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:05:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbaCTMF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:05:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 06/12] KEYS: Ceph: Use key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, Sage Weil <sage@newdream.net>,
        linux-security-module@vger.kernel.org,
        Tommi Virtanen <tommi.virtanen@dreamhost.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:20 +0000
Message-ID: <20140320120520.21635.61500.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of key preparsing in Ceph so that quota size determination can take
place prior to keyring locking when a key is being added.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Tommi Virtanen <tommi.virtanen@dreamhost.com>
cc: Sage Weil <sage@newdream.net>
---

 net/ceph/crypto.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 6e7a236525b6..2c8078d990ee 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -423,8 +423,7 @@ int ceph_encrypt2(struct ceph_crypto_key *secret, void *dst, size_t *dst_len,
 	}
 }
 
-static int ceph_key_instantiate(struct key *key,
-				struct key_preparsed_payload *prep)
+static int ceph_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct ceph_crypto_key *ckey;
 	size_t datalen = prep->datalen;
@@ -435,10 +434,6 @@ static int ceph_key_instantiate(struct key *key,
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
 		goto err;
 
-	ret = key_payload_reserve(key, datalen);
-	if (ret < 0)
-		goto err;
-
 	ret = -ENOMEM;
 	ckey = kmalloc(sizeof(*ckey), GFP_KERNEL);
 	if (!ckey)
@@ -450,7 +445,8 @@ static int ceph_key_instantiate(struct key *key,
 	if (ret < 0)
 		goto err_ckey;
 
-	key->payload.data = ckey;
+	prep->payload[0] = ckey;
+	prep->quotalen = datalen;
 	return 0;
 
 err_ckey:
@@ -459,12 +455,20 @@ err:
 	return ret;
 }
 
+static void ceph_key_free_preparse(struct key_preparsed_payload *prep)
+{
+	struct ceph_crypto_key *ckey = prep->payload[0];
+	ceph_crypto_key_destroy(ckey);
+	kfree(ckey);
+}
+
 static int ceph_key_match(const struct key *key, const void *description)
 {
 	return strcmp(key->description, description) == 0;
 }
 
-static void ceph_key_destroy(struct key *key) {
+static void ceph_key_destroy(struct key *key)
+{
 	struct ceph_crypto_key *ckey = key->payload.data;
 
 	ceph_crypto_key_destroy(ckey);
@@ -473,7 +477,9 @@ static void ceph_key_destroy(struct key *key) {
 
 struct key_type key_type_ceph = {
 	.name		= "ceph",
-	.instantiate	= ceph_key_instantiate,
+	.preparse	= ceph_key_preparse,
+	.free_preparse	= ceph_key_free_preparse,
+	.instantiate	= generic_key_instantiate,
 	.match		= ceph_key_match,
 	.destroy	= ceph_key_destroy,
 };

