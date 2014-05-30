Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaE3Dfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:35:36 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:52155 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaE3Dfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:35:34 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Unionmount and overlayfs testsuite
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, mszeredi@suse.cz
In-Reply-To: <28592.1401382081@warthog.procyon.org.uk>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk>
Date: Fri, 30 May 2014 12:35:31 +0900
Message-ID: <11446.1401420931@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells:
> http://git.infradead.org/users/dhowells/unionmount-testsuite.git

I've found some interesting cases.

- impermissible.test,
	open_file_as_bin -t -w $file -E EACCES
  When $termslash is "/", a '/' is appended to the expanded $file, such
  as "/path/fileA/". If fileA is a regular file, that path is obviously
  wrong. Does UnionMount expect EACCES in this case too?
  Should it be ENOTDIR?
  It might be better to change
	errcode=EACCES
	test ! "$termslash" = "" && errcode=ENOTDIR
	open_file_as_bin -t -w $file -E $errcode

- readlink.test,
	fs_op readlink $file -R $testdir/direct_dir_sym100 ${termslash:+-E EINVAL}
  It expects "$testdir/direct_dir_sym100". Does it mean UnionMount
  converts the target path?
  For example,
  - /u = /rw + /ro
  - /rw/symlinkA doesn't exist
  - /ro/symlinkA points to /ro/fileA
  Does readlink(2) return "/u/fileA" instead of "/u/fileA"?

And all tests should be done by a superuser?


J. R. Okajima
