Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab3DJS0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:26:47 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37475 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936652Ab3DJS0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:26:45 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH RFC 2/2] SELinux: Increase ebitmap_node size for 64-bit configuration
Date: Wed, 10 Apr 2013 14:26:23 -0400
Message-Id: <1365618383-29340-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1365618383-29340-1-git-send-email-Waiman.Long@hp.com>
References: <1365618383-29340-1-git-send-email-Waiman.Long@hp.com>
To: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the ebitmap_node structure has a fixed size of 32 bytes. On
a 32-bit system, the overhead is 8 bytes, leaving 24 bytes for being
used as bitmaps. The overhead ratio is 1/4.

On a 64-bit system, the overhead is 16 bytes. Therefore, only 16 bytes
are left for bitmap purpose and the overhead ratio is 1/2. With a
3.8.2 kernel, a boot-up operation will cause the ebitmap_get_bit()
function to be called about 9 million times. The average number of
ebitmap_node traversal is about 3.7.

This patch increases the size of the ebitmap_node structure to 64
bytes for 64-bit system to keep the overhead ratio at 1/4. This may
also improve performance a little bit by making node to node traversal
less frequent (< 2) as more bits are available in each node.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 security/selinux/ss/ebitmap.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/ebitmap.h b/security/selinux/ss/ebitmap.h
index 922f8af..653a5b9 100644
--- a/security/selinux/ss/ebitmap.h
+++ b/security/selinux/ss/ebitmap.h
@@ -16,7 +16,13 @@
 
 #include <net/netlabel.h>
 
-#define EBITMAP_UNIT_NUMS	((32 - sizeof(void *) - sizeof(u32))	\
+#ifdef CONFIG_64BIT
+#define	EBITMAP_NODE_SIZE	64
+#else
+#define	EBITMAP_NODE_SIZE	32
+#endif
+
+#define EBITMAP_UNIT_NUMS	((EBITMAP_NODE_SIZE-sizeof(void *)-sizeof(u32))\
 					/ sizeof(unsigned long))
 #define EBITMAP_UNIT_SIZE	BITS_PER_LONG
 #define EBITMAP_SIZE		(EBITMAP_UNIT_NUMS * EBITMAP_UNIT_SIZE)
-- 
1.7.1

