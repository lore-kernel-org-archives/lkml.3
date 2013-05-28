Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab3E1PCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:02:21 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:33455 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439Ab3E1PCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:02:18 -0400
Message-ID: <51A4C6F1.9000607@linux.vnet.ibm.com>
Date: Tue, 28 May 2013 23:02:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130524203432.GB4525@amt.cnet> <51A2C2DC.6080403@linux.vnet.ibm.com> <20130528001802.GB1359@amt.cnet>
In-Reply-To: <20130528001802.GB1359@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052814-5140-0000-0000-00000346BDB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 08:18 AM, Marcelo Tosatti wrote:
> On Mon, May 27, 2013 at 10:20:12AM +0800, Xiao Guangrong wrote:
>> On 05/25/2013 04:34 AM, Marcelo Tosatti wrote:
>>> On Thu, May 23, 2013 at 03:55:53AM +0800, Xiao Guangrong wrote:
>>>> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
>>>> caused by requiring lock
>>>>
>>>> After the patch, kvm_zap_obsolete_pages can forward progress anyway,
>>>> so update the comments
>>>>
>>>> [ It improves kernel building 0.6% ~ 1% ]
>>>
>>> Can you please describe the overload in more detail? Under what scenario
>>> is kernel building improved?
>>
>> Yes.
>>
>> The scenario is we do kernel building, meanwhile, repeatedly read PCI rom
>> every one second.
>>
>> [
>>    echo 1 > /sys/bus/pci/devices/0000\:00\:03.0/rom
>>    cat /sys/bus/pci/devices/0000\:00\:03.0/rom > /dev/null
>> ]
> 
> Can't see why it reflects real world scenario (or a real world
> scenario with same characteristics regarding kvm_mmu_zap_all vs faults)?
> 
> Point is, it would be good to understand why this change 
> is improving performance? What are these cases where breaking out of
> kvm_mmu_zap_all due to either (need_resched || spin_needbreak) on zapped
> < 10 ?

When guest read ROM, qemu will set the memory to map the device's firmware,
that is why kvm_mmu_zap_all can be called in the scenario.

The reasons why it heart the performance are:
1): Qemu use a global io-lock to sync all vcpu, so that the io-lock is held
    when we do kvm_mmu_zap_all(). If kvm_mmu_zap_all() is not efficient, all
    other vcpus need wait a long time to do I/O.

2): kvm_mmu_zap_all() is triggered in vcpu context. so it can block the IPI
    request from other vcpus.

Is it enough?



