Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3CUU0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab3CUU0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:26:40 -0400
Date: Thu, 21 Mar 2013 16:26:35 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: VFS deadlock ?
Message-ID: <20130321202635.GA16406@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130321190653.GA15479@redhat.com>
 <20130321192935.GY21522@ZenIV.linux.org.uk>
 <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyvwJK99YvDLDsazD4tWT6sNQO6kGM_1WyDdvwPNDxbLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 01:15:08PM -0700, Linus Torvalds wrote:
 > On Thu, Mar 21, 2013 at 12:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
 > >
 > > #0 oddity aside, that looks very much like directory aliased by two different
 > > dentries.  Try to add
 > >         BUG_ON(p1->d_inode == p2->d_inode);
 > > just before
 > >         mutex_lock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
 > > and see if it triggers.
 > 
 > Don't do a BUG_ON(), instead do something like
 > 
 >    if (WARN_ON_ONCE(p1->d_inode == p2->d_inode)) {
 >         printk("pi=%s p2=%s\n", pi->d_name, p2->d_name);
 >         mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
 >         return NULL;
 >    }

those are qstr's, so I used d_name.name, right ?

 > so that we actually see where it is. I'm assuming it's some sysfs oddity again..

I'd be surprised actually, I've got sysfs excluded from its list of victim files,
due to unrelated issues still unresolved.  So unless it followed a symlink into
sys from somewhere in /proc or /dev...

It took a few hours to reproduce last time, I'll increase the number of child
processes to see if I can trigger it faster now that I have the debug stuff in there.

	Dave
