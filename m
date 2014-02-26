Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaBZUON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:14:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44116 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaBZULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:11:41 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 05/12] Restrict /dev/mem and /dev/kmem when trusted_kernel is true
Date: Wed, 26 Feb 2014 15:11:06 -0500
Message-Id: <1393445473-15068-6-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing users to write to address space provides mechanisms that may permit
modification of the kernel at runtime. Prevent this if trusted_kernel is
true.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 15331a8..2cecab9 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -158,6 +158,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -496,6 +499,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (get_trusted_kernel())
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-- 
1.8.5.3

