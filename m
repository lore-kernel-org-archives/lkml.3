Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBRWqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:46:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaBRWqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:46:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 19/24] KVM: Fix buffer overflow in kvm_set_irq()
Date: Tue, 18 Feb 2014 14:47:06 -0800
Message-Id: <20140218224550.766302748@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224550.221535225@linuxfoundation.org>
References: <20140218224550.221535225@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

commit f2ebd422f71cda9c791f76f85d2ca102ae34a1ed upstream.

kvm_set_irq() has an internal buffer of three irq routing entries, allowing
connecting a GSI to three IRQ chips or on MSI.  However setup_routing_entry()
does not properly enforce this, allowing three irqchip routes followed by
an MSI route to overflow the buffer.

Fix by ensuring that an MSI entry is added to an empty list.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/irq_comm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -318,6 +318,7 @@ static int setup_routing_entry(struct kv
 	 */
 	hlist_for_each_entry(ei, n, &rt->map[ue->gsi], link)
 		if (ei->type == KVM_IRQ_ROUTING_MSI ||
+		    ue->type == KVM_IRQ_ROUTING_MSI ||
 		    ue->u.irqchip.irqchip == ei->irqchip.irqchip)
 			return r;
 


