Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3AUEh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:37:59 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60026 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3AUEh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:37:57 -0500
MIME-Version: 1.0
In-Reply-To: <87vcarur8n.fsf@rustcorp.com.au>
References: <20130118074309.GB31793@elgon.mountain> <87ip6rwcvz.fsf@rustcorp.com.au>
 <CA+55aFzEkSOWL13cX2xaYttPF5=Qpvya9Yapk-RC8KQ5=QJk+w@mail.gmail.com> <87vcarur8n.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Jan 2013 20:37:36 -0800
X-Google-Sender-Auth: ibmTKtsyiwY4a8lgLqaDW1fx3kg
Message-ID: <CA+55aFyhfuLJqsEiAJ3jyf_OikgZroFkfBW1i-LYwCr0YOVX1w@mail.gmail.com>
Subject: Re: [patch] module: potential deadlock in error path
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Prarit Bhargava <prarit@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 7:52 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> You've now conflated two completely different lock paths into a single
> unlock.

We have that elsewhere too. And it's what we used to have before too.

So the simple fact is that commit 1fb9341ac348 just introduced this
bug, and moving the goto target around is the obvious fix for it, and
makes it match the old code that was simply incorrectly modified.

The suggested patch instead has *some* cleanup inside the
if-statement, and some at the goto target. That makes no sense to
humans, and just makes it harder for the compiler to generate better
code.

> mutex_bug_cleanup() should really lock internally, but doesn't
> so we wrap it.  And that mutex_unlock of yours has nothing to do with
> cleaning up ddebug, so the labels misnamed, at best.

Bah, humbug. It's called "ddebug_cleanup" because it's called after
the  debug setup, so it needs to clean up the state set up by that.
The fact that it needs to unlock is secondary, and is simply because
the lock is taken at that point, so needs to be released. The naming
is not wonderful, but it's not hugely illogical, and again, that's
what it used to (except "ddebug" has been renamed to
"ddebug_cleanup"). You could rename it if you want to (we used to have
a target called "unlock" at that point), but that's *still* no excuse
for just creating code that does cleanup in two totally unrelated
places.

> Not that it matters much: this is going to change for next merge window.

Now, agreed, that looks better, although I suspect you could have
taken the "split that ugly function up" further still.

                   Linus
