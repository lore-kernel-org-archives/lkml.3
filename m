Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3H2Ld6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:33:58 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58025 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3H2Ld5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:33:57 -0400
Message-ID: <521F319B.9000006@linux.vnet.ibm.com>
Date: Thu, 29 Aug 2013 19:33:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828092001.GQ22899@redhat.com> <521DC3FD.1020507@linux.vnet.ibm.com> <20130828094630.GR22899@redhat.com> <521DCD57.7000401@linux.vnet.ibm.com> <20130828104938.GT22899@redhat.com> <521DE9E8.2040908@linux.vnet.ibm.com> <20130828133635.GU22899@redhat.com> <521EEF4B.4040107@linux.vnet.ibm.com> <20130829093141.GC22899@redhat.com>
In-Reply-To: <20130829093141.GC22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082911-2674-0000-0000-00000A6F3370
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 05:31 PM, Gleb Natapov wrote:
> On Thu, Aug 29, 2013 at 02:50:51PM +0800, Xiao Guangrong wrote:
>> After more thinking, I still think rcu_assign_pointer() is unneeded when a entry
>> is removed. The remove-API does not care the order between unlink the entry and
>> the changes to its fields. It is the caller's responsibility:
>> - in the case of rcuhlist, the caller uses call_rcu()/synchronize_rcu(), etc to
>>   enforce all lookups exit and the later change on that entry is invisible to the
>>   lookups.
>>
>> - In the case of rculist_nulls, it seems refcounter is used to guarantee the order
>>   (see the example from Documentation/RCU/rculist_nulls.txt).
>>
>> - In our case, we allow the lookup to see the deleted desc even if it is in slab cache
>>   or its is initialized or it is re-added.
>>
> BTW is it a good idea? We can access deleted desc while it is allocated
> and initialized to zero by kmem_cache_zalloc(), are we sure we cannot
> see partially initialized desc->sptes[] entry? On related note what about
> 32 bit systems, they do not have atomic access to desc->sptes[].

Good eyes. This is a bug here.

It seems we do not have a good to fix this. How disable this optimization on
32 bit host, small changes:

 static inline void kvm_mmu_rcu_free_page_begin(struct kvm *kvm)
 {
+#ifdef CONFIG_X86_64
        rcu_read_lock();

        kvm->arch.rcu_free_shadow_page = true;
        /* Set the indicator before access shadow page. */
        smp_mb();
+#else
+       spin_lock(kvm->mmu_lock);
+#endif
 }

 static inline void kvm_mmu_rcu_free_page_end(struct kvm *kvm)
 {
+#ifdef CONFIG_X86_64
        /* Make sure that access shadow page has finished. */
        smp_mb();
        kvm->arch.rcu_free_shadow_page = false;

        rcu_read_unlock();
+#else
+       spin_unlock(kvm->mmu_lock);
+#endif
 }


