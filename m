Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaF3Mco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:32:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380AbaF3McK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 175/181] lz4: fix another possible overrun
Date: Mon, 30 Jun 2014 13:53:16 +0200
Message-Id: <0c7247a5873d6fd7e1e6089dda62323567b1ccf8.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4148c1f67abf823099b2d7db6851e4aea407f5ee upstream.

There is one other possible overrun in the lz4 code as implemented by
Linux at this point in time (which differs from the upstream lz4
codebase, but will get synced at in a future kernel release.)  As
pointed out by Don, we also need to check the overflow in the data
itself.

While we are at it, replace the odd error return value with just a
"simple" -1 value as the return value is never used for anything other
than a basic "did this work or not" check.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Reported-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/lz4/lz4_decompress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 99a03acb7d47..b74da447e81e 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -108,6 +108,8 @@ static int lz4_uncompress(const char *source, char *dest, int osize)
 		if (length == ML_MASK) {
 			for (; *ip == 255; length += 255)
 				ip++;
+			if (unlikely(length > (size_t)(length + *ip)))
+				goto _output_error;
 			length += *ip++;
 		}
 
@@ -157,7 +159,7 @@ static int lz4_uncompress(const char *source, char *dest, int osize)
 
 	/* write overflow error detected */
 _output_error:
-	return (int) (-(((char *)ip) - source));
+	return -1;
 }
 
 static int lz4_uncompress_unknownoutputsize(const char *source, char *dest,
-- 
2.0.0

