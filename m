Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbaFBPDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:03:21 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49310 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaFBPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:03:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 17:01:20 +0200
Message-ID: <5896675.3VErDJM7s2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140602130700.GC14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <15496653.1vSv1RUCC0@wuerfel> <20140602130700.GC14276@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SNdR1vrDuzzqVL0vQDRk1V2ukWgeZoI99UU1eid5LlS
 fuLI/t6HzX7M9Tnf1nuIEi1ng1T9OJqx0VoUQe6fdJBd4Ekihd
 7N8SqHag7FfGUYfFegVzGKUZ+c9VsQO8ULEqg3Zk9v/qOPFGeZ
 6aCS5C1gKy0EPfu8QLUDawOWTffgbh8+7IJb5frlnXHUmSfqKT
 lkL8OEZ6EJlo4ovNEJSEiS+wyGCC/toA63BIm+8lkpGyaF7tV4
 rXVucuDJW2Qg6AYdXyVxh4ddn8D6nAIHkdaFlJI9/eJ7C4eRRQ
 Zbm4ZFBfPh7frttxMCvSwnaImngDvp0ERED3X+zfqidNx8TCz0
 j/6zcgRe2CXoVVHGlz20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 09:07:00 Theodore Ts'o wrote:
> Yes, there are some ongoing dicussions about changing the post-2038
> encoding of the timestamp in ext4, which is why this hasn't been fixed
> yet.  The main thing that's been missing is time for me to review the
> patches, and a good way of writing regression tests that will work (or
> at least not fail) on build environments with a 32-bit time_t and
> 32-bit-only capable versions of functions such as gmtime(3).
> 
> And given current discussions, I may want to think about some kind of
> superblock flag to allow the use of a 32-bit unsigned encoding for
> file systems using a 128-byte inode, with a way of setting that flag
> after scanning the file system to make sure there are no times that
> are previous to January 1, 1970.  (Or more generally, allow any epoch
> to be defined using a 64-bit time_t offset stored in the superblock...)

FWIW, I've gone through the other file system implementations once
more. The most common pattern I've encountered is to have a read_inode
function with

	inode->i_mtime = le32_to_cpu(raw_inode->mtime);

which results in interpreting the time as 'signed' on 32-bit
kernels, but as 'unsigned' on 64-bit kernels. This could have been
done intentionally to extend the valid time range to 2106 on 64-bit
kernels, but it seems more likely that the code was written with
no thought given to 64-bit time_t at all. I see this pattern on
p9fs (old protocol only), afs, bfs, ceph, efs, freevxfs, hpfs, jffs2,
jfs, minix, nfsv2/v3 (this was clearly intentional and is
spelled out in the RFC), qnx4, qnx6, reiserfs, squashfs, sysv,
and ufs (protocol version 1 only).

The other behavior I see is to treat the on-disk 32-bit value
as signed on both 32-bit and 64-bit kernels:

	inode->i_mtime = (signed)le32_to_cpu(raw_inode->mtime);

this seems to be done intentionally in all cases, to maintain
compatibility between 32-bit and 64-bit kernels, but it's
relatively rare: exofs, ext2/3/4 (good old inodes) and xfs
are the only ones doing this.

In case of ext2/3/4, the sign handlign was introduced here:
http://www.spinics.net/lists/linux-ext4/msg01758.html

exofs and xfs seem to have done it like this for all of git
history.

	Arnd
