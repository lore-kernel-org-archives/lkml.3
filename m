Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab3CLUJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:09:18 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:38491 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3CLUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130312194353.GI21522@ZenIV.linux.org.uk>
References: <20130307223610.GA2494@redhat.com>
	<CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
	<20130308145306.GA24085@redhat.com>
	<CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
	<20130310221047.GA21522@ZenIV.linux.org.uk>
	<20130311003530.GE21522@ZenIV.linux.org.uk>
	<CA+55aFx+TAg+z9eWVm3EeAHQga3ai6YRFEb7rVQ++iNTn4NhGQ@mail.gmail.com>
	<20130311180543.GF21522@ZenIV.linux.org.uk>
	<20130312130614.GA32237@ZenIV.linux.org.uk>
	<CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
	<20130312194353.GI21522@ZenIV.linux.org.uk>
Date: Tue, 12 Mar 2013 13:09:16 -0700
X-Google-Sender-Auth: lxEwmj42xCPjGM2KajCW7sCaYl0
Message-ID: <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
Subject: Re: pipe_release oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 12:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Umm...  How about the following, then?  I think it makes the whole thing
> simpler and saner...  NOTE: this got only a light beating and we'd
> just seen an example of long-standing breakage in that area; I'd really
> like to see it tortured by Dave's scripts before it gets merged into
> mainline.

Looks ok to me.

But it's very hard to see the changes when they are joined by code
movement, so either I'd almost like to see it split into two ("pure
movement" followed by "clean up"), or I'd like to feel a lot safer by
having somebody beat on named pipes with some app that actually uses
them. They are rather seldom used, it's easy to break them and not
even notice. For example, we have that whole "r/w_counter" logic that
is subtle (and mis-documented, I notice). It's not a "count of
readers/writers", it's a "*sequence* count of readers/writers having
come in", and it's needed for the whole "oh, we're waiting for a
writer, and one came in, but disappeared before we noticed, but we can
see that it was there from the sequence number".

So the whole FIFO code is trivial from the standpoint of sharing all
the IO code with pipes, but it's nontrivial in having some very
specific semantics at open time, and it's seldom actually used, and
easy to get wrong.

So anything like this needs to be either "obviously no semantic
changes", or needs some real fifo testing.

           Linus
