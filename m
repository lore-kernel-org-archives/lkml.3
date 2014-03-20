Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaCTMG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:06:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbaCTMGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:06:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 08/12] KEYS: DNS: Use key preparsing
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:05:35 +0000
Message-ID: <20140320120535.21635.7950.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
References: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of key preparsing in the DNS resolver so that quota size determination
can take place prior to keyring locking when a key is being added.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/dns_resolver/dns_key.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index bf8584339048..f380b2c58178 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -46,7 +46,7 @@ const struct cred *dns_resolver_cache;
 #define	DNS_ERRORNO_OPTION	"dnserror"
 
 /*
- * Instantiate a user defined key for dns_resolver.
+ * Preparse instantiation data for a dns_resolver key.
  *
  * The data must be a NUL-terminated string, with the NUL char accounted in
  * datalen.
@@ -58,17 +58,15 @@ const struct cred *dns_resolver_cache;
  *        "ip1,ip2,...#foo=bar"
  */
 static int
-dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
+dns_resolver_preparse(struct key_preparsed_payload *prep)
 {
 	struct user_key_payload *upayload;
 	unsigned long derrno;
 	int ret;
-	size_t datalen = prep->datalen, result_len = 0;
+	int datalen = prep->datalen, result_len = 0;
 	const char *data = prep->data, *end, *opt;
 
-	kenter("%%%d,%s,'%*.*s',%zu",
-	       key->serial, key->description,
-	       (int)datalen, (int)datalen, data, datalen);
+	kenter("'%*.*s',%u", datalen, datalen, data, datalen);
 
 	if (datalen <= 1 || !data || data[datalen - 1] != '\0')
 		return -EINVAL;
@@ -95,8 +93,7 @@ dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
 			opt_len = next_opt - opt;
 			if (!opt_len) {
 				printk(KERN_WARNING
-				       "Empty option to dns_resolver key %d\n",
-				       key->serial);
+				       "Empty option to dns_resolver key\n");
 				return -EINVAL;
 			}
 
@@ -125,30 +122,28 @@ dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
 					goto bad_option_value;
 
 				kdebug("dns error no. = %lu", derrno);
-				key->type_data.x[0] = -derrno;
+				prep->type_data[0] = ERR_PTR(-derrno);
 				continue;
 			}
 
 		bad_option_value:
 			printk(KERN_WARNING
-			       "Option '%*.*s' to dns_resolver key %d:"
+			       "Option '%*.*s' to dns_resolver key:"
 			       " bad/missing value\n",
-			       opt_nlen, opt_nlen, opt, key->serial);
+			       opt_nlen, opt_nlen, opt);
 			return -EINVAL;
 		} while (opt = next_opt + 1, opt < end);
 	}
 
 	/* don't cache the result if we're caching an error saying there's no
 	 * result */
-	if (key->type_data.x[0]) {
-		kleave(" = 0 [h_error %ld]", key->type_data.x[0]);
+	if (prep->type_data[0]) {
+		kleave(" = 0 [h_error %ld]", PTR_ERR(prep->type_data[0]));
 		return 0;
 	}
 
 	kdebug("store result");
-	ret = key_payload_reserve(key, result_len);
-	if (ret < 0)
-		return -EINVAL;
+	prep->quotalen = result_len;
 
 	upayload = kmalloc(sizeof(*upayload) + result_len + 1, GFP_KERNEL);
 	if (!upayload) {
@@ -159,13 +154,23 @@ dns_resolver_instantiate(struct key *key, struct key_preparsed_payload *prep)
 	upayload->datalen = result_len;
 	memcpy(upayload->data, data, result_len);
 	upayload->data[result_len] = '\0';
-	rcu_assign_pointer(key->payload.data, upayload);
 
+	prep->payload[0] = upayload;
 	kleave(" = 0");
 	return 0;
 }
 
 /*
+ * Clean up the preparse data
+ */
+static void dns_resolver_free_preparse(struct key_preparsed_payload *prep)
+{
+	pr_devel("==>%s()\n", __func__);
+
+	kfree(prep->payload[0]);
+}
+
+/*
  * The description is of the form "[<type>:]<domain_name>"
  *
  * The domain name may be a simple name or an absolute domain name (which
@@ -234,7 +239,9 @@ static long dns_resolver_read(const struct key *key,
 
 struct key_type key_type_dns_resolver = {
 	.name		= "dns_resolver",
-	.instantiate	= dns_resolver_instantiate,
+	.preparse	= dns_resolver_preparse,
+	.free_preparse	= dns_resolver_free_preparse,
+	.instantiate	= generic_key_instantiate,
 	.match		= dns_resolver_match,
 	.revoke		= user_revoke,
 	.destroy	= user_destroy,

