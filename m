Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaKZRhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:37:35 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:47732 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaKZRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:37:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141126143413.GA5876@redhat.com>
References: <20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
	<CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
	<5475596A.9010301@suse.com>
	<CA+55aFx1SiFBzmA=k9jHxi3cZE3Ei_+2NHepujgf86KEvkz8eQ@mail.gmail.com>
	<54756424.6020409@suse.com>
	<CA+55aFzVyTi_pR4y3=Z3y1bWkXbvgoJaykoyn0pUE7eTYgr+ZQ@mail.gmail.com>
	<CA+55aFzOSfdvgrkfiN=zZg4mSoot-tJQiVRh5ENW2-rzmLMy1w@mail.gmail.com>
	<20141126143413.GA5876@redhat.com>
Date: Wed, 26 Nov 2014 09:37:25 -0800
X-Google-Sender-Auth: lDPYb4EI_qLWaT7XOXtjtrgr11U
Message-ID: <CA+55aFwyKDicFjibkHmL2++guBRq=90nAijXUijsUQ4e60oodg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 6:34 AM, Dave Jones <davej@redhat.com> wrote:
>
> Woke up to the below trace. Looks like a different issue.

Yeah, apparently the Xen issue was really just a Xen bug.

> NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c149:24766]
> RIP: 0010:[<ffffffff8104658c>]  [<ffffffff8104658c>] kernel_map_pages+0xbc/0x120

Well, this one at least makes some amount of sense. The "Code:" line says it's

  1b: 9c                   pushfq
  1c: 5a                   pop    %rdx
  1d: fa                   cli
  1e: 0f 20 e0             mov    %cr4,%rax
  21: 48 89 c1             mov    %rax,%rcx
  24: 80 e1 7f             and    $0x7f,%cl
  27: 0f 22 e1             mov    %rcx,%cr4
  2a: 0f 22 e0             mov    %rax,%cr4
  2d: 52                   push   %rdx
  2e: 9d                   popfq
  2f:* eb cf                 jmp    back <-- trapping instruction

and %rdx is 0x0202 which is actually a valid flags value.

That looks like the code for __native_flush_tlb_global().

Not that interrupt should have been disabled very long.

> Call Trace:
>  [<ffffffff81185ebf>] get_page_from_freelist+0x49f/0xaa0
>  [<ffffffff811866ee>] __alloc_pages_nodemask+0x22e/0xb60
>  [<ffffffff811d093e>] alloc_pages_vma+0xee/0x1b0
>  [<ffffffff81194f0e>] shmem_alloc_page+0x6e/0xc0
>  [<ffffffff81197880>] shmem_getpage_gfp+0x4d0/0x7e0
>  [<ffffffff81197bd2>] shmem_write_begin+0x42/0x70
>  [<ffffffff8117c2d4>] generic_perform_write+0xd4/0x1f0
>  [<ffffffff8117eac2>] __generic_file_write_iter+0x162/0x350
>  [<ffffffff8117ecef>] generic_file_write_iter+0x3f/0xb0
>  [<ffffffff811f01b8>] do_iter_readv_writev+0x78/0xc0
>  [<ffffffff811f19e8>] do_readv_writev+0xd8/0x2a0
>  [<ffffffff811f1c3c>] vfs_writev+0x3c/0x50
>  [<ffffffff811f1dac>] SyS_writev+0x5c/0x100
>  [<ffffffff817e0249>] tracesys_phase2+0xd4/0xd9

Hmm. Maybe some oom issue, that we spent a long time before this
trying to free pages?

                  Linus
