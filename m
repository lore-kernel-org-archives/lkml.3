Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbbA2I7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:59:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753650AbbA2I73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alain Knaff <alain@knaff.lu>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 126/176] decompress_bunzip2: off by one in get_next_block()
Date: Wed, 28 Jan 2015 15:29:16 +0100
Message-Id: <8abf460d9f1135d9beaa8642ac3860108e054e2a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/decompress_bunzip2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 31c5f7675fbf..f504027d66a8 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -184,7 +184,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 	if (get_bits(bd, 1))
 		return RETVAL_OBSOLETE_INPUT;
 	origPtr = get_bits(bd, 24);
-	if (origPtr > dbufSize)
+	if (origPtr >= dbufSize)
 		return RETVAL_DATA_ERROR;
 	/* mapping table: if some byte values are never used (encoding things
 	   like ascii text), the compression code removes the gaps to have fewer
-- 
2.2.2

