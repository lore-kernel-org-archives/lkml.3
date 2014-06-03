Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaFCJSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 05:18:20 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50073 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaFCJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 05:18:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Tue, 03 Jun 2014 11:16:50 +0200
Message-ID: <5502404.8z4rGLMfhs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140603084130.GF14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <5082342.alZgfaU1Q0@wuerfel> <20140603084130.GF14410@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pt3DsXlHBsyPjmPaNAXDA9lHvUIrqsM+3a9qKR9v8tn
 liOdLy1q9zODdZPGc3FeSVP2cQDSg30BvSzoJUEJcFfGp4K1cd
 i1mLdWG3XP3e6rGXZ7K0MuGwj4rsIV8WOWZ5v0LX2zkIzYNo9o
 Figv2TerL8ouwO0iIFTql2pjJft7a0GLETcuYtxYIi10PK1Hoi
 atrzzVjqL5WVvVyJaFmo7Sgq3wgYov4I5cLKlQ5aWNEqQFAFLh
 bSHyBdu3h5+YJCSdLIDWLBwDtrMglMaw3RjLL/7Y9VOCUUpVTF
 QkttUlCfuel+SMJ/vAy9t4rTaQ5yGvmxzw+YzMXt8ec0uFPCNI
 Cx8v7LSCwd6qDNsYFxZU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2014 18:41:30 Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 09:33:36AM +0200, Arnd Bergmann wrote:
> > On Tuesday 03 June 2014 10:32:27 Dave Chinner wrote:
> > > On Mon, Jun 02, 2014 at 01:43:44PM +0200, Arnd Bergmann wrote:
> > > > On Monday 02 June 2014 10:28:22 Dave Chinner wrote:
> > > > > On Sun, Jun 01, 2014 at 10:24:37AM +1000, Dave Chinner wrote:
> > > > > > On Sat, May 31, 2014 at 05:37:52PM +0200, Arnd Bergmann wrote:
> > > > My patch set
> > > > (at least with the 64-bit tv_sec) just gets 32-bit kernels to behave
> > > > more like 64-bit kernels regarding inode time stamps, which does
> > > > impact all the file systems that the a 64-bit time or the NFS
> > > > unsigned epoch (1970-2106), while your patch extends the file
> > > > system internal epoch (1901-2038 for XFS) so it can be used by
> > > > anything that knows how to handle larger than 32-bit second values
> > > > (either 64-bit kernel or 32-bit with inode_time patch).
> > > 
> > > Right, but the issue is that 64 bit second counters are broken right
> > > now because most filesystems can't support more than 32 bit values.
> > > So it doesn't matter whether it's 32 bit or 64 bit machines, just
> > > adding explicit support for >32 bit second counters without doing
> > > anything else just extends that brokenness into the indefinite
> > > future.
> > 
> > Of course, "most filesystems" are obsolete, and most of the modern
> > file systems already support >32 bit timestamps: ext4, btrfs, cifs,
> > f2fs, 9p, nfsv4, ntfs, gfs2, ocfs2, fuse, ufs2. Everything else
> > except xfs, ext2/3 and exofs uses the nfsv3 interpretation on
> > 64-bit systems, which interprets time stamps with the high bit
> > set as years 2038-2106 rather than 1903-1969.
> 
> I'm not sure that's an entirely correct representation - the
> remainder of the 32 bit-only timestamp filesystems don't actively
> interpret the time stamp at all - it's just an opaque 32 bit value.
> hence the interpretation of the value is dependent on whether the
> kernel treats it as signed or unsigned....

As I mentioned elsewhere in the thread, I don't the way it's handled
is intentional, but it's definitely the file system code that does
the assignment to the timeval and decides on the interpretation, doing
either

	inode->i_mtime.tv_sec = (signed)le32_to_cpu(raw_inode.mtime);

or

	inode->i_mtime.tv_sec = le32_to_cpu(raw_inode.mtime);


	Arnd
