Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaLRCn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:43:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26507 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLRCn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:43:26 -0500
Message-ID: <54923F1F.7040301@oracle.com>
Date: Wed, 17 Dec 2014 21:42:39 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
References: <20141211145408.GB16800@redhat.com>	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>	<20141212185454.GB4716@redhat.com>	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>	<20141213165915.GA12756@redhat.com>	<20141213223616.GA22559@redhat.com>	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>	<20141214234654.GA396@redhat.com>	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>	<20141215055707.GA26225@redhat.com>	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com> <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
In-Reply-To: <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 06:46 PM, Linus Torvalds wrote:
> I cleaned up the patch a bit, split it up into two to clarify it, and
> have committed it to my tree. I'm not marking the patches for stable,
> because while I'm convinced it's a bug, I'm also not sure why even if
> it triggers it doesn't eventually recover when the IO completes. So
> I'd mark them for stable only if they are actually confirmed to fix
> anything in the wild, and after they've gotten some testing in
> general. The patches *look* straightforward, they remove more lines
> than they add, and I think the code is more understandable too, but
> maybe I just screwed up. Whatever. Some care is warranted, but this is
> the first time I feel like I actually fixed something that matched at
> least one of your lockup symptoms.
> 
> Anyway, it's there as
> 
>   26178ec11ef3 ("x86: mm: consolidate VM_FAULT_RETRY handling")
>   7fb08eca4527 ("x86: mm: move mmap_sem unlock from mm_fault_error() to caller")

I guess you did "just screwed up"...

I've started seeing this:

[  240.190061] BUG: unable to handle kernel paging request at 00007f341768b000
[  240.190061] IP: [<00007f341baf61fb>] 0x7f341baf61fb
[  240.190061] PGD 12b3e4067 PUD 12b3e5067 PMD 29a700067 PTE 0
[  240.190061] Oops: 0004 [#10] PREEMPT SMP
[  240.190061] Dumping ftrace buffer:
[  240.190061]    (ftrace buffer empty)
[  240.190061] Modules linked in:
[  240.190061] CPU: 6 PID: 9691 Comm: trinity-c619 Tainted: G      D        3.18.0-sasha-08443-g2b40f4a #1618
[  240.190061] task: ffff88012b346000 ti: ffff88012b3d4000 task.ti: ffff88012b3d4000
[  240.190061] RIP: 0033:[<00007f341baf61fb>]  [<00007f341baf61fb>] 0x7f341baf61fb
[  240.190061] RSP: 002b:00007fff39f045f8  EFLAGS: 00010206
[  240.190061] RAX: 00007fff39f04600 RBX: 0000000000000363 RCX: 0000000000000200
[  240.190061] RDX: 0000000000001000 RSI: 00007f341768b000 RDI: 00007fff39f04600
[  240.190061] RBP: 00007fff39f05640 R08: 00007f341bdf20a8 R09: 00007f341bdf2100
[  240.190061] R10: 0000000000000000 R11: 0000000000001000 R12: 0000000000001000
[  240.190061] R13: 0000000000001000 R14: 0000000000362000 R15: 00007fff39f04600
[  240.190061] FS:  00007f341bffb700(0000) GS:ffff8802da400000(0000) knlGS:0000000000000000
[  240.190061] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  240.190061] CR2: 00007f341894801c CR3: 000000012b364000 CR4: 00000000000006a0
[  240.190061] DR0: ffffffff81000000 DR1: 0000000000000000 DR2: 0000000000000000
[  240.190061] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000b0602
[  240.190061]
[  240.190061] RIP  [<00007f341baf61fb>] 0x7f341baf61fb
[  240.190061]  RSP <00007fff39f045f8>
[  240.190061] CR2: 00007f341768b000

Which was bisected down to:

	26178ec11ef3 ("x86: mm: consolidate VM_FAULT_RETRY handling")


Thanks,
Sasha
