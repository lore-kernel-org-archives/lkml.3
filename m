Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3GJJuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:50:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33970 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab3GJJui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:50:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51DD2E5A.1030200@jp.fujitsu.com>
Date: Wed, 10 Jul 2013 18:50:18 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com> <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com> <51DA4ED9.60903@jp.fujitsu.com> <20130708112839.498ccfc6@holzheu> <20130708142826.GA9094@redhat.com> <51DBA47C.8090708@jp.fujitsu.com> <20130710104252.479a0f92@holzheu>
In-Reply-To: <20130710104252.479a0f92@holzheu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/10 17:42), Michael Holzheu wrote:
> Hello Hatayama,
>
> On Tue, 09 Jul 2013 14:49:48 +0900
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>
>> (2013/07/08 23:28), Vivek Goyal wrote:
>>> On Mon, Jul 08, 2013 at 11:28:39AM +0200, Michael Holzheu wrote:
>>>> On Mon, 08 Jul 2013 14:32:09 +0900
>>>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>
> [snip]
>
>>> I personally perfer not to special case it for s390 only and let the
>>> handler be generic.
>>>
>>> If there is a bug in remap_old_pfn_range(), only side affect is that
>>> we will fault in the page when it is accessed and that will be slow. BUG()
>>> sounds excessive. At max it could be WARN_ONCE().
>>>
>>> In regular cases for x86, this path should not even hit. So special casing
>>> it to detect issues with remap_old_pfn_range() does not sound very good
>>> to me. I would rather leave it as it is and if there are bugs and mmap()
>>> slows down, then somebody needs to debug it.
>>>
>>
>> I agree to WARN_ONCE(). Then, we can notice bug at least if it occurs.
>>
>> Interface is like this?
>>
>> [generic]
>>
>> bool __weak in_valid_fault_range(pgoff_t pgoff)
>> {
>>       return false;
>> }
>>
>> [s390]
>>
>> bool in_valid_fault_range(pgoff_t pgoff)
>> {
>>       loff_t offset = pgoff << PAGE_CACHE_SHIFT;
>>       u64 paddr = vmcore_offset_to_paddr(offset);
>>
>>       return paddr < ZFCPDUMP_HSA_SIZE;
>> }
>>
>> assuming vmcore_offset_to_paddr() that looks up vmcore_list and returns physical
>> address corresponding to given offset of vmcore. I guess this could return error
>> value if there's no entry corresponding to given offset in vmcore_list.
>
> I think this is too much code (and overhead) just for checking the correctness the
> kdump mmap implementation.
>
> My suggestion is to add the WARN_ONCE() for #ifndef CONFIG_S390. This has the same
> effect as your suggestion for all architectures besides of s390. And for s390 we
> take the risk that a programming error would result in poor /proc/vmcore
> performance.
>

If you want to avoid looking up vmcore_list that takes linear time w.r.t. the number
of the elements, you can still calculate the range of offsets in /proc/vmcore
corresponding to HSA during /proc/vmcore initialization.

Also, could you tell me how often and how much the HSA region is during crash dumping?
I guess the read to HSA is done mainly during early part of crash dumping process only.
According to the code, it appears at most 64MiB only. Then, I feel performance is not
a big issue.

Also, cost of WARN_ONCE() is one memory access only in the 2nd and later calls. I don't
think it too much overhead...

> So, at least for this patch series I would implement the fault handler as follows:
>
> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> {
> ...
>          char *buf;
>          int rc;
>
> #ifndef CONFIG_S390
>          WARN_ONCE(1, "vmcore: Unexpected call of mmap_vmcore_fault()");
> #endif
>          page = find_or_create_page(mapping, index, GFP_KERNEL);
>
> At this point I have to tell you that we plan another vmcore patch series where
> the fault handler might be called also for other architectures. But I think we
> should *then* discuss your issue again.
>

Could you explain the plan in more detail? Or I cannot review correctly since I don't
know whether there's really usecase of this generic fault handler for other
architectures. This is the issue for architectures other than s390, not mine; now we
don't need it at all.

-- 
Thanks.
HATAYAMA, Daisuke

