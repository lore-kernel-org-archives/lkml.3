Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab3APQEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:04:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36219 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3APQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Corey Minyard <cminyard@mvista.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 115/222] CRIS: fix I/O macros
Date: Wed, 16 Jan 2013 13:55:15 -0200
Message-Id: <1358351822-7675-116-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <cminyard@mvista.com>

commit c24bf9b4cc6a0f330ea355d73bfdf1dae7e63a05 upstream.

The inb/outb macros for CRIS are broken from a number of points of view,
missing () around parameters and they have an unprotected if statement
in them.  This was breaking the compile of IPMI on CRIS and thus I was
being annoyed by build regressions, so I fixed them.

Plus I don't think they would have worked at all, since the data values
were missing "&" and the outsl had a "3" instead of a "4" for the size.
>From what I can tell, this stuff is not used at all, so this can't be
any more broken than it was before, anyway.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/cris/include/asm/io.h |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 32567bc..ac12ae2 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -133,12 +133,39 @@ static inline void writel(unsigned int b, volatile void __iomem *addr)
 #define insb(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,1,count) : 0)
 #define insw(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,2,count) : 0)
 #define insl(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,4,count) : 0)
-#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,1,1)
-#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,2,1)
-#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,4,1)
-#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,1,count)
-#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,2,count)
-#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,3,count)
+static inline void outb(unsigned char data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 1, 1);
+}
+static inline void outw(unsigned short data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 2, 1);
+}
+static inline void outl(unsigned int data, unsigned int port)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *) &data, 4, 1);
+}
+static inline void outsb(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 1, count);
+}
+static inline void outsw(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 2, count);
+}
+static inline void outsl(unsigned int port, const void *addr,
+			 unsigned long count)
+{
+	if (cris_iops)
+		cris_iops->write_io(port, (void *)addr, 4, count);
+}
 
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
-- 
1.7.9.5

