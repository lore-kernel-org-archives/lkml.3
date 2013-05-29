Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab3E2QEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:04:05 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53568 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab3E2QDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:03:54 -0400
Message-ID: <51A626E0.9030308@linux.vnet.ibm.com>
Date: Thu, 30 May 2013 00:03:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130524203432.GB4525@amt.cnet> <51A2C2DC.6080403@linux.vnet.ibm.com> <20130528001802.GB1359@amt.cnet> <51A4C6F1.9000607@linux.vnet.ibm.com> <20130529111132.GA5931@amt.cnet> <51A5FDF5.8020003@linux.vnet.ibm.com> <20130529133243.GG5931@amt.cnet> <51A60A64.2080509@linux.vnet.ibm.com>
In-Reply-To: <51A60A64.2080509@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052915-8878-0000-0000-0000074E5DE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 10:02 PM, Xiao Guangrong wrote:
> On 05/29/2013 09:32 PM, Marcelo Tosatti wrote:
>> On Wed, May 29, 2013 at 09:09:09PM +0800, Xiao Guangrong wrote:
>>> This information is I replied Gleb in his mail where he raced a question that
>>> why "collapse tlb flush is needed":
>>>
>>> ======
>>> It seems no.
>>> Since we have reloaded mmu before zapping the obsolete pages, the mmu-lock
>>> is easily contended. I did the simple track:
>>>
>>> +       int num = 0;
>>>  restart:
>>>         list_for_each_entry_safe_reverse(sp, node,
>>>               &kvm->arch.active_mmu_pages, link) {
>>> @@ -4265,6 +4265,7 @@ restart:
>>>                 if (batch >= BATCH_ZAP_PAGES &&
>>>                       cond_resched_lock(&kvm->mmu_lock)) {
>>>                         batch = 0;
>>> +                       num++;
>>>                         goto restart;
>>>                 }
>>>
>>> @@ -4277,6 +4278,7 @@ restart:
>>>          * may use the pages.
>>>          */
>>>         kvm_mmu_commit_zap_page(kvm, &invalid_list);
>>> +       printk("lock-break: %d.\n", num);
>>>  }
>>>
>>> I do read pci rom when doing kernel building in the guest which
>>> has 1G memory and 4vcpus with ept enabled, this is the normal
>>> workload and normal configuration.
>>>
>>> # dmesg
>>> [ 2338.759099] lock-break: 8.
>>> [ 2339.732442] lock-break: 5.
>>> [ 2340.904446] lock-break: 3.
>>> [ 2342.513514] lock-break: 3.
>>> [ 2343.452229] lock-break: 3.
>>> [ 2344.981599] lock-break: 4.
>>>
>>> Basically, we need to break many times.
>>
>> Should measure kvm_mmu_zap_all latency.
>>
>>> ======
>>>
>>> You can see we should break 3 times to zap all pages even if we have zapoed
>>> 10 pages in batch. It is obviously that it need break more times without
>>> batch-zapping.
>>
>> Again, breaking should be no problem, what matters is latency. Please
>> measure kvm_mmu_zap_all latency after all optimizations to justify 
>> this minimum batching.
> 
> Okay, okay. I will benchmark the latency.

Okay, I have done the test, the test environment is the same that
"I do read pci rom when doing kernel building in the guest which
has 1G memory and 4vcpus with ept enabled, this is the normal
workload and normal configuration.".

Batch-zapped:
Guest:
# cat     /sys/bus/pci/devices/0000\:00\:03.0/rom
# free -m
             total       used       free     shared    buffers     cached
Mem:           975        793        181          0          6        438
-/+ buffers/cache:        347        627
Swap:         2015         43       1972

Host shows:
[ 2229.918558] lock-break: 5.
[ 2229.918564] kvm_mmu_invalidate_zap_all_pages: 174706e.


No-batch:
Guest:
# cat     /sys/bus/pci/devices/0000\:00\:03.0/rom
# free -m
             total       used       free     shared    buffers     cached
Mem:           975        843        131          0         17        476
-/+ buffers/cache:        348        626
Swap:         2015          2

Host shows:
[ 2931.675285] lock-break: 13.
[ 2931.675291] kvm_mmu_invalidate_zap_all_pages: 69c1676.

That means, nearly the same memory accessed on guest:
- batch-zapped need to break 5 times, the latency is 174706e.
- no-batch need to break 13 times, the latency is 69c1676.

The code change to track the latency:

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 055d675..a66f21b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4233,13 +4233,13 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
        spin_unlock(&kvm->mmu_lock);
 }

-#define BATCH_ZAP_PAGES        10
+#define BATCH_ZAP_PAGES        0
 static void kvm_zap_obsolete_pages(struct kvm *kvm)
 {
        struct kvm_mmu_page *sp, *node;
        LIST_HEAD(invalid_list);
        int batch = 0;
-
+       int num = 0;
 restart:
        list_for_each_entry_safe_reverse(sp, node,
              &kvm->arch.active_mmu_pages, link) {
@@ -4265,6 +4265,7 @@ restart:
                if (batch >= BATCH_ZAP_PAGES &&
                      cond_resched_lock(&kvm->mmu_lock)) {
                        batch = 0;
+                       num++;
                        goto restart;
                }

@@ -4277,6 +4278,7 @@ restart:
         * may use the pages.
         */
        kvm_mmu_commit_zap_page(kvm, &invalid_list);
+       printk("lock-break: %d.\n", num);
 }

 /*
@@ -4290,7 +4292,12 @@ restart:
  */
 void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
 {
+       u64 start;
+
        spin_lock(&kvm->mmu_lock);
+
+       start = local_clock();
+
        trace_kvm_mmu_invalidate_zap_all_pages(kvm);
        kvm->arch.mmu_valid_gen++;

@@ -4306,6 +4313,9 @@ void kvm_mmu_invalidate_zap_all_pages(struct kvm *kvm)
        kvm_reload_remote_mmus(kvm);

        kvm_zap_obsolete_pages(kvm);
+
+       printk("%s: %llx.\n", __FUNCTION__, local_clock() - start);
+
        spin_unlock(&kvm->mmu_lock);
 }



