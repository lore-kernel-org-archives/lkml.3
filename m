Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3GRGZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:25:34 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38357 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab3GRGZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:25:33 -0400
Message-ID: <51E78A4F.9060801@linux.vnet.ibm.com>
Date: Thu, 18 Jul 2013 14:25:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: markus@trippelsdorf.de, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
References: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130718053154.GY11772@redhat.com> <51E784CB.1040402@linux.vnet.ibm.com> <20130718060628.GA15613@redhat.com>
In-Reply-To: <20130718060628.GA15613@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071806-6102-0000-0000-000003E08649
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 02:06 PM, Gleb Natapov wrote:
> On Thu, Jul 18, 2013 at 02:01:47PM +0800, Xiao Guangrong wrote:
>> On 07/18/2013 01:31 PM, Gleb Natapov wrote:
>>> On Thu, Jul 18, 2013 at 12:52:37PM +0800, Xiao Guangrong wrote:
>>>> Currently, fast page fault tries to fix mmio page fault when the
>>>> generation number is invalid (spte.gen != kvm.gen) and returns to
>>>> guest to retry the fault since it sees the last spte is nonpresent
>>>> which causes infinity loop
>>>>
>>>> It can be triggered only on AMD host since the mmio page fault is
>>>> recognized as ept-misconfig
>>>>
>>> We still call into regular page fault handler from ept-misconfig
>>> handler, but fake zero error_code we provide makes page_fault_can_be_fast()
>>> return false.
>>
>> Yes.
>>
>>>
>>> Shouldn't shadow paging trigger this too? I haven't encountered this on
>>> Intel without ept.
>>
>> Since currently fast page fault only works for direct mmu. :)
> Ah, yes. So with shadow page and paging disabled in a guest is can
> happen eventually, but we do not trigger it for some reason?

Yes. I guess so, paging disable is short-lived and the sptes will be
invalid after memslot changed for 150 times, so it is hard to be triggered.

I should update this to the changelog, thanks for your reminder, Gleb.

======
[PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault

Currently, fast page fault tries to fix mmio page fault when the
generation number is invalid (spte.gen != kvm.gen) and returns to
guest to retry the fault since it sees the last spte is nonpresent.
It causes infinity loop

Since fast page fault only works for direct mmu, the issue exists when
1) tdp is enabled. It is only triggered only on AMD host since on Intel host
   the mmio page fault is recognized as ept-misconfig whose handler call
   fault-page path with error_code = 0

2) guest paging is disabled. Under this case, the issue is hardly discovered
   since paging disable is short-lived and the sptes will be invalid after
   memslot changed for 150 times

Fix it by filtering the mmio page fault out in page_fault_can_be_fast

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bf7af1e..3a9493a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2811,6 +2811,13 @@ exit:
 static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, u32 error_code)
 {
 	/*
+	 * Do not fix the mmio spte with invalid generation number which
+	 * need to be updated by slow page fault path.
+	 */
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return false;
+
+	/*
 	 * #PF can be fast only if the shadow page table is present and it
 	 * is caused by write-protect, that means we just need change the
 	 * W bit of the spte which can be done out of mmu-lock.
-- 
1.8.1.4




