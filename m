Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3GTCB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 22:01:58 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59636 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3GTCB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 22:01:56 -0400
Date: Fri, 19 Jul 2013 19:02:04 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: shift VM_GROWS* check from mmap_region() to
 do_mmap_pgoff()
In-Reply-To: <20130716144315.2a8e80479d9b4789df69fb91@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1307191900390.986@eggly.anvils>
References: <20130714165432.GA20828@redhat.com> <20130714165451.GA20847@redhat.com> <20130716144315.2a8e80479d9b4789df69fb91@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Andrew Morton wrote:
> On Sun, 14 Jul 2013 18:54:51 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > mmap() doesn't allow the non-anonymous mappings with VM_GROWS* bit set.
> > In particular this means that mmap_region()->vma_merge(file, vm_flags)
> > must always fail if vm_flags & VM_GROWS.

I didn't understand that sentence: if file is non-NULL perhaps?

> > So it does not make sense to
> > check VM_GROWS* after we already allocated the new vma, the only caller,
> > do_mmap_pgoff(), which can pass this flag can do the check itself.
> > 
> > And this looks a bit more correct, mmap_region() already unmapped the
> > old mapping at this stage. But if mmap() is going to fail, it should
> > avoid do_munmap() if possible.

I agree with the sentiment, but the patch looks wrong to me.

> > 
> > ...
> >
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1327,6 +1327,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
> >  		}
> >  	}
> >  
> > +	/* Only MAP_PRIVATE|MAP_ANONYMOUS can use MAP_GROWS */
> > +	if ((vm_flags & VM_MAYSHARE) && (vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
> 
> That is of course vm_flags&(VM_MAYSHARE|VM_GROWSDOWN|VM_GROWSUP),

Seems very plausible, but I believe you're wrong on that!

> but that perhaps is less clear.
> 
> > +		return -EINVAL;
> 
> I had to stare for a while but yes, the change looks OK to me.

It did need staring, yes, but it looks NOK to me: this change permits
mmap(addr, len, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_GROWSDOWN, fd, off)
where fd is for a real file: we never allowed MAP_GROWSDOWN on private
(or shared) mappings of real files before, and I think we should not now.

Hugh
