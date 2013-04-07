Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161513Ab3DGH41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 03:56:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57303 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161119Ab3DGH40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 03:56:26 -0400
Date: Sun, 7 Apr 2013 08:56:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: old->umask copying without spin_lock, in copy_fs_struct()
Message-ID: <20130407075625.GN4068@ZenIV.linux.org.uk>
References: <CADZ9YHiQBips5DB=xo0Kh-Nx_s60K+W+5RK-kCrHMfy6AGkhyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHiQBips5DB=xo0Kh-Nx_s60K+W+5RK-kCrHMfy6AGkhyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 11:37:27AM +0600, Rakib Mullick wrote:
> Hello,
> 
> In copy_fs_struct(), old->umask is assigned to fs->umask outside of
> spin_lock(&old->lock). Shouldn't it be inside spin_lock()? Since we're
> dealing with  fs_struct *old ? Isn't it unsafe? Following lines -
> 
>               fs->umask = old->umask;
> 
>                 spin_lock(&old->lock);

What would moving it down buy us?  Root, pwd and umask are all modified
independently; the *only* reason why we hold old->lock for root and
pwd (and we might drop and regain it between copying those - it would
be pointless, so we don't bother, but it wouldn't have affected correctness)
is that we want the values of root.mnt and root.dentry taken at the same
time and we want to grab extra references on those while they are still
valid.  The same goes for pwd, of course.  That's what old->lock
protects - we want the damn thing atomic wrt set_fs_root() and set_fs_pwd().
umask is an integer; its updates are atomic anyway, so it's not as if we
could see a half-updated value or needed to do anything with refcounts.
