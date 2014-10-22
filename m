Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaJVIRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:17:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40954 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294AbaJVIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:16:55 -0400
Date: Wed, 22 Oct 2014 11:16:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alain Knaff <alain@knaff.lu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch] decompress_bunzip2: off by one in get_next_block()
Message-ID: <20141022081615.GD31384@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"origPtr" is used as an offset into the bd->dbuf[] array.  That array
is allocated in start_bunzip() and has "bd->dbufSize" number of elements
so the test here should be >= instead of >.

Later we check "origPtr" again before using it as an offset so I don't
know if this bug can be triggered in real life.

Fixes: bc22c17e12c1 ('bzip2/lzma: library support for gzip, bzip2 and lzma decompression')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 8290e0b..6dd0335 100644
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
