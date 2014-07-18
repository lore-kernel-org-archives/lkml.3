Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965471AbaGRNJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:09:18 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17428 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965267AbaGRNJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Don A. Bailey" <donb@securitymouse.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/170] lz4: add overrun checks to lz4_uncompress_unknownoutputsize()
Date: Fri, 18 Jul 2014 14:10:59 +0200
Message-Id: <fac842fd65ee900a65a3ffe48b4b41669b785291.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4a3a99045177369700c60d074c0e525e8093b0fc upstream.

Jan points out that I forgot to make the needed fixes to the
lz4_uncompress_unknownoutputsize() function to mirror the changes done
in lz4_decompress() with regards to potential pointer overflows.

The only in-kernel user of this function is the zram code, which only
takes data from a valid compressed buffer that it made itself, so it's
not a big issue.  But due to external kernel modules using this
function, it's better to be safe here.

Reported-by: Jan Beulich <JBeulich@suse.com>
Cc: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/lz4/lz4_decompress.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index b74da447e81e..7a85967060a5 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -192,6 +192,8 @@ static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
 			int s = 255;
 			while ((ip < iend) && (s == 255)) {
 				s = *ip++;
+				if (unlikely(length > (size_t)(length + s)))
+					goto _output_error;
 				length += s;
 			}
 		}
@@ -232,6 +234,8 @@ static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
 		if (length == ML_MASK) {
 			while (ip < iend) {
 				int s = *ip++;
+				if (unlikely(length > (size_t)(length + s)))
+					goto _output_error;
 				length += s;
 				if (s == 255)
 					continue;
@@ -284,7 +288,7 @@ static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
 
 	/* write overflow error detected */
 _output_error:
-	return (int) (-(((char *) ip) - source));
+	return -1;
 }
 
 int lz4_decompress(const unsigned char *src, size_t *src_len,
-- 
2.0.0

