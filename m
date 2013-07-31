Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab3GaHeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:34:06 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:39202 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab3GaHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:34:04 -0400
Message-ID: <51F8BDE2.7060309@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 15:33:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 05/12] KVM: MMU: add spte into rmap before logging dirty
 page
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51F7BF49.1000101@redhat.com>
In-Reply-To: <51F7BF49.1000101@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073107-6102-0000-0000-000003F27727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 09:27 PM, Paolo Bonzini wrote:
> Il 30/07/2013 15:02, Xiao Guangrong ha scritto:
>> kvm_vm_ioctl_get_dirty_log() write-protects the spte based on the dirty
>> bitmap, we should ensure the writable spte can be found in rmap before the
>> dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and failed
>> to write-protect the page
>>
>> It need the memory barrier to prevent out-of-order that will be added in the
>> later patch
> 
> Do you mean that the later patch will also introduce a memory barrier?

No. Sorry for the confusion. I mean we miss the memory barrier in this patch
and will fix it in the latter patch where we introduce the lockless
write-protection.

The memory barrier is added in
[PATCH 11/12] KVM: MMU: locklessly write-protect the page:

+	/*
+	 * We should put the sptep into rmap before dirty log
+	 * otherwise the lockless spte write-protect path will
+	 * clear the dirty bit map but fail to find the spte.
+	 *
+	 * See the comments in kvm_vm_ioctl_get_dirty_log().
+	 */
+	smp_wmb();
+
 	if (pte_access & ACC_WRITE_MASK)

and the barrier in the another side is:
+		/*
+		 * xchg acts as a full barrier that ensures
+		 * clearing dirty bitmap before read rmap.
+		 *
+		 * See the comments in set_spte().
+		 */
 		mask = xchg(&dirty_bitmap[i], 0);

