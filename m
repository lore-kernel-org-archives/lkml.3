Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3COEPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:15:44 -0400
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:37665 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3COEPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:15:41 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
In-Reply-To: <20130315012541.GU21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <20130313160854.54ac0491044371b4db214698@linux-foundation.org> <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com> <20130315012541.GU21522@ZenIV.linux.org.uk>
Date: Fri, 15 Mar 2013 13:15:36 +0900
Message-ID: <19058.1363320936@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> Umm...  I would prefer it to go through vfs.git, with serious modifications.
> I really don't like the idea of xattr-based whiteouts, for example.

I'd ask you how do you think another whiteout approach?
Here is a part of a posts which describes about aufs2 in 2009
<http://marc.info/?l=linux-kernel&m=123934927611907&w=2>

	:::
+- whiteout is hardlinked in order to reduce the consumption of inodes
+  on branch
	:::
+- kernel thread for removing the dir who has a plenty of whiteouts
	:::
+The whiteout is for hiding files on lower branches. Also it is applied
+to stop readdir going lower branches.
+The latter case is called \[oq]opaque directory.\[cq] Any
+whiteout is an empty file, it means whiteout is just an mark.
+In the case of hiding lower files, the name of whiteout is
+\[oq]\*[AUFS_WH_PFX]<filename>.\[cq]
+And in the case of stopping readdir, the name is
+\[oq]\*[AUFS_WH_PFX]\*[AUFS_WH_PFX].opq\[cq] or
+\[oq]\*[AUFS_WH_PFX]__dir_opaque.\[cq] The name depends upon your compile
+configuration
+CONFIG_AUFS_COMPAT.
+.\" All of newly created or renamed directory will be opaque.
+All whiteouts are hardlinked,
+including \[oq]<writable branch top dir>/\*[AUFS_WH_BASE].\[cq]
	:::
+The whiteout in aufs is very similar to Unionfs's. That is represented
+by its filename. UnionMount takes an approach of a file mode, but I am
+afraid several utilities (find(1) or something) will have to support it.
+
+Basically the whiteout represents "logical deletion" which stops aufs to
+lookup further, but also it represents "dir is opaque" which also stop
+lookup.
+
+In aufs, rmdir(2) and rename(2) for dir uses whiteout alternatively.
+In order to make several functions in a single systemcall to be
+revertible, aufs adopts an approach to rename a directory to a temporary
+unique whiteouted name.
+For example, in rename(2) dir where the target dir already existed, aufs
+renames the target dir to a temporary unique whiteouted name before the
+actual rename on a branch and then handles other actions (make it opaque,
+update the attributes, etc). If an error happens in these actions, aufs
+simply renames the whiteouted name back and returns an error. If all are
+succeeded, aufs registers a function to remove the whiteouted unique
+temporary name completely and asynchronously to the system global
+workqueue.
	:::

Latest version is aufs3 (for linux-3.x series), there is no essential
changes about whiteout since aufs2.


J. R. Okajima
