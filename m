Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaATRZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:25:55 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34424 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752803AbaATRZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:25:52 -0500
Date: Mon, 20 Jan 2014 11:26:09 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCHv2 1/2] Add mm flag to control THP
Message-ID: <20140120172609.GC18196@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <20140118234134.GA10970@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140118234134.GA10970@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 19, 2014 at 01:41:34AM +0200, Kirill A. Shutemov wrote:
> On Thu, Jan 16, 2014 at 03:01:43PM -0600, Alex Thorlton wrote:
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 91672e2..475f59f 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -1,6 +1,8 @@
> >  #ifndef _LINUX_HUGE_MM_H
> >  #define _LINUX_HUGE_MM_H
> >  
> > +#include <linux/sched.h>
> > +
> 
> Hm, now <linux/mm.h> depends on <linux/sched.h>. It doesn't look as a good
> idea.
> 
> Why do we have MMF_* defines in <linux/sched.h>?
> Wouldn't it more appropriate to put them in <linux/mm_types.h>?

I'm not sure about that.  I just placed my definitions where everything
else was defined.  It might make more sense to have these in
mm_types.h, though that's a separate effort.  For now, I don't think I
have a choice but to include sched.h here, but it does seem to make
sense that I should be able to see the defined mm flags from huge_mm.h,
without having to include sched.h.  I'm sure there are other places where
this applies as well.

> >  extern int do_huge_pmd_anonymous_page(struct mm_struct *mm,
> >  				      struct vm_area_struct *vma,
> >  				      unsigned long address, pmd_t *pmd,
> > @@ -74,7 +76,8 @@ extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
> >  	   (1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG) &&			\
> >  	   ((__vma)->vm_flags & VM_HUGEPAGE))) &&			\
> >  	 !((__vma)->vm_flags & VM_NOHUGEPAGE) &&			\
> > -	 !is_vma_temporary_stack(__vma))
> > +	 !is_vma_temporary_stack(__vma) &&				\
> > +	 !test_bit(MMF_THP_DISABLE, &(__vma)->vm_mm->flags))
> >  #define transparent_hugepage_defrag(__vma)				\
> >  	((transparent_hugepage_flags &					\
> >  	  (1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)) ||			\
> > @@ -227,7 +230,6 @@ static inline int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_str
> >  {
> >  	return 0;
> >  }
> > -
> >  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >  
> >  #endif /* _LINUX_HUGE_MM_H */
> 
> Why?

Are you asking about the line I removed there?  That was probably an
accident.  I'll fix that

- Alex
