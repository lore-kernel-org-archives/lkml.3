Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaFPWYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaFPWYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:24:45 -0400
Date: Tue, 17 Jun 2014 00:24:09 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] Volatile Ranges (v14 - madvise reborn edition!)
Message-ID: <20140616222409.GA27291@redhat.com>
References: <1398806483-19122-1-git-send-email-john.stultz@linaro.org>
 <536BBB08.3000503@linaro.org>
 <20140603145710.GQ2878@cmpxchg.org>
 <CALAqxLXBs0scEEb7-rYbq9vHHs8VWUg-9vFXDoK4mzUt4smbYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLXBs0scEEb7-rYbq9vHHs8VWUg-9vFXDoK4mzUt4smbYw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

On Mon, Jun 16, 2014 at 01:12:41PM -0700, John Stultz wrote:
> On Tue, Jun 3, 2014 at 7:57 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > That, however, truly is a separate virtual memory feature.  Would it
> > be possible for you to take MADV_FREE and MADV_REVIVE as a base and
> > implement an madvise op that switches the no-page behavior of a VMA
> > from zero-filling to SIGBUS delivery?
> 
> I'll see if I can look into it if I get some time. However, I suspect
> its more likely I'll just have to admit defeat on this one and let
> someone else champion the effort. Interest and reviews have seemingly
> dropped again here and with other work ramping up, I'm not sure if
> I'll be able to justify further work on this. :(

About adding an madvise op that switches the no-page behavior from
zero-filling to SIGBUS delivery (right now only for anonymous vmas but
we can evaluate to extend it) I've mostly completed the
userfaultfd/madvise(MADV_USERFAULT) according to the design I
described earlier. Like we discussed earlier that may fit the bill if
extended to tmpfs? The first preliminary tests just passed last week.

http://git.kernel.org/cgit/linux/kernel/git/andrea/aa.git/?h=userfault

If userfaultfd() isn't instantiated by the process, it only sends a
SIBGUS to the thread accessing the unmapped virtual address
(handle_mm_faults returns VM_FAULT_SIGBUS). The address of the fault
is then available in siginfo->si_addr.

You strictly need a memory externalization thread opening the
userfaultfd and speaking the userfaultfd protocol only if you need to
access the memory also through syscalls or drivers doing GUP
calls. This allows memory mapped in a secondary MMU for example to be
externalized without a single change to the secondary MMU code. The
userfault becomes invisible to
handle_mm_fault/gup()/gup_fast/FOLL_NOWAIT etc.... The only
requirement is that the memory externalization thread never accesses
any memory in the MADV_USERFAULT marked regions (and if it does
because of a bug, the deadlock should be quite apparent by simply
checking the stack trace of the externalization thread blocked in
handle_userfault(), sigkill will then clear it up :). If you close the
userfaultfd the SIGBUS behavior will immediately return for the
MADV_USERFAULT marked regions and any hung task waiting to be waken
will get an immediate SIGBUS.
