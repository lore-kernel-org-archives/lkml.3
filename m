Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaEZB4q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 21:56:46 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:47875 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaEZB4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 21:56:45 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH 00/13] overlay filesystem v22
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@gmail.com,
        mszeredi@suse.cz
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
Date: Mon, 26 May 2014 10:56:42 +0900
Message-ID: <25513.1401069402@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for CC-ing me.

Here are some comments.

- I have no objection about the 0:0 char-dev whiteout, but you don't
  have to have the inode for each whiteout. The hardlink is better.
  In this version, you have <workdir> now. How about creating a "base"
  whiteout under workdir at the mount-time? Maybe it is possible by
  user-space "mount.overlayfs" or kernel-space. When the whiteout meets
  EMLINK, create a non-hardlink for that target synchronously and
  re-create the "base" asynchronously.

- Is <workdir>/work always visible to users? If a user accidentally
  removes it or its children, then some operations will fail. And he
  cannot recover it anymore. I know it cannot easily happen since its
  mode is 0. But I am afraid it will be a source of troubles. For
  example, find(1) or "ls -R /overlayfs" will almost always fail.

- If I remember correctly, the length of the dir mutex is held time has
  been pointed out. This version has still a long mutex held time, a whole
  copy-up operation includeing lookup, create, copy filedata, copy
  xattr/attr, and then rename. How about unlock the dir before copying
  filedata and re-lock and confirm after copying attr?

- When two processes copy-up a similar dir hierarcy, for example
  /dirA/dirB/fileC and /dirA/dirB/dirC/fileD, may a race condition
  happen? Two processes begin copying-up dirA, first processA succeeds
  it and second processB fails and returns EIO?

- All copy-up operations will be serialized due to <workdir> lock.

- In fstat(2) for a dir, is nlink set to 1 even it is removed?

- In readdir, it lookup or getattr to determine whether the found char
  dev entry is a whiteout or not. I know a char dev is not so many, so
  this overhead won't be large. But if its name represented "I am a
  whiteout", then the extra lookup or getattr would be unnecessary.


My personal impression for overall is overlayfs starts growing.
Also several parts look like towarding aufs. For example,
- a <workdir> means an overlayfs specific work. Aufs has such special
  dir for copying-up an unlinked file and a pseudo-link. Both are
  unnecessary for overlayfs because overlayfs copies-up a file in
  open(2) time, and doesn't support the hardlink between layers.
- many small wrapper functions for VFS helpers resemble to aufs
  too. In aufs, all they have lockdep_off/on.
- the internal cache for readdir allocating extra memory. Aufs adopts
  a simple hashing, while overlayfs uses rbtree.

But of course the fundamental design differences between overlayfs and
aufs are kept, such as
- a name-based union .vs. an inode-aware union
- multiple layers
- allow users to access the layers directly
- etc...

If LKML people consider merging overlayfs, then I'd ask to consier aufs
too. The basic design is unchanged since when I posted a few years ago.
http://marc.info/?l=linux-kernel&m=123934927611907&w=2

And latest one is
http://aufs.sourceforge.net


J. R. Okajima
