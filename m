Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbbANWpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:45:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbbANWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:45:33 -0500
Date: Wed, 14 Jan 2015 14:45:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Calvin Owens <calvinowens@fb.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-Id: <20150114144531.2564398d03c19fd48e4749d9@linux-foundation.org>
In-Reply-To: <20150114210326.GA25159@mail.thefacebook.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<87oaq1v49z.fsf@rasmusvillemoes.dk>
	<CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
	<87fvbdv2g3.fsf@rasmusvillemoes.dk>
	<20150114210326.GA25159@mail.thefacebook.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 13:03:26 -0800 Calvin Owens <calvinowens@fb.com> wrote:

> > Well, only when combined with checking vm_file for being NULL. One would
> > also need to ensure that vm_pgoff is 0 for any non-stack,
> > non-file-backed VMA. At which point it is somewhat ugly. 
> > 
> > > One problem with caching the value on clone like this though is that
> > > the stack could change due to a setcontext, but AFAICT we don't care
> > > about that for the process stack either.
> > 
> > If it is important, I guess one could update the info when a task calls
> > setcontext.
> 
> If I understand the current behavior, the "[stack]" marker will get put
> next to *any* mapping that encompasses the current value in the task's
> %sp, regardless of how the mapping was created or ucontext stuff. If
> you use flags on the VMA structs things could potentially be marked as
> stacks even though %sp points somewhere else.
> 
> It's probable that nobody cares (you'd obviously have to be doing crazy
> things to be pointing %sp at arbitrary places), but that's why I was
> hesitant to mess with it.

Fixing the N^2 search would of course be much better than adding a new
proc file to sidestep it.

Could we do something like refreshing the new vma.vm_flags:VM_IS_STACK
on each thread at the time when /proc/PID/maps is opened?  So do a walk
of the threads, use each thread's sp to hunt down the thread's stack's
vma, then set VM_IS_STACK and fill in the new vma.stack_tid field?

There are still several flags unused in vma.vm_flags btw.

I'm not sure that we can repurpose vm_pgoff (or vm_private_data) for
this: a badly behaved thread could make its sp point at a random vma
then trick the kernel into scribbling on that vma's vm_proff?  Adding a
new field to the vma wouldn't kill us, I guess.  That would remove the
need for a VM_IS_STACK.


