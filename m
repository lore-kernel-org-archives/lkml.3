Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab3GCUh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:37:28 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48332 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3GCUh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <1372882741-22563-4-git-send-email-Waiman.Long@hp.com>
References: <1372882741-22563-1-git-send-email-Waiman.Long@hp.com>
	<1372882741-22563-4-git-send-email-Waiman.Long@hp.com>
Date: Wed, 3 Jul 2013 13:37:25 -0700
X-Google-Sender-Auth: PSZy2SjWiE5X20g49UFYGYNUnVY
Message-ID: <CA+55aFzRbOgBhmL3y=bgR=OakOH6RizVYD5XBc8aP9LzfMn8cA@mail.gmail.com>
Subject: Re: [PATCH v3 03/25] dcache: Enable lockless update of d_count in
 dentry structure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch grew a lot, and that seems to be mainly because of bad reasons.

I'd suggest dropping the whole
"lockref_ret_count()"/"lockref_ret_lock()" helpers, which cause all
the annoyance, and just make people use the members directly.

Then, just do

   #define d_lock d_lockref.lockref_lock

or similar, so that all the existing code just continues to work,
without the need for the syntactic changes:

-       spin_lock(&dentry->d_lock);
+       d_lock(dentry);

For d_count, we probably do need to have the wrapper macro:

  #define dentry_count(dentry)  ((dentry)->d_lockref.lockref_count)

and change the existing users of "dentry->d_count" to use that, but
there are fewer of those than there are of people taking the dentry
lock. And most of them are in fs/dcache.c and would be affected by
this set of patches anyway.

                  Linus
