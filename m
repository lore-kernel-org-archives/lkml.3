Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3H0XIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:08:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52437 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3H0XIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:08:35 -0400
Date: Wed, 28 Aug 2013 00:08:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
Message-ID: <20130827230827.GI27005@ZenIV.linux.org.uk>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
 <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:16:34PM -0700, Andy Lutomirski wrote:
> This is an experiment to see if we can get nice semantics for all syscalls
> that either follow symlinks or allow AT_EMPTY_PATH without jumping through
> enormous hoops.  This converts truncate (although you can't tell using
> truncate from coreutils, because it actually uses open + ftruncate).
> 
> The basic idea is that there's a new helper function
> user_file_or_path_at.  It takes an fd and a path and, depending on
> flags, the emptiness of the path, and whether path is a magic /proc
> symlink (or a symlink to a magic /proc/symlink), it returns either a
> struct path or a struct file *.

No.  

> +	path_get(&nd->path);
> +	if (nd->flags & LOOKUP_FILE) {
> +		if (nd->last_symlink_file)
> +			fput(nd->last_symlink_file);
> +		nd->last_symlink_file = file;

This is ugly (and costs quite a bit of overhead)

> -static int proc_cwd_link(struct dentry *dentry, struct path *path)
> +static int proc_cwd_link(struct dentry *dentry, struct file_or_path *link)

... and this is even more vile.  Vetoed, for being too ugly to live.

I think I've a saner approach, not involving anything that ugly; I'll post
a writeup later tonight.
