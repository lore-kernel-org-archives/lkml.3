Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaGHQ10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:27:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:35182 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaGHQ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:27:25 -0400
X-IronPort-AV: E=Sophos;i="5.01,625,1400025600"; 
   d="scan'208";a="150888428"
Message-ID: <53BC1B96.3070101@citrix.com>
Date: Tue, 8 Jul 2014 17:25:58 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
CC: <xen-devel@lists.xenproject.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH] mmap_vmcore: skip non-ram pages reported
 by hypervisors
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com> <20140707133301.dfcc078f416efeb1ada72da9@linux-foundation.org>
In-Reply-To: <20140707133301.dfcc078f416efeb1ada72da9@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/14 21:33, Andrew Morton wrote:
> On Mon,  7 Jul 2014 17:05:49 +0200 Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> 
>> we have a special check in read_vmcore() handler to check if the page was
>> reported as ram or not by the hypervisor (pfn_is_ram()). However, when
>> vmcore is read with mmap() no such check is performed. That can lead to
>> unpredictable results, e.g. when running Xen PVHVM guest memcpy() after
>> mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
>> enormous load in both DomU and Dom0.

Does make forward progress though?  Or is it ending up in a repeatedly
retrying the same instruction?

Is it failing on a ballooned page in a RAM region? Or is mapping non-RAM
regions as well?

>> Fix the issue by mapping each non-ram page to the zero page. Keep direct
>> path with remap_oldmem_pfn_range() to avoid looping through all pages on
>> bare metal.
>>
>> The issue can also be solved by overriding remap_oldmem_pfn_range() in
>> xen-specific code, as remap_oldmem_pfn_range() was been designed for.
>> That, however, would involve non-obvious xen code path for all x86 builds
>> with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
>> code on x86 arch from doing the same override.

The oldmem_pfn_is_ram() is Xen-specific but this problem (ballooned
pages) must be common to KVM.  How does KVM handle this?

David
