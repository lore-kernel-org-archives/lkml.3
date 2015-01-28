Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbbA1FYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:24:04 -0500
Received: from mail.kernel.org ([198.145.29.136]:37362 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933488AbbA1EPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:15:23 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 023/177] kvm: don't take vcpu mutex for obviously invalid vcpu ioctls
Date: Wed, 28 Jan 2015 12:06:53 +0800
Message-Id: <1422418236-12852-46-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Matlack <dmatlack@google.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2ea75be3219571d0ec009ce20d9971e54af96e09 upstream.

vcpu ioctls can hang the calling thread if issued while a vcpu is running.
However, invalid ioctls can happen when userspace tries to probe the kind
of file descriptors (e.g. isatty() calls ioctl(TCGETS)); in that case,
we know the ioctl is going to be rejected as invalid anyway and we can
fail before trying to take the vcpu mutex.

This patch does not change functionality, it just makes invalid ioctls
fail faster.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bc5ed14..f4732bd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 
 #include <asm/processor.h>
 #include <asm/io.h>
+#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
@@ -1744,6 +1745,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
 
+	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
+		return -EINVAL;
+
 #if defined(CONFIG_S390) || defined(CONFIG_PPC)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
-- 
1.9.1

