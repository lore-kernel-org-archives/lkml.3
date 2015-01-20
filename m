Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbbATWWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:22:40 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14027 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbbATWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:22:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQJAGfUvlR5LLLk/2dsb2JhbABbgwaBKoI2sTMBAQEDBpgyBAICgShEAQEBAQF9hAwBAQEDAScTHCMFCwgDDgoJJQ8FJQMhE4gkB9EqAQEBAQEFAQEBAR4YhW2JdAeDFoETBZdvkisihAIqMYJDAQEB
Date: Wed, 21 Jan 2015 09:22:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Namjae Jeon <namjae.jeon@samsung.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Brian Foster'" <bfoster@redhat.com>,
        "'Dmitry Monakhov'" <dmonakhov@openvz.org>,
        "=?utf-8?B?J0x1a8OhxaE=?= Czerner'" <lczerner@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: file freeze support
Message-ID: <20150120222222.GF16552@dastard>
References: <005c01d030b7$90ab2cb0$b2018610$@samsung.com>
 <20150118233334.GB16552@dastard>
 <005601d033e8$d0b338a0$7219a9e0$@samsung.com>
 <20150120112137.GC15756@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120112137.GC15756@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 12:21:37PM +0100, Jan Kara wrote:
> On Mon 19-01-15 22:07:01, Namjae Jeon wrote:
> > > > When this state is set, any process which tries to modify the file's address
> > > > space, either by pagefault mmap writes or using write(2), will block until
> > > > the this state is cleared. I_WRITE_FREEZED is set by calling FS_IOC_FWFREEZE
> > > > ioctl and clear by FS_IOC_FWTHAW ioctl.
....
> > I checked the routines where checks for I_FROZEN would be required.
> > Most of them are Ok but do_unlinkat() confuses me a little.
> > vfs_unlink is called under parent inode's i_mutex, so we cannot sleep
> > keeping parent's i_mutex held.
> > i.e while freezing file, all file in directory are blocked by parent
> > i_mutex. Is it ok to release parnets->mutex before checking for I_FROZEN
> > or there is some idea?
>   So I believe Dave thought that you'd just reuse places we currently use
> to call sb_start_write() / mnt_want_write(). You'd probably have to come up
> with a function like path_want_write() (takes struct path as an argument)
> and which will call mnt_want_write(), sb_start_write(), and do appropriate
> inode freeze handling. Then you replace all calls to mnt_want_write() with
> calls to path_want_write()... Possibly you can also provide a trivial
> wrapper for path_want_write() which takes struct file instead.

Yes, that's pretty much what I as thinking - a single function
that does all the freeze checking/blocking for a given operation,
regardless of the type of freeze we block on. That way all the
nesting semantics are located in one set of code, and it's easy to
verify correct.

> This should also deal with the locking problems you describe above as
> mnt_want_write() is always called before taking i_mutex.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
