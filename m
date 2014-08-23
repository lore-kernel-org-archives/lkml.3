Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaHXAQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 20:16:18 -0400
Received: from mta-out1.inet.fi ([62.71.2.232]:48024 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaHXAQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 20:16:17 -0400
Date: Sun, 24 Aug 2014 02:50:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Feiner <pfeiner@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/3] mm: softdirty: enable write notifications on VMAs
 after VM_SOFTDIRTY cleared
Message-ID: <20140823235058.GA27234@node.dhcp.inet.fi>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-2-git-send-email-pfeiner@google.com>
 <20140823230011.GA26483@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823230011.GA26483@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 02:00:11AM +0300, Kirill A. Shutemov wrote:
> On Sat, Aug 23, 2014 at 06:11:59PM -0400, Peter Feiner wrote:
> > For VMAs that don't want write notifications, PTEs created for read
> > faults have their write bit set. If the read fault happens after
> > VM_SOFTDIRTY is cleared, then the PTE's softdirty bit will remain
> > clear after subsequent writes.
> > 
> > Here's a simple code snippet to demonstrate the bug:
> > 
> >   char* m = mmap(NULL, getpagesize(), PROT_READ | PROT_WRITE,
> >                  MAP_ANONYMOUS | MAP_SHARED, -1, 0);
> >   system("echo 4 > /proc/$PPID/clear_refs"); /* clear VM_SOFTDIRTY */
> >   assert(*m == '\0');     /* new PTE allows write access */
> >   assert(!soft_dirty(x));
> >   *m = 'x';               /* should dirty the page */
> >   assert(soft_dirty(x));  /* fails */
> > 
> > With this patch, write notifications are enabled when VM_SOFTDIRTY is
> > cleared. Furthermore, to avoid faults, write notifications are
> > disabled when VM_SOFTDIRTY is reset.
> > 
> > Signed-off-by: Peter Feiner <pfeiner@google.com>

One more case to consider: mprotect() which doesn't trigger successful
vma_merge() will not set VM_SOFTDIRTY and will not enable write-protect on
the vma.

It's probably better to take VM_SOFTDIRTY into account in
vma_wants_writenotify() and re-think logic in other corners.

-- 
 Kirill A. Shutemov
