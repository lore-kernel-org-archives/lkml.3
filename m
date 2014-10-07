Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaJGQN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:13:27 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:40036 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaJGQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:13:24 -0400
Date: Tue, 7 Oct 2014 09:13:20 -0700
From: Peter Feiner <pfeiner@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 10/17] mm: rmap preparation for remap_anon_pages
Message-ID: <20141007161320.GA17858@google.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-11-git-send-email-aarcange@redhat.com>
 <CA+55aFx++R42L75ooE=Fmaem73=V=q7f6pYTcALxgrA1y98G-A@mail.gmail.com>
 <20141006085540.GD2336@work-vm>
 <20141006164156.GA31075@redhat.com>
 <CA+55aFxAOYBny+QwXfkPy-P3rs-RPr5SLYLcPNBiFO3waBXtQA@mail.gmail.com>
 <20141007141913.GC2342@redhat.com>
 <20141007155247.GD2342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007155247.GD2342@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:52:47PM +0200, Andrea Arcangeli wrote:
> I probably grossly overestimated the benefits of resolving the
> userfault with a zerocopy page move, sorry. [...]

For posterity, I think it's worth noting that most expensive aspect of a TLB
shootdown is the interprocessor interrupt necessary to flush other CPUs' TLBs.
On a many-core machine, copying 4K of data looks pretty cheap compared to
taking an interrupt and invalidating TLBs on many cores :-)

> [...] So if we entirely drop the
> zerocopy behavior and the TLB flush of the old page like you
> suggested, the way to keep the userfaultfd mechanism decoupled from
> the userfault resolution mechanism would be to implement an
> atomic-copy syscall. That would work for SIGBUS userfaults too without
> requiring a pseudofd then. It would be enough then to call
> mcopy_atomic(userfault_addr,tmp_addr,len) with the only constraints
> that len must be a multiple of PAGE_SIZE. Of course mcopy_atomic
> wouldn't page fault or call GUP into the destination address (it can't
> otherwise the in-flight partial copy would be visible to the process,
> breaking the atomicity of the copy), but it would fill in the
> pte/trans_huge_pmd with the same strict behavior that remap_anon_pages
> currently has (in turn it would by design bypass the VM_USERFAULT
> check and be ideal for resolving userfaults).
> 
> mcopy_atomic could then be also extended to tmpfs and it would work
> without requiring the source page to be a tmpfs page too without
> having to convert page types on the fly.
> 
> If I add mcopy_atomic, the patch in subject (10/17) can be dropped of
> course so it'd be even less intrusive than the current
> remap_anon_pages and it would require zero TLB flush during its
> runtime (it would just require an atomic copy).

I like this new approach. It will be good to have a single interface for
resolving anon and tmpfs userfaults.

> So should I try to embed a mcopy_atomic inside userfault_write or can
> I expose it to userland as a standalone new syscall? Or should I do
> something different? Comments?

One interesting (ab)use of userfault_write would be that the faulting process
and the fault-handling process could be different, which would be necessary
for post-copy live migration in CRIU (http://criu.org).

Aside from the asthetic difference, I can't think of any advantage in favor of
a syscall.

Peter
