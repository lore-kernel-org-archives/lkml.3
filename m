Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3HYT52 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:57:28 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:43689 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab3HYT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130825033741.GX27005@ZenIV.linux.org.uk>
References: <20130822185317.GI31117@1wt.eu>
	<CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
	<CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
	<CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
	<CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
	<CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
	<20130823010726.GP27005@ZenIV.linux.org.uk>
	<20130825033741.GX27005@ZenIV.linux.org.uk>
Date: Sun, 25 Aug 2013 12:57:25 -0700
X-Google-Sender-Auth: jytpx4kyH1L1J1mtgBPGKE5rfgY
Message-ID: <CA+55aFxaKGcpdxKXK_axqyFz_oCvFm1Q=_fJLq8di97x_-cCig@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 8:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, I'm tempted to try the following trick:
>         * introduce FMODE_FLINK in file->f_mode; O_TMPFILE would set it,
> unless O_EXCL is present.
>         * introduce LOOKUP_LINK, to be passed by sys_linkat() when
> resolving the target.

[ .. snipped .. ]

Yes. I think we should do this, but I think we should also look at
what _other_ LOOKUP_xyz we should do for the /proc case.

For the read-only fd case, we should have a LOOKUP_WRITE flag, and
return -EPERM if an operation is a write, and we terminate in that
LAST_BIND case.

That would catch the truncate() case, but also the "open a read-only
fd for write or O_TRUNC" case.

Anything else? What other path operations matter that follow links
than truncate(), link() and open()?

                Linus
