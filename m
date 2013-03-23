Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3CWFiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 01:38:08 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:46574 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3CWFiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 01:38:06 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        jack@suse.cz, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com, mszeredi@suse.cz
In-Reply-To: <20130323044140.GS21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <1944.1363525619@warthog.procyon.org.uk> <13789.1363973875@jrobl> <20130322181111.GP21522@ZenIV.linux.org.uk> <20130322182107.GQ21522@ZenIV.linux.org.uk> <23399.1364006951@jrobl> <20130323044140.GS21522@ZenIV.linux.org.uk>
Date: Sat, 23 Mar 2013 14:37:46 +0900
Message-ID: <26769.1364017066@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> Different ->i_mutex; you are holding one on the parent directory already.

Let me make sure. In your scenario,
- processA writes something into the union, and the unioning fs operates
  the writable layer. After sb_start_write() succeeds, processA should
  not block by the reason of fsfreeze.
- processC causes the copyup.
  The current aufs implementation holds parent->i_mutex on the writable
  layer during the copyup. The parent->i_mutex can make processA
  blocking.

Now I am considering the copyup approach you suggested in another mail,
and I am going to replace your
	"unlink the target, re-link later, no dir lock during copyup"
by
	"make it hidden instead of unlinking, rename the correct name
	later, no dir lock during copyup"
since I am not sure all FSs can operate "->link with the unlinked
one". I guess most FS can handle it, but I don't want to make sure
everything particulary remote fs, journals.

To make a file "hidden", I guess I can use the aufs "doubley whiteouted"
approach. As you might know, aufs prepends the ".wh." prefix to the
filename as whiteout. With one more prefix, the name loses the role of
whiteout. Aufs simply ignores such doubly whiteouted name.
The demerit is that aufs has to limit the length of the name.


J. R. Okajima
