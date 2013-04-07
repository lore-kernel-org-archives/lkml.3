Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab3DGIt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 04:49:56 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:53106 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab3DGItz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 04:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130407075625.GN4068@ZenIV.linux.org.uk>
References: <CADZ9YHiQBips5DB=xo0Kh-Nx_s60K+W+5RK-kCrHMfy6AGkhyA@mail.gmail.com>
	<20130407075625.GN4068@ZenIV.linux.org.uk>
Date: Sun, 7 Apr 2013 14:49:54 +0600
Message-ID: <CADZ9YHiROer+sNAVz5TVAdFB3ec6tiJ96aKAMh6YUn=Dom5e2w@mail.gmail.com>
Subject: Re: old->umask copying without spin_lock, in copy_fs_struct()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 7, 2013 at 1:56 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Apr 07, 2013 at 11:37:27AM +0600, Rakib Mullick wrote:
>> Hello,
>>
>> In copy_fs_struct(), old->umask is assigned to fs->umask outside of
>> spin_lock(&old->lock). Shouldn't it be inside spin_lock()? Since we're
>> dealing with  fs_struct *old ? Isn't it unsafe? Following lines -
>>
>>               fs->umask = old->umask;
>>
>>                 spin_lock(&old->lock);
>
> What would moving it down buy us?  Root, pwd and umask are all modified
> independently; the *only* reason why we hold old->lock for root and
> pwd (and we might drop and regain it between copying those - it would
> be pointless, so we don't bother, but it wouldn't have affected correctness)
> is that we want the values of root.mnt and root.dentry taken at the same
> time and we want to grab extra references on those while they are still
> valid.  The same goes for pwd, of course.  That's what old->lock
> protects - we want the damn thing atomic wrt set_fs_root() and set_fs_pwd().
> umask is an integer; its updates are atomic anyway, so it's not as if we
> could see a half-updated value or needed to do anything with refcounts.

Thanks for your explanation! The ->umask operation is trivial and as
you've explained (I was also looking at the code),
it seems that code execution order makes sure that nothing goes wrong.
fs_struct's data are protected with the ->lock, that's what I was
thinking in that way and was just making sure it wasn't missed out
accidentally.

Thanks
Rakib.
