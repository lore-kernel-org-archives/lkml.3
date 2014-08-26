Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbaHZPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:18:17 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:33329 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaHZPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:18:16 -0400
Date: Tue, 26 Aug 2014 19:18:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH v5] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140826151813.GB8952@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408937681-1472-1-git-send-email-pfeiner@google.com>
 <alpine.LSU.2.11.1408252142380.2073@eggly.anvils>
 <20140826064952.GR25918@moon>
 <20140826140419.GA10625@node.dhcp.inet.fi>
 <20140826141914.GA8952@moon>
 <20140826145612.GA11226@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826145612.GA11226@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 05:56:12PM +0300, Kirill A. Shutemov wrote:
> > > 
> > > It seems safe in vma-softdirty context. But if somebody else will decide that
> > > it's fine to modify vm_flags without down_write (in their context), we
> > > will get trouble. Sasha will come with weird bug report one day ;)
> > > 
> > > At least vm_flags must be updated atomically to avoid race in middle of
> > > load-modify-store.
> > 
> > Which race you mean here? Two concurrent clear-refs?
> 
> Two concurent clear-refs is fine. But if somebody else will exploit the
> same approch to set/clear other VM_FOO and it will race with clear-refs
> we get trouble: some modifications can be lost.

yup, i see

> Basically, it's safe if only soft-dirty is allowed to modify vm_flags
> without down_write(). But why is soft-dirty so special?

because how we use this bit, i mean in normal workload this bit won't
be used intensively i think so it's not widespread in kernel code

> Should we consider moving protection of some vma fields under per-vma lock
> rather use over-loaded mmap_sem?

Hard to say, if vma-softdirty bit is the reason then I guess no, probably
it worth to estimate how much profit we would have if using per-vma lock.
