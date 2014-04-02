Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbaDBIsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:48:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbaDBIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:47:49 -0400
Date: Wed, 2 Apr 2014 11:47:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/2] lib/string.c: strlcpy() might read too far
Message-ID: <20140402084731.GB6018@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401.161838.1562296825577866979.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imagine you have a user controlled variable at the end of a struct which
is allocated at the end of a page.  The strlen() could read beyond the
mapped memory and cause an oops.

Probably there are two reasons why we have never hit this condition in
real life.  First you would have to be really unlucky for all the
variables to line up so the oops can happen.  Second we don't do a lot
of fuzzing with invalid strings.

The strnlen() call is obviously a little bit slower than strlen() but I
have tested it and I think it's probably ok.

Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/string.c b/lib/string.c
index 9b1f906..8074962 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -148,10 +148,10 @@ EXPORT_SYMBOL(strncpy);
  */
 size_t strlcpy(char *dest, const char *src, size_t size)
 {
-	size_t ret = strlen(src);
+	size_t ret = strnlen(src, size);
 
 	if (size) {
-		size_t len = (ret >= size) ? size - 1 : ret;
+		size_t len = (ret < size) ? ret : ret - 1;
 		memcpy(dest, src, len);
 		dest[len] = '\0';
 	}
