Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3GYHRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 03:17:46 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41858 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3GYHRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 03:17:43 -0400
Message-ID: <51F0D109.4050002@oracle.com>
Date: Thu, 25 Jul 2013 15:17:29 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, bhelgaas@google.com,
        Feng Jin <joe.jin@oracle.com>,
        "x86@kernel.org >> \"x86@kernel.org\"" <x86@kernel.org>
Subject: Re: [PATCH 3/3] msix restore code optimization for dom0
References: <51EF453B.5070200@oracle.com> <20130724135555.GD2518@phenom.dumpdata.com>
In-Reply-To: <20130724135555.GD2518@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-07-24 21:55, Konrad Rzeszutek Wilk wrote:
> On Wed, Jul 24, 2013 at 11:08:43AM +0800, Zhenzhong Duan wrote:
>> PHYSDEVOP_restore_msi is used to restore all msix entrys in one hypercall
>> in dom0. But it is called multi times in current code.
> Couldn't the restore_msi_irqs instead check whether it has already
> made the hypercall (perhaps by seeing if the MSI-X's are enabled?)
> and if so don't do the hypercall?
I think it's better to remove the for loop for dom0, also hard to know 
when to clear hypercall count.
>
> I think you are addressing the problem from a different viewpoint.
>
> The problem is not with the API (the x86_msi one). The problem
> is with the implementation (x86_msi.restore_msi_irq - specifically
> the Xen one) having an side effect.
We have x86_msi.restore_msi_irqs and no x86_msi.restore_msi_irq,if want to
add x86_msi.restore_msi_irq, same hypercall need to be added accordingly.
>
>> This patch split arch_restore_msi_irqs into two functions.
>> Use arch_restore_msi_irq deal with one entry and avoid call hypercall multi
>> times in __pci_restore_msix_state.
> But irregardless of how you address the problem, this in the MSI code
> is a bit odd:
>
> 	list_for_each_entry(entry, &dev->msi_list, list) {
> 		arch_restore_msi_irqs(dev, entry->irq);
> 	}
>
> and if you collapse that and make the 'arch_restore_msi_irqs' be responsible
> for doing all the heavy lifting.. That does seem an improvement on the API
> and will make it inline with 'teardown_msi_irqs'.
>
> So from that view I think it would be nicer?
Yes, This patch just did that. There is 
teardown_msi_irqs/teardown_msi_irq pair.
But in current code, arch_restore_msi_irqs is used for one msix entry, 
this is not consistent with
its naming tradiition. So I changed default_restore_msi_irqs to deal 
with all entrys and
default_restore_msi_irq to deal with one entry for baremetal. For dom0, 
we have
PHYSDEVOP_restore_msi  to restore all msix entrys.
