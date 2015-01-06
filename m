Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbbAFPoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbbAFPox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:53 -0500
Date: Tue, 6 Jan 2015 17:44:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v2 22/40] tile: fix put_user sparse errors
Message-ID: <1420558883-10131-23-git-send-email-mst@redhat.com>
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

is safe, but currently triggers a sparse warning on tile.

The reason has to do with this code:
	__typeof((x)-(x))
which seems to be a way to force check for an integer type.

Since this is part of __put_user_8 which is only ever used
for unsigned and signed char types, this seems unnecessary -
I also note that no other architecture has such protections.

Fix that up using __force u64 cast.

Note: this does not suppress any useful sparse checks since
the original merely casted x to typeof(x-x).

Tile currently does not trigger sparse warnings when get_user
causes an illegal assignment across bitwise types.
This patch does not attempt to fix this.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/tile/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index b6cde32..22cffa1 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -246,7 +246,7 @@ extern int __get_user_bad(void)
 #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
 #define __put_user_8(x, ptr, ret)					\
 	({								\
-		u64 __x = (__typeof((x)-(x)))(x);			\
+		u64 __x = (__force u64)(x);				\
 		int __lo = (int) __x, __hi = (int) (__x >> 32);		\
 		asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"	\
 			     "2: { sw %0, %3; movei %0, 0 }\n"		\
-- 
MST

