Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaFMPKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:10:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30455 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaFMPKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:10:34 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-cf-539b14683f00
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: ming.lei@canonical.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 1/1] firmware: read firmware size using i_size_read()
Date: Fri, 13 Jun 2014 18:09:54 +0300
Message-id: <248c69602c96d68aea1ffb4cb75e77ec38b6b75f.1402672110.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1402672110.git.d.kasatkin@samsung.com>
References: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
 <cover.1402672110.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1402672110.git.d.kasatkin@samsung.com>
References: <cover.1402672110.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4Nd0MkdnBBus/K1rc+ruX2eLL0jqL
	5sXr2Swu75rDZrHr4Xd2B1aPWQ29bB47Z91l99g/dw27R9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGUcvdLMXHCGq6Ll1Em2BsYHHF2MnBwSAiYSx8+2sEDYYhIX7q1n62Lk4hASWMoocenM
	NWYIp5NJomvZXVaQKjYBPYkNzT/YQWwRASmJ3j2dzCA2s0Azo8TNKz5djBwcwgIeEucmVoKE
	WQRUJWZeO8UIYvMKxEnM//ANapmcxMljk8FGcgpYSbR9mAcWFxJoYpR49z8dU9xS4tCLNuYJ
	jPwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE25cdjIuPWR1iFOBgVOLh/VA9K1iI
	NbGsuDL3EKMEB7OSCO+9BqAQb0piZVVqUX58UWlOavEhRiYOTqkGxkmNhRNmfGP7tIxDtH9j
	4j/WjTG+jeUrRPcaTt/8+gdLUeJij0PMW99q6lmYruGX6hdXm6Iwf4ol05fZN8xsGernqcwT
	4RK0ffTIimcb1zz58uML0lg1j9mod947N7vu1Yu5a+LsbnUvM5wUey5mi93Vp8e/v32+PrJj
	g6PtZNaPDdkrbN/VvlBiKc5INNRiLipOBACTrk7mFQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to read attr because inode structure contains size
of the file. Use i_size_read() instead.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 drivers/base/firmware_class.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33..e84da14 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -279,26 +279,15 @@ static const char * const fw_path[] = {
 module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
 MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
 
-/* Don't inline this: 'struct kstat' is biggish */
-static noinline_for_stack int fw_file_size(struct file *file)
-{
-	struct kstat st;
-	if (vfs_getattr(&file->f_path, &st))
-		return -1;
-	if (!S_ISREG(st.mode))
-		return -1;
-	if (st.size != (int)st.size)
-		return -1;
-	return st.size;
-}
-
 static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
 {
 	int size;
 	char *buf;
 	int rc;
 
-	size = fw_file_size(file);
+	if (!S_ISREG(file_inode(file)->i_mode))
+		return -EINVAL;
+	size = i_size_read(file_inode(file));
 	if (size <= 0)
 		return -EINVAL;
 	buf = vmalloc(size);
-- 
1.9.1

