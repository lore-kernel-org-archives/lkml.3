Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaJFOPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaJFOPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:15:21 -0400
Date: Mon, 6 Oct 2014 16:14:28 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: qemu-devel@nongnu.org, KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\Dr. David Alan Gilbert\\" <dgilbert@redhat.com>,
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
Subject: Re: [PATCH 04/17] mm: gup: make get_user_pages_fast and
 __get_user_pages_fast latency conscious
Message-ID: <20141006141428.GU2342@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <1412356087-16115-5-git-send-email-aarcange@redhat.com>
 <CA+55aFyuYRuY9fiJQKL=XJ0-BKhGsZbo1HGkGUOJ6DbbxdA-dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyuYRuY9fiJQKL=XJ0-BKhGsZbo1HGkGUOJ6DbbxdA-dQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 03, 2014 at 11:23:53AM -0700, Linus Torvalds wrote:
> On Fri, Oct 3, 2014 at 10:07 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> > This teaches gup_fast and __gup_fast to re-enable irqs and
> > cond_resched() if possible every BATCH_PAGES.
> 
> This is disgusting.
> 
> Many (most?) __gup_fast() users just want a single page, and the
> stupid overhead of the multi-page version is already unnecessary.
> This just makes things much worse.
> 
> Quite frankly, we should make a single-page version of __gup_fast(),
> and convert existign users to use that. After that, the few multi-page
> users could have this extra latency control stuff.

Ok. I didn't think at a better way to add the latency control other
than to reduce nr_pages in a outer loop instead of altering the inner
calls, but this is what I got after implementing it... If somebody has
a cleaner way to implement the latency control stuff that's welcome
and I'd be glad to replace it.

> And yes, the single-page version of get_user_pages_fast() is actually
> latency-critical. shared futexes hit it hard, and yes, I've seen this
> in profiles.

KVM would save a few cycles from a single-page version too. I just
thought further optimizations could be added later and this was better
than nothing.

Considering I've no better idea how to implement the latency control
stuff, for now I'll just drop this controversial patch, and I'll
convert those get_user_pages to gup_unlocked instead of converting
them to gup_fast, which is more than enough to obtain the mmap_sem
holding scalability improvement (that also solves the mmap_sem trouble
for the userfaultfd). gup_unlocked isn't as good as gup_fast but it's
at least better than the current get_user_pages().

I got into this gup_fast latency control stuff purely because there
were a few get_user_pages that could have been converted to
get_user_pages_fast as they were using "current" and "current->mm" as the
first two parameters, except for the risk of disabling irq for
long. So I tried to do the right thing and fix gup_fast but I'll leave
this further optimization queued for later.

About the missing commit header for the other patch Paolo already
replied to it, to clarify this a bit further in short I expect that
FOLL_TRIED flag to be merged through the KVM git tree which already
contains it. I'll add a comment to the commit header to specify
it. Sorry for the confusion about that patch.

Thanks,
Andrea
