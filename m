Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaLET3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:29:07 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:52994 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLET3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:29:06 -0500
MIME-Version: 1.0
In-Reply-To: <1417806247.4845.1@mail.thefacebook.com>
References: <547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
Date: Fri, 5 Dec 2014 11:29:05 -0800
X-Google-Sender-Auth: EG9Mr2hw3_x3id_ITZ1PkHgnPY8
Message-ID: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Mason <clm@fb.com>
Cc: Dave Jones <davej@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 11:04 AM, Chris Mason <clm@fb.com> wrote:
>
> So one idea is that our allocation/freeing of pages is dramatically more
> expensive and we're hitting a strange edge condition.  Maybe we're even
> faulting on a readonly page from a horrible place?

Well, various allocators have definitely shown up a lot.
DEBUG_PAGEALLOC does horrible things to performance, though, and the
kernel will just spend a *lot* of time in memory allocators when it is
on. So it might just be "yeah, the traces show allocations a lot, but
that might just be because allocation is slow". The last one showed
slub debugging - getting a call trace for the allocation.

> [83246.925234] end_request: I/O error, dev sda, sector 0
>
> Ext3/4 shouldn't be doing IO to sector zero.  Something is stomping on ram?

I'd buy memory corruption through wild pointers as the reason, but
quite frankly, that tends to have completely different failure modes.
Not NMI watchdogs.

So it must be some very particular corruption. I still vote for "let's
see if Dave can narrow it down with bisection".

                 Linus
