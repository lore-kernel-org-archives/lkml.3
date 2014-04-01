Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaDAHEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:04:42 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2515 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaDAHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:04:40 -0400
Message-ID: <533A64EC.2090106@xs4all.nl>
Date: Tue, 01 Apr 2014 09:04:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Sparse Mailing-list <linux-sparse@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Christopher Li <sparse@chrisli.org>
Subject: [PATCH] Fix _IOC_TYPECHECK sparse error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running sparse over drivers/media/v4l2-core/v4l2-ioctl.c I get these
errors:

drivers/media/v4l2-core/v4l2-ioctl.c:2043:9: error: bad integer constant expression
drivers/media/v4l2-core/v4l2-ioctl.c:2044:9: error: bad integer constant expression
drivers/media/v4l2-core/v4l2-ioctl.c:2045:9: error: bad integer constant expression
drivers/media/v4l2-core/v4l2-ioctl.c:2046:9: error: bad integer constant expression

etc.

The root cause of that turns out to be in include/asm-generic/ioctl.h:

#include <uapi/asm-generic/ioctl.h>

/* provoke compile error for invalid uses of size argument */
extern unsigned int __invalid_size_argument_for_IOC;
#define _IOC_TYPECHECK(t) \
        ((sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
          sizeof(t) : __invalid_size_argument_for_IOC)

If it is defined as this (as is already done if __KERNEL__ is not defined):

#define _IOC_TYPECHECK(t) (sizeof(t))

then all is well with the world.

This patch allows sparse to work correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/asm-generic/ioctl.h b/include/asm-generic/ioctl.h
index d17295b..297fb0d 100644
--- a/include/asm-generic/ioctl.h
+++ b/include/asm-generic/ioctl.h
@@ -3,10 +3,15 @@
 
 #include <uapi/asm-generic/ioctl.h>
 
+#ifdef __CHECKER__
+#define _IOC_TYPECHECK(t) (sizeof(t))
+#else
 /* provoke compile error for invalid uses of size argument */
 extern unsigned int __invalid_size_argument_for_IOC;
 #define _IOC_TYPECHECK(t) \
 	((sizeof(t) == sizeof(t[1]) && \
 	  sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
 	  sizeof(t) : __invalid_size_argument_for_IOC)
+#endif
+
 #endif /* _ASM_GENERIC_IOCTL_H */

