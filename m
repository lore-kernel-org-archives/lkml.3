Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3HRUdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab3HRUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 14/34] frv: Use correct size for task_struct allocation
Date: Sun, 18 Aug 2013 13:34:27 -0700
Message-Id: <20130818203300.663467283@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit cce4517f33384c3794c759e206cc8e1bb6df146b upstream.

alloc_task_struct_node() allocates THREAD_SIZE and maintains some
weird refcount in the allocated memory. This never blew up as
task_struct size on 32bit machines was always less than THREAD_SIZE

Allocate just sizeof(struct task_struct) and get rid of the magic
refcounting.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120503085033.898475542@linutronix.de
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/frv/kernel/process.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -46,17 +46,12 @@ EXPORT_SYMBOL(pm_power_off);
 
 struct task_struct *alloc_task_struct_node(int node)
 {
-	struct task_struct *p = kmalloc_node(THREAD_SIZE, GFP_KERNEL, node);
-
-	if (p)
-		atomic_set((atomic_t *)(p+1), 1);
-	return p;
+	return kmalloc_node(sizeof(task_struct), GFP_KERNEL, node);
 }
 
 void free_task_struct(struct task_struct *p)
 {
-	if (atomic_dec_and_test((atomic_t *)(p+1)))
-		kfree(p);
+	kfree(p);
 }
 
 static void core_sleep_idle(void)


