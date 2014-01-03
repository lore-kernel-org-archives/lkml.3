Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaACTqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:46:33 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60061 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaACTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <52C70C75.4050502@t-online.de>
References: <52C70C75.4050502@t-online.de>
Date: Fri, 3 Jan 2014 11:46:29 -0800
X-Google-Sender-Auth: 5cKVw6NMwIcF1or1Zu59Lnr1jG0
Message-ID: <CA+55aFxVs_aGnMdcTck3C7AayFrjX=GrFSwmJwiC9q3-3wySgw@mail.gmail.com>
Subject: Re: [BUG 3.13.0-rc6] reiserfs possible circular locking dependency
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jeff Mahoney <jeffm@suse.com>,
        reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 3, 2014 at 11:16 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> Rebooting after a power failure on an openSuSE 13.1 system
> with kernel 3.13.0-rc6 triggered the attached lockdep warning.

Hmm. It seems to be that the *normal* sequence should be:

 - get i_mutex, call lookup, which gets sbi->lock (reiserfs_write_lock)

but in the mounting path, we have special circumstances.

That finish_unfinished() function does

 - reiserfs_write_lock_nested() .
 - remove_save_link
 - iput(inode) with the write lock held

and that can apparently end up taking i_mutex in open_xa_dir (and then
recursively the write lock, but that's an explicitly recursive lock,
so that part should be ok).

Now, I don't think this can *really* deadlock with the normal order of
operations, because during mounting there is no other process that can
take those in the reverse order (since the filesystem isn't live), but
I do wonder if we should just release the reiserfs write lock over the
iputs. We release it in other parts anyway (like for the quota off)

Jeff, you already touched this exact case in commit d2d0395fd177
("reiserfs: locking, release lock around quota operations") except
that was for those quota operation cases.

Even if it's not a real problem, making lockdep happy sounds like a
good idea. Of course, the trouble is that this code path almost never
gets exercised (which is why this hasn't been noticed earlier), so
testing...

Jeff? Comments?

             Linus
