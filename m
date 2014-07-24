Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbaGXJsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934604AbaGXJse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Don A. Bailey" <donb@securitymouse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 080/128] lz4: add overrun checks to lz4_uncompress_unknownoutputsize()
Date: Thu, 24 Jul 2014 10:45:29 +0100
Message-Id: <1406195177-8656-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/lz4/lz4_decompress.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 8ee9333e87ae..b6ce2cf35d5d 100644
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
 
 int lz4_decompress(const char *src, size_t *src_len, char *dest,
-- 
1.9.1

