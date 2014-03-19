Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbaCSCHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:07:05 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60858 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879AbaCSCHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:07:02 -0400
Date: Tue, 18 Mar 2014 19:06:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bob Liu <bob.liu@oracle.com>, Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
In-Reply-To: <CA+55aFx0ZyCVrkosgTongBrNX6mJM4B8+QZQE1p0okk8ubbv7g@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1403181848380.3318@eggly.anvils>
References: <20140311045109.GB12551@redhat.com> <20140310220158.7e8b7f2a.akpm@linux-foundation.org> <20140311053017.GB14329@redhat.com> <20140311132024.GC32390@moon> <531F0E39.9020100@oracle.com> <20140311134158.GD32390@moon> <20140311142817.GA26517@redhat.com>
 <20140311143750.GE32390@moon> <20140311171045.GA4693@redhat.com> <20140311173603.GG32390@moon> <20140311173917.GB4693@redhat.com> <alpine.LSU.2.11.1403181703470.7055@eggly.anvils> <CA+55aFx0ZyCVrkosgTongBrNX6mJM4B8+QZQE1p0okk8ubbv7g@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Linus Torvalds wrote:
> On Tue, Mar 18, 2014 at 5:38 PM, Hugh Dickins <hughd@google.com> wrote:
> >
> > And yes, it is possible (though very unusual) to find an anon page or
> > swap entry in a VM_SHARED nonlinear mapping: coming from that horrid
> > get_user_pages(write, force) case which COWs even in a shared mapping.
> 
> Hmm. Maybe we could just disallow that forced case.
> 
> It *used* to be a trivial "we can just do a COW", but that was back
> when the VM was much simpler and we had no rmap's etc. So "that horrid
> case" used to be a simple hack that wasn't painful. But I suspect we
> could very easily just fail it instead of forcing a COW, if that would
> make it simpler for the VM code.

I'd love that, if we can get away with it now: depends very
much on whether we then turn out to break userspace or not.

If I remember correctly, it's been that way since early days,
in case ptrace were used to put a breakpoint into a MAP_SHARED
mapping of an executable: to prevent that modification from
reaching the file, if the file happened to be opened O_RDWR.
Usually it's not open for writing, and mapped MAP_PRIVATE anyway.

That is still something worth protecting against, I presume;
but I'd much rather do it by failing the awkward case,
than by perverting the VM to break its own rules.

If I'm not mistaken, Konstantin (who happens to be already on this
Cc list) had a patch (that I hated) to complicate things, to fix up
some of the inconsistencies arising from this very odd and overlooked
corner-case.  I think he'd prefer this simplification to his patch too.

I'll look into it further, but not in haste.

Hugh
