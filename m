Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbbATLVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:21:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbbATLVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:21:40 -0500
Date: Tue, 20 Jan 2015 12:21:37 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "=?utf-8?B?J0x1a8OhxaE=?= Czerner'" <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: file freeze support
Message-ID: <20150120112137.GC15756@quack.suse.cz>
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
 <20150118233334.GB16552@dastard>
 <005601d033e8$d0b338a0$7219a9e0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005601d033e8$d0b338a0$7219a9e0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-01-15 22:07:01, Namjae Jeon wrote:
> > > When this state is set, any process which tries to modify the file's address
> > > space, either by pagefault mmap writes or using write(2), will block until
> > > the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFREEZE
> > > ioctl and clear by FS_IOC_FWTHAW ioctl.
> > >
> > > File write freeze functionality, when used in conjunction with
> > > inode's immutable flag can be used for creating truly stable file snapshots
> > > wherein write freeze will prevent any modification to the file from already
> > > open file descriptors and immutable flag will prevent any new modification
> > > to the file. One of the intended uses for stable file snapshots would be in
> > > the defragmentation applications which defrags single file.
> > 
> > I don't quite understand why the full filesystem freeze is
> > necessary? The thaw occurs immediately after I_WRITE_FREEZED is set,
> We started by looking at fs freeze for file freeze implementation,
> So got biased for using fs freeze or similar approach.
> Thanks for suggesting a better way.
> 
> > which means there's nothing that prevent the file from being
> > truncated or otherwise modified by fallocate, etc while it is
> > frozen....
> Right, So, After that, we had also thought of setting immutable
> flag of inode. Immutable flag + I_WRITE_FROZEN => truly frozen file.
> 
> > 
> > AFAICT, fsync will bring the file down to a consistent state and
> > we've already got freeze hooks for all inode modification
> > operations. We also have IO barriers for truncate operations so that
> > we can wait for all outstanding IO to complete, so I would have
> > thought this covers all bases for an inode freeze. i.e.:
> Right.
> 
> > 
> > i_mutex -> I_FROZEN -> fsync -> inode_dio_wait
> > 
> > Should give us a clean inode where there are not ongoing operations
> > by the time that inode_dio_wait() completes. All new modification
> > operations need to check I_FROZEN in addition to the superblock
> > freeze checks...
> I checked the routines where checks for I_FROZEN would be required.
> Most of them are Ok but do_unlinkat() confuses me a little.
> vfs_unlink is called under parent inode's i_mutex, so we cannot sleep
> keeping parent's i_mutex held.
> i.e while freezing file, all file in directory are blocked by parent
> i_mutex. Is it ok to release parnets->mutex before checking for I_FROZEN
> or there is some idea?
  So I believe Dave thought that you'd just reuse places we currently use
to call sb_start_write() / mnt_want_write(). You'd probably have to come up
with a function like path_want_write() (takes struct path as an argument)
and which will call mnt_want_write(), sb_start_write(), and do appropriate
inode freeze handling. Then you replace all calls to mnt_want_write() with
calls to path_want_write()... Possibly you can also provide a trivial
wrapper for path_want_write() which takes struct file instead.

This should also deal with the locking problems you describe above as
mnt_want_write() is always called before taking i_mutex.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
