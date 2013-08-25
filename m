Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3HYUF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 16:05:58 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33773 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3HYUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 16:05:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130825194844.GA16717@redhat.com>
References: <20130822185317.GI31117@1wt.eu>
	<CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
	<CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<20130824182939.GA23630@redhat.com>
	<20130824212432.GA9299@1wt.eu>
	<20130825052317.GZ27005@ZenIV.linux.org.uk>
	<20130825065039.GB9299@1wt.eu>
	<CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com>
	<20130825194844.GA16717@redhat.com>
Date: Sun, 25 Aug 2013 13:05:55 -0700
X-Google-Sender-Auth: OZgmarFsmDFPEx__726djjDb8qA
Message-ID: <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com>
Subject: Re: /proc/pid/fd && anon_inode_fops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 12:48 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Or pid_revalidate(), but my concern is task_dumpable() logic.
>
> pid_revalidate() does inode->i_*id = GLOBAL_ROOT_*ID if task_dumpable()
> fails, but it can fail simply because ->mm = NULL.
>
> This means that almost everything in /proc/zombie-pid/ becomes root.
> Doesn't really hurt, but for what? Looks a bit strange imho.

The zombie case shouldn't be relevant, because a zombie will have
closed all the file descriptors anyway, so they no longer exist.

That said, task_dumpable isn't wonderful, and I suspect we could drop
that logic entirely in the tid-fd case if we just use f_cred.

The reason we have task_dumpable is exactly because we use the task
credentials, and they may not really be relevant to the file
credentials. IOW, it's there to protect against execve'ing a suid
program that opens some protected file and then in setuid()'s back the
the original user after having done the critical stuff.  But
file->f_cred is exactly about the credentials at the time of the open,
so it should make things like that irrelevant.

            Linus
