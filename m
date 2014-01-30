Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaA3IsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 03:48:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaA3IsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 03:48:07 -0500
Date: Thu, 30 Jan 2014 09:48:02 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] /dev/mem: handle out-of-bounds read/write
Message-ID: <20140130094802.4ee29435@hananiah.suse.cz>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 92c5937..917403f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -99,6 +99,9 @@ static ssize_t read_mem(struct file *file, char
__user *buf, ssize_t read, sz;
 	char *ptr;
 
+	if (p != *ppos)
+		return 0;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 	read = 0;
@@ -157,6 +160,9 @@ static ssize_t write_mem(struct file *file, const
char __user *buf, unsigned long copied;
 	void *ptr;
 
+	if (p != *ppos)
+		return -EFBIG;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
-- 
1.8.4.5
