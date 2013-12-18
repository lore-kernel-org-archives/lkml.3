Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3LRNCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:02:17 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1998 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LRNCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:02:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Dec 2013 05:04:24 -0800
Date: Wed, 18 Dec 2013 05:02:14 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] bitops: fix signedness of compile-time hweight
 implementations
Message-ID: <alpine.DEB.2.02.1312180459580.30198@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-2000334104-1387371735=:30198"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-2000334104-1387371735=:30198
Content-Type: text/plain; format=flowed; charset="ISO-8859-7"
Content-Transfer-Encoding: 8BIT


Enabling '-Wsign-compare' compiler warnings on code that includes
include/linux/bitops.h can generate the following warning:

In file included from include/linux/kernel.h:10:0,
                  from <random filename>:48:
include/linux/bitops.h: In function ¡hweight_long¢:
include/linux/bitops.h:77:26: error: signed and unsigned type in conditional expression [-Werror=sign-compare]

(converted to an error with -Werror)

This is due to the use of the logical negation operator '!' in the
__const_hweight8 macro in include/asm-generic/bitops/const_hweight.h.
The use of that operator here results in a signed value.

Fix by explicitly casting the __const_hweight8 macro expansion to
'unsigned int'.  While here, clean up several checkpatch.pl warnings.

Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
---
Intended for v3.14.

  include/asm-generic/bitops/const_hweight.h | 17 +++++++++--------
  1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
index fa2a50b7ee66..40966203804d 100644
--- a/include/asm-generic/bitops/const_hweight.h
+++ b/include/asm-generic/bitops/const_hweight.h
@@ -5,14 +5,15 @@
   * Compile time versions of __arch_hweightN()
   */
  #define __const_hweight8(w)		\
-      (	(!!((w) & (1ULL << 0))) +	\
-	(!!((w) & (1ULL << 1))) +	\
-	(!!((w) & (1ULL << 2))) +	\
-	(!!((w) & (1ULL << 3))) +	\
-	(!!((w) & (1ULL << 4))) +	\
-	(!!((w) & (1ULL << 5))) +	\
-	(!!((w) & (1ULL << 6))) +	\
-	(!!((w) & (1ULL << 7)))	)
+	((unsigned int)		\
+	 ((!!((w) & (1ULL << 0))) +	\
+	  (!!((w) & (1ULL << 1))) +	\
+	  (!!((w) & (1ULL << 2))) +	\
+	  (!!((w) & (1ULL << 3))) +	\
+	  (!!((w) & (1ULL << 4))) +	\
+	  (!!((w) & (1ULL << 5))) +	\
+	  (!!((w) & (1ULL << 6))) +	\
+	  (!!((w) & (1ULL << 7)))))

  #define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
  #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
-- 
1.8.5.1

--8323329-2000334104-1387371735=:30198--
