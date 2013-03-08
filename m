Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab3CHSvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:51:07 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44834 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3CHSvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <20130308150408.GA25399@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130308150408.GA25399@redhat.com>
Date: Fri, 8 Mar 2013 10:51:03 -0800
X-Google-Sender-Auth: qSVFUpOAv9t0RjQBahZ5U6tpA_E
Message-ID: <CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 7:04 AM, Dave Jones <davej@redhat.com> wrote:
>
> Managed to trigger this one from a different path..
>
> kernel BUG at fs/namei.c:1439!
> Call Trace:
>  [<ffffffff811c973e>] path_lookupat+0x71e/0x740
>  [<ffffffff811c9794>] filename_lookup+0x34/0xc0
>  [<ffffffff811cc58e>] user_path_at_empty+0x8e/0x110
>  [<ffffffff811cc621>] user_path_at+0x11/0x20
>  [<ffffffff811e4347>] sys_lgetxattr+0x37/0xa0
>  [<ffffffff816d11c2>] system_call_fastpath+0x16/0x1b
>
> What can I dump here that might give us more clues ?

I think we should do the same thing and print out dentry names to give
us clues about where in /proc the problem happens.

And it doesn't really have to be proc - because of the symlinks in
/proc, we could easily get to /sys through processes like udev etc..

So how about just replaving that BUG_ON() with a

    if (WARN_ON(nd->inode != parent->d_inode)) {
        printk("%s -> %s (%s)\n", parent->d_name.name,
path->dentry->d_name.name, nd->last.name);
        return -EINVAL;
    }

or something like that.

Hopefully that gives some clue about whare it happens, and some idea
about what migth be going on..

          Linus
