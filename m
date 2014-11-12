Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaKLQ7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:59:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13633 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaKLQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:59:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,370,1413244800"; 
   d="scan'208";a="192042410"
Message-ID: <546391DE.7040508@citrix.com>
Date: Wed, 12 Nov 2014 16:59:10 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: use the maximum MFN to calculate
 the required DMA mask
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com> <1415805906-27316-4-git-send-email-david.vrabel@citrix.com> <546390FC0200007800046E50@mail.emea.novell.com>
In-Reply-To: <546390FC0200007800046E50@mail.emea.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 15:55, Jan Beulich wrote:
>>>> On 12.11.14 at 16:25, <david.vrabel@citrix.com> wrote:
>> +u64
>> +xen_swiotlb_get_required_mask(struct device *dev)
>> +{
>> +	u64 max_mfn;
>> +
>> +	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
>> +
>> +	return DMA_BIT_MASK(fls64(max_mfn << PAGE_SHIFT) + 1);
>> +}
> 
> The value the hypercall returns is exclusive and an unsigned long.

The docs in include/public/memory.h say:

"Returns the maximum machine frame number of mapped RAM in this system."

Which sounds inclusive to me...  Do we need a doc update here?

> Hence I'd suggest
> 
> u64
> xen_swiotlb_get_required_mask(struct device *dev)
> {
> 	unsigned long max_mfn;
> 
> 	max_mfn = HYPERVISOR_memory_op(XENMEM_maximum_ram_page, NULL);
> 
> 	return DMA_BIT_MASK(__fls(max_mfn - 1) + 1 + PAGE_SHIFT);
> }
> 
> Jan
> 

