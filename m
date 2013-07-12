Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402Ab3GLUVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:21:10 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46057 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965283Ab3GLUVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:21:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130712193919.GC4165@ZenIV.linux.org.uk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
	<CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
	<20130712054817.GY4165@ZenIV.linux.org.uk>
	<8738rk9eai.fsf@rasmusvillemoes.dk>
	<20130712154833.GA4165@ZenIV.linux.org.uk>
	<87wqovviyy.fsf@rasmusvillemoes.dk>
	<20130712191321.GB4165@ZenIV.linux.org.uk>
	<20130712193919.GC4165@ZenIV.linux.org.uk>
Date: Fri, 12 Jul 2013 13:21:07 -0700
X-Google-Sender-Auth: qTrFaaVdgXztsSSoBtgBQuvuJMY
Message-ID: <CA+55aFxA3qoM5wpMUya7gEA8SZyJep7kMBRjrPOsOm_OudD8aQ@mail.gmail.com>
Subject: Re: [git pull] vfs.git part 2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I mean something like this:
>
> Safer ABI for O_TMPFILE
>
> [suggested by Rasmus Villemoes] make O_DIRECTORY | O_RDWR part of O_TMPFILE;
> that will fail on old kernels in a lot more cases than what I came up with.

So see earlier about why I'm not convinced about O_RDWR. But even if
we really want that (and it might be better to start off too narrow
than accept anything else) your patch tests those bits the wrong way
(any O_RDWR test should be done using the O_ACCMODE mask, not using
the O_RDWR value itself as a mask)

Also, to make sure that the "no preexisting file" case fails, I still
think you should also verify that O_CREAT is not set. Otherwise
Rasmus' case

    open("/tmp/test/link_to_nowhere", O_DIRECTORY | O_RDWR, 0666) ->
-1; No such file or directory

can work, and the case that rasmus didn't have at all (non-existent
pathname) also just silently succeeds by creating a file instead of
the expected directory..

So you could have something like

  #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY | O_RDWR)
  #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT | O_ACCMODE)

and then use

   if ((flags & O_TMPFILE_MASK) != O_TMPFILE)
       return -ENOTSUPP;

or whatever.

Hmm?

              Linus
