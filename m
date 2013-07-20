Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3GTP1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 11:27:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3GTP1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 11:27:53 -0400
Date: Sat, 20 Jul 2013 17:22:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] mm: shift VM_GROWS* check from mmap_region() to
	do_mmap_pgoff()
Message-ID: <20130720152246.GA588@redhat.com>
References: <20130714165432.GA20828@redhat.com> <20130714165451.GA20847@redhat.com> <20130716144315.2a8e80479d9b4789df69fb91@linux-foundation.org> <alpine.LNX.2.00.1307191900390.986@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1307191900390.986@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This patch replaces the buggy

	mm-shift-vm_grows-check-from-mmap_region-to-do_mmap_pgoff.patch

I do not send the *-fix.patch because I'd like to update the changelog.

However it needs the explicit ack from Hugh.

On 07/19, Hugh Dickins wrote:
>
> On Tue, 16 Jul 2013, Andrew Morton wrote:
> > On Sun, 14 Jul 2013 18:54:51 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set.
> > > In particular this means that mmap_region()->vma_merge(file, vm_flags)
> > > must always fail if vm_flags & VM_GROWS.
>
> I didn't understand that sentence: if file is non-NULL perhaps?

Yes, this looks confusing, sorry.

I meant, vma_merge() must fail if "vm_flags & VM_GROWS" is set incorrectly.
is_mergeable_vma() compares both vm_file and vm_flags.

Even if file == NULL (at this stage), "VM_SHARED | VM_GROWS" is not correct
too, and vma_merge() can't succeed.

And, to clarify, I only mentioned this because I tried to convince myself
that this change (if correct) can't make any difference except "avoid the
not-really-correct do_munmap".

> > > So it does not make sense to
> > > check VM_GROWS* after we already allocated the new vma, the only caller,
> > > do_mmap_pgoff(), which can pass this flag can do the check itself.
> > >
> > > And this looks a bit more correct, mmap_region() already unmapped the
> > > old mapping at this stage. But if mmap() is going to fail, it should
> > > avoid do_munmap() if possible.
>
> I agree with the sentiment, but the patch looks wrong to me.

Heh. You are right of course.

> It did need staring, yes, but it looks NOK to me: this change permits
> mmap(addr, len, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_GROWSDOWN, fd, off)
> where fd is for a real file:

And note that "Only MAP_PRIVATE|MAP_ANONYMOUS can use MAP_GROWS" even
tries to document that "MAP_PRIVATE && file" is not allowed too.

I have no idea how I managed to forget that MAP_PRIVATE never sets
VM_MAYSHARE.

Thanks a lot Hugh.

Oleg.

