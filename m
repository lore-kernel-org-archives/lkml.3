Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab3ETUXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab3ETUXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:23:34 -0400
Date: Mon, 20 May 2013 16:23:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on CPU
 due to 09a9f1d27
Message-ID: <20130520202328.GG2739@redhat.com>
References: <CANN689GKfxM3R96wgY8-+FftpVT76zMFcHdgKccNKnjHGfYq1Q@mail.gmail.com>
 <20130415163552.GA31868@redhat.com>
 <20130415173424.GB31868@redhat.com>
 <20130415175929.GB30583@redhat.com>
 <20130415191304.GC30583@redhat.com>
 <alpine.LNX.2.00.1304151425540.1030@eggly.anvils>
 <20130416002123.GA29465@google.com>
 <alpine.LNX.2.00.1304151825270.1376@eggly.anvils>
 <CANN689EcqDg0xp+74SoQJYQMecU4z-WWdA+7FtM3Sc_R-uK=sg@mail.gmail.com>
 <20130429132952.GA8204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429132952.GA8204@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 09:29:52AM -0400, Vivek Goyal wrote:
> On Mon, Apr 29, 2013 at 01:57:18AM -0700, Michel Lespinasse wrote:
> > On Mon, Apr 15, 2013 at 6:27 PM, Hugh Dickins <hughd@google.com> wrote:
> > > On Mon, 15 Apr 2013, Michel Lespinasse wrote:
> > >> sys_brk() passes the length as the difference of two page aligned addresses, so it's fine. But vm_brk() doesn't - it calls do_brk() which page aligns the length, but then vm_brk passes the unaligned length to mm_populate().
> > >>
> > >> What do you think of the following ? len is already a PAGE_SIZE multiple when called from sys_brk()...
> > >
> > > Yes, that's good.
> > >>
> > >> diff --git a/mm/mmap.c b/mm/mmap.c
> > >> index 0db0de1c2fbe..6af8b0d1c7db 100644
> > >> --- a/mm/mmap.c
> > >> +++ b/mm/mmap.c
> > >> @@ -2557,10 +2557,6 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
> > >>       pgoff_t pgoff = addr >> PAGE_SHIFT;
> > >>       int error;
> > >>
> > >> -     len = PAGE_ALIGN(len);
> > >> -     if (!len)
> > >> -             return addr;
> > >> -
> > >>       flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
> > >>
> > >>       error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
> > >> @@ -2643,6 +2639,10 @@ unsigned long vm_brk(unsigned long addr, unsigned long len)
> > >>       unsigned long ret;
> > >>       bool populate;
> > >>
> > >> +     len = PAGE_ALIGN(len);
> > >> +     if (!len)
> > >> +             return addr;
> > >> +
> > >>       down_write(&mm->mmap_sem);
> > >>       ret = do_brk(addr, len);
> > >>       populate = ((mm->def_flags & VM_LOCKED) != 0);
> > 
> > Vivek - what should I do with this change ? Do you want to take it as
> > part of your series, or should I push to Linus/Andrew ?
> > 
> > All vm_brk calls are in elf and aout loaders, so I don' t think we can
> > hit the issue without your changes. Still, it may be good to make
> > vm_brk robust anyway.
> 
> Hi Michel,
> 
> Thanks for the fix. Sorry, could not respond earlier as I was away from
> work.
> 
> This patch did fix the issue for me. I think it is a good idea to push
> this fix to Andrew irrespective of my changes. My series is in RFC phase
> and there are no guarantees whether patches will be accespected or not.
> 
> So please go ahead and send this fix to andrew for inclusion. 

Hi Michel,

So are you planning to push this patch upstream?

Vivek
