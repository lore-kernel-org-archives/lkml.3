Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbaD1PDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:03:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbaD1PDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:03:15 -0400
Date: Mon, 28 Apr 2014 17:03:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/2] KVM: async_pf: change async_pf_execute() to use
	get_user_pages(tsk => NULL)
Message-ID: <20140428150300.GB19879@redhat.com>
References: <20140421132543.GA13594@redhat.com> <535E361D.3050902@redhat.com> <20140428141532.GD10488@redhat.com> <20140428150234.GA19879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428150234.GA19879@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

async_pf_execute() passes tsk == current to gup(), this is doesn't
hurt but unnecessary and misleading. "tsk" is only used to account
the number of faults and current is the random workqueue thread.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 virt/kvm/async_pf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 0ced4f3..62f4223 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -81,7 +81,7 @@ static void async_pf_execute(struct work_struct *work)
 	might_sleep();
 
 	down_read(&mm->mmap_sem);
-	get_user_pages(current, mm, addr, 1, 1, 0, NULL, NULL);
+	get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
 	up_read(&mm->mmap_sem);
 	kvm_async_page_present_sync(vcpu, apf);
 
-- 
1.5.5.1


