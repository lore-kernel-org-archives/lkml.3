Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaFZUep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:34:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbaFZUem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:34:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 07/15] kexec: Make kexec_segment user buffer pointer a union
Date: Thu, 26 Jun 2014 16:33:36 -0400
Message-Id: <1403814824-7587-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far kexec_segment->buf was always a user space pointer as user space
passed the array of kexec_segment structures and kernel copied it.

But with new system call, list of kexec segments will be prepared by
kernel and kexec_segment->buf will point to a kernel memory.

So while I was adding code where I made assumption that ->buf is pointing
to kernel memory, sparse started giving warning.

Make ->buf a union. And where a user space pointer is expected, access
it using ->buf and where a kernel space pointer is expected, access it
using ->kbuf. That takes care of sparse warnings.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/kexec.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d9bb0a5..66d56ac 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -69,7 +69,18 @@ typedef unsigned long kimage_entry_t;
 #define IND_SOURCE       0x8
 
 struct kexec_segment {
-	void __user *buf;
+	/*
+	 * This pointer can point to user memory if kexec_load() system
+	 * call is used or will point to kernel memory if
+	 * kexec_file_load() system call is used.
+	 *
+	 * Use ->buf when expecting to deal with user memory and use ->kbuf
+	 * when expecting to deal with kernel memory.
+	 */
+	union {
+		void __user *buf;
+		void *kbuf;
+	};
 	size_t bufsz;
 	unsigned long mem;
 	size_t memsz;
-- 
1.9.0

