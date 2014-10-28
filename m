Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaJ1F7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:59:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:41368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565AbaJ1F7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407084556"
Message-ID: <544F300B.7050002@intel.com>
Date: Tue, 28 Oct 2014 13:56:27 +0800
From: Ren Qiaowei <qiaowei.ren@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH v9 11/12] x86, mpx: cleanup unused bound tables
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-12-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241451280.5308@nanos> <544DB873.1010207@intel.com> <alpine.DEB.2.11.1410272138540.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410272138540.5308@nanos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 04:49 AM, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Ren Qiaowei wrote:
>> If so, I guess that there are some questions needed to be considered:
>>
>> 1) Almost all palces which call do_munmap() will need to add
>> mpx_pre_unmap/post_unmap calls, like vm_munmap(), mremap(), shmdt(), etc..
>
> What's the problem with that?
>

For example:

shmdt()
     down_write(mm->mmap_sem);
     vma = find_vma();
     while (vma)
         do_munmap();
     up_write(mm->mmap_sem);

We could not simply add mpx_pre_unmap() before do_munmap() or 
down_write(). And seems like it is a little hard for shmdt() to be 
changed to match this solution, right?

>> 2) before mpx_post_unmap() call, it is possible for those bounds tables within
>> mm->bd_remove_vmas to be re-used.
>>
>> In this case, userspace may do new mapping and access one address which will
>> cover one of those bounds tables. During this period, HW will check if one
>> bounds table exist, if yes one fault won't be produced.
>
> Errm. Before user space can use the bounds table for the new mapping
> it needs to add the entries, right? So:
>
> CPU 0					CPU 1
>
> down_write(mm->bd_sem);
> mpx_pre_unmap();
>     clear bounds directory entries	
> unmap();
> 					map()
> 					write_bounds_entry()
> 					trap()
> 					  down_read(mm->bd_sem);
> mpx_post_unmap();
> up_write(mm->bd_sem);
> 					  allocate_bounds_table();
>
> That's the whole point of bd_sem.
>

Yes. Got it.

>> 3) According to Dave, those bounds tables related to adjacent VMAs within the
>> start and the end possibly don't have to be fully unmmaped, and we only need
>> free the part of backing physical memory.
>
> Care to explain why that's a problem?
>

I guess you mean one new field mm->bd_remove_vmas should be added into 
staruct mm, right?

For those VMAs which we only need to free part of backing physical 
memory, we could not clear bounds directory entries and should also mark 
the range of backing physical memory within this vma. If so, maybe there 
are too many new fields which will be added into mm struct, right?

Thanks,
Qiaowei

