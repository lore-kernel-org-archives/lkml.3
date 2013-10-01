Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3JAD1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:27:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54357 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3JAD1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:27:30 -0400
Date: Tue, 1 Oct 2013 04:27:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: spinlock contention of files->file_lock
Message-ID: <20131001032715.GW13318@ZenIV.linux.org.uk>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
 <1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
 <20131001015344.GV13318@ZenIV.linux.org.uk>
 <CA+55aFz3gJE_DpZufTDNoRZ=vgJS3OwMspR7ZSqzGY_rWMq4gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz3gJE_DpZufTDNoRZ=vgJS3OwMspR7ZSqzGY_rWMq4gQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 07:02:23PM -0700, Linus Torvalds wrote:

> Shouldn't a cmpxchg() in just the dup2 code solve that?
> 
> If the old value was NULL, you'd have to repeat and go back and see if
> the open_fds[] bit had been cleared in the meantime (ie it's NULL not
> because somebody else is busy installing it, but because somebody just
> uninstalled it).

Yechh...  Under ->file_lock (in do_dup2()), hopefully?  Or you'll get
all kinds of fun with close() thrown into the game, as well...

> But yeah, I do agree that that sounds nasty and a complication I
> hadn't even thought about. dup2() does violate our normal "let's
> pre-allocate the fd slot" rule. Ugh.

Hell knows...  Descriptor handling *is* pretty well isolated these
days, so it just might be doable without disrupting the living hell
out of anything else.  fs/file.c is pretty much it - everything else
goes through it.

I've enough on my plate at the moment with fs/namespace.c and fs/namei.c,
though, and praying hard fs/inode.c doesn't enter the game.  I _know_
that fs/notify will and I'm not enjoying that for a second.  BTW, has
eparis resurfaced with any fixes for *notify/umount races?  I don't seem
to have anything related in the mailbox, but...
