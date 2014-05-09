Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbaEIHoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:44:15 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1767 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbaEIHoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:44:12 -0400
Message-ID: <536C873E.8060408@xs4all.nl>
Date: Fri, 09 May 2014 09:43:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix _IOC_TYPECHECK sparse error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, can you merge this for 3.15 or 3.16 (you decide)? While it fixes a sparse error
for the media subsystem, it is not really appropriate to go through our media tree.

Thanks,

	Hans


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
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/asm-generic/ioctl.h | 5 +++++
 1 file changed, 5 insertions(+)

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
-- 
2.0.0.rc0

