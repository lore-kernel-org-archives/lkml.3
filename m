Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaJJPrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 11:47:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaJJPrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 11:47:22 -0400
Message-ID: <5437FF6A.9030203@ti.com>
Date: Fri, 10 Oct 2014 11:46:50 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: add bus notifier to set dma_pfn_offset
 for pci devices
References: <1412954137-4567-1-git-send-email-m-karicheri2@ti.com> <5437FB3F.4010906@ti.com> <20141010154258.GN5182@n2100.arm.linux.org.uk>
In-Reply-To: <20141010154258.GN5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/10/14 11:42 AM, Russell King - ARM Linux wrote:
> On Fri, Oct 10, 2014 at 11:29:03AM -0400, Santosh Shilimkar wrote:
>>
>>
>> On 10/10/14 11:15 AM, Murali Karicheri wrote:
>>> When PCI device driver such as that for e1000e tries to set dma mask
>>> using dma_set_mask_and_coherent(), it fails because the dma_pfn_offset
>>> is incorrect on a Keystone SoC. This patch fix this by adding a bus
>>> notifier to set this correctly for PCI devices.
>>>
>>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>>> ---
>> Looks good. I will pick this up after the merge window.
>
> No it doesn't, this patch is crap.  Really.  Let's look again at what the
> patch is doing:
>
>          if (platform_nb.notifier_call)
>                  bus_register_notifier(&platform_bus_type, &platform_nb);
> +       if (platform_nb.notifier_call)
> +               bus_register_notifier(&pci_bus_type, &platform_nb);
>
> Notice that both calls are using the same platform_nb structure, which is:
>
> static struct notifier_block platform_nb;
>
> and in turn this is:
>
> struct notifier_block {
>          notifier_fn_t notifier_call;
>          struct notifier_block __rcu *next;
>          int priority;
> };
>
> Notice that "next" pointer - these blocks are used as a single-linked list.
> So, this block gets registered for the platform bus, and is inserted into
> that bus notifier chain.  That means "next" may be set to a non-NULL
> next notifier block.
>
> Then it gets registered against the PCI bus, which *will* overwrite the
> next pointer in platform_nb.
>
Err.... You are dead right. I missed completely that it is using the
same notifier block. Sorry for oversight and thanks for spotting it.

Regards,
Santosh

