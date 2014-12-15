Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaLOXqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:46:43 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58338 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaLOXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:46:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
References: <20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
Date: Mon, 15 Dec 2014 15:46:41 -0800
X-Google-Sender-Auth: nMLlx-GaqOJ-Ma_7Z6YbsWdnG74
Message-ID: <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:21 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So let's just fix it. Here's a completely untested patch.

So after looking at this more, I'm actually really convinced that this
was a pretty nasty bug.

I'm *not* convinced that it's necessarily *your* bug, but I still
think it could be.

I cleaned up the patch a bit, split it up into two to clarify it, and
have committed it to my tree. I'm not marking the patches for stable,
because while I'm convinced it's a bug, I'm also not sure why even if
it triggers it doesn't eventually recover when the IO completes. So
I'd mark them for stable only if they are actually confirmed to fix
anything in the wild, and after they've gotten some testing in
general. The patches *look* straightforward, they remove more lines
than they add, and I think the code is more understandable too, but
maybe I just screwed up. Whatever. Some care is warranted, but this is
the first time I feel like I actually fixed something that matched at
least one of your lockup symptoms.

Anyway, it's there as

  26178ec11ef3 ("x86: mm: consolidate VM_FAULT_RETRY handling")
  7fb08eca4527 ("x86: mm: move mmap_sem unlock from mm_fault_error() to caller")

and I'll continue to look at the page fault patch. I still have a
slight worry that it's something along the lines of corrupted page
tables or some core VM issue, but I apart from my general nervousness
about the auto-numa code (which will be cleaned up eventually though
the pte_protnone patches), I can't actually see how you'd get into
endless page faults any other way. So I'm really hoping that the buggy
VM_FAULT_RETRY handling explains it.

But me not seeing any other bug clearly doesn't mean it doesn't exist.

                    Linus
