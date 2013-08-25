Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3HYPwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab3HYPwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:52:18 -0400
Date: Sun, 25 Aug 2013 17:45:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: /proc/pid/fd && anon_inode_fops
Message-ID: <20130825154556.GA25922@redhat.com>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net> <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com> <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com> <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com> <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com> <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824212432.GA9299@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

On 08/24, Willy Tarreau wrote:
>
> On Sat, Aug 24, 2013 at 08:29:39PM +0200, Oleg Nesterov wrote:
> >
> > On 08/22, Willy Tarreau wrote:
> > >
> > > It's not only that, it also supports sockets and pipes that you can access
> > > via /proc/pid/fd and not via a real symlink which would try to open eg
> > > "pipe:[23456]" instead of the real file.
> >
> > But sock_no_open() disallows this, and for good reason I guess.
>
> Hmmm not exactly, it works for a pipe but not for a socket.

But this is what I meant, sorry for confusion.

Let me try to explain. Just in case, this has nothing to do with security
and I do not see any problem, still I think there is something wrong (but
harmless).

Suppose that you are trying to open(/proc/pid/$pipe-or-socket-fd).
nd_jump_link() sets nd->inode correctly, then dentry_open() does the
rest. Everything is correct at this stage, the new file gets the correct
f_inode/f_op.

However, unlike fifo_open(), socket_file_ops->open() can not actually
create the file/sock connection, so sock_no_open() just fails and
nothing bad happens.

But if you open an anon_inodefs file via proc, you get the "bogus" file.
There is a single anon_inode_inode, its ->i_fop points to the empty
anon_inode_fops, this has nothing to do with ->f_op of the actual file
you tried to open.

Nothing bad happens, still I think this is simply wrong and misleading,
and thus I think it would be better to disallow this via anon_open().

Oleg.

