Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3IGATk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:19:40 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:50863 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3IGATi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:19:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130907000044.GX13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
	<1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
	<20130906210546.GW13318@ZenIV.linux.org.uk>
	<CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
	<20130907000044.GX13318@ZenIV.linux.org.uk>
Date: Fri, 6 Sep 2013 17:19:37 -0700
X-Google-Sender-Auth: wV1QD1S8KM6EqP2BW4tUOc8IgM0
Message-ID: <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
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

On Fri, Sep 6, 2013 at 5:00 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Er... what will happen if you have done just what you've described and have
> a process call d_lookup()?

Umm. Yes?

What part of "one single path component" did you not get?

To repeat: d_lookup() NEVER LOOKS UP A WHOLE PATHNAME. It looks up
just a single path component. It matters not one whit whether you look
up a filename that is 1500 components deep, d_lookup() only ever works
on one single component. It's a single short hash chain lookup.

Sure, it can fail, but people really have to work at it. You're not
going to be able to make it fail by just calling "rename()" in a loop.
You're going to have to do multiple threads at least, and now you need
to do it on multiple different filesystems, since otherwise those
multiple threads are going to be serialized by the (outer)
per-filesystem vfs-layer rename semaphores. In other words, it sounds
impossible to trigger, wouldn't you say? Or if you try, you're going
to stand out for using a *lot* of resources.

In contrast, doing the getcwd() lookup really is following potentially
quite long chains.

So it's quite possible that just a single thread doing rename() in a
loop (on, say, /tmp, so that there isn't any IO) can trigger the
sequence write-lock frequently enough that traversing 1500 d_parent
entries might never complete.

Have I tried it? No. But think about the two different scenarios.
There really is a *big* difference between looking up one single
dentry from its parent using our hash tables, and traversing a
potentially almost unbounded parenthood chain.

(We're bounded in practice by PATH_MAX, so you can't make getcwd()
traverse more than about 2000 parents (single character filename plus
the slash for each level), and for all I know filesystems might cap it
before that, so it's not unbounded, but the difference between "1" and
"2000" is pretty damn big)

             Linus
