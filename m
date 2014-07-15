Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbaGOWME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:12:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54353 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbaGOVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:35:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 196/198] lz4: fix another possible overrun
Date: Tue, 15 Jul 2014 14:31:06 -0700
Message-Id: <1405459868-15089-197-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/lz4/lz4_decompress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 99a03ac..b74da44 100644
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
1.9.1

