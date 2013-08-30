Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab3H3VXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:23:00 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:55314 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H3VW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <52210A55.8010308@hp.com>
References: <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<5220E56A.80603@hp.com>
	<CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
	<5220F090.5050908@hp.com>
	<CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
	<5220FD51.2010709@hp.com>
	<CA+55aFzhiLMdSCnePX0OgFUXo7KC+aomM8URppDuV+7xUaaSpw@mail.gmail.com>
	<20130830205404.GF13318@ZenIV.linux.org.uk>
	<52210A55.8010308@hp.com>
Date: Fri, 30 Aug 2013 14:22:58 -0700
X-Google-Sender-Auth: RRvkY7bqQQaS5-ySZt6CSfxO2co
Message-ID: <CA+55aFz3+Nbn155YeiwT0uBgqyXsAQn4jkT0NHWnE7+OvJbQig@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 2:10 PM, Waiman Long <waiman.long@hp.com> wrote:
>
> Actually, prepend_path() was called with rename_lock taken. So d_move()
> couldn't be run at the same time. Am I right?

Al was discussing the case I mentioned: getting rid of that lock
entirely, running it all just under RCU, and then just checking the
rename sequence count around it all and retrying if required.

It would have the advantage of not only not having to get the lock,
but by doing it as an RCU walk, we would avoid all the nasty reference
counting costs too. We wouldn't even need to get refcounts on the
root/pwd entries (which currently cost us quite a bit), since we could
just check the sequence number in "struct fs_struct" too. That also
gets rid of the necessity for the fs->lock spinlock.

You do have to be a bit careful when following the dentry pointers
under RCU (and you cannot just do a "memcpy()" on the name, as Al
points out), but it really doesn't look nasty. It just looks "you have
to be careful".

              Linus
