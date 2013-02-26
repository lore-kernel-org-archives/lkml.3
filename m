Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358Ab3B0AId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:08:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab3BZX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: [ 31/53] NLS: improve UTF8 -> UTF16 string conversion routine
Date: Tue, 26 Feb 2013 15:58:00 -0800
Message-Id: <20130226235623.076142314@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0720a06a7518c9d0c0125bd5d1f3b6264c55c3dd upstream.

The utf8s_to_utf16s conversion routine needs to be improved.  Unlike
its utf16s_to_utf8s sibling, it doesn't accept arguments specifying
the maximum length of the output buffer or the endianness of its
16-bit output.

This patch (as1501) adds the two missing arguments, and adjusts the
only two places in the kernel where the function is called.  A
follow-on patch will add a third caller that does utilize the new
capabilities.

The two conversion routines are still annoyingly inconsistent in the
way they handle invalid byte combinations.  But that's a subject for a
different patch.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/hv/hv_kvp.c |   10 ++++++----
 fs/fat/namei_vfat.c         |    3 ++-
 fs/nls/nls_base.c           |   43 +++++++++++++++++++++++++++++++++----------
 include/linux/nls.h         |    5 +++--
 4 files changed, 44 insertions(+), 17 deletions(-)

--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -201,11 +201,13 @@ kvp_respond_to_host(char *key, char *val
 	 * The windows host expects the key/value pair to be encoded
 	 * in utf16.
 	 */
-	keylen = utf8s_to_utf16s(key_name, strlen(key_name),
-				(wchar_t *)kvp_data->data.key);
+	keylen = utf8s_to_utf16s(key_name, strlen(key_name), UTF16_HOST_ENDIAN,
+				(wchar_t *) kvp_data->data.key,
+				HV_KVP_EXCHANGE_MAX_KEY_SIZE / 2);
 	kvp_data->data.key_size = 2*(keylen + 1); /* utf16 encoding */
-	valuelen = utf8s_to_utf16s(value, strlen(value),
-				(wchar_t *)kvp_data->data.value);
+	valuelen = utf8s_to_utf16s(value, strlen(value), UTF16_HOST_ENDIAN,
+				(wchar_t *) kvp_data->data.value,
+				HV_KVP_EXCHANGE_MAX_VALUE_SIZE / 2);
 	kvp_data->data.value_size = 2*(valuelen + 1); /* utf16 encoding */
 
 	kvp_data->data.value_type = REG_SZ; /* all our values are strings */
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -514,7 +514,8 @@ xlate_to_uni(const unsigned char *name,
 	int charlen;
 
 	if (utf8) {
-		*outlen = utf8s_to_utf16s(name, len, (wchar_t *)outname);
+		*outlen = utf8s_to_utf16s(name, len, UTF16_HOST_ENDIAN,
+				(wchar_t *) outname, FAT_LFN_LEN + 2);
 		if (*outlen < 0)
 			return *outlen;
 		else if (*outlen > FAT_LFN_LEN)
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -114,34 +114,57 @@ int utf32_to_utf8(unicode_t u, u8 *s, in
 }
 EXPORT_SYMBOL(utf32_to_utf8);
 
-int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs)
+static inline void put_utf16(wchar_t *s, unsigned c, enum utf16_endian endian)
+{
+	switch (endian) {
+	default:
+		*s = (wchar_t) c;
+		break;
+	case UTF16_LITTLE_ENDIAN:
+		*s = __cpu_to_le16(c);
+		break;
+	case UTF16_BIG_ENDIAN:
+		*s = __cpu_to_be16(c);
+		break;
+	}
+}
+
+int utf8s_to_utf16s(const u8 *s, int len, enum utf16_endian endian,
+		wchar_t *pwcs, int maxlen)
 {
 	u16 *op;
 	int size;
 	unicode_t u;
 
 	op = pwcs;
-	while (*s && len > 0) {
+	while (len > 0 && maxlen > 0 && *s) {
 		if (*s & 0x80) {
 			size = utf8_to_utf32(s, len, &u);
 			if (size < 0)
 				return -EINVAL;
+			s += size;
+			len -= size;
 
 			if (u >= PLANE_SIZE) {
+				if (maxlen < 2)
+					break;
 				u -= PLANE_SIZE;
-				*op++ = (wchar_t) (SURROGATE_PAIR |
-						((u >> 10) & SURROGATE_BITS));
-				*op++ = (wchar_t) (SURROGATE_PAIR |
+				put_utf16(op++, SURROGATE_PAIR |
+						((u >> 10) & SURROGATE_BITS),
+						endian);
+				put_utf16(op++, SURROGATE_PAIR |
 						SURROGATE_LOW |
-						(u & SURROGATE_BITS));
+						(u & SURROGATE_BITS),
+						endian);
+				maxlen -= 2;
 			} else {
-				*op++ = (wchar_t) u;
+				put_utf16(op++, u, endian);
+				maxlen--;
 			}
-			s += size;
-			len -= size;
 		} else {
-			*op++ = *s++;
+			put_utf16(op++, *s++, endian);
 			len--;
+			maxlen--;
 		}
 	}
 	return op - pwcs;
--- a/include/linux/nls.h
+++ b/include/linux/nls.h
@@ -43,7 +43,7 @@ enum utf16_endian {
 	UTF16_BIG_ENDIAN
 };
 
-/* nls.c */
+/* nls_base.c */
 extern int register_nls(struct nls_table *);
 extern int unregister_nls(struct nls_table *);
 extern struct nls_table *load_nls(char *);
@@ -52,7 +52,8 @@ extern struct nls_table *load_nls_defaul
 
 extern int utf8_to_utf32(const u8 *s, int len, unicode_t *pu);
 extern int utf32_to_utf8(unicode_t u, u8 *s, int maxlen);
-extern int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs);
+extern int utf8s_to_utf16s(const u8 *s, int len,
+		enum utf16_endian endian, wchar_t *pwcs, int maxlen);
 extern int utf16s_to_utf8s(const wchar_t *pwcs, int len,
 		enum utf16_endian endian, u8 *s, int maxlen);
 


