Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3IAW6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 18:58:35 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:38111 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3IAW6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 18:58:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130901224459.GW13318@ZenIV.linux.org.uk>
References: <CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
	<CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
	<CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
	<CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
	<20130901223521.GV13318@ZenIV.linux.org.uk>
	<20130901224459.GW13318@ZenIV.linux.org.uk>
Date: Sun, 1 Sep 2013 15:58:32 -0700
X-Google-Sender-Auth: uWd7qt_TH1JSPB7ajv7TlAAFLHc
Message-ID: <CA+55aFyBmaewJkfkBW94bSDsymg+R1wZyv064-nnj-TUrhYDyA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Waiman Long <waiman.long@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
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

On Sun, Sep 1, 2013 at 3:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> GRRR...  I see something else:
> void file_sb_list_del(struct file *file)
> {
>         if (!list_empty(&file->f_u.fu_list)) {
>                 lg_local_lock_cpu(&files_lglock, file_list_cpu(file));
>                 list_del_init(&file->f_u.fu_list);
>                 lg_local_unlock_cpu(&files_lglock, file_list_cpu(file));
>         }
> }
> will cheerfully cause cross-CPU traffic.  If that's what is going on, the
> earlier patch I've sent (not putting non-regulars and files opened r/o
> on ->s_list) should reduce the cacheline bouncing on that cacheline.

Hmm. That might indeed be a bad sources of cross-cpu bouncing on some
loads, but the load I test doesn't actually open any files. It just
does "stat()" on a filename.

So no "struct file *" anywhere for me..It really seems to be
vfsmount_lock itself somehow.

              Linus
