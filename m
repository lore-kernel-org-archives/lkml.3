Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab3GPJkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:40:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50582 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3GPJkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:40:45 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51E5150C.3000905@jp.fujitsu.com>
Date: Tue, 16 Jul 2013 18:40:28 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: kexec@lists.infradead.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com> <1372707159-10425-4-git-send-email-holzheu@linux.vnet.ibm.com> <51DA4ED9.60903@jp.fujitsu.com> <20130708112839.498ccfc6@holzheu> <20130708142826.GA9094@redhat.com> <51DBA47C.8090708@jp.fujitsu.com> <20130710104252.479a0f92@holzheu> <51DD2E5A.1030200@jp.fujitsu.com> <20130710143309.GD5819@redhat.com> <51DFE2FB.2000804@jp.fujitsu.com> <20130715142059.GA23772@redhat.com> <51E49383.9030308@jp.fujitsu.com>
In-Reply-To: <51E49383.9030308@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/16 9:27), HATAYAMA Daisuke wrote:
> (2013/07/15 23:20), Vivek Goyal wrote:
>> On Fri, Jul 12, 2013 at 08:05:31PM +0900, HATAYAMA Daisuke wrote:
>>
>> [..]
>>> How about
>>>
>>> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>>> {
>>> ...
>>>          char *buf;
>>>          int rc;
>>>
>>> #ifndef CONFIG_S390
>>>          return VM_FAULT_SIGBUS;
>>> #endif
>>>          page = find_or_create_page(mapping, index, GFP_KERNEL);
>>>
>>> Considering again, I don't think WARN_ONCE() is good now. The fact that fault occurs on
>>> mmap() region indicates some kind of buggy situation occurs on the process. The process
>>> should be killed as soon as possible. If user still wants to get crash dump, he should
>>> try again in another process.
>>
>> I don't understand that. Process should be killed only if there was no
>> mapping created for the region process is trying to access.
>>
>> If there is a mapping but we are trying to fault in the actual contents,
>> then it is not a problem of process. Process is accessing a region of
>> memory which it is supposed to access.
>>
>> Potential problem here is that remap_pfn_range() did not map everything
>> it was expected to so we have to resort on page fault handler to read
>> that in. So it is more of a kernel issue and not process issue and for
>> that WARN_ONCE() sounds better?
>>
>
> On the current design, there's no page faults on memory mapped by remap_pfn_range().
> They map a whole range in the current design. If there are page faults, page table of the process
> is broken in their some page entries. This indicates the process's bahaviour is affected by
> some software/hardware bugs. In theory, process could result in arbitrary behaviour. We cannot
> detect the reason and recover the original sane state. The only thing we can do is to kill
> the process and drop the possibility of the process to affect other system components and of
> system to result in worse situation.
>

In summary, it seems that you two and I have different implementation
policy on how to deal with the process that is no longer in healthy state.

You two's idea is try to continue dump in non-healthy state as much as possible
as long as there is possibility of continuing it, while my idea kill the process
promptly and to retry crash dump in another new process since the process is no longer
in healthy state and could behave arbitrarily.

The logic in non-healthy states depends on implementation policy since there
is no obviously correct logic. I guess this discussion would not end soon.
I believe it is supposed that maintainer's idea should basically have high
priority over others. So I don't object anymore, though I don't think it best
at all.

-- 
Thanks.
HATAYAMA, Daisuke

