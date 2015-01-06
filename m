Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbbAFPpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbbAFPpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:16 -0500
Date: Tue, 6 Jan 2015 17:44:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        =?us-ascii?B?PT9VVEYtOD9xP1V3ZT0yMEtsZWluZS1LPUMzPUI2bmlnPz0=?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 17/40] arm: fix put_user sparse errors
Message-ID: <1420558883-10131-18-git-send-email-mst@redhat.com>
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
 arch/arm/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 4767eb9..74fcde7 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -413,14 +413,14 @@ do {									\
 #ifndef __ARMEB__
 #define __put_user_asm_half(x,__pu_addr,err)			\
 ({								\
-	unsigned long __temp = (unsigned long)(x);		\
+	unsigned long __temp = (__force unsigned long)(x);	\
 	__put_user_asm_byte(__temp, __pu_addr, err);		\
 	__put_user_asm_byte(__temp >> 8, __pu_addr + 1, err);	\
 })
 #else
 #define __put_user_asm_half(x,__pu_addr,err)			\
 ({								\
-	unsigned long __temp = (unsigned long)(x);		\
+	unsigned long __temp = (__force unsigned long)(x);	\
 	__put_user_asm_byte(__temp >> 8, __pu_addr, err);	\
 	__put_user_asm_byte(__temp, __pu_addr + 1, err);	\
 })
-- 
MST

