Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaGIJRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbaGIJRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:17:25 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        <xen-devel@lists.xenproject.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH] mmap_vmcore: skip non-ram pages reported by hypervisors
References: <1404745549-16023-1-git-send-email-vkuznets@redhat.com>
	<20140707133301.dfcc078f416efeb1ada72da9@linux-foundation.org>
	<53BC1B96.3070101@citrix.com>
Date: Wed, 09 Jul 2014 11:17:13 +0200
In-Reply-To: <53BC1B96.3070101@citrix.com> (David Vrabel's message of "Tue, 8
	Jul 2014 17:25:58 +0100")
Message-ID: <87vbr6opra.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <david.vrabel@citrix.com> writes:

> On 07/07/14 21:33, Andrew Morton wrote:
>> On Mon,  7 Jul 2014 17:05:49 +0200 Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>>> we have a special check in read_vmcore() handler to check if the page was
>>> reported as ram or not by the hypervisor (pfn_is_ram()). However, when
>>> vmcore is read with mmap() no such check is performed. That can lead to
>>> unpredictable results, e.g. when running Xen PVHVM guest memcpy() after
>>> mmap() on /proc/vmcore will hang processing HVMMEM_mmio_dm pages creating
>>> enormous load in both DomU and Dom0.
>
> Does make forward progress though?  Or is it ending up in a repeatedly
> retrying the same instruction?

If memcpy is using SSE2 optimization 16-byte 'movdqu' instruction never
finishes (repeatedly retrying to issue two 8-byte requests to
qemu-dm). qemu-dm decides that it's hitting 'Neither RAM nor known MMIO
space' and returns 8 0xff bytes for both of this requests (I was testing
with qemu-traditional).

>
> Is it failing on a ballooned page in a RAM region? Or is mapping non-RAM
> regions as well?

I wasn't using ballooning, it happens that oldmem has several (two in my
test) pages which are HVMMEM_mmio_dm but qemu-dm considers them being
neither ram nor mmio.

>
>>> Fix the issue by mapping each non-ram page to the zero page. Keep direct
>>> path with remap_oldmem_pfn_range() to avoid looping through all pages on
>>> bare metal.
>>>
>>> The issue can also be solved by overriding remap_oldmem_pfn_range() in
>>> xen-specific code, as remap_oldmem_pfn_range() was been designed for.
>>> That, however, would involve non-obvious xen code path for all x86 builds
>>> with CONFIG_XEN_PVHVM=y and would prevent all other hypervisor-specific
>>> code on x86 arch from doing the same override.
>
> The oldmem_pfn_is_ram() is Xen-specific but this problem (ballooned
> pages) must be common to KVM.  How does KVM handle this?

Is far as I'm concearned the issue was never hit with KVM. I *think* the
issue has something to do with the conjunction of 16-byte 'movdqu'
emulation for io pages in xen hypervisor, 8-byte event channel requests
and qemu-traditional. But even if it gets fixed on hypervisor side I
believe fixing the issue kernel-side still worth it as there are
non-fixed hypervisors out there (e.g. AWS EC2).

>
> David

-- 
  Vitaly
