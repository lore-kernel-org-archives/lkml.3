Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3IPCx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:53:26 -0400
Received: from science.horizon.com ([71.41.210.146]:54914 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932210Ab3IPCxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:53:24 -0400
Date: 15 Sep 2013 22:53:21 -0400
Message-ID: <20130916025321.15502.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joe@perches.com, keescook@chromium.org
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, davem@davemloft.net,
        eldad@fogrefinery.com, jbeulich@suse.com, jkosina@suse.cz,
        linux-kernel@vger.kernel.org, linux@horizon.com,
        penguin-kernel@i-love.sakura.ne.jp, rdunlap@infradead.org,
        viro@zeniv.linux.org.uk
In-Reply-To: <1379114610.2066.37.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyone else have an opinion?

tl;dr: seq_printf() whould return void.


Well, certainly *if* seq_printf returns a value, it should be consistent
with printf, i.e. length or -errno.

If it's going to be anything else, then it should be incompatible with
an integer, so attempted uses cause compile-time errors.  Except for
the fairly unreasonable options of a pointer or a structure, void is
the only available type.

Looking at the callers, a lot of them are trying to compute a summary
length, which is actually really easy to find by just snapshotting
m->count before and after the region being printed.  And there's an
existing seq_overflow() function for detecting errors.

But more importantly, seq_show doesn't *need* the total length returned!
What they various show() functions are achieving by summing the return
values from seq_printf is generating 0 if all prints succeeded and some
negative number of failed prints otherwise.

But show() is supposed to return -errno, and *not* return an error
on overflow (fs/seq_file.c/traverse() checks seq_overflow separately),
so this is Just Plain Broken.  This pattern appears everywhere, and it
appears that somebody misunderstood the specs once, and the result has
been cargo cult copied all over the kernel.

What happens on overflow is that you get some random errno returned to user
space.  Bad bad bad.

Since show() functions *aren't supposed to check* for overflows from
seq_printf (if they do, it breaks the "reallocate and try again" logic),
I support making it return void so that this broken code style errors
out and someone has to really try to mess it up.

(Another code stupidity is that I have no idea why traverse() doesn't
just take care of the -EAGAIN case internally and simplify the calling
convention; it's not like either of the callers check any conditions
before calling right back in again.)
