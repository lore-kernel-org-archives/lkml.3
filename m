Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaEODiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:38:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaEODit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:38:49 -0400
Date: Wed, 14 May 2014 20:38:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH v2 -next] x86,vdso: Fix an OOPS accessing the hpet
 mapping w/o an hpet
Message-Id: <20140514203859.8c82aa3a.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBC1E9x-zU-zJbNP+zbPgb=nhi39TqrxqpcGdi=OR9duXg@mail.gmail.com>
References: <c8b0a9a0b8d011a8b273cbb2de88d37190ed2751.1400111179.git.luto@amacapital.net>
	<CAJd=RBC1E9x-zU-zJbNP+zbPgb=nhi39TqrxqpcGdi=OR9duXg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 11:18:29 +0800 Hillf Danton <dhillf@gmail.com> wrote:

> > --- a/arch/x86/vdso/vma.c
> > +++ b/arch/x86/vdso/vma.c
> > @@ -90,6 +90,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
> >         struct vm_area_struct *vma;
> >         unsigned long addr;
> >         int ret = 0;
> > +       static struct page *no_pages[] = {NULL};
> >
> >         if (calculate_addr) {
> >                 addr = vdso_addr(current->mm->start_stack,
> > @@ -125,7 +126,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
> >                                        addr + image->size,
> >                                        image->sym_end_mapping - image->size,
> >                                        VM_READ,
> > -                                      NULL);
> > +                                      no_pages);
> >
> >         if (IS_ERR(vma)) {
> >                 ret = PTR_ERR(vma);
> > --
> > 1.9.0
> >
> As the comment says,
> /*
>  * Called with mm->mmap_sem held for writing.
>  * Insert a new vma covering the given region, with the given flags.
>  * Its pages are supplied by the given array of struct page *.
>  * The array can be shorter than len >> PAGE_SHIFT if it's null-terminated.
>  * The region past the last page supplied will always produce SIGBUS.
>  * The array pointer and the pages it points to are assumed to stay alive
>  * for as long as this mapping might exist.
>  */
> struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
>    unsigned long addr, unsigned long len,
>    unsigned long vm_flags, struct page **pages)
> {
> 
> we can send sigbus at fault time if no pages are supplied at install time.

Yes, but the way to communicate "no pages" is to pass (*pages)==NULL. 
Passing (pages)==NULL causes the code to oops at fault time.

We could easily change the interface so that pages==NULL means "no
pages" but that isn't the way it works at present.

