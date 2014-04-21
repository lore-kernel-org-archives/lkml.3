Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaDUN0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbaDUN0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:26:04 -0400
Date: Mon, 21 Apr 2014 15:25:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: async_pf: kill the unnecessary use_mm/unuse_mm
	async_pf_execute()
Message-ID: <20140421132558.GA13608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421132543.GA13594@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

async_pf_execute() has no reasons to adopt apf->mm, gup(current, mm)
should work just fine even if current has another or NULL ->mm.

Recently kvm_async_page_present_sync() was added insedie the "use_mm"
section, but it seems that it doesn't need current->mm too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 virt/kvm/async_pf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 10df100..0ced4f3 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -80,12 +80,10 @@ static void async_pf_execute(struct work_struct *work)
 
 	might_sleep();
 
-	use_mm(mm);
 	down_read(&mm->mmap_sem);
 	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
 	up_read(&mm->mmap_sem);
 	kvm_async_page_present_sync(vcpu, apf);
-	unuse_mm(mm);
 
 	spin_lock(&vcpu->async_pf.lock);
 	list_add_tail(&apf->link, &vcpu->async_pf.done);
-- 
1.5.5.1

