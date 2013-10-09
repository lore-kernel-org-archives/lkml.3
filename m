Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3JIKF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:05:28 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36748 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3JIKF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <20131002223437.GA15728@redhat.com>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
	<CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
	<20131002185723.GA32614@redhat.com>
	<1380745082.12351.6.camel@pippen.local.home>
	<20131002223437.GA15728@redhat.com>
Date: Wed, 9 Oct 2013 14:05:26 +0400
Message-ID: <CAAeHK+wTs3THbh+EVoTm0wqQH8cg2VbT8aKYBX67A385+ohq0w@mail.gmail.com>
Subject: Re: Fwd: Potential out-of-bounds in ftrace_regex_release
From: Andrey Konovalov <andreyknvl@google.com>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrey Konovalov <andreyknvl@google.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com,
        Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got one more report of a similar bug:

AddressSanitizer: heap-buffer-overflow on address ffff8800205f0e40
Write of size 1 by thread T14005:
 [<ffffffff811e2542>] ftrace_event_write+0xe2/0x130
./kernel/trace/trace_events.c:583
 [<ffffffff8128c497>] vfs_write+0x127/0x2f0 ??:0
 [<ffffffff8128d572>] SyS_write+0x72/0xd0 ??:0
 [<ffffffff818423d2>] system_call_fastpath+0x16/0x1b
./arch/x86/kernel/entry_64.S:629

Allocated by thread T14005:
 [<     inlined    >] trace_parser_get_init+0x28/0x70 kmalloc
./include/linux/slab.h:413
 [<ffffffff811cc258>] trace_parser_get_init+0x28/0x70 ./kernel/trace/trace.c:759
 [<ffffffff811e24d2>] ftrace_event_write+0x72/0x130
./kernel/trace/trace_events.c:572
 [<ffffffff8128c497>] vfs_write+0x127/0x2f0 ??:0
 [<ffffffff8128d572>] SyS_write+0x72/0xd0 ??:0
 [<ffffffff818423d2>] system_call_fastpath+0x16/0x1b
./arch/x86/kernel/entry_64.S:629

The buggy address ffff8800205f0e40 is located 0 bytes to the right
 of 128-byte region [ffff8800205f0dc0, ffff8800205f0e40)

Memory state around the buggy address:
 ffff8800205f0900: rrrrrrrr rrrrrrrr rrrrrrrr rrrrrrrr
 ffff8800205f0a00: rrrrrrrr ........ ........ rrrrrrrr
 ffff8800205f0b00: rrrrrrrr rrrrrrrr rrrrrrrr rrrrrrrr
 ffff8800205f0c00: ........ .......5 rrrrrrrr rrrrrrrr
 ffff8800205f0d00: rrrrrrrr rrrrrrrr rrrrrrrr ........
>ffff8800205f0e00: ........ rrrrrrrr rrrrrrrr rrrrrrrr
                            ^
 ffff8800205f0f00: rrrrrrrr rrrrrrrr rrrrrrrr rrrrrrrr
 ffff8800205f1000: ........ ........ ........ ........
 ffff8800205f1100: ........ ........ ........ ........
 ffff8800205f1200: ........ ........ ........ ........
 ffff8800205f1300: ........ ........ ........ ........
Legend:
 f - 8 freed bytes
 r - 8 redzone bytes
 . - 8 allocated bytes
 x=1..7 - x allocated bytes + (8-x) redzone bytes

This time it was caused by 'parser.buffer[parser.idx] = 0;' in
'ftrace_event_write()', which calls 'trace_get_user()' right before
the bad assignment.

So I still think that the bug is in 'trage_get_user()':
Checking that 'parser->idx < parser->size - 1' is not performed in 'if
(isspace(ch))' section, so 'parser->idx' becomes equal to
'parser->size' after 'parser->buffer[parser->idx++] = ch;'.
(However in 'while (cnt && !isspace(ch))' loop checking is performed.)
