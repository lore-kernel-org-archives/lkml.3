Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbbAFPoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbbAFPoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:44 -0500
Date: Tue, 6 Jan 2015 17:44:34 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thierry Reding <treding@nvidia.com>, linux-ia64@vger.kernel.org
Subject: [PATCH v2 19/40] ia64: fix put_user sparse errors
Message-ID: <1420558883-10131-20-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio wants to write bitwise types to userspace using put_user.
At the moment this triggers sparse errors, since the value is passed
through an integer.

For example:

	__le32 __user *p;
	__le32 x;
	put_user(x, p);

is safe, but currently triggers a sparse warning.

Fix that up using __force.

Note: this does not suppress any useful sparse checks since callers
do a cast (__typeof__(*(ptr))) (x) which in turn forces all the
necessary type checks.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/ia64/include/asm/uaccess.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/include/asm/uaccess.h b/arch/ia64/include/asm/uaccess.h
index 967c312..4f3fb6cc 100644
--- a/arch/ia64/include/asm/uaccess.h
+++ b/arch/ia64/include/asm/uaccess.h
@@ -169,10 +169,11 @@ do {									\
 	(err) = ia64_getreg(_IA64_REG_R8);				\
 	(val) = ia64_getreg(_IA64_REG_R9);				\
 } while (0)
-# define __put_user_size(val, addr, n, err)							\
-do {												\
-	__st_user("__ex_table", (unsigned long) addr, n, RELOC_TYPE, (unsigned long) (val));	\
-	(err) = ia64_getreg(_IA64_REG_R8);							\
+# define __put_user_size(val, addr, n, err)				\
+do {									\
+	__st_user("__ex_table", (unsigned long) addr, n, RELOC_TYPE,	\
+		  (__force unsigned long) (val));			\
+	(err) = ia64_getreg(_IA64_REG_R8);				\
 } while (0)
 #endif /* !ASM_SUPPORTED */
 
-- 
MST

