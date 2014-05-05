Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbaEEMzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:55:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40991 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932285AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Tesarik <ptesarik@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 03/50] /dev/mem: handle out-of-bounds read/write
Date: Mon,  5 May 2014 14:42:45 +0200
Message-Id: <3566e03b5bc9c06855b07423ab4c6e2710aa21e4.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Tesarik <ptesarik@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 08d2d00b291ed4eb91530050274e67a761c1901d upstream.

The loff_t type may be wider than phys_addr_t (e.g. on 32-bit systems).
Consequently, the file offset may be truncated in the assignment.
Currently, /dev/mem wraps around, which may cause applications to read
or write incorrect regions of memory by accident.

Let's follow POSIX file semantics here and return 0 when reading from
and -EFBIG when writing to an offset that cannot be represented by a
phys_addr_t.

Note that the conditional is optimized out by the compiler if loff_t
has the same size as phys_addr_t.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index f895a8c8a244..d1f4675809f8 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -100,6 +100,9 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 	ssize_t read, sz;
 	char *ptr;
 
+	if (p != *ppos)
+		return 0;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 	read = 0;
@@ -158,6 +161,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (p != *ppos)
+		return -EFBIG;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
-- 
1.9.2

