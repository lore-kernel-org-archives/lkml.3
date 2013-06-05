Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab3FEVPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:15:51 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18558 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3FEVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:15:49 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v2 2/2] SELinux: Increase ebitmap_node size for 64-bit configuration
Date: Wed,  5 Jun 2013 17:15:02 -0400
Message-Id: <1370466902-21144-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1370466902-21144-1-git-send-email-Waiman.Long@hp.com>
References: <1370466902-21144-1-git-send-email-Waiman.Long@hp.com>
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
index e7eb3a9..712c8a7 100644
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

