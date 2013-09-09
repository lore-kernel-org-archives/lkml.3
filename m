Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3IIPw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:52:28 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44958 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3IIPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:09 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 05/12] Restrict /dev/mem and /dev/kmem when securelevel is set.
Date: Mon,  9 Sep 2013 11:49:39 -0400
Message-Id: <1378741786-18430-6-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:5d52:9ee3:3e84:6668
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing users to write to address space provides mechanisms that may permit
modification of the kernel at runtime. Prevent this if securelevel has been
set.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/char/mem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 741f536..91d1cff 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -159,6 +159,9 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	unsigned long copied;
 	void *ptr;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (!valid_phys_addr_range(p, count))
 		return -EFAULT;
 
@@ -497,6 +500,9 @@ static ssize_t write_kmem(struct file *file, const char __user *buf,
 	char *kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 	int err = 0;
 
+	if (get_securelevel() > 0)
+		return -EPERM;
+
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-- 
1.8.3.1

