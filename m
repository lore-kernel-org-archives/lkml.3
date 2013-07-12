Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab3GLQD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:03:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57245 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3GLQDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:03:25 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51E028AA.7070203@jp.fujitsu.com>
Date: Sat, 13 Jul 2013 01:02:50 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: kexec@lists.infradead.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com> <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com> <51DA4ED9.60903@jp.fujitsu.com> <20130708112839.498ccfc6@holzheu> <20130708142826.GA9094@redhat.com> <51DBA47C.8090708@jp.fujitsu.com> <20130710104252.479a0f92@holzheu> <51DD2E5A.1030200@jp.fujitsu.com> <20130710130017.468e0bdf@holzheu>
In-Reply-To: <20130710130017.468e0bdf@holzheu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/10 20:00), Michael Holzheu wrote:
> On Wed, 10 Jul 2013 18:50:18 +0900
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>
> [snip]
>
>> (2013/07/10 17:42), Michael Holzheu wrote:
>>> My suggestion is to add the WARN_ONCE() for #ifndef CONFIG_S390. This has the same
>>> effect as your suggestion for all architectures besides of s390. And for s390 we
>>> take the risk that a programming error would result in poor /proc/vmcore
>>> performance.
>>>
>>
>> If you want to avoid looking up vmcore_list that takes linear time w.r.t. the number
>> of the elements, you can still calculate the range of offsets in /proc/vmcore
>> corresponding to HSA during /proc/vmcore initialization.
>>
>> Also, could you tell me how often and how much the HSA region is during crash dumping?
>> I guess the read to HSA is done mainly during early part of crash dumping process only.
>> According to the code, it appears at most 64MiB only. Then, I feel performance is not
>> a big issue.
>
> Currently it is 32 MiB and normally it is read only once.
>
>>
>> Also, cost of WARN_ONCE() is one memory access only in the 2nd and later calls. I don't
>> think it too much overhead...
>
> I was more concerned about in_valid_fault_range(). But I was most concerned the additional
> interface that introduces more complexity to the code. And that just to implement a
> sanity check that in our opinion we don't really need.
>
> And what makes it even worse:
>

What you think the sanity check is unnecessary is perfectly wrong. You design page faults
always happens on HSA region. If page fault happens on the other parts, i.e. some point
of mmap()ed region, it means somehow page table on the address has not been created. This
is bug, possibly caused by mmap() itself, page table creation, other components in kernel,
bit-flip due to broken hardware, etc. Anyway, program cannot detect what kind of bug occurs
now. There's no guarantee that program runs safely, of course for page cache creation, too.
We cannot and must expect such buggy process to behave in invalid states just as our design.
It results in undefined behaviour. The only thing we can do is to kill the buggy process
as soon as possible.

> With the current patch series this check is only relevant for s390 :-)
>
>>
>>> So, at least for this patch series I would implement the fault handler as follows:
>>>
>>> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>>> {
>>> ...
>>>           char *buf;
>>>           int rc;
>>>
>>> #ifndef CONFIG_S390
>>>           WARN_ONCE(1, "vmcore: Unexpected call of mmap_vmcore_fault()");
>>> #endif
>>>           page = find_or_create_page(mapping, index, GFP_KERNEL);
>>>
>>> At this point I have to tell you that we plan another vmcore patch series where
>>> the fault handler might be called also for other architectures. But I think we
>>> should *then* discuss your issue again.
>>>
>>
>> Could you explain the plan in more detail? Or I cannot review correctly since I don't
>> know whether there's really usecase of this generic fault handler for other
>> architectures.
>> This is the issue for architectures other than s390, not mine; now we
>> don't need it at all.
>
> I would have preferred to do the things one after the other. Otherwise I fear
> that this discussion will never come to an end. This patch series is needed
> to get zfcpdump running with /proc/vmcore. And for that reason the patch series
> makes sense for itself.
>
> But FYI:
>
> The other patch series deals with the problem that we have additional
> information for s390 that we want to include in /proc/vmcore. We have a one
> byte storage key per memory page. This storage keys are stored in the
> s390 firmware and can be read using a s390 specific machine instruction.
> We plan to put that information into the ELF notes section. For a 1 TiB
> dump we will have 256 MiB storage keys.
>
> Currently the notes section is preallocated in vmcore.c. Because we do
> not want to preallocate so much memory we would like to read the notes
> section on demand. Similar to the HSA memory for zfcpdump. To get this
> work with your mmap code, we would then also use the fault handler to
> get the notes sections on demand. Our current patch does this for all
> notes and therefore also the other architectures would then use the
> fault handler.
>
> One advantage for the common code is that no additional memory has
> to be allocated for the notes buffer.
>
> The storage key patch series is currently not final because it depends
> on the zfcpdump patch series.
>

Yes, on-demand memory allocation by fault handler is definitely suitable
for note sections throughout all architectures. But need of sanity check
is unchanged here. The issue is orthogonal. It's still needed just as
explained above.

BTW, sanity check for note sections is easy.

         if (!(elfnote->p_offset <= offset ||
               offset < elfnote->p_offset + elfnote->p_filesz))
             return VM_FAULT_SIGBUS;

I assume elfnote has a pointer to a unique PT_NOTE program header table
in the ELF header buffer. The code would be the same on every
architecture.

-- 
Thanks.
HATAYAMA, Daisuke

