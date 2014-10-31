Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbaJaNjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:39:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57346 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471AbaJaNje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:39:34 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 2/6] uio: Add new UIO_MEM_PHYS_CACHE type for mem regions
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAPTm99W0J-Q6CwCDVaYe4eyEWrruWuY5pzpHoESyVu9N3cFA=g@mail.gmail.com>
Date: Fri, 31 Oct 2014 08:39:29 -0500
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4B098F57-E202-412C-B54D-085A46792EDC@codeaurora.org>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org> <1413871011-4101-3-git-send-email-ankit.jindal@linaro.org> <6D33D50E-2DD1-482C-B05E-45B237F3B779@codeaurora.org> <CAPTm99W0J-Q6CwCDVaYe4eyEWrruWuY5pzpHoESyVu9N3cFA=g@mail.gmail.com>
To: Ankit Jindal <ankit.jindal@linaro.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 31, 2014, at 4:30 AM, Ankit Jindal <ankit.jindal@linaro.org> wrote:

> Hi Kumar,
> 
> On 21 October 2014 12:08, Kumar Gala <galak@codeaurora.org> wrote:
>> 
>> On Oct 21, 2014, at 7:56 AM, Ankit Jindal <ankit.jindal@linaro.org> wrote:
>> 
>>> Currently, three types of mem regions are supported: UIO_MEM_PHYS,
>>> UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL. Among these UIO_MEM_PHYS helps
>>> UIO driver export physcial memory to user space as non-cacheable
>>> user memory. Typcially memory-mapped registers of a device are exported
>>> to user space as UIO_MEM_PHYS type mem region. The UIO_MEM_PHYS type
>>> is not efficient if dma-capable devices are capable of maintaining coherency
>>> with CPU caches.
>>> 
>>> This patch adds new type UIO_MEM_PHYS_CACHE for mem regions to enable
>>> cacheable access to physical memory from user space.
>>> 
>>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>>> ---
>>> drivers/uio/uio.c          |   11 ++++++++---
>>> include/linux/uio_driver.h |    1 +
>>> 2 files changed, 9 insertions(+), 3 deletions(-)
>> 
>> Rather than adding a new type, why not allow the driver to set the pgprot value, this way one has full control and we don’t need to keep adding types for various different cache attributions in the future.
> 
> Do you mean to add a new field pgprot_t in the memtype structure and
> uio_mmap_physical will set vma->vm_page_prot to this value provided by
> driver ? If this is the case then we will need to change all the
> current uio based drivers which was the reason I preferred to have a
> new mem type.
> 
> Please let me know if I have misunderstood anything.

I’m suggeting in uio_mmap_physical to do something like:

if (idev->info->set_pgprot)
	idev->info->set_pgprot(vma->vm_page_prot)
else
	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

And add a set_prprot callback to 'struct uio_info’.

Here’s patch from several years ago:

http://patchwork.ozlabs.org/patch/119224/

- k

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

