Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3CUT3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:29:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37850 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3CUT3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:29:37 -0400
Date: Thu, 21 Mar 2013 19:29:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321192935.GY21522@ZenIV.linux.org.uk>
References: <20130321190653.GA15479@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321190653.GA15479@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 03:06:53PM -0400, Dave Jones wrote:

> Showing all locks held in the system:
> 4 locks on stack by trinity-child2/7669:
>  #0: blocked:  (sb_writers#4){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
>  #1: held:     (&type->s_vfs_rename_key){+.+.+.}, instance: ffff8801292d1928, at: [<ffffffff811c6f5e>] lock_rename+0x3e/0x120
>  #2: held:     (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff811c701e>] lock_rename+0xfe/0x120
>  #3: blocked:  (&type->i_mutex_dir_key#2/2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff811c7034>] lock_rename+0x114/0x120

#0 oddity aside, that looks very much like directory aliased by two different
dentries.  Try to add
	BUG_ON(p1->d_inode == p2->d_inode);
just before
        mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
and see if it triggers.
