Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab3I2RUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 13:20:04 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49934 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab3I2RUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 13:20:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130929060601.GL13318@ZenIV.linux.org.uk>
References: <20130928202728.GK13318@ZenIV.linux.org.uk>
	<CA+55aFzrjiM6bgqNgdckJGAZks2fR8ZD+R_5AqxvrnS64DD3ow@mail.gmail.com>
	<20130929060601.GL13318@ZenIV.linux.org.uk>
Date: Sun, 29 Sep 2013 10:19:59 -0700
X-Google-Sender-Auth: LtqcXp42FBJ8pKUk3eKVVyI5-Q8
Message-ID: <CA+55aFyGY7hZTDhWiyWBe+oSkxd2GzoYWGhvXtGTyZKL-3PZ1w@mail.gmail.com>
Subject: Re: [rfc][possible solution] RCU vfsmounts
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 11:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Sigh...  Looks like there's a lot of fun in shrink_dcache_for_umount() -
> at the very least, it needs to bump ->d_seq on everything, because with
> that change we *can* walk into a filesystem in the middle of that.
> We obviously don't want to slap rcu_barrier() into the final mntput() -

I have to say, that when I was working with the dcache lockref code, I
absolutely _detested_ the magical shrink_dcache_for_umount() code that
violated all the locking rules.

So I actually wouldn't mind at all if that was all forced to follow
all the same rules that the live filesystem code is forced to follow.
Yes, yes, it's going to slow things down, but it's not like umount()
is _that_ performance critical. And I think the whole "let's ignore
locking rules" actually comes from back when we had one global
dcache_lock: we used to have batching in order to not hold the
dcache_lock over long periods, and then it got converted to the
per-dentry locking, and then that got removed entirely with the whole
RCU lookup etc.

So I would be *entirely* ok with having
shrink_dcache_for_umount_subtree() take the d_lock on the dentry as it
shrinks it etc etc.

                     Linus
