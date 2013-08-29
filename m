Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab3H2Juq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:50:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23585 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3H2Juo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:50:44 -0400
Message-ID: <521F196E.2010102@oracle.com>
Date: Thu, 29 Aug 2013 17:50:38 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/3 v3] Refactor MSI restore call-chain to
 drop unnecessary argument
References: <521EB76B.8090903@oracle.com> <521F12FC02000078000EF503@nat28.tlf.novell.com>
In-Reply-To: <521F12FC02000078000EF503@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-08-29 15:23, Jan Beulich wrote:
>>>> On 29.08.13 at 04:52, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
>> But in initial domain (aka priviliged guest), it's different.
>> Driver init call graph under initial domain:
>> driver_init->
>>      msix_capability_init->
>>          msix_program_entries->
>>              msix_mask_irq->
>>                  entry->masked = 1
>>      request_irq->
>>          __setup_irq->
>>              irq_startup->
>>                  __startup_pirq->
>>                      EVTCHNOP_bind_pirq hypercall    (trap into Xen)
>> [Xen:]
>> pirq_guest_bind->
>>      startup_msi_irq->
>>          unmask_msi_irq->
>>              msi_set_mask_bit->
>>                  entry->msi_attrib.masked = 0
>>
>> So entry->msi_attrib.masked in xen side always has newest value. entry->masked
>> in initial domain is untouched and is 1 after msix_capability_init.
> And as said several times before - Linux shouldn't be touching
> the MSI-X table at all during initial setup or resume (it should in
> particular not rely on such accesses to not fault, as being a
> privilege violation); all it needs to do is update its software state.
My patch just remove access to msix mask register in dom0. Anything 
wrong with that?
>
> Hence fiddling with default_restore_msi_irqs() seems the wrong
> approach towards solving the problem.
dom0 uses xen_initdom_restore_msi_irqs, default_restore_msi_irqs is for 
baremetal.

zduan
