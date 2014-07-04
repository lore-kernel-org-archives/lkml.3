Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbaGDScO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:32:14 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:29808 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaGDScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:32:12 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ekfyrejs0ialTxoY/iPPu2PXDa3bE8LSg7
X-RZG-CLASS-ID: mo00
Message-ID: <53B6F30E.2000706@schoebel-theuer.de>
Date: Fri, 04 Jul 2014 20:31:42 +0200
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Selling Points for MARS Light
References: <53B6897F.6020802@schoebel-theuer.de> <CAFLxGvynFuCh0puda06kTH1P3i=701dQO-+opjLnQrd2KqUTHA@mail.gmail.com>
In-Reply-To: <CAFLxGvynFuCh0puda06kTH1P3i=701dQO-+opjLnQrd2KqUTHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are interested in the real low level design ideas. i.e. Why do you
need all syscalls exported?

OK, simple question, simple first-order answer, more complicated
second-order answer.

First-order answer:

Exporting all syscalls was a mistake made by me. It's not needed. Only a
handful is really needed. Of course, I am willing to correct my mistake.

A first-order fix for this is really simple. A second-order fix
(avoiding _any_ additional exports, or almost any) would get much more
complicated.

Second-order answer to the more detailed question behind your question:
why does tst need filesystem operations like *_symlink() or *_readlink()
at the low level?

I tried to explain the general high-level rationale behind the
architecture of MARS in the last part of my "marketing drone" appraisal
(which I also hated some years ago, but I had to learn how to produce
such an evil thing when changing from academia to the industry).

Detailed steps of the rationale, with some non-obvious intermediate steps:

Due to the enterprise-class dynamic shared store needed for masses of
backlog data (as explained in the last part of my former posting), I had
the low-level implementation choice of

a) just re-using existing filesystem technology for that, or

b) implementing my own filesystem-like dynamic store for that.

I also examined another potential alternative c), namely trying to use
LVM / DM for that. I looked at the concepts and some parts of the
interfaces, as well as of the implemention (all in a rather old kernel
as used in production!!!), and found some clashes at concept level, and
therefore got the impression that it could likely become very
cumbersome, so I precluded this potential alternative at a rather early
stage.

At that time, my office was next door to the IT operations system
architect, who became a friend of mine. So we were discussing many
political as well as detailed technical implementation problems in a
very small team (sometimes when drinking a beer together).

At that time, the rationale was to produce a POC (proof of concept)
ASAP, in order to aquire some resources for the emerging MARS project
internally. Around that time, we decided jointly to postpone all
"expensive" efforts to a later version called "MARS FULL" (originally
all in capital letters), and to try to get a quick-win called "MARS
LIGHT" ASAP.

Under that premise, it becomes immediately clear that a) had to be taken
for MARS Light, and whenever b) should turn out a better alternative
(which I think is quite possible), we decided to do it "later".

An additional advantage of a) is that ordinary sysadmin commands such as
"ls -l" can be used for inspection of the internal state of MARS, since
implementation of a key->value store this way has the low-level
advantage that you can easily experiment with it or even workaround some
bugs via "ln -s" and friends.

Not as an excuse, but please believe me that MARS originally started as
a strictly _internal_ 1&1 project, and it took quite a while until I got
the official permission from our CTO to publish it under GPL (before
that, I had to convince many other people). Until that point, we had no
official thoughts of ever going kernel upstream, probably besides some
drinking of beer in very small group ;)

Yes, well, life is not straightforward....   not only some letters were
lowercased, but the rollout of MARS Light to practice, as originally
planned, took much longer than expected (due to reasons which are out of
scope here).

In the meantime, MARS Light got into production in _another_ sysadmin
team as originally planned. They just took it, and it just worked for them.

Of course, that was fantastic for me in first order.

But a second-order consequence now is that any changes in low-level data
formats (such as replacing the symlinks by other formats such as files)
_must_ provide an upgrade path for them.

If I am not operating very carefully, this could become a problem in
future. I have to avoid any bigger forks between the out-of-tree and the
potential in-tree versions; at least I have to provide an easy and
robust upgrade path between them (probably in both directions).

In addition, I have to ensure that the timescale for parallel
maintainance of two major flavours is limited. If I did things which
would prolifer the version split ad infinitum, this would very likely
become a no-go for going upstream.

I hope you can understand that. In no way I want to put pressure on you.
It's just the diverging pressure I am trapped in.

Now, the discussion here showed up some painpoints for me (in my
subjective view).

In oder to try to resolve the complaints about the "symlink farms", I
could try to replace some operations, such as the symlink operations, by
file operations. But I am not sure whether this really helps. It just
complicates things.

Therefore I will continue trying to convince you whether we could
jointly find a solution for both sides, which both does not
unnecessarily violate the upstream rules, while not consuming too much
of my valuable manpower for maintaining both versions in a compatible
manner from a luser's perspective.

Now my posting got longer than intended. But I hope it could contribute
to a better mutual understanding.

Cheers,

yours sincerly Thomas

