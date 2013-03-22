Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422712Ab3CVRiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:38:03 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:59759 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661Ab3CVRiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:38:00 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jack@suse.cz, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, mszeredi@suse.cz
In-Reply-To: <1944.1363525619@warthog.procyon.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <1944.1363525619@warthog.procyon.org.uk>
Date: Sat, 23 Mar 2013 02:37:55 +0900
Message-ID: <13789.1363973875@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells:
> Now, looking at __sb_start_write(), I'm not entirely sure how the deadlock
> might operate, so it's possible that this is a false alarm.  Maybe Jan Kara can
> illuminate further, so I've added him to the cc list.

It is related to the design of UnionMount, isn't it?
UnionMount is not a filesystem and doen't have its own superblock.
If it was a fs, then
- vfs_truncate() acquires sb_writers for the unioning-fs.
- the unioning-fs may call vfs_truncate() again for the underlying fs.
- this time, sb_writers is for the underlying fs which is a different
  sb_writers object from the already acquired one.
So there would be no deadlock.

Still lockdep will produce the message since sb_writers doesn't have the
lockdep class. Of course, we can introduce the lock class for it, or call
lockdep_off()/on() simply in order to stop the message. But, as long as
the unioning feature is not implemented as a fs, the solution will not
be so easy. I am afraid UnionMount will need to introduce a new counter
(or a new flag) to indicate the task entered the union, and adjust the
lock class or decide to call lockdep_off() for sb_writers. I don't think
it is a good idea.


J. R. Okajima
