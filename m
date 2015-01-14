Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbbANXv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:51:56 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:61342 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbANXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:51:54 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Calvin Owens <calvinowens@fb.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Organization: D03
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<87oaq1v49z.fsf@rasmusvillemoes.dk>
	<CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
	<87fvbdv2g3.fsf@rasmusvillemoes.dk>
	<20150114210326.GA25159@mail.thefacebook.com>
	<20150114144531.2564398d03c19fd48e4749d9@linux-foundation.org>
X-Hashcash: 1:20:150114:adobriyan@gmail.com::HrFZ/FI37A0+Nrrf:0000000000000000000000000000000000000000000aIw
X-Hashcash: 1:20:150114:akpm@linux-foundation.org::fQkJAdNXuoDcSCB/:00000000000000000000000000000000000006ce
X-Hashcash: 1:20:150114:viro@zeniv.linux.org.uk::kLrIvuwni3mKCQA4:0000000000000000000000000000000000000017B6
X-Hashcash: 1:20:150114:siddhesh.poyarekar@gmail.com::o+5hng6NVK+zdUGN:0000000000000000000000000000000001Qxg
X-Hashcash: 1:20:150114:grant.likely@secretlab.ca::K6HxJJ0gZ/ABMQF9:0000000000000000000000000000000000002EO9
X-Hashcash: 1:20:150114:kernel-team@fb.com::L31azH7Y2vevSk70:00000000000000000000000000000000000000000003RF4
X-Hashcash: 1:20:150114:calvinowens@fb.com::K//9QrfHenXQofz9:00000000000000000000000000000000000000000003vac
X-Hashcash: 1:20:150114:pfeiner@google.com::Lqc6bSSWxgkvv83u:00000000000000000000000000000000000000000004bNo
X-Hashcash: 1:20:150114:ebiederm@xmission.com::XP9J+8JqBqzk+Iyg:00000000000000000000000000000000000000005Ojo
X-Hashcash: 1:20:150114:kirill.shutemov@linux.intel.com::oDx2JwMKtAcOHk8z:0000000000000000000000000000006Fag
X-Hashcash: 1:20:150114:linux-kernel@vger.kernel.org::2puSux+30x/LXXtC:0000000000000000000000000000000007OEV
X-Hashcash: 1:20:150114:oleg@redhat.com::14OJSxDopHfL4ugE:009pTY
Date: Thu, 15 Jan 2015 00:51:50 +0100
In-Reply-To: <20150114144531.2564398d03c19fd48e4749d9@linux-foundation.org>
	(Andrew Morton's message of "Wed, 14 Jan 2015 14:45:31 -0800")
Message-ID: <87y4p4gbu1.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14 2015, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 14 Jan 2015 13:03:26 -0800 Calvin Owens <calvinowens@fb.com> wrote:
>> 
>> If I understand the current behavior, the "[stack]" marker will get put
>> next to *any* mapping that encompasses the current value in the task's
>> %sp, regardless of how the mapping was created or ucontext stuff. If
>> you use flags on the VMA structs things could potentially be marked as
>> stacks even though %sp points somewhere else.
>> 
>> It's probable that nobody cares (you'd obviously have to be doing crazy
>> things to be pointing %sp at arbitrary places), but that's why I was
>> hesitant to mess with it.
>
> Fixing the N^2 search would of course be much better than adding a new
> proc file to sidestep it.
>
> Could we do something like refreshing the new vma.vm_flags:VM_IS_STACK
> on each thread at the time when /proc/PID/maps is opened?  So do a walk
> of the threads, use each thread's sp to hunt down the thread's stack's
> vma, then set VM_IS_STACK and fill in the new vma.stack_tid field?

So this would be roughly #tasks*log(#vmas) + #vmas. Sounds
good. Especially since all the work will be done by the reader, so
there's no extra bookkeeping to do in sys_clone etc. Concurrent readers
could influence what each other end up seeing, but most of the time the
update will be idempotent, and the information may be stale anyway by
the time the reader has a chance to process it.

> There are still several flags unused in vma.vm_flags btw.
>
> I'm not sure that we can repurpose vm_pgoff (or vm_private_data) for
> this: a badly behaved thread could make its sp point at a random vma
> then trick the kernel into scribbling on that vma's vm_proff?

Well, we could still check vm_file for being NULL before writing to
vm_pgoff/vm_stack_tid. 

> Adding a new field to the vma wouldn't kill us, I guess.  That would
> remove the need for a VM_IS_STACK.

Either way, it seems that that decision can be changed later.

Rasmus
