Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbaJ1HXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:23:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaJ1DnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:43:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.16 017/127] kvm: dont take vcpu mutex for obviously invalid vcpu ioctls
Date: Tue, 28 Oct 2014 11:34:12 +0800
Message-Id: <20141028033421.674345032@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
 
 #include <asm/processor.h>
 #include <asm/io.h>
+#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 
@@ -1989,6 +1990,9 @@ static long kvm_vcpu_ioctl(struct file *
 	if (vcpu->kvm->mm != current->mm)
 		return -EIO;
 
+	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
+		return -EINVAL;
+
 #if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,


