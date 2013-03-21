Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3CUUPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:15:11 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:62914 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3CUUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130321192935.GY21522@ZenIV.linux.org.uk>
References: <20130321190653.GA15479@redhat.com>
	<20130321192935.GY21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 13:15:08 -0700
X-Google-Sender-Auth: jkE-SDN_0DX3sJTvEzk0SycZCi0
Message-ID: <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> #0 oddity aside, that looks very much like directory aliased by two different
> dentries.  Try to add
>         BUG_ON(p1->d_inode == p2->d_inode);
> just before
>         mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
> and see if it triggers.

Don't do a BUG_ON(), instead do something like

   if (WARN_ON_ONCE(p1->d_inode == p2->d_inode)) {
        printk("pi=%s p2=%s\n", pi->d_name, p2->d_name);
        mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
        return NULL;
   }

so that we actually see where it is. I'm assuming it's some sysfs oddity again..

            Linus
