Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaHPBaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 21:30:05 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39657 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaHPBaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 21:30:03 -0400
Date: Fri, 15 Aug 2014 18:28:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davidlohr Bueso <davidlohr@hp.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Robert Richter <rric@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH] mm: introduce for_each_vma helpers
In-Reply-To: <20140813140800.df0310a05e5fad6ed6b55886@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.1408151818100.10115@eggly.anvils>
References: <1407865523.2633.3.camel@buesod1.americas.hpqcorp.net> <20140812215213.GB17497@node.dhcp.inet.fi> <1407887208.2695.9.camel@buesod1.americas.hpqcorp.net> <20140813140800.df0310a05e5fad6ed6b55886@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Andrew Morton wrote:
> On Tue, 12 Aug 2014 16:46:48 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> > On Wed, 2014-08-13 at 00:52 +0300, Kirill A. Shutemov wrote:
> > > On Tue, Aug 12, 2014 at 10:45:23AM -0700, Davidlohr Bueso wrote:
> > > > The most common way of iterating through the list of vmas, is via:
> > > >     for (vma = mm->mmap; vma; vma = vma->vm_next)
> > > > 
> > > > This patch replaces this logic with a new for_each_vma(vma) helper,
> > > > which 1) encapsulates this logic, and 2) make it easier to read.
> > > 
> > > Why does it need to be encapsulated?
> > > Do you have problem with reading plain for()?
> > > 
> > > Your for_each_vma(vma) assumes "mm" from the scope. This can be confusing
> > > for reader: whether it uses "mm" from the scope or "current->mm". This
> > > will lead to very hard to find bug one day.
> > 
> > I think its fairly obvious to see where the mm is coming from -- the
> > helpers *do not* necessarily use current, it uses whatever mm was
> > already there in the first place. I have not changed anything related to
> > this from the callers. 
> 
> It is a bit of a hand-grenade for those (rare) situations where code is
> dealing with other-tasks-mm.  It's simple enough to add an `mm' arg?
> 
> > The only related change I can think of, is for some callers that do:
> > 
> > for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next)
> > 
> > So we just add a local mm from current->mm and replace the for() with
> > for_each_vma(). I don't see anything particularly ambiguous with that.
> 
> Adding a local to support a macro which secretly uses that local is
> pretty nasty.
> 
> 
> Overall, I'm not really sure that
> 
> -	for (vma = mm->mmap; vma; vma = vma->vm_next) {
> +	for_each_vma(mm, vma) {
> 
> is much of an improvement.  I'll wait to see what others think...

... I'm with Kirill: obscuring a simple for loop is unhelpful -
unless it's a prelude to a grand enhancement under the hood?

As to the hidden mm argument: a momentary lapse of taste, I hope.

Hugh
