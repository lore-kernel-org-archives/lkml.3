Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaI3QWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 12:22:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaI3QWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 12:22:13 -0400
Date: Tue, 30 Sep 2014 12:22:01 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: pipe/page fault oddness.
Message-ID: <20140930162201.GC15903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Michel Lespinasse <walken@google.com>
References: <20140930033327.GA14558@redhat.com>
 <CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>
 <20140930043309.GA16196@redhat.com>
 <CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>
 <CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>
 <20140930160510.GA15903@redhat.com>
 <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 09:10:26AM -0700, Linus Torvalds wrote:
 > On Tue, Sep 30, 2014 at 9:05 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > I left it spinning overnight in case someone wanted me to probe it
 > > further, so I haven't tried reproducing it yet.  It took ~12 hours
 > > yesterday before it got in that state.  I'll restart it, and tell it
 > > to only use pipe fd's, which might speed things up a little.
 > 
 > Actually, if you haven't restarted it yet, do a few more "Sysrq-T"'s
 > to see if the stack below the page fault ever changes. Is it *always*
 > that "second access by fault_in_pages_writeable()" or migth there be
 > some looping going on in copy_page_to_iter() after all? (Quite
 > frankly, I don't see how such looping could happen with a good
 > compiler, and 4.8.3 should be good, but just in case).

Here's another snap of the same process..

trinity-c49     R  running task    12544 19464   7633 0x00080004
ffffffff910ac790 ffffffff91042e54 ffff8800a09bf9e8 00000064c0206056
0000000000000001 0000000008dd0d40 ffff8800a09bfaa0 ffff8800a13427e8
ffff8800a13427d0 ffff88010b017e00 0000000000000002 ffffffff910ac795
Call Trace:
[<ffffffff910cd401>] ? lock_acquired+0x1d1/0x3c0
[<ffffffff910d4885>] ? do_raw_spin_unlock+0x5/0x90
[<ffffffff910d4835>] ? do_raw_spin_trylock+0x5/0x50
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff918239f1>] ? _raw_spin_unlock+0x31/0x50
[<ffffffff911c3c67>] ? handle_mm_fault+0x3a7/0xcd0
[<ffffffff91042c84>] ? __do_page_fault+0x1a4/0x600
[<ffffffff9103ad23>] ? prepare_ftrace_return+0x73/0xe0
[<ffffffff91826b3a>] ? ftrace_graph_caller+0x5a/0x85
[<ffffffff910cb1ad>] ? trace_hardirqs_off+0xd/0x10
[<ffffffff918253e4>] ? retint_restore_args+0xe/0xe
[<ffffffff9118eda7>] ? context_tracking_user_exit+0x67/0x1b0
[<ffffffff910430fe>] ? do_page_fault+0x1e/0x70
[<ffffffff913a5ebe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff918264b2>] ? page_fault+0x22/0x30
[<ffffffff911bd7e3>] ? copy_page_to_iter+0x3b3/0x500
[<ffffffff9120eddf>] ? pipe_read+0xdf/0x330
[<ffffffff9120ed00>] ? pipe_write+0x490/0x490
[<ffffffff912051a0>] ? do_sync_readv_writev+0xa0/0xa0
[<ffffffff912053b8>] ? do_iter_readv_writev+0x78/0xc0
[<ffffffff91206bbe>] ? do_readv_writev+0xce/0x280
[<ffffffff9120ed00>] ? pipe_write+0x490/0x490
[<ffffffff910cbbf6>] ? lock_release_holdtime.part.29+0xe6/0x160
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff910ac8ab>] ? preempt_count_sub+0x6b/0xf0
[<ffffffff91206da9>] ? vfs_readv+0x39/0x50
[<ffffffff91206e6c>] ? SyS_readv+0x5c/0x100
[<ffffffff918249e4>] ? tracesys+0xdd/0xe2

and a few seconds later..

trinity-c49     R  running task    12544 19464   7633 0x00080004
ffff880235073840 ffff8800a09bf920 0000000000000046 ffff8800a09bf930
ffff8800a09bfa28 ffffffff910ac840 0000000000000000 ffff8800a09bf968
0000000000000000 00000000a8ef9693 ffff880244c203c0 00000000a8ef9693
Call Trace:
[<ffffffff910d4880>] ? do_raw_spin_trylock+0x50/0x50
[<ffffffff91167913>] ? trace_graph_entry+0x123/0x250
[<ffffffff9115b7ce>] ? trace_buffer_lock_reserve+0x1e/0x60
[<ffffffff911c3c67>] ? handle_mm_fault+0x3a7/0xcd0
[<ffffffff910ce68d>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff911678f8>] ? trace_graph_entry+0x108/0x250
[<ffffffff91042d14>] ? __do_page_fault+0x234/0x600
[<ffffffff9103ad23>] ? prepare_ftrace_return+0x73/0xe0
[<ffffffff910ca040>] ? down_write_nested+0xc0/0xc0
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff91042d14>] ? __do_page_fault+0x234/0x600
[<ffffffff9103ad23>] ? prepare_ftrace_return+0x73/0xe0
[<ffffffff91826b3a>] ? ftrace_graph_caller+0x5a/0x85
[<ffffffff913a5ebe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff9118eda7>] ? context_tracking_user_exit+0x67/0x1b0
[<ffffffff910430fe>] ? do_page_fault+0x1e/0x70
[<ffffffff913a5efd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[<ffffffff911bd7e3>] ? copy_page_to_iter+0x3b3/0x500
[<ffffffff9120eddf>] ? pipe_read+0xdf/0x330
[<ffffffff9120ed00>] ? pipe_write+0x490/0x490
[<ffffffff912051a0>] ? do_sync_readv_writev+0xa0/0xa0
[<ffffffff912053b8>] ? do_iter_readv_writev+0x78/0xc0
[<ffffffff91206bbe>] ? do_readv_writev+0xce/0x280
[<ffffffff9120ed00>] ? pipe_write+0x490/0x490
[<ffffffff910cbbf6>] ? lock_release_holdtime.part.29+0xe6/0x160
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff910ac74d>] ? get_parent_ip+0xd/0x50
[<ffffffff910ac8ab>] ? preempt_count_sub+0x6b/0xf0
[<ffffffff91206da9>] ? vfs_readv+0x39/0x50
[<ffffffff91206e6c>] ? SyS_readv+0x5c/0x100
[<ffffffff918249e4>] ? tracesys+0xdd/0xe2

That second one is odd, because I had disabled all the function tracing
before doing the sysrq-t, so still seeing all the ftrace stuff on the
stack suprised me.  Also puzzling is how every symbol in both cases
is '?'.


I've got to run to the dentist for an hour or so, so if you still have
more things you want me to test on this before I reboot, I'll put that
off until I get back.

	Dave

