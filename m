Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaILOhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:37:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:60922 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaILOhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:37:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,513,1406617200"; 
   d="scan'208";a="572326045"
Message-ID: <5413050A.1090307@intel.com>
Date: Fri, 12 Sep 2014 07:36:58 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos> <alpine.DEB.2.10.1409121120440.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409121120440.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 02:24 AM, Thomas Gleixner wrote:
> On Fri, 12 Sep 2014, Thomas Gleixner wrote:
>> On Thu, 11 Sep 2014, Dave Hansen wrote:
>>> Well, we use it to figure out whether we _potentially_ need to tear down
>>> an VM_MPX-flagged area.  There's no guarantee that there will be one.
>>
>> So what you are saying is, that if user space sets the pointer to NULL
>> via the unregister prctl, kernel can safely ignore vmas which have the
>> VM_MPX flag set. I really can't follow that logic.
>>  
>> 	mmap_mpx();
>> 	prctl(enable mpx);
>> 	do lots of crap which uses mpx;
>> 	prctl(disable mpx);
>>
>> So after that point the previous use of MPX is irrelevant, just
>> because we set a pointer to NULL? Does it just look like crap because
>> I do not get the big picture how all of this is supposed to work?
> 
> do_bounds() will happily map new BTs no matter whether the prctl was
> invoked or not. So what's the value of the prctl at all?

The behavior as it stands is wrong.  We should at least have the kernel
refuse to map new BTs if the prctl() hasn't been issued.  We'll fix it up.

> The mapping is flagged VM_MPX. Why is this not sufficient?

The comment is confusing and only speaks to half of what the if() in
question is doing.  We'll get a better comment in there.  But, for the
sake of explaining it fully:

There are two mappings in play:
1. The mapping with the actual data, which userspace is munmap()ing or
   brk()ing away, etc... (never tagged VM_MPX)
2. The mapping for the bounds table *backing* the data (is tagged with
   VM_MPX)

The code ends up looking like this:

vm_munmap()
{
	do_unmap(vma); // #1 above
	if (mm->bd_addr && !(vma->vm_flags & VM_MPX))
		// lookup the backing vma (#2 above)
		vm_munmap(vma2)
}

The bd_addr check is intended to say "could the kernel have possibly
created some VM_MPX vmas?"  As you noted above, we will happily go
creating VM_MPX vmas without mm->bd_addr being set.  That's will get fixed.

The VM_MPX _flags_ check on the VMA is there simply to prevent
recursion.  vm_munmap() of the VM_MPX vma is called _under_ vm_munmap()
of the data VMA, and we've got to ensure it doesn't recurse.  *This*
part of the if() in question is not addressed in the comment.  That's
something we can fix up in the next version.
