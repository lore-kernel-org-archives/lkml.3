Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaE2Qgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:36:38 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:61072 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbaE2Qgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:36:35 -0400
Date: Thu, 29 May 2014 18:36:29 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: More kernel errors with overlay filesystem v22
Message-ID: <20140529163629.GN17233@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpeguyE0cg+RAEwOR89=qTGnr2OZFuhZ4tmAfkMLn5-DP_wg@mail.gmail.com>
 <27993.1401360881@warthog.procyon.org.uk>
 <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
 <28313.1401362925@warthog.procyon.org.uk>
 <20140529120734.GM17233@tucsk.piliscsaba.szeredi.hu>
 <22475.1401380602@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22475.1401380602@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 05:23:22PM +0100, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Fixes pushed to overlayfs.v22 (and overlayfs.current).  Will
> > eventually fold these into the main overlayfs patch.
> 
> Okay... those are fixed.  Here's the next:
> 

generic_file_splice_write() uses I_MUTEX_CHILD.  Not sure why, though, parent
shouldn't be locked.  Maybe it's some remaining thing from the days when pipes
used the i_mutex on the pipe inode.  Probably should just remove that notation
and things will work.

Untested.

Thanks,
Miklos

diff --git a/fs/splice.c b/fs/splice.c
index fb1094bbe5af..3703c512c46e 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1019,7 +1019,7 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		if (ret <= 0)
 			break;
 
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
+		mutex_lock(&inode->i_mutex);
 		ret = file_remove_suid(out);
 		if (!ret) {
 			ret = file_update_time(out);
