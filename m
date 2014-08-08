Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbaHHPiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:38:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59301 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaHHPiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:38:04 -0400
Message-ID: <53E4EED7.6050302@gmail.com>
Date: Fri, 08 Aug 2014 23:37:59 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: gleb@kernel.org, pbonzini@redhat.com
CC: kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to '-1'
 after free it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a generic function, deassign_guest_irq() assumes it can be called
even if assign_guest_irq() is not be called successfully (which can be
triggered by ioctl from user mode, indirectly).

So for assign_guest_irq() failure process, need set 'dev->irq_source_id'
to -1 after free 'dev->irq_source_id', or deassign_guest_irq() may free
it again.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 virt/kvm/assigned-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index bf06577..5819a27 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -526,8 +526,10 @@ static int assign_guest_irq(struct kvm *kvm,
 		dev->irq_requested_type |= guest_irq_type;
 		if (dev->ack_notifier.gsi != -1)
 			kvm_register_irq_ack_notifier(kvm, &dev->ack_notifier);
-	} else
+	} else {
 		kvm_free_irq_source_id(kvm, dev->irq_source_id);
+		dev->irq_source_id = -1;
+	}
 
 	return r;
 }
-- 
1.7.11.7
