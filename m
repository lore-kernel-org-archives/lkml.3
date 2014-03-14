Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbaCNUmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:42:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37266 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaCNUmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:42:36 -0400
Message-ID: <532369AF.8020406@oracle.com>
Date: Fri, 14 Mar 2014 16:42:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Bob Liu <lliubbo@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: kernel BUG at mm/huge_memory.c:2785!
References: <530F3F0A.5040304@oracle.com> <20140227150313.3BA27E0098@blue.fi.intel.com> <CAA_GA1c02iSmkmCLHFkrK4b4W+JppZ4CSMUJ-Wn1rCs-c=dV6g@mail.gmail.com> <53169FC5.4080006@oracle.com> <531921C0.3030904@oracle.com> <20140307121810.GA6740@node.dhcp.inet.fi>
In-Reply-To: <20140307121810.GA6740@node.dhcp.inet.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 07:18 AM, Kirill A. Shutemov wrote:
> On Thu, Mar 06, 2014 at 08:32:48PM -0500, Sasha Levin wrote:
>> On 03/04/2014 10:53 PM, Sasha Levin wrote:
>>> On 03/04/2014 10:16 PM, Bob Liu wrote:
>>>> On Thu, Feb 27, 2014 at 11:03 PM, Kirill A. Shutemov
>>>> <kirill.shutemov@linux.intel.com> wrote:
>>>>> Sasha Levin wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> While fuzzing with trinity inside a KVM tools guest running latest -next kernel I've stumbled on the
>>>>>> following spew:
>>>>>>
>>>>>> [ 1428.146261] kernel BUG at mm/huge_memory.c:2785!
>>>>>
>>>>> Hm, interesting.
>>>>>
>>>>> It seems we either failed to split huge page on vma split or it
>>>>> materialized from under us. I don't see how it can happen:
>>>>>
>>>>>    - it seems we do the right thing with vma_adjust_trans_huge() in
>>>>>      __split_vma();
>>>>>    - we hold ->mmap_sem all the way from vm_munmap(). At least I don't see
>>>>>      a place where we could drop it;
>>>>>
>>>>
>>>> Enable CONFIG_DEBUG_VM may show some useful information, at least we
>>>> can confirm weather rwsem_is_locked(&tlb->mm->mmap_sem) before
>>>> split_huge_page_pmd().
>>>
>>> I have CONFIG_DEBUG_VM enabled and that code you're talking is not triggering, so mmap_sem
>>> is locked.
>>
>> Guess what. I've just hit it.
>
> I think this particular traceback is not a real problem: by time of
> exit_mm() we shouldn't race with anybody for the mm_struct.
>
> We probably could drop ->mmap_sem later in mmput() rather then in
> exit_mm() to fix this false positive.
>
>> It's worth keeping in mind that this is the first time I see it.
>
> Hm. That's strange exit_mmap() is called without holding ->mmap_sem.
>

This issues does happen quite often and is very easy to reproduce, I could try
anything you can thing of.


Thanks,
Sasha
