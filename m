Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3GIFuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:50:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3GIFuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:50:02 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51DBA47C.8090708@jp.fujitsu.com>
Date: Tue, 09 Jul 2013 14:49:48 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, kexec@lists.infradead.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com> <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com> <51DA4ED9.60903@jp.fujitsu.com> <20130708112839.498ccfc6@holzheu> <20130708142826.GA9094@redhat.com>
In-Reply-To: <20130708142826.GA9094@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/08 23:28), Vivek Goyal wrote:
> On Mon, Jul 08, 2013 at 11:28:39AM +0200, Michael Holzheu wrote:
>> On Mon, 08 Jul 2013 14:32:09 +0900
>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>>
>>> (2013/07/02 4:32), Michael Holzheu wrote:
>>>> For zfcpdump we can't map the HSA storage because it is only available
>>>> via a read interface. Therefore, for the new vmcore mmap feature we have
>>>> introduce a new mechanism to create mappings on demand.
>>>>
>>>> This patch introduces a new architecture function remap_oldmem_pfn_range()
>>>> that should be used to create mappings with remap_pfn_range() for oldmem
>>>> areas that can be directly mapped. For zfcpdump this is everything besides
>>>> of the HSA memory. For the areas that are not mapped by remap_oldmem_pfn_range()
>>>> a generic vmcore a new generic vmcore fault handler mmap_vmcore_fault()
>>>> is called.
>>>>
>>>
>>> This fault handler is only for s390 specific issue. Other architectures don't need
>>> this for the time being.
>>>
>>> Also, from the same reason, I'm doing this review based on source code only.
>>> I cannot run the fault handler on meaningful system, which is currently s390 only.
>>
>> You can test the code on other architectures if you do not map anything in advance.
>> For example you could just "return 0" in remap_oldmem_pfn_range():
>>
>> /*
>>   * Architectures may override this function to map oldmem
>>   */
>> int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
>>                                    unsigned long from, unsigned long pfn,
>>                                    unsigned long size, pgprot_t prot)
>> {
>>          return 0;
>> }
>>
>> In that case for all pages the new mechanism would be used.
>>
>>>
>>> I'm also concerned about the fault handler covers a full range of vmcore, which
>>> could hide some kind of mmap() bug that results in page fault.
>>>
>>> So, the fault handler should be enclosed by ifdef CONFIG_S390 for the time being.
>>
>> I personally do not like that, but if Vivek and you prefer this, of course we
>> can do that.
>>
>> What about something like:
>>
>> #ifdef CONFIG_S390
>> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> {
>> ...
>> }
>> #else
>> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>> {
>> 	BUG();
>> }
>> #endif
>
> I personally perfer not to special case it for s390 only and let the
> handler be generic.
>
> If there is a bug in remap_old_pfn_range(), only side affect is that
> we will fault in the page when it is accessed and that will be slow. BUG()
> sounds excessive. At max it could be WARN_ONCE().
>
> In regular cases for x86, this path should not even hit. So special casing
> it to detect issues with remap_old_pfn_range() does not sound very good
> to me. I would rather leave it as it is and if there are bugs and mmap()
> slows down, then somebody needs to debug it.
>

I agree to WARN_ONCE(). Then, we can notice bug at least if it occurs.

Interface is like this?

[generic]

bool __weak in_valid_fault_range(pgoff_t pgoff)
{
     return false;
}

[s390]

bool in_valid_fault_range(pgoff_t pgoff)
{
     loff_t offset = pgoff << PAGE_CACHE_SHIFT;
     u64 paddr = vmcore_offset_to_paddr(offset);

     return paddr < ZFCPDUMP_HSA_SIZE;
}

assuming vmcore_offset_to_paddr() that looks up vmcore_list and returns physical
address corresponding to given offset of vmcore. I guess this could return error
value if there's no entry corresponding to given offset in vmcore_list.

-- 
Thanks.
HATAYAMA, Daisuke

