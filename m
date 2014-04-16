Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161763AbaDPPUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:20:43 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56653 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161715AbaDPPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:20:42 -0400
From: Lin Yongting <linyongting@gmail.com>
To: gregkh@suse.de, akpm@linux-foundation.org, harryxiyou@gmail.com,
        rdunlap@infradead.org
Cc: linux-kernel@zh-kernel.org, linux-doc@vger.kernel.or,
        linux-kernel@vger.kernel.org, linyongting@gmail.com,
        linyongting@huawei.com
Subject: =?UTF-8?q?=5BPATCH=5D=20Chinese=3A=20add=20translation=20of=20io=5Fordering=2Etxt?=
Date: Wed, 16 Apr 2014 23:20:16 +0800
Message-Id: <1397661616-6095-1-git-send-email-linyongting@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a Chinese translated version of Documentation/io_ordering.txt

Signed-off-by: Lin Yongting <linyongting@gmail.com>
---
 Documentation/zh_CN/io_ordering.txt |   67 +++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/zh_CN/io_ordering.txt

diff --git a/Documentation/zh_CN/io_ordering.txt b/Documentation/zh_CN/io_ordering.txt
new file mode 100644
index 0000000..e592daf
--- /dev/null
+++ b/Documentation/zh_CN/io_ordering.txt
@@ -0,0 +1,67 @@
+Chinese translated version of Documentation/io_orderings.txt
+
+If you have any comment or update to the content, please contact the
+original document maintainer directly.  However, if you have a problem
+communicating in English you can also ask the Chinese maintainer for
+help.  Contact the Chinese maintainer if this translation is outdated
+or if there is a problem with the translation.
+
+Chinese maintainer: Lin Yongting <linyongting@gmail.com>
+---------------------------------------------------------------------
+Documentation/io_ordering.txt 的中文翻译
+
+如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
+交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
+译存在问题，请联系中文版维护者。
+
+中文版维护者： 林永听 Lin Yongting <linyongting@gmail.com>
+中文版翻译者： 林永听 Lin Yongting <linyongting@gmail.com>
+中文版校译者： 林永听 Lin Yongting <linyongting@gmail.com>
+
+
+以下为正文
+---------------------------------------------------------------------
+
+在某些平台上，所谓的内存映射I/O是弱顺序。在这些平台上，驱动开发者有责任
+保证I/O内存映射地址的写操作按程序图意的顺序达到设备。通常读取一个“安全”
+设备寄存器或桥寄存器，触发IO芯片清刷未处理的写操作到达设备后才处理读操作，
+而达到保证目的。驱动程序通常在spinlock保护的临界区退出之前使用这种技术。
+这也可以保证后面的写操作只在前面的写操作之后到达设备（这非常类似于内存
+屏障操作，mb()，不过仅适用于I/O）。
+
+假设一个设备驱动程的具体例子：
+
+        ...
+CPU A:  spin_lock_irqsave(&dev_lock, flags)
+CPU A:  val = readl(my_status);
+CPU A:  ...
+CPU A:  writel(newval, ring_ptr);
+CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
+        ...
+CPU B:  spin_lock_irqsave(&dev_lock, flags)
+CPU B:  val = readl(my_status);
+CPU B:  ...
+CPU B:  writel(newval2, ring_ptr);
+CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
+        ...
+
+上述例子中，设备可能会先接收到newval2的值，然后接收到newval的值，问题就
+发生了。不过很容易通过下面方法来修复：
+
+        ...
+CPU A:  spin_lock_irqsave(&dev_lock, flags)
+CPU A:  val = readl(my_status);
+CPU A:  ...
+CPU A:  writel(newval, ring_ptr);
+CPU A:  (void)readl(safe_register); /* 配置寄存器？*/
+CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
+        ...
+CPU B:  spin_lock_irqsave(&dev_lock, flags)
+CPU B:  val = readl(my_status);
+CPU B:  ...
+CPU B:  writel(newval2, ring_ptr);
+CPU B:  (void)readl(safe_register); /* 配置寄存器？*/
+CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
+
+在解决方案中，读取safe_register寄存器，触发IO芯片清刷未处理的写操作，
+再处理后面的读操作，防止引发数据不一致问题。
-- 
1.7.9.5

