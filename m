Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaILPWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:22:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:30961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaILPWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:22:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,513,1406617200"; 
   d="scan'208";a="572346926"
Message-ID: <54130F9A.3000406@intel.com>
Date: Fri, 12 Sep 2014 08:22:02 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409120950260.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 01:11 AM, Thomas Gleixner wrote:
> So what you are saying is, that if user space sets the pointer to NULL
> via the unregister prctl, kernel can safely ignore vmas which have the
> VM_MPX flag set. I really can't follow that logic.
>  
> 	mmap_mpx();
> 	prctl(enable mpx);
> 	do lots of crap which uses mpx;
> 	prctl(disable mpx);
> 
> So after that point the previous use of MPX is irrelevant, just
> because we set a pointer to NULL? Does it just look like crap because
> I do not get the big picture how all of this is supposed to work?

The prctl(register) is meant to be a signal from userspace to the kernel
to say, "I would like your help in managing these bounds tables".
prctl(unregister) is the opposite, meaning "I don't want your help any
more".

The kernel won't really ignore VM_MPX vmas, it just won't go looking for
them actively in response to the unmapping of other non-VM_MPX vmas.

>> Yes.  The only other way the kernel can possibly know that it needs to
>> go tearing things down is with a potentially frequent and expensive xsave.
>>
>> Either we change mmap to say "this mmap() is for a bounds directory", or
>> we have some other interface that says "the mmap() for the bounds
>> directory is at $foo".  We could also record the bounds directory the
>> first time that we catch userspace using it.  I'd rather have an
>> explicit interface than an implicit one like that, though I don't feel
>> that strongly about it.
> 
> I really have to disagree here. If I follow your logic then we would
> have a prctl for using floating point as well instead of catching the
> use and handle it from there. Just get it, if you make it simple for
> user space to do stupid things, they will happen in all provided ways
> and some more.

Here's what it boils down to:

If userspace uses a floating point register, it wants it saved.

If userspace uses MPX, it does not necessarily want the kernel to do
bounds table management all the time (or ever in some cases).  Without
the prctl(), the kernel has no way of distinguishing what userspace wants.

>>> The design to support this feature makes no sense at all to me. We
>>> have a special mmap interface, some magic kernel side mapping
>>> functionality and then on top of it a prctl telling the kernel to
>>> ignore/respect it.
>>
>> That's a good point.  We don't seem to have anything in the
>> allocate_bt() side of things to tell the kernel to refuse to create
>> things if the prctl() hasn't been called.  That needs to get added.
> 
> And then you need another bunch of logic in the prctl(disable mpx)
> path to cleanup the mess instead of just setting a random pointer to
> NULL.

The bounds tables potentially represent a *lot* of state.  If userspace
wants to temporarily turn off the kernel's MPX bounds table management,
it does not necessarily want that state destroyed.  On the other hand,
if userspace feels the need to go destroying all the state, it is free
to do so and does not need any help to do so from the kernel.

