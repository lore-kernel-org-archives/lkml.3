Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbaGOXsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439AbaGOXso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:48:44 -0400
Date: Wed, 16 Jul 2014 07:48:35 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, qiuxishi@huawei.com,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH v2] not adding modules range to kcore if it's equal to
 vmcore range
Message-ID: <20140715234835.GA2297@dhcp-17-102.nay.redhat.com>
References: <1405212144-2725-1-git-send-email-bhe@redhat.com>
 <20140713010546.GA2832@dhcp-17-102.nay.redhat.com>
 <20140715151600.b561ab770b5b0f9a2200b49f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715151600.b561ab770b5b0f9a2200b49f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 at 03:16pm, Andrew Morton wrote:
> On Sun, 13 Jul 2014 09:05:46 +0800 Baoquan He <bhe@redhat.com> wrote:
> 
> > On some ARCHs modules range is eauql to vmalloc range. E.g on i686
> > "#define MODULES_VADDR   VMALLOC_START"
> > "#define MODULES_END     VMALLOC_END"
> > This will cause 2 duplicate program segments in /proc/kcore, makes
> > user confused. In this patch a judgment added to check if modules
> > range is equal to vmalloc range. If yes, just skip adding the modules
> > range.
> > 
> > ...
> >
> > --- a/fs/proc/kcore.c
> > +++ b/fs/proc/kcore.c
> > @@ -610,8 +610,10 @@ static void __init proc_kcore_text_init(void)
> >  struct kcore_list kcore_modules;
> >  static void __init add_modules_range(void)
> >  {
> > -	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> > -			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> > +	if (MODULES_VADDR != VMALLOC_START) {
> > +		kclist_add(&kcore_modules, (void *)MODULES_VADDR,
> > +				MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
> > +	}
> >  }
> >  #else
> >  static void __init add_modules_range(void)
> 
> But if some application or script is using the modules range, won't
> this patch cause breakage on some architectures?

Hi Andrew,

Thanks for your review and comments.

Since in this situation the modules range and the vmalloc range are
the same, and from the print of /proc/kcore you can't differentiate
them, I guess people may not care it.

Unless people assume the range after vmalloc is modules range in script.
But if someone did this, his/her program is not carefully considered.
Entries of kcore are not fixed, E.g in x86-64 kcore_vsyscall exists
while it doesn't exist in i686. AFAIK, usually people use address range
to judge what area it is, E.g in makedumpfile, one user space utility
of kdump, below function is used to check the type of virtual address in
x86-64.

int                                                                                                               
is_vmalloc_addr(ulong vaddr)                                                                                      
{                                                                                                                 
        /*                                                                                                        
         *  vmalloc, virtual memmap, and module space as VMALLOC space.                                           
         */                                                                                                       
        return ((vaddr >= VMALLOC_START && vaddr <= VMALLOC_END)                                                  
            || (vaddr >= VMEMMAP_START && vaddr <= VMEMMAP_END)                                                   
            || (vaddr >= MODULES_VADDR && vaddr <= MODULES_END));                                                 
}

In i686, the code is 

int
is_vmalloc_addr_x86(unsigned long vaddr)
{
        return (info->vmalloc_start && vaddr >= info->vmalloc_start);
}

So I think people should check entries of kcore by range it spans,
not which line the entry could be in. When I tried to read /proc/kcore,
I was confused why the same line comes up twice. It could be better to
remove the confusion, from my personal opinion.

Thanks
Baoquan


> 
