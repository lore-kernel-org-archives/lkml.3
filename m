Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3LBRFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:05:21 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53353 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LBRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:05:18 -0500
Date: Mon, 2 Dec 2013 18:05:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Ian Applegate <ia@cloudflare.com>,
        Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>
Subject: Re: Found it! (was Re: [3.10] Oopses in kmem_cache_allocate() via
 prepare_creds())
Message-ID: <20131202170514.GA29537@gmail.com>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <20131202162755.GB27781@gmail.com>
 <20131202164601.GF10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202164601.GF10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Dec 02, 2013 at 05:27:55PM +0100, Ingo Molnar wrote:
> 
> > It's not like there should be many (any?) VFS operations where a pipe 
> > is used via i_mutex and pipe->mutex in parallel, which would improve 
> > scalability - so I don't see the scalability advantage. (But I might 
> > be missing something)
> > 
> > Barring such kind of workload the extra mutex just adds extra 
> > micro-costs because now two locks have to be taken on 
> > creation/destruction, plus it adds extra complexity and races.
> > 
> > So unless I'm missing something obvious, another good fix would be to 
> > just revert pipe->mutex and rely on i_mutex as before?
> 
> You are missing the extra shitloads of complexity in ->i_mutex ordering,
> and ->i_mutex is already used for too many things...

Well, AFAICS the split-out did not reduce ordering complexity but 
increased it, at least in the short term: pipe->mutex now has to be 
taken in the right order with i_mutex, the subject of the bug here.

Plus AFAICS where i_mutex was used for pipe-internal purposes we used 
pretty generic facilities like user-copy, signal-sending, wakeups, 
etc. - none of which is really adding complexity to i_mutex ordering, 
as those are always expected to be facilities independent of the VFS 
in the future as well.

Anyway, it's your call obviously.

In any case, what prompted my reply was the overly terse nature of the 
changelog, would it make sense to put more verbose reasoning into 
changelogs, especially where such a change has a seemingly non-obvious 
(to me) cost/benefit balance?

Thanks,

	Ingo
