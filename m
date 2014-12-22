Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaLVTEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:04:40 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:45801 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaLVTEj (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 22 Dec 2014 14:04:39 -0500
Message-ID: <1419275072.8812.1.camel@stgolabs.net>
Subject: Re: mm: NULL ptr deref in unlink_file_vma
From: Davidlohr Bueso <dave@stgolabs.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Date: Mon, 22 Dec 2014 11:04:32 -0800
In-Reply-To: <20141222180420.GA20261@node.dhcp.inet.fi>
References: <549832E2.8060609@oracle.com>
	 <20141222180102.GA8072@node.dhcp.inet.fi>
	 <20141222180420.GA20261@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-22 at 20:04 +0200, Kirill A. Shutemov wrote:
> [ fixed Davidlohr's address. ]
> 
> On Mon, Dec 22, 2014 at 08:01:02PM +0200, Kirill A. Shutemov wrote:
> > On Mon, Dec 22, 2014 at 10:04:02AM -0500, Sasha Levin wrote:
> > > Hi all,
> > > 
> > > While fuzzing with trinity inside a KVM tools guest running the latest -next
> > > kernel, I've stumbled on the following spew:
> > > 
> > > [  432.376425] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
> > > [  432.378876] IP: down_write (./arch/x86/include/asm/rwsem.h:105 ./arch/x86/include/asm/rwsem.h:121 kernel/locking/rwsem.c:71)
> > 
> > Looks like vma->vm_file->mapping is NULL. Somebody freed ->vm_file from
> > under us?
> > 
> > I suspect Davidlohr's patchset on i_mmap_lock, but I cannot find any code
> > path which could lead to the crash.

Sasha, does this still occur if you revert c8475d144abb?

> > I've noticed one strange code path, which probably is not related to the
> > issue:
> > 
> > unmap_mapping_range()
> >   i_mmap_lock_read(mapping);
> >   unmap_mapping_range_tree()
> >     unmap_mapping_range_vma()
> >       zap_page_range_single()
> >         unmap_single_vma()
> > 	  if (unlikely(is_vm_hugetlb_page(vma))) {
> > 	    i_mmap_lock_write(vma->vm_file->f_mapping);

Right, this is would be completely bogus. But the deadlock cannot happen
in reality as hugetlb uses its own handlers and thus never calls
unmap_mapping_range.

Thanks,
Davidlohr

