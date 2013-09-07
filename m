Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3IGA7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:59:12 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:45128 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IGA6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
	<1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
	<20130906210546.GW13318@ZenIV.linux.org.uk>
	<CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
	<20130907000044.GX13318@ZenIV.linux.org.uk>
	<CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
Date: Fri, 6 Sep 2013 17:58:51 -0700
X-Google-Sender-Auth: jze1Gihwpotc-S6zOp2MsCR11UE
Message-ID: <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 5:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> (We're bounded in practice by PATH_MAX, so you can't make getcwd()
> traverse more than about 2000 parents (single character filename plus
> the slash for each level), and for all I know filesystems might cap it
> before that, so it's not unbounded, but the difference between "1" and
> "2000" is pretty damn big)

.. in particular, it's big enough that one is pretty much guaranteed
to fit in any reasonable L1 cache (if we have dentry hash chains so
long that that becomes a problem for traversing a single chain, we're
screwed anyway), while the other can most likely be a case of "not a
single L1 cache hit because by the time you fail and go back to the
start, you've flushed the L1 cache".

Now, whether 2000 L2 cache misses is long enough to give people a
chance to run the whole rename system call path in a loop a few times,
I don't know, but it sure as heck sounds likely.

Of course, you might still ask "why should we even care?" At least
without preemption, you might be able to trigger some really excessive
latencies and possibly a watchdog screaming at you as a result. But
that said, maybe we wouldn't care. I just think that the solution is
so simple (what, five extra lines or so) that it's worth avoiding even
the worry.

          Linus
