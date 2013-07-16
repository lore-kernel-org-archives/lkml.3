Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab3GPDZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:25:17 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:54588 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GPDZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130716023847.GA31481@redhat.com>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
Date: Mon, 15 Jul 2013 20:25:14 -0700
X-Google-Sender-Auth: 7RxA8Lk9FmjIJ0b3h3zaeMX3whw
Message-ID: <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 7:38 PM, Dave Jones <davej@redhat.com> wrote:
>
>   The recent trinity changes shouldn't have really made
> any notable difference here.

Hmm. I'm not aware pf anything that has changed in this area since
3.10 - neither in execve, xfs or in splice. Not even since 3.9.

But I may certainly have missed something.

> Interestingly, the 'soft lockups' I was
> seeing all the time on that box seem to have gone into hiding.

Honestly, I'm somewhat inclined to blame the whole perf situation, and
saying that we hopefully got that fixed. In between the silly do_div()
buglets and all the indications that the time was spent in nmi
handlers, I'd be willing to just ignore them as false positives
brought on by the whole switch to the perf irq..

>  > Or is the XFS i_iolock required for this thing to happen at all?
>  > Adding Ben Myers to the cc just for luck/completeness.
>
> It is only happening (so far) on the XFS test box, but I don't have
> enough data to say that's definite yet.

.. so there's been a number of xfs changes, and I don't know the code,
but none of them seem at all relevant to this.

The "pipe -> cred_guard_mutex" lock chain is pretty direct, and can be
clearly attributed to splicing into /proc. Now, whether that is a
*good* idea or not is clearly debatable, and I do think that maybe we
should just not splice to/from proc files, but that doesn't seem to be
new, and I don't think it's necessarily *broken* per se, it's just
that splicing into /proc seems somewhat unnecessary, and various proc
files do end up taking locks that can be "interesting".

At the other end of the spectrum, the "cred_guard_mutex -> FS locks"
thing from execve() is also pretty clear, and probably not fixable or
necessarily something we'd even want to fix.

But the "FS locks -> pipe" part is a bit questionable. Honestly, I'd
be much happier if XFS used generic_file_splice_read/write().

And looking more at that, I'm actually starting to think this is an
XFS locking problem. XFS really should not call back to splice while
holding the inode lock.

But that XFS code doesn't seem new either. Is XFS a new thing for you
to test with?

Ben? Comments? I added the xfs list too now that I'm starting to
possibly blame XFS more actively..

                  Linus
