Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3EQCWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:22:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45422 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3EQCWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:22:15 -0400
Message-ID: <5195944A.3050608@oracle.com>
Date: Fri, 17 May 2013 10:22:02 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load first
 time
References: <518A0A50.1020705@oracle.com> <20130510185339.GD2562@phenom.dumpdata.com> <alpine.DEB.2.02.1305131136020.4799@kaball.uk.xensource.com> <20130513140749.GQ6811@phenom.dumpdata.com> <alpine.DEB.2.02.1305131540020.4799@kaball.uk.xensource.com> <20130513161714.GC10401@phenom.dumpdata.com> <alpine.DEB.2.02.1305131753070.4799@kaball.uk.xensource.com> <20130513182055.GC14177@phenom.dumpdata.com> <alpine.DEB.2.02.1305141440500.4799@kaball.uk.xensource.com> <20130514142013.GA10173@konrad-lan.dumpdata.com> <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1305151037100.4799@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-05-15 17:41, Stefano Stabellini wrote:
> On Tue, 14 May 2013, Konrad Rzeszutek Wilk wrote:
>> On Tue, May 14, 2013 at 02:49:50PM +0100, Stefano Stabellini wrote:
>>> On Mon, 13 May 2013, Konrad Rzeszutek Wilk wrote:
>>>> On Mon, May 13, 2013 at 06:24:46PM +0100, Stefano Stabellini wrote:
>>>>> On Mon, 13 May 2013, Konrad Rzeszutek Wilk wrote:
>>>>>> On Mon, May 13, 2013 at 03:50:52PM +0100, Stefano Stabellini wrote:
>>>>>>> On Mon, 13 May 2013, Konrad Rzeszutek Wilk wrote:
>>>>>>>> On Mon, May 13, 2013 at 12:06:43PM +0100, Stefano Stabellini wrote:
>>>>>>>>> On Fri, 10 May 2013, Konrad Rzeszutek Wilk wrote:
>>>>>>>>>> On Wed, May 08, 2013 at 04:18:24PM +0800, Zhenzhong Duan wrote:
>>>>>>>>>>> When driver load and unload in a loop, pirq will exhaust finally.
>>>>>>>>>>> Try to use the same pirq which was already mapped and binded at first time
>>>>>>>>>> So what happens if I unload and reload two drivers in random order?
>>>>>>>>>>
>>>>>>>>>>> when driver loaded.
>>>>>>>>>>>
>>>>>>>>>>> Read pirq from msix entry and test if data is XEN_PIRQ_MSI_DATA
>>>>>>>>>>> xen_irq_from_pirq(pirq) < 0 checking is wrong as irq will be freed
>>>>>>>>>>> when driver unload, it's always true in second load.
>>>>>>>>>> If my understanding is right the issue at hand is that the caching
>>>>>>>>>> information about the pirq disappears once the driver has been
>>>>>>>>>> unloaded b/c the event's irq-info is removed (as the driver is
>>>>>>>>>> unloaded and free_irq is called).
>>>>>>>>>>
>>>>>>>>>> Stefano,
>>>>>>>>>> Is there a specific write to the MSI structure that would cause the
>>>>>>>>>> hypervisor to drop the PIRQ? Or a nice hypercall to "free" an
>>>>>>>>>> PIRQ in usage?
>>>>>>>>> We already have a "free PIRQ" hypercall, it's called
>>>>>>>>> PHYSDEVOP_unmap_pirq and should be called by QEMU.
>>>>>>>> Considering that we call function that allocates (PHYSDEVOP_get_free_pirq)
>>>>>>>> it in the Linux kernel (and not in QEMU), perhaps that should be done in the
>>>>>>>> Linux kernel as part of xen_destroy_irq()? Or would that confuse QEMU?
>>>>>>> I think it would confuse QEMU. It is probably better to let the unmap
>>>>>>> being handled by it.
>>>>>>>
>>>>>>>
>>>>>>>> It looks like QEMU only does that hypercall (via xc_physdev_unmap_pirq)
>>>>>>>> unregister_real_device which is only called during pci unplug?
>>>>>>> You are right! I would think that this behaviour is erroneous unless it
>>>>>>> was done on purpose to avoid allocating MSIs twice.
>>>>>>> If that is the case we would need to do something similar in Linux too.
>>>>>>>
>>>>>>> I think that the issue is the mismatch between QEMU's and Linux's
>>>>>>> behaviours: either both should be allocating MSIs once, or they should
>>>>>>> both be allocating and deallocating MSIs every time the driver is loaded
>>>>>>> and unloaded.
>>>>>> Right. But we also have the scenario that QEMU and Linux are going to
>>>>>> be out of sync. So we need fixes in both places - I think.
>>>>> QEMU is the owner of the pirq, in fact it is the one that creates and
>>>>> destroys the mapping. I think that the right place to fix this problem
>>>>> is in QEMU, the ABI would be much cleaner as a result. As a side effect
>>>>> we don't need to make any changes in Linux.
>>>> You do. You need to remove the PHYSDEVOP_get_free_pirq call in that case.
>>>   
>>> PHYSDEVOP_get_free_pirq needs to stay, because Linux needs to know the
>>> pirq that QEMU is going to use.
>> That looks like an API violation. We have an hypercall that
>> allocates the PIRQ in the Linux, then two hypercalls in the QEMU
>> layer - one to map, and the other to unmap and free.
>>
>>> However I would let QEMU handle the mapping (it already does that in
>>> pt_msi_setup calling xc_physdev_map_pirq_msi) and unmapping (that is
>>> done by calling xc_domain_unbind_msi_irq from pt_msi_disable).
>>> I think the problem is that pt_msi_disable is only called on
>>> unregister_real_device and pt_reset_interrupt_and_io_mapping, not when
>>> the guest disables MSIs.
>> Sure, I am not disputing that. I think the fix in QEMU to call the
>> unmap is correct.
>>
>> But I am also wondering whether it makes sense to do that in the Linux
>> kernel - as it does the alloc in the first place. Seems like a bit of
>> duct-tape has been used to connect this plumbing together.
>
> I admit that it is not a great interface.
> I would be open to options that move the entire setup/freeing in Linux,
> but keep in mind that we need to retain the pirq code in QEMU for pure
> HVM guests.
Hi Stefano,

do you work out a patch for me to test?

thanks
zduan
