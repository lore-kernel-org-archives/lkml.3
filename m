Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaI2QHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:07:03 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62667 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaI2QHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140929155918.GG7996@ZenIV.linux.org.uk>
References: <20140924201813.GI7996@ZenIV.linux.org.uk>
	<20140925044601.GL7996@ZenIV.linux.org.uk>
	<20140926164442.GA26897@ZenIV.linux.org.uk>
	<20140927044555.GS7996@ZenIV.linux.org.uk>
	<CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
	<20140927183139.GT7996@ZenIV.linux.org.uk>
	<20140927191657.GU7996@ZenIV.linux.org.uk>
	<20140928074747.GZ7996@ZenIV.linux.org.uk>
	<20140928180556.GA7996@ZenIV.linux.org.uk>
	<CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
	<20140929155918.GG7996@ZenIV.linux.org.uk>
Date: Mon, 29 Sep 2014 09:07:00 -0700
X-Google-Sender-Auth: Sjudkdu9rqRlsZJRm6GJ4QlU7rs
Message-ID: <CA+55aFyveyOABqssxLinsmHkBg9=95TwEGC1ZT1POe+RmTbj+A@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 8:59 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Now RCU lookup starts.  And on another CPU we move the first dentry over
> the third one.  copy_name() is called, it decrements the refcount down
> to 1 (__d_free() hasn't happened yet) and doesn't schedule any freeing.

Ahh. If we were to do *all* of the copy-name name freeing under RCU,
we'd be ok. But we don't. We do the refcount decrement immediately
(and have to, if we want to have the rcu/refcount union). Yeah, good
call, although I find that doubvle rcu grace period for the common
case to be very annoying.

Ugh. I'm starting to be sorry I ever suggested this cleanup. Maybe
we're better off with the horrid hack (which is equivalent to what we
did before) after all.

               Linus
