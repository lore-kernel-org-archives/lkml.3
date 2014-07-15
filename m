Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbaGOM64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:58:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32821 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682AbaGOM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:21 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-03-53c524e97a5e
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 1/4] ima: provide hook to load IMA keys when rootfs is ready
Date: Tue, 15 Jul 2014 15:54:20 +0300
Message-id: <2b20badc350112abc405751e67a7eaf3e3932358.1405428802.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xK7ovVY4GG2z6Y2YxZ/0aNotbf/cy
	W7xr+s1i8WVpncXLGfPYLS7vmsNm8aHnEZvFpxWTmB04PHbOusvucWLGbxaPB4c2s3jsXvCZ
	yeP9vqtsHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJVx7vZbxoIZ3BWNp2cxNzBO5uxi5OSQ
	EDCRaFo3jx3CFpO4cG89WxcjF4eQwFJGifbNn6GcTiaJFTvmM4FUsQnoSWxo/sEOkhARaGeU
	OHD9NFg7s0CNxMOeRSwgtrCAv8TaWStZQWwWAVWJf3+nMYPYvAJxEstfnGCEWCcncfLYZLAa
	TgErictLDwHN4QDaZilx7UIADuEJjPwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQE
	6JcdjIuPWR1iFOBgVOLhrRA7HCzEmlhWXJl7iFGCg1lJhLdQ6WiwEG9KYmVValF+fFFpTmrx
	IUYmDk6pBkZRlTUMH7cfjG+MyA2W5f/4YuMCD6mDkRzFVdOCF9p0mihfa3jaMSMxTvF6AZ+L
	w+6c3fe15aaIFly9FBfFvfja5ytVOQJXvFKalx0QDfvpv1vb9S+/pFGG9uFX2vuUVGY76QSX
	9X9xtFuaFrWOZbdH6HI93/jeGwY8uc2nJl0I4KkUZvg0VYmlOCPRUIu5qDgRALm5R5wuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keys can only be loaded when rootfs is mounted. Initcalls
are not suitable for that. Provide a special hook.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 include/linux/ima.h | 9 +++++++++
 init/main.c         | 6 +++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 23a87a4..b617c1a 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -73,4 +73,13 @@ static inline int ima_inode_removexattr(struct dentry *dentry,
 	return 0;
 }
 #endif /* CONFIG_IMA_APPRAISE */
+
+#ifdef CONFIG_IMA_APPRAISE_SIGNED_INIT
+extern void __init ima_prepare_keys(void);
+#else
+static inline void ima_prepare_keys(void)
+{
+}
+#endif
+
 #endif /* _LINUX_IMA_H */
diff --git a/init/main.c b/init/main.c
index e8ae1fe..b24cfaa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -78,6 +78,7 @@
 #include <linux/context_tracking.h>
 #include <linux/random.h>
 #include <linux/list.h>
+#include <linux/ima.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1028,6 +1029,9 @@ static noinline void __init kernel_init_freeable(void)
 	 * initmem segments and start the user-mode stuff..
 	 */
 
-	/* rootfs is available now, try loading default modules */
+	/* rootfs is available now */
+	/* try loading public keys */
+	ima_prepare_keys();
+	/* try loading default modules */
 	load_default_modules();
 }
-- 
1.9.1

