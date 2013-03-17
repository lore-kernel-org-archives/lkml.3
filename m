Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3CQNIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 09:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab3CQNIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 09:08:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Date: Sun, 17 Mar 2013 13:06:59 +0000
Message-ID: <1944.1363525619@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Export do_splice_direct() to modules.  Needed by overlay filesystem.

Apparently you cannot call this from any function that is holding an i_mutex
if the target of the splice uses generic_file_splice_write().

The problem is a potential deadlock situation:

We have places already that do:

	mnt_want_write()
	mutex_lock()

This can be found in do_last() for example.

However, mnt_want_write() calls sb_start_write() as does
generic_file_splice_write().  So now in ovl_copy_up_locked() you're adding:

	mutex_lock()
	sb_start_write()

which lockdep reports as a potential ABBA deadlock.

Now, looking at __sb_start_write(), I'm not entirely sure how the deadlock
might operate, so it's possible that this is a false alarm.  Maybe Jan Kara can
illuminate further, so I've added him to the cc list.

I've attached the report I got with unionmount.

David
---
[ INFO: possible recursive locking detected ]
3.9.0-rc1-fsdevel+ #934 Not tainted
---------------------------------------------
fs-op/4476 is trying to acquire lock:
 (sb_writers#4){.+.+.+}, at: [<ffffffff811087a4>] generic_file_splice_write+0x5d/0x14b
but task is already holding lock:
 (sb_writers#4){.+.+.+}, at: [<ffffffff810ff97c>] mnt_want_write+0x1f/0x46
other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(sb_writers#4);
  lock(sb_writers#4);
 *** DEADLOCK ***
 May be due to missing lock nesting notation
2 locks held by fs-op/4476:
 #0:  (sb_writers#4){.+.+.+}, at: [<ffffffff810ff97c>] mnt_want_write+0x1f/0x46
 #1:  (&type->i_mutex_dir_key[1]){+.+.+.}, at: [<ffffffff81131c74>] __union_copy_up+0x9a/0x132
stack backtrace:
Pid: 4476, comm: fs-op Not tainted 3.9.0-rc1-fsdevel+ #934
Call Trace:
 [<ffffffff81070398>] __lock_acquire+0x86a/0x16cf
 [<ffffffff811081cc>] ? page_cache_pipe_buf_release+0x1b/0x1b
 [<ffffffff810715e2>] lock_acquire+0x57/0x6d
 [<ffffffff811087a4>] ? generic_file_splice_write+0x5d/0x14b
 [<ffffffff810e3314>] __sb_start_write+0x10d/0x15d
 [<ffffffff811087a4>] ? generic_file_splice_write+0x5d/0x14b
 [<ffffffff811087a4>] generic_file_splice_write+0x5d/0x14b
 [<ffffffff811083d5>] do_splice_from+0x74/0x91
 [<ffffffff81108410>] direct_splice_actor+0x1e/0x20
 [<ffffffff8110868b>] splice_direct_to_actor+0xc2/0x17e
 [<ffffffff811083f2>] ? do_splice_from+0x91/0x91
 [<ffffffff8110999d>] do_splice_direct+0x47/0x5a
 [<ffffffff81131a99>] __union_copy_up_locked+0x171/0x2b2
 [<ffffffff81131cc4>] __union_copy_up+0xea/0x132
 [<ffffffff810e02ca>] vfs_truncate+0x15e/0x289
 [<ffffffff810e043b>] do_sys_truncate+0x46/0x83
 [<ffffffff810e05cf>] sys_truncate+0x9/0xb
 [<ffffffff81456f92>] system_call_fastpath+0x16/0x1b
