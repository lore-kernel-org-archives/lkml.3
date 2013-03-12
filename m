Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab3CLUvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:51:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35093 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532Ab3CLUvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:51:06 -0400
Date: Tue, 12 Mar 2013 20:51:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130312205101.GJ21522@ZenIV.linux.org.uk>
References: <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130310221047.GA21522@ZenIV.linux.org.uk>
 <20130311003530.GE21522@ZenIV.linux.org.uk>
 <CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
 <20130311180543.GF21522@ZenIV.linux.org.uk>
 <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 01:09:16PM -0700, Linus Torvalds wrote:
> On Tue, Mar 12, 2013 at 12:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Umm...  How about the following, then?  I think it makes the whole thing
> > simpler and saner...  NOTE: this got only a light beating and we'd
> > just seen an example of long-standing breakage in that area; I'd really
> > like to see it tortured by Dave's scripts before it gets merged into
> > mainline.
> 
> Looks ok to me.
> 
> But it's very hard to see the changes when they are joined by code
> movement, so either I'd almost like to see it split into two ("pure
> movement" followed by "clean up"),

FWIW, that delta came from git diff HEAD^^ ;-)  Internally, it's a couple
of commits; see vfs.git#pipe for details.

> or I'd like to feel a lot safer by
> having somebody beat on named pipes with some app that actually uses
> them.

Definitely.  Well, one such app is sysvinit, so aforementioned light beating
did include that to some extent, but it certainly needs more testing.

> They are rather seldom used, it's easy to break them and not
> even notice. For example, we have that whole "r/w_counter" logic that
> is subtle (and mis-documented, I notice). It's not a "count of
> readers/writers", it's a "*sequence* count of readers/writers having
> come in", and it's needed for the whole "oh, we're waiting for a
> writer, and one came in, but disappeared before we noticed, but we can
> see that it was there from the sequence number".

... and moreover, it's interacting with poll()/select().  I _think_ it's
OK (note that we only step into that thing when we open an extra descriptor
via /proc/<pid>/fd/<pipe_fd>), but...

> So the whole FIFO code is trivial from the standpoint of sharing all
> the IO code with pipes, but it's nontrivial in having some very
> specific semantics at open time, and it's seldom actually used, and
> easy to get wrong.
> 
> So anything like this needs to be either "obviously no semantic
> changes", or needs some real fifo testing.

Agreed.
