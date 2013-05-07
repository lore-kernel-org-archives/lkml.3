Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3EGKMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab3EGKL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:11:59 -0400
Date: Tue, 7 May 2013 13:11:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH RFC] x86: uaccess s/might_sleep/might_fault/
Message-ID: <20130507101141.GA15929@redhat.com>
References: <20130502022134.GA7700@redhat.com>
 <20130502085241.GA27969@gmail.com>
 <20130502132840.GA27322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502132840.GA27322@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:28:40PM +0300, Michael S. Tsirkin wrote:
> On Thu, May 02, 2013 at 10:52:41AM +0200, Ingo Molnar wrote:
> > 
> > * Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > > The only reason uaccess routines might sleep
> > > is if they fault. Make this explicit for
> > > __copy_from_user_nocache, and consistent with
> > > copy_from_user and friends.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > > 
> > > I've updated all other arches as well - still
> > > build-testing. Any objections to the x86 patch?
> > > 
> > >  arch/x86/include/asm/uaccess_64.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
> > > index 142810c..4f7923d 100644
> > > --- a/arch/x86/include/asm/uaccess_64.h
> > > +++ b/arch/x86/include/asm/uaccess_64.h
> > > @@ -235,7 +235,7 @@ extern long __copy_user_nocache(void *dst, const void __user *src,
> > >  static inline int
> > >  __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
> > >  {
> > > -	might_sleep();
> > > +	might_fault();
> > >  	return __copy_user_nocache(dst, src, size, 1);
> > 
> > Looks good to me:
> > 
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> > 
> > ... but while reviewing the effects I noticed a bug in might_fault():
> > 
> > #ifdef CONFIG_PROVE_LOCKING
> > void might_fault(void)
> > {
> >         /*
> >          * Some code (nfs/sunrpc) uses socket ops on kernel memory while
> >          * holding the mmap_sem, this is safe because kernel memory doesn't
> >          * get paged out, therefore we'll never actually fault, and the
> >          * below annotations will generate false positives.
> >          */
> >         if (segment_eq(get_fs(), KERNEL_DS))
> >                 return;
> > 
> >         might_sleep();
> > 
> > the might_sleep() call should come first. With the current code 
> > might_fault() schedules differently depending on CONFIG_PROVE_LOCKING, 
> > which is an undesired semantical side effect ...
> > 
> > So please fix that too while at it.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> 
> OK. And there's another bug that I'd like to fix:
> if caller does pagefault_disable, pagefaults don't
> actually sleep: the page fault handler will detect we are in
> tomic context and go directly to fixups instead of
> processing the page fault.
> 
> So calling anything that faults in atomic context is
> ok, and it should be
> 
> 	if (pagefault_disabled())
> 		might_sleep();

Hi Ingo,

Okay, so I thought the following will do the trick
for the code in include/linux/kernel.h :

#ifdef CONFIG_PROVE_LOCKING
void might_fault(void);
#elif CONFIG_DEBUG_ATOMIC_SLEEP
static inline void might_fault(void)
{
        might_sleep_if(!in_atomic());
}
#else
static inline void might_fault(void)
{
}
#endif

And similarly in mm/memory.c:
-	might_sleep();
+       might_sleep_if(!in_atomic());

Except in_atomic is not available in kernel.h - so will have to
make might_fault a macro from an inline, or move it to another header.

Any comments on this part?

Now if I do this, it becomes possible to do extend this to:

#ifdef CONFIG_PROVE_LOCKING
void might_fault(void);
#elif CONFIG_DEBUG_ATOMIC_SLEEP
static inline void might_fault(void)
{
        might_sleep_if(!in_atomic() && !segment_eq(get_fs(), KERNEL_DS));
}
#else
static inline void might_fault(void)
{
}
#endif

And this will address your comment?

Any early comments on the above?

Thanks,

> -- 
> MST
