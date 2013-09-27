Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3I0UZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:25:51 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:43753 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3I0UZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:25:49 -0400
Message-ID: <5245E9C9.9030509@gmail.com>
Date: Fri, 27 Sep 2013 22:25:45 +0200
From: Vojtech Bocek <vbocek@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: About atags_proc buffer size
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I want to ask something about atags_proc.c implementation. Currently,
it uses a buffer to temporarily store atags. The buffer size is set to
1.5kb for some reason, but as far as I know, atag list's size is not
limited in any way. I've got a device (HTC One) which uses about 12kb
of tags, that means it panics during boot if CONFIG_ATAGS_PROC is
enabled, because the buffer contains only part of the tag list without
an end tag.

Why is only 1.5kb used? Is it some specific size the device should not
exceed?

I don't know much about the way ARM boot process works, but I tried to
store just the pointer to atag list, and it works fine (quick patch
attached). Do atags get erased later in boot process on some platforms,
is that the reason why buffer had to be used?
This requires modifications in kexec-tools, because it uses that 1.5kb
buffer, too. Again, here's my version of such modification[1]. If this
is okay, I can create a proper patch and submit it.

Yours,
Vojtech Bocek

[1]: https://github.com/Tasssadar/kexec-tools/commit/c6844e1ddb13a6b60cfefcb01c3843da97d6174c

---

diff --git a/arch/arm/kernel/atags_proc.c b/arch/arm/kernel/atags_proc.c
index c7ff807..12cc483 100644
--- a/arch/arm/kernel/atags_proc.c
+++ b/arch/arm/kernel/atags_proc.c
@@ -21,12 +21,11 @@ static const struct file_operations atags_fops = {
 	.llseek = default_llseek,
 };
 
-#define BOOT_PARAMS_SIZE 1536
-static char __initdata atags_copy[BOOT_PARAMS_SIZE];
+static const struct tag* __initdata atags_copy;
 
 void __init save_atags(const struct tag *tags)
 {
-	memcpy(atags_copy, tags, sizeof(atags_copy));
+	atags_copy = tags;
 }
 
 static int __init init_atags_procfs(void)
@@ -40,7 +39,7 @@ static int __init init_atags_procfs(void)
 	struct buffer *b;
 	size_t size;
 
-	if (tag->hdr.tag != ATAG_CORE) {
+	if (!atags_copy || tag->hdr.tag != ATAG_CORE) {
 		printk(KERN_INFO "No ATAGs?");
 		return -EINVAL;
 	}
@@ -49,7 +48,7 @@ static int __init init_atags_procfs(void)
 		;
 
 	/* include the terminating ATAG_NONE */
-	size = (char *)tag - atags_copy + sizeof(struct tag_header);
+	size = (char *)tag - (char *)atags_copy + sizeof(struct tag_header);
 
 	WARN_ON(tag->hdr.tag != ATAG_NONE);
 
