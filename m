Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481AbaH0XPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:15:08 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50296 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbaH0XOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:14:23 -0400
Date: Wed, 27 Aug 2014 16:12:43 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
In-Reply-To: <20140826155351.GC8952@moon>
Message-ID: <alpine.LSU.2.11.1408271512090.7961@eggly.anvils>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com> <1408937681-1472-1-git-send-email-pfeiner@google.com> <alpine.LSU.2.11.1408252142380.2073@eggly.anvils> <20140826064952.GR25918@moon> <20140826140419.GA10625@node.dhcp.inet.fi>
 <20140826141914.GA8952@moon> <20140826145612.GA11226@node.dhcp.inet.fi> <20140826151813.GB8952@moon> <20140826154355.GA11464@node.dhcp.inet.fi> <20140826155351.GC8952@moon>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Cyrill Gorcunov wrote:
> On Tue, Aug 26, 2014 at 06:43:55PM +0300, Kirill A. Shutemov wrote:
> > On Tue, Aug 26, 2014 at 07:18:13PM +0400, Cyrill Gorcunov wrote:
> > > > Basically, it's safe if only soft-dirty is allowed to modify vm_flags
> > > > without down_write(). But why is soft-dirty so special?
> > > 
> > > because how we use this bit, i mean in normal workload this bit won't
> > > be used intensively i think so it's not widespread in kernel code
> > 
> > Weak argument to me.

Yes.  However rarely it's modified, we don't want any chance of it
corrupting another flag.

VM_SOFTDIRTY is special in the sense that it's maintained in a very
different way from the other VM_flags.  If we had a little alignment
padding space somewhere in struct vm_area_struct, I think I'd jump at
Kirill's suggestion to move it out of vm_flags and into a new field:
that would remove some other special casing, like the vma merge issue.

But I don't think we have such padding space, and we'd prefer not to
bloat struct vm_area_struct for it; so maybe it should stay for now.
Besides, with Peter's patch, we're also talking about the locking on
modifications to vm_page_prot, aren't we?

> > 
> > What about walk through vmas twice: first with down_write() to modify
> > vm_flags and vm_page_prot, then downgrade_write() and do
> > walk_page_range() on every vma?
> 
> I still it's undeeded,

Yes, so long as nothing else is doing the same.
No bug yet, that we can see, but a bug in waiting.

> but for sure using write-lock/downgrade won't hurt,
> so no argues from my side.

Yes, Kirill's two-stage suggestion seems the best:

down_write
quickly scan vmas clearing VM_SOFT_DIRTY and updating vm_page_prot
downgrade_write (or up_write, down_read?)
slowly walk page tables write protecting and clearing soft-dirty on ptes
up_read

But please don't mistake me for someone who has a good grasp of
soft-dirty: I don't.

Hugh
