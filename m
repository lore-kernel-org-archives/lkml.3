Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaGHJ3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:29:30 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60128 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaGHJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:29:27 -0400
Date: Tue, 8 Jul 2014 11:29:17 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: Overlayfs rename bug
Message-ID: <20140708092848.GA26119@tucsk.piliscsaba.szeredi.hu>
References: <11446.1401420931@jrobl>
 <7184.1401439773@warthog.procyon.org.uk>
 <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
 <15839.1401786056@warthog.procyon.org.uk>
 <CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
 <CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
 <10013.1401791634@warthog.procyon.org.uk>
 <20140603132153.GA26512@tucsk.piliscsaba.szeredi.hu>
 <19281.1401809418@warthog.procyon.org.uk>
 <17091.1403628374@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17091.1403628374@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 05:46:14PM +0100, David Howells wrote:

> strace shows:
> 
> 	rename("/mnt/a/foo104", "/mnt/a/foo105") = 0
> 	lstat("/mnt/a/foo104", {st_mode=S_IFREG|0644, st_size=12, ...}) = 0
> 
> which shouldn't happen.

Sorry for the delay.  Following patch fixes it and tests now run fine.

Problem was that copy-up didn't set opaque flag on non-dir.  The reason this has
gone unnoticed is that the dentry on overlayfs was unhashed (to get rid of the
unneeded lower dentry reference) so after a new lookup the opaque flag would be
set correctly.  Rename, however, rehashed the copied up dentry and so old_opaque
and the opaque flag on old would become out-of-sync.

As a followup patch we could also unhash the copied dentry after the rename, but
that's just an optimization.

Thanks for the report and the great test suite!

Miklos


diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 1670dbe..274c857 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -255,9 +255,13 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	 * Easiest way to get rid of the lower dentry reference is to
 	 * drop this dentry.  This is neither needed nor possible for
 	 * directories.
+	 *
+	 * Non-directores become opaque when copied up.
 	 */
-	if (!S_ISDIR(stat->mode))
+	if (!S_ISDIR(stat->mode)) {
+		ovl_dentry_set_opaque(dentry, true);
 		d_drop(dentry);
+	}
 out:
 	dput(upper);
 	dput(newdentry);
