Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3CPN57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:57:59 -0400
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:47014 "EHLO
	mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab3CPN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:57:58 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Robo Bot <apw@canonical.com>,
        Felix Fietkau <nbd@openwrt.org>, Neil Brown <neilb@suse.de>,
        Jordi Pujol <jordipujolp@gmail.com>, ezk@fsl.cs.sunysb.edu,
        David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Miklos Szeredi <mszeredi@suse.cz>
In-Reply-To: <CA+55aFxd_jSc75pfhNQ6jTbwcQkDfNqALMNThYtgBsH0Z7tA4Q@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <20130313160854.54ac0491044371b4db214698@linux-foundation.org> <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com> <20130315012541.GU21522@ZenIV.linux.org.uk> <19058.1363320936@jrobl> <20130315044411.GW21522@ZenIV.linux.org.uk> <20079.1363324154@jrobl> <CA+55aFxd_jSc75pfhNQ6jTbwcQkDfNqALMNThYtgBsH0Z7tA4Q@mail.gmail.com>
Date: Sat, 16 Mar 2013 22:57:56 +0900
Message-ID: <8442.1363442276@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds:
> Yes. That would be lovely. And trivial for most filesystems to support.
>
> Sure, you could have an inode if you need to (not all filesystems may
> have a flag in the directory entry), so it would look like "mknod()"
> for the filesystem. But the filesystem might decide to never actually
> create the inode at all if it reconizes the node as a whiteout node.

I am not sure whether it is trivial for FS developers. But I agree that
it is the maintainer who can decide the most suitable method to whiteout
for that FS.


> Also note that it's only the "upper layer" filesystem that needs
> whiteout nodes. So it's not "all filesystems involved with overlayfs",
> it's only the upper ones. And they have to already support xattr, so
> I'm assuming in practice we're talking only a few cases, right? Just
> tmpfs, ext3, ext4 probably covers most cases..

I agree that tmpfs is majority.
In real world, people uses various fs as the upper RW layer. NFS is
popular too. Sometimes non-mainlined FSs are used such as glusterfs. In
the long history of aufs1 to aufs3, there have been xfs, smbfs, fuse,
ubifs and fat/vfat are used as far as I remember. (though I am not sure
users still use them)
It means that the unioning is used in various way of long-live systems,
not only on the short-live LiveCD systems.

And there are a use-case which uses aufs like a version control
system. For example,
- /aufs = /rw1 + /ro0
- all the changes are stored under /rw1.
- prepend a new top layer and set /rw1 readonly,
  /aufs = /rw2 + /ro1 (which was /rw1) + /ro0
- now /ro1 holds the past changes and later changes are all go to /rw2.
- on the next day/week/month,
  /aufs = /rw3 + /ro2 (which was /rw2) + /ro1 (which as /rw1) + /ro0

As a variation, there is a merging approach. It means moving files from
the upper RW to the lower RO and creates a new RO. In this variation,
the number of layers will not change.

Ah, I should have mentioned the difference between overlayfs and aufs.
- aufs supports muliple layers more than 2.
- direct access to the layers (bypassing aufs) is allowed.

If the underlying FS chooses the way to introduce a new d_type to
implement whiteout, then many applications have to support it. And the
above merging approach (or backup) will not be used until the
application completes supporting. When the FS is a network filesystem,
the new d_type has to be available on both of server and client. Of
course, the server may be other than linux. Even if FS is local, users
may setup dual-boot. And the other OS has to recognize the new d_type
value.
I still doubt it is a good approach.


J. R. Okajima
