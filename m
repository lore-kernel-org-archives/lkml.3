Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaF3MT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:19:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51949 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/181] lz4: ensure length does not wrap
Date: Mon, 30 Jun 2014 13:51:34 +0200
Message-Id: <1f4abc9e35ad7340d3cbd141b816e68f3a796888.1404128998.git.jslaby@suse.cz>
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

commit 206204a1162b995e2185275167b22468c00d6b36 upstream.

Given some pathologically compressed data, lz4 could possibly decide to
wrap a few internal variables, causing unknown things to happen.  Catch
this before the wrapping happens and abort the decompression.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 lib/lz4/lz4_decompress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index df6839e3ce08..99a03acb7d47 100644
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
2.0.0

