Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422659AbaGRNRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:17:42 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17923 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933858AbaGRNRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:17:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 107/170] CIFS: fix mount failure with broken pathnames when smb3 mount with mapchars option
Date: Fri, 18 Jul 2014 14:11:52 +0200
Message-Id: <ae8c79f81f3b3e10a688a8980e70965a3a07b857.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve French <smfrench@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ce36d9ab3bab06b7b5522f5c8b68fac231b76ffb upstream.

When we SMB3 mounted with mapchars (to allow reserved characters : \ / > < * ?
via the Unicode Windows to POSIX remap range) empty paths
(eg when we open "" to query the root of the SMB3 directory on mount) were not
null terminated so we sent garbarge as a path name on empty paths which caused
SMB2/SMB2.1/SMB3 mounts to fail when mapchars was specified.  mapchars is
particularly important since Unix Extensions for SMB3 are not supported (yet)

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/cifs_unicode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 0227b45ef00a..15e9505aa35f 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -290,7 +290,8 @@ int
 cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		 const struct nls_table *cp, int mapChars)
 {
-	int i, j, charlen;
+	int i, charlen;
+	int j = 0;
 	char src_char;
 	__le16 dst_char;
 	wchar_t tmp;
@@ -298,12 +299,11 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 	if (!mapChars)
 		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
 
-	for (i = 0, j = 0; i < srclen; j++) {
+	for (i = 0; i < srclen; j++) {
 		src_char = source[i];
 		charlen = 1;
 		switch (src_char) {
 		case 0:
-			put_unaligned(0, &target[j]);
 			goto ctoUTF16_out;
 		case ':':
 			dst_char = cpu_to_le16(UNI_COLON);
@@ -350,6 +350,7 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 	}
 
 ctoUTF16_out:
+	put_unaligned(0, &target[j]); /* Null terminate target unicode string */
 	return j;
 }
 
-- 
2.0.0

