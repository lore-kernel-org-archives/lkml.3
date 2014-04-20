Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaDTW21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 18:28:27 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:31602 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaDTW2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 18:28:25 -0400
Message-ID: <1398032896.19331.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 2/6] m68k: call find_vma with the mmap_sem held in
 sys_cacheflush()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, zeus@gnu.org,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>
Date: Sun, 20 Apr 2014 15:28:16 -0700
In-Reply-To: <CAMuHMdVBZSC3Kvwsw5pa-m8ZAUCjpkF8gjJH1XbOK2iFbU1KEg@mail.gmail.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
	 <1397960791-16320-3-git-send-email-davidlohr@hp.com>
	 <CAMuHMdVBZSC3Kvwsw5pa-m8ZAUCjpkF8gjJH1XbOK2iFbU1KEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-20 at 10:04 +0200, Geert Uytterhoeven wrote:
> Hi David,
> 
> On Sun, Apr 20, 2014 at 4:26 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> > Performing vma lookups without taking the mm->mmap_sem is asking
> > for trouble. While doing the search, the vma in question can be
> > modified or even removed before returning to the caller. Take the
> > lock (shared) in order to avoid races while iterating through
> > the vmacache and/or rbtree.
> 
> Thanks for your patch!
> 
> > This patch is completely *untested*.
> >
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: linux-m68k@lists.linux-m68k.org
> > ---
> >  arch/m68k/kernel/sys_m68k.c | 18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
> > index 3a480b3..d2263a0 100644
> > --- a/arch/m68k/kernel/sys_m68k.c
> > +++ b/arch/m68k/kernel/sys_m68k.c
> > @@ -376,7 +376,6 @@ cache_flush_060 (unsigned long addr, int scope, int cache, unsigned long len)
> >  asmlinkage int
> >  sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
> >  {
> > -       struct vm_area_struct *vma;
> >         int ret = -EINVAL;
> >
> >         if (scope < FLUSH_SCOPE_LINE || scope > FLUSH_SCOPE_ALL ||
> > @@ -389,16 +388,23 @@ sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
> >                 if (!capable(CAP_SYS_ADMIN))
> >                         goto out;
> >         } else {
> > +               struct vm_area_struct *vma;
> > +               bool invalid;
> > +
> > +               /* Check for overflow.  */
> > +               if (addr + len < addr)
> > +                       goto out;
> > +
> >                 /*
> >                  * Verify that the specified address region actually belongs
> >                  * to this process.
> >                  */
> > -               vma = find_vma (current->mm, addr);
> >                 ret = -EINVAL;
> > -               /* Check for overflow.  */
> > -               if (addr + len < addr)
> > -                       goto out;
> > -               if (vma == NULL || addr < vma->vm_start || addr + len > vma->vm_end)
> > +               down_read(&current->mm->mmap_sem);
> > +               vma = find_vma(current->mm, addr);
> > +               invalid = !vma || addr < vma->vm_start || addr + len > vma->vm_end;
> > +               up_read(&current->mm->mmap_sem);
> > +               if (invalid)
> >                         goto out;
> >         }
> 
> Shouldn't the up_read() be moved to the end of the function?
> The vma may still be modified or destroyed between the call to find_vma(),
> and the actual cache flush?

I don't think so. afaict the vma is only searched to check upon validity
for the address being passed. Once the sem is dropped, the call doesn't
do absolutely anything else with the returned vma.

Thanks,
Davidlohr

