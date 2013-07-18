Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab3GRG3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:29:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30852 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3GRG3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:29:49 -0400
X-Spam-Score: -100.8
Message-ID: <51E78B21.50907@asianux.com>
Date: Thu, 18 Jul 2013 14:28:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux@horizon.com, Jiri Kosina <jkosina@suse.cz>,
        andriy.shevchenko@linux.intel.com, andrei.emeltchenko@intel.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/vsprintf.c: fix the incorrect return value of vsnprintf()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When "str >= end", necessary to reset 'str' to "end - 1", or the return
value will be larger than the real one, the callers which depend on the
return value, may cause memory overflow.

When for copying constant string, 'str' is point to destination buffer,
so it need add 'copy' (for destination buffer), not 'read' (for source
buffer).

Also add white space between variable and operator to make code cleaner.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 lib/vsprintf.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 739a363..b153768 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1542,7 +1542,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 					copy = end - str;
 				memcpy(str, old_fmt, copy);
 			}
-			str += read;
+			str += copy;
 			break;
 		}
 
@@ -1662,12 +1662,14 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	if (size > 0) {
 		if (str < end)
 			*str = '\0';
-		else
+		else {
 			end[-1] = '\0';
+			str = end - 1;
+		}
 	}
 
 	/* the trailing null byte doesn't count towards the total */
-	return str-buf;
+	return str - buf;
 
 }
 EXPORT_SYMBOL(vsnprintf);
-- 
1.7.7.6
