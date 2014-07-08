Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaGHGqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:46:36 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48216 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGHGqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:46:34 -0400
Message-ID: <53BB93C8.7000905@gmail.com>
Date: Tue, 08 Jul 2014 09:46:32 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: Gleb Natapov <gleb@kernel.org>, mtosatti@redhat.com, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kvm, mem-hotplug: Update apic access page when it
 is migrated.
References: <1404291637-15048-1-git-send-email-tangchen@cn.fujitsu.com> <1404291637-15048-5-git-send-email-tangchen@cn.fujitsu.com> <20140703135507.GM18167@minantech.com> <53B60EF1.6030307@cn.fujitsu.com> <20140704101310.GE4399@minantech.com> <53BA6DD3.9040400@cn.fujitsu.com> <53BA87A3.5020205@gmail.com> <20140707115446.GP18167@minantech.com> <53BA8E2F.9000200@gmail.com> <53BB4CF3.2010908@cn.fujitsu.com>
In-Reply-To: <53BB4CF3.2010908@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang,

I am sorry if I caused any confusion.

Following Gleb response, there is no apparent need for dealing with the 
scenario I mentioned (relocating the APIC base), so you don't need to do 
any changes to your patch, and I will post another patch later to warn 
if the guest relocates its APIC (from the default address to another 
guest physical address). My answers to your questions are below.

On 7/8/14, 4:44 AM, Tang Chen wrote:
> Hi Nadav,
>
> Thanks for the reply, please see below.
>
> On 07/07/2014 08:10 PM, Nadav Amit wrote:
>> On 7/7/14, 2:54 PM, Gleb Natapov wrote:
>>> On Mon, Jul 07, 2014 at 02:42:27PM +0300, Nadav Amit wrote:
>>>> Tang,
>>>>
>>>> Running some (unrelated) tests I see that KVM does not handle APIC base
>>>> relocation correctly. When the base is changed, kvm_lapic_set_base just
>>>> changes lapic->base_address without taking further action (i.e.,
>>>> modifying
>>>> the VMCS apic address in VMX).
>>>>
>>>> This patch follows KVM bad behavior by using the constant
>>>> VMX_APIC_ACCESS_PAGE_ADDR instead of lapic->base_address.
>>> There is no OS out there that relocates APIC base (in fact it was not
>>> always
>>> relocatable on real HW), so there is not point in complicating the
>>> code to support
>>> it. In fact current APIC_ACCESS_ADDR handling relies on the fact that
>>> all vcpus
>>> has apic mapped at the same address.
>>>
>>>>
>>>> Anyhow, I didn't see anything that would make my life (in fixing the
>>>> lapic
>>>> base issue) too difficult. Yet, feel free in making it more
>>>> "fix-friendly".
>>>>
>>> Why would you want to fix it?
>>>
>> If there is no general need, I will not send a fix. However, I think the
>> very least a warning message should be appear if the guest relocates the
>> APIC base.
>
> Maybe I didn't understand you question correctly. If I'm wrong, please
> tell me.
>
> This patch does not relocate APIC base in guest, but in host. Host migrates
> the apic page to somewhere else, and KVM updates ept pagetable to track it.
> In guest, apic base address (gpa) doesn't change.
The last claim is true in practice, according to Gleb, but it is not 
necessarily so according to the specifications. Pentium 4, Intel Xeon 
and P6 family processors support APIC base relocation. See the Intel SDM 
section 10.4.5. Anyhow, Gleb claims it is not used by any OS.

>
> Is this lapic->base_address a hpa ?
No, it is guest physical address.

>
> Is there anywhere I need to update in my patch ?

No. I'll send another patch on top of yours that prints a warning if the 
APIC base is relocated (i.e., the guest physical address of the APIC 
base is changed). Such relocation is done explicitly by the guest, not 
by your patch.

Nadav

