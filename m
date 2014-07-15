Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaGOVig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647AbaGOViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 175/198] lz4: ensure length does not wrap
Date: Tue, 15 Jul 2014 14:30:45 -0700
Message-Id: <1405459868-15089-176-git-send-email-kamal@canonical.com>
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

commit 206204a1162b995e2185275167b22468c00d6b36 upstream.

Given some pathologically compressed data, lz4 could possibly decide to
wrap a few internal variables, causing unknown things to happen.  Catch
this before the wrapping happens and abort the decompression.

Reported-by: "Don A. Bailey" <donb@securitymouse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 lib/lz4/lz4_decompress.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index df6839e..99a03ac 100644
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

