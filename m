Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaE3IuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549AbaE3IuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:50:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <11446.1401420931@jrobl>
References: <11446.1401420931@jrobl> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk>
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: dhowells@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@gmail.com, mszeredi@suse.cz
Subject: Re: Unionmount and overlayfs testsuite
Date: Fri, 30 May 2014 09:49:33 +0100
Message-ID: <7184.1401439773@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. R. Okajima <hooanon05g@gmail.com> wrote:

> I've found some interesting cases.
> 
> - impermissible.test,
> 	open_file_as_bin -t -w $file -E EACCES
>   When $termslash is "/", a '/' is appended to the expanded $file, such
>   as "/path/fileA/". If fileA is a regular file, that path is obviously
>   wrong. Does UnionMount expect EACCES in this case too?
>   Should it be ENOTDIR?
>   It might be better to change
> 	errcode=EACCES
> 	test ! "$termslash" = "" && errcode=ENOTDIR
> 	open_file_as_bin -t -w $file -E $errcode

I'd never got to the end of the impermissible test because the utimes test
fails on both unionmount and overlayfs.  I'll have to address the termslash
alterations at some point.

> - readlink.test,
> 	fs_op readlink $file -R $testdir/direct_dir_sym100 ${termslash:+-E EINVAL}
>   It expects "$testdir/direct_dir_sym100". Does it mean UnionMount
>   converts the target path?
>   For example,
>   - /u = /rw + /ro
>   - /rw/symlinkA doesn't exist
>   - /ro/symlinkA points to /ro/fileA

No.  Unionmount unions are constructed by mounting the lower layers all on the
same mountpoint and then mounting the union over them, also on the same
mountpoint.  So their paths are coincident.

>   Does readlink(2) return "/u/fileA" instead of /ro/fileA?"

No.

The test suite sets the lower symlink to point to the union path for its target.

[root@andromeda union-testsuite]# readlink /lower/a/indirect_dir_sym100 
/mnt/a/direct_dir_sym100

> And all tests should be done by a superuser?

Yes.  It also will test things like mknod at some point and runs things as
other users to test permissions.

David
