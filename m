Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966135Ab3E2NJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:09:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60662 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966072Ab3E2NJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:09:19 -0400
Message-ID: <51A5FDF5.8020003@linux.vnet.ibm.com>
Date: Wed, 29 May 2013 21:09:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130524203432.GB4525@amt.cnet> <51A2C2DC.6080403@linux.vnet.ibm.com> <20130528001802.GB1359@amt.cnet> <51A4C6F1.9000607@linux.vnet.ibm.com> <20130529111132.GA5931@amt.cnet>
In-Reply-To: <20130529111132.GA5931@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052913-1618-0000-0000-000003FA672A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 07:11 PM, Marcelo Tosatti wrote:
> On Tue, May 28, 2013 at 11:02:09PM +0800, Xiao Guangrong wrote:
>> On 05/28/2013 08:18 AM, Marcelo Tosatti wrote:
>>> On Mon, May 27, 2013 at 10:20:12AM +0800, Xiao Guangrong wrote:
>>>> On 05/25/2013 04:34 AM, Marcelo Tosatti wrote:
>>>>> On Thu, May 23, 2013 at 03:55:53AM +0800, Xiao Guangrong wrote:
>>>>>> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
>>>>>> caused by requiring lock
>>>>>>
>>>>>> After the patch, kvm_zap_obsolete_pages can forward progress anyway,
>>>>>> so update the comments
>>>>>>
>>>>>> [ It improves kernel building 0.6% ~ 1% ]
>>>>>
>>>>> Can you please describe the overload in more detail? Under what scenario
>>>>> is kernel building improved?
>>>>
>>>> Yes.
>>>>
>>>> The scenario is we do kernel building, meanwhile, repeatedly read PCI rom
>>>> every one second.
>>>>
>>>> [
>>>>    echo 1 > /sys/bus/pci/devices/0000\:00\:03.0/rom
>>>>    cat /sys/bus/pci/devices/0000\:00\:03.0/rom > /dev/null
>>>> ]
>>>
>>> Can't see why it reflects real world scenario (or a real world
>>> scenario with same characteristics regarding kvm_mmu_zap_all vs faults)?
>>>
>>> Point is, it would be good to understand why this change 
>>> is improving performance? What are these cases where breaking out of
>>> kvm_mmu_zap_all due to either (need_resched || spin_needbreak) on zapped
>>> < 10 ?
>>
>> When guest read ROM, qemu will set the memory to map the device's firmware,
>> that is why kvm_mmu_zap_all can be called in the scenario.
>>
>> The reasons why it heart the performance are:
>> 1): Qemu use a global io-lock to sync all vcpu, so that the io-lock is held
>>     when we do kvm_mmu_zap_all(). If kvm_mmu_zap_all() is not efficient, all
>>     other vcpus need wait a long time to do I/O.
>>
>> 2): kvm_mmu_zap_all() is triggered in vcpu context. so it can block the IPI
>>     request from other vcpus.
>>
>> Is it enough?
> 
> That is no problem. The problem is why you chose "10" as the minimum number of
> pages to zap before considering reschedule. I would expect the need to

Well, my description above explained why batch-zapping is needed - we do
not want the vcpu spend lots of time to zap all pages because it hurts other
vcpus running.

But, why the batch page number is "10"... I can not answer this, i just guessed
that '10' can make vcpu do not spend long time on zap_all_pages and do
not cause mmu-lock too hungry. "10" is the speculative value and i am not sure
it is the best value but at lease, i think it can work.

> reschedule to be rare enough that one kvm_mmu_zap_all instance (between
> schedule in and schedule out) to be able to release no less than a
> thousand pages.

Unfortunately, no.

This information is I replied Gleb in his mail where he raced a question that
why "collapse tlb flush is needed":

======
It seems no.
Since we have reloaded mmu before zapping the obsolete pages, the mmu-lock
is easily contended. I did the simple track:

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

I do read pci rom when doing kernel building in the guest which
has 1G memory and 4vcpus with ept enabled, this is the normal
workload and normal configuration.

# dmesg
[ 2338.759099] lock-break: 8.
[ 2339.732442] lock-break: 5.
[ 2340.904446] lock-break: 3.
[ 2342.513514] lock-break: 3.
[ 2343.452229] lock-break: 3.
[ 2344.981599] lock-break: 4.

Basically, we need to break many times.
======

You can see we should break 3 times to zap all pages even if we have zapoed
10 pages in batch. It is obviously that it need break more times without
batch-zapping.




