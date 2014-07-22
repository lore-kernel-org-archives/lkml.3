Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbaGVWY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:24:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaGVWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:24:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve French <smfrench@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 109/116] [CIFS] fix mount failure with broken pathnames when smb3 mount with mapchars option
Date: Tue, 22 Jul 2014 15:22:00 -0700
Message-Id: <1406067727-19683-110-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <smfrench@gmail.com>

commit ce36d9ab3bab06b7b5522f5c8b68fac231b76ffb upstream.

When we SMB3 mounted with mapchars (to allow reserved characters : \ / > < * ?
via the Unicode Windows to POSIX remap range) empty paths
(eg when we open "" to query the root of the SMB3 directory on mount) were not
null terminated so we sent garbarge as a path name on empty paths which caused
SMB2/SMB2.1/SMB3 mounts to fail when mapchars was specified.  mapchars is
particularly important since Unix Extensions for SMB3 are not supported (yet)

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/cifs_unicode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 71d5d0a..839a5321 100644
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
1.9.1

