Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3JACC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 22:02:26 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:52684 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3JACCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 22:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131001015344.GV13318@ZenIV.linux.org.uk>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
	<1380589503.5326.13.camel@edumazet-glaptop.roam.corp.google.com>
	<20131001015344.GV13318@ZenIV.linux.org.uk>
Date: Mon, 30 Sep 2013 19:02:23 -0700
X-Google-Sender-Auth: lfuQUG4XG8jTqRofRiiMqqK7JGo
Message-ID: <CA+55aFz3gJE_DpZufTDNoRZ=vgJS3OwMspR7ZSqzGY_rWMq4gQ@mail.gmail.com>
Subject: Re: spinlock contention of files->file_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 6:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> The problem is dup2()

Shouldn't a cmpxchg() in just the dup2 code solve that?

If the old value was NULL, you'd have to repeat and go back and see if
the open_fds[] bit had been cleared in the meantime (ie it's NULL not
because somebody else is busy installing it, but because somebody just
uninstalled it).

But yeah, I do agree that that sounds nasty and a complication I
hadn't even thought about. dup2() does violate our normal "let's
pre-allocate the fd slot" rule. Ugh.

              Linus
