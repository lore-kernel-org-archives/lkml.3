Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441AbaGXKXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:23:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54686 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820AbaGXJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 026/128] lz4: ensure length does not wrap
Date: Thu, 24 Jul 2014 10:44:35 +0100
Message-Id: <1406195177-8656-27-git-send-email-luis.henriques@canonical.com>
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

commit 206204a1162b995e2185275167b22468c00d6b36 upstream.

Given some pathologically compressed data, lz4 could possibly decide to
wrap a few internal variables, causing unknown things to happen.  Catch
this before the wrapping happens and abort the decompression.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 lib/lz4/lz4_decompress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 411be80ddb46..6423f018f907 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -72,6 +72,8 @@ static int lz4_uncompress(const char *source, char *dest, int osize)
 			len = *ip++;
 			for (; len == 255; length += 255)
 				len = *ip++;
+			if (unlikely(length > (size_t)(length + len)))
+				goto _output_error;
 			length += len;
 		}
 
-- 
1.9.1

