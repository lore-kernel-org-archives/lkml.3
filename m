Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbbAFPot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:44:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbbAFPor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:44:47 -0500
Date: Tue, 6 Jan 2015 17:44:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Subject: [PATCH v2 18/40] blackfin: fix put_user sparse errors
Message-ID: <1420558883-10131-19-git-send-email-mst@redhat.com>
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

Note: this does not suppress any useful sparse checks since caller
assigns x to typeof(*p), which in turn forces all the necessary type
checks.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/blackfin/include/asm/uaccess.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/include/asm/uaccess.h b/arch/blackfin/include/asm/uaccess.h
index 2dcc930..4bf968c 100644
--- a/arch/blackfin/include/asm/uaccess.h
+++ b/arch/blackfin/include/asm/uaccess.h
@@ -89,10 +89,10 @@ struct exception_table_entry {
 			break;					\
 		case 8: {					\
 			long _xl, _xh;				\
-			_xl = ((long *)&_x)[0];			\
-			_xh = ((long *)&_x)[1];			\
-			__put_user_asm(_xl, ((long __user *)_p)+0, );	\
-			__put_user_asm(_xh, ((long __user *)_p)+1, );	\
+			_xl = ((__force long *)&_x)[0];		\
+			_xh = ((__force long *)&_x)[1];		\
+			__put_user_asm(_xl, ((__force long __user *)_p)+0, );\
+			__put_user_asm(_xh, ((__force long __user *)_p)+1, );\
 		} break;					\
 		default:					\
 			_err = __put_user_bad();		\
-- 
MST

