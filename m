Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3CTCdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 22:33:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52735 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3CTCdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 22:33:23 -0400
Date: Wed, 20 Mar 2013 02:33:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Message-ID: <20130320023308.GM21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
 <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <1944.1363525619@warthog.procyon.org.uk>
 <20130318153936.GB28508@quack.suse.cz>
 <20130318215333.GE21522@ZenIV.linux.org.uk>
 <20130319202543.GF5222@quack.suse.cz>
 <20130319213831.GK21522@ZenIV.linux.org.uk>
 <20130319221032.GL21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130319221032.GL21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:10:32PM +0000, Al Viro wrote:

> OK, it's going to be an interesting series - aforementioned tentative patch
> was badly incomplete ;-/

The interesting question is how far do we want to lift that.  ->aio_write()
part is trivial - see vfs.git#experimental; the trouble begins with
->splice_write().  For *everything* except default_file_splice_write(),
lifting into the caller (do_splice_from()) is the right thing to do.

default_file_splice_write(), however, it trickier; there we end up calling
vfs_write() (via an ugly callchain).  And _that_ is a real bitch.  Granted,
vfs_write() is somewhat an overkill there (we'd already done rw_verify_area()
and access_ok() is pointless due to set_fs() we do around vfs_write()
there) and we'd already lifted it up to do_sync_write().  But if we lift
it any further, we'll need to deal with ->write() callers in the tree.
Current situation:

fs/coredump.c:662:      return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr, nr, &file->f_pos) == nr;
arch/powerpc/platforms/cell/spufs/coredump.c:63:        written = file->f_op->write(file, addr, nr, &file->f_pos);

for these guys we might actually want to lift all way up to do_coredump()

drivers/staging/comedi/drivers/serial2002.c:91: result = f->f_op->write(f, buf, count, &f->f_pos);
fs/autofs4/waitq.c:73:         (wr = file->f_op->write(file,data,bytes,&file->f_pos)) > 0) {

not regular files, unless I'm seriously misreading the code.

kernel/acct.c:553:      file->f_op->write(file, (char *)&ac,

BTW, this is probably where we want to deal with your acct deadlock.

fs/compat.c:1103:               fn = (io_fn_t)file->f_op->write;
fs/read_write.c:435:                    ret = file->f_op->write(file, buf, count, pos);
fs/read_write.c:732:            fn = (io_fn_t)file->f_op->write;

syscalls - the question here is whether we lift it up to vfs_write/vfs_writev/
compat_writev, or actually take it further.

fs/cachefiles/rdwr.c:967:                       ret = file->f_op->write(

cachefiles_write_page(); no fucking idea what locks might be held by caller
and potentially that's a rather nasty source of PITA

fs/coda/file.c:84:      ret = host_file->f_op->write(host_file, buf, count, ppos);

coda writing to file in cache on local fs.  Potentially a nasty bugger, since
it's hard to lift any further - the caller has no idea that the thing is
on CODA, let alone what happens to hold the local cache.

drivers/block/loop.c:234:       bw = file->f_op->write(file, buf, len, &pos);

do_bio_filebacked(), with some ugliness between that and callsite.  Note,
BTW, that we have a pair of possible vfs_fsync() calls in there; how do those
interact with freeze?

This does *not* touch the current callers of vfs_write()/vfs_writev(); any of
those called while holding ->i_mutex on a directory (or mnt_want_write(), for
that matter) is a deadlock right now.

And we'd better start thinking about how we'll backport that crap - deadlock
in e.g. xfs ->splice_write() had been there since last summer ;-/
