Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaGHAea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:34:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaGGXyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>, David Disseldorp <ddiss@suse.de>
Subject: [PATCH 3.14 62/94] CIFS: fix mount failure with broken pathnames when smb3 mount with mapchars option
Date: Mon,  7 Jul 2014 16:57:52 -0700
Message-Id: <20140707235758.615612857@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifs_unicode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
@@ -298,12 +299,11 @@ cifsConvertToUTF16(__le16 *target, const
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
@@ -350,6 +350,7 @@ cifsConvertToUTF16(__le16 *target, const
 	}
 
 ctoUTF16_out:
+	put_unaligned(0, &target[j]); /* Null terminate target unicode string */
 	return j;
 }
 


