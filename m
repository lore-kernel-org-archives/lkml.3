Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3CHTr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:47:58 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58643 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3CHTr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:47:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130308193652.GA11692@redhat.com>
References: <20130307021645.GA10173@redhat.com>
	<20130308150408.GA25399@redhat.com>
	<CA+55aFxAfWHdSH+45qgids1ByBxzieZnz_ujRXYGY-at1mg5eg@mail.gmail.com>
	<20130308191804.GA9774@redhat.com>
	<20130308192042.GA10305@redhat.com>
	<20130308193652.GA11692@redhat.com>
Date: Fri, 8 Mar 2013 11:47:54 -0800
X-Google-Sender-Auth: K-ij8uiZzePW6Nh511AaiIQgE3I
Message-ID: <CA+55aFyE12rZ3DZUtTkonPjbcQiZNdAmys7w5zf7_Xry2z=-2A@mail.gmail.com>
Subject: Re: BUG_ON(nd->inode != parent->d_inode);
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 11:36 AM, Dave Jones <davej@redhat.com> wrote:
>
> I changed it to do this..
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 961bc12..c1ca29e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -689,8 +689,6 @@ void nd_jump_link(struct nameidata *nd, struct path *path)
>         nd->path = *path;
>         nd->inode = nd->path.dentry->d_inode;
>         nd->flags |= LOOKUP_JUMPED;
> -
> -       BUG_ON(nd->inode->i_op->follow_link);
>  }
>
>  static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)
> @@ -1438,7 +1436,13 @@ static int lookup_slow(struct nameidata *nd, struct path *path)
>         int err;
>
>         parent = nd->path.dentry;
> -       BUG_ON(nd->inode != parent->d_inode);
> +
> +    if (WARN_ON(nd->inode != parent->d_inode)) {
> +        printk("%s -> %p (%s)\n", parent->d_name.name, path->dentry, nd->last.name);
> +        return -EINVAL;
> +    }

Ok, it might be nice to print out the path dentry name if it has one,
but it may well be that this only happens with negative dentries in
proc or sysfs, since you said that you just added testing of that..

> And now I'm getting a different BUG_ON

Heh. It's the same BUG_ON(), it's just replicated (and "parent" is
called "dir" here).

Maybe you can make the WARN_ON_ONCE() version be a macro, because that
test exists in multiple places: unlazy_walk, complete_walk,
lookup_slow and do_last (and walk_component in a different guise).

              Linus
