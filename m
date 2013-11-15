Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3KOV6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 16:58:14 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53701 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3KOV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 16:58:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131114065212.GA13618@thunk.org>
References: <20131114020332.GA10961@thunk.org>
	<20131114065212.GA13618@thunk.org>
Date: Fri, 15 Nov 2013 13:58:05 -0800
X-Google-Sender-Auth: _qehb7ztIq-QykMGq92j9gX0GYs
Message-ID: <CA+55aFyyENCDErpcYGcy4qf2M8mBtRo_9_nT0HaUPuY+kozk7g@mail.gmail.com>
Subject: Re: /dev/random changes for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> There will be a merge conflict thanks to changes from the net tree.
> Here is the proposed resolution:

Ok, I finally got around to the random tree, but your proposed merge
resolution makes no sense, so I didn't end up applying it.

> - -     r->entropy_total += nbits;
>         if (!r->initialized && nbits > 0) {
> +               r->entropy_total += nbits;

This part undoes your commit 6265e169cd31 ("random: push extra entropy
to the output pools"), and the "entropy_total" field will now never be
non-zero when "r->initialized" is set. So then the rest of your
commit, which looks like this:

+ /* If the input pool is getting full, send some
+ * entropy to the two output pools, flipping back and
+ * forth between them, until the output pools are 75%
+ * full.
+ */
+ if (entropy_bytes > random_write_wakeup_thresh &&
+    r->initialized &&
+    r->entropy_total >= 2*random_read_wakeup_thresh) {
+ static struct entropy_store *last = &blocking_pool;
+ struct entropy_store *other = &blocking_pool;

can never trigger (because "r->initialized && r->entropy_total >=
2*random_read_wakeup_thresh" is never true).

So your merge resolution diff makes no sense to me.

That said, the networking change seems to be simpler and largely
equivalent to that commit, so maybe you meant to basically castrate
that commit 6265e169cd31? Or maybe the diff you posted was incomplete
and just doesn't show the undone part (because "git diff --cc" will
not show parts that match the other branch).

So I think the correct resolution is to basically take the code that
the networking tree added, and undo the "If the input pool is getting
full.." part of commit 6265e169cd31.

Hmm?

Just verifying that we're on the same page before merging this..

            Linus
