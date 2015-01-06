Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbbAFPpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbbAFPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:56 -0500
Date: Tue, 6 Jan 2015 17:44:47 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Chris Metcalf <cmetcalf@ezchip.com>
Subject: [PATCH v2 23/40] tile: enable sparse checks for get/put_user
Message-ID: <1420558883-10131-24-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tile currently does not trigger sparse warnings when get_user
causes an illegal assignment across bitwise types.

For example:

__le32 __user *p;
__u32 x;
put_user(x, p);

violates endian-ness rules, but currently does not trigger sparse
warning on tile.

Fix this by adding some dead code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/tile/include/asm/uaccess.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index 22cffa1..03d905c 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -218,6 +218,8 @@ extern int __get_user_bad(void)
 		case 8: __get_user_8(x, ptr, __ret); break;		\
 		default: __ret = __get_user_bad(); break;		\
 		}							\
+		if (0)							\
+			x = *(__force typeof(*ptr) *)(ptr);		\
 		__ret;							\
 	})
 
@@ -297,6 +299,8 @@ extern int __put_user_bad(void)
 	case 8: __put_user_8(x, ptr, __ret); break;			\
 	default: __ret = __put_user_bad(); break;			\
 	}								\
+	if (0)								\
+		*(__force typeof(*ptr) *)(ptr) = x;			\
 	__ret;								\
 })
 
-- 
MST

