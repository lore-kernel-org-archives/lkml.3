Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbbAYSXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:23:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbbAYSKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Alain Knaff <alain@knaff.lu>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.18 175/183] decompress_bunzip2: off by one in get_next_block()
Date: Sun, 25 Jan 2015 10:08:17 -0800
Message-Id: <20150125180817.768916799@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b5c8afe5be51078a979d86ae5ae78c4ac948063d upstream.

"origPtr" is used as an offset into the bd->dbuf[] array.  That array is
allocated in start_bunzip() and has "bd->dbufSize" number of elements so
the test here should be >= instead of >.

Later we check "origPtr" again before using it as an offset so I don't
know if this bug can be triggered in real life.

Fixes: bc22c17e12c1 ('bzip2/lzma: library support for gzip, bzip2 and lzma decompression')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/decompress_bunzip2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -184,7 +184,7 @@ static int INIT get_next_block(struct bu
 	if (get_bits(bd, 1))
 		return RETVAL_OBSOLETE_INPUT;
 	origPtr = get_bits(bd, 24);
-	if (origPtr > dbufSize)
+	if (origPtr >= dbufSize)
 		return RETVAL_DATA_ERROR;
 	/* mapping table: if some byte values are never used (encoding things
 	   like ascii text), the compression code removes the gaps to have fewer


