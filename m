Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3LJXY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:24:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35120 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3LJXYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:24:55 -0500
Date: Tue, 10 Dec 2013 23:24:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210232449.GP10323@ZenIV.linux.org.uk>
References: <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:42:15PM +0100, Thomas Gleixner wrote:
>         /*
>          * If write access is not required (eg. FUTEX_WAIT), try
>          * and get read-only access.
>          */
>         if (err == -EFAULT && rw == VERIFY_READ) {
>                 err = get_user_pages_fast(address, 1, 0, &page);
> 
> That's a legitimate use case. And futex_requeue only requests
> VERIFY_READ for the !requeue_pi case.
> 
> Now, if that map is RO, i.e. we took the fallback path then the THP
> one will fail as it has write=1 unconditionally.

access_ok() has nothing whatsoever to do with RO vs. RW mappings.
It checks whether the address is OK for userland on architectures
with userland and kernel sharing the same address space (e.g. x86).
On something like e.g. sparc64 or s390 it's constant 1.

Note that there's nothing to stop another thread from remapping an RW
area RO just as you've returned from access_ok(), so checking for
writability in access_ok() would've been racy as hell.  Ditto for
address being mapped at all...

Moreover, there are exactly two architectures that do not ignore the
first argument of access_ok() - microblaze and um.  The former uses
it in debugging printk in failure case.  The latter... AFAICS, it's
pointless - it's a special dispensation for read access to host
vsyscall page from guest process.  The thing is, writes there are
going to fail anyway - host kernel won't let the guest kernel to
modify that page, period.  IOW, it looks like um might as well drop
the (type == VERIFY_READ) part in __access_ok_vsyscall().

Why do we have the 'type' argument of access_ok(), anyway?
