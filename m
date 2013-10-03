Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3JCSXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:23:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43387 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3JCSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:23:14 -0400
Date: Thu, 3 Oct 2013 19:23:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
Message-ID: <20131003182311.GI13318@ZenIV.linux.org.uk>
References: <20131003163411.GA17101@www.outflux.net>
 <20131003175824.GH13318@ZenIV.linux.org.uk>
 <CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:03:07AM -0700, Kees Cook wrote:

> > When you start a port to a 512-bit architecture, you'll have much nastier
> > problems than this one...
> 
> Well, this is simply taking advantage of this particular allocator's
> behavior. Instead of depending on this side-effect, why not change the
> allocation so that we never risk a potentially broken read? (Even SLOB
> notes that it may have as low as 2-byte granularity.)

Oh, for fuck sake!  "Hardening", indeed...

Kees, try to think for a minute[1].  Really.  We have general-purpose
allocator.  Asked to give us something considerably bigger than one
word.  How do you call a situation when it returns something with
the end of requested object crossing the page boundary if rounded
up to nearest multiple of word size?

That's right, FUBAR.  Because for that to happen it would have to
have given you an address that would not be word-aligned.  In response
to request to allocate something wider than a word.  Remember the
words along the lines of "the pointer returned if the allocation
succeeds is properly aligned..."?

It's not a behaviour of this particular allocator.  It's something that
will have to be guaranteed by *any* general-purpose allocator.

[1] yes, yes, I know - the mere mention of security should've prevented such
arrogant requests.  It's an imperfect universe.
