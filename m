Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935240AbaEaOdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:33:31 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57503 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaEaOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:33:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [RFC 13/32] ext3: convert to struct inode_time
Date: Sat, 31 May 2014 16:32:58 +0200
Message-ID: <6394184.hHtXJE2Bp6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53899C95.80806@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-14-git-send-email-arnd@arndb.de> <53899C95.80806@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:x5nnwPh6XIwwIR1M816xl1GB2Xlh6qcP5TgML9kzJ5S
 tguP5BLW7oIeCUBsegvJECg7+vyL/vhHOBx57LMsFCSbGPmh/X
 30KpTX58kXAToJ+bU+ApIce69D/3Hxid7oWBVNoe4/2eLfNGd4
 W6XiJWNJfHRCNtVE4HVc6gR5j+sv5F9ynGmTUqJ+zbPIG45ncE
 kkY8mXuRqc08ztsx5zi3CMErCJI4ShE2/dk5Al98C3crBxq/QD
 pycOxHeOcN4v9hAiFS5wQEp9SOmcfVLZ1e+zm5HMymy89WulDq
 d1NuKKebPZO/ZSdAfSMu018ECsp+DBLrScHDm9phaBj8W+bDVn
 I6pNMWQBh+vxcP2lbktc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 02:10:45 H. Peter Anvin wrote:
> On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> > ext3fs uses unsigned 32-bit seconds for inode timestamps, which will work
> > for the next 92 years, but the VFS uses struct timespec for timestamps,
> > which is only good until 2038 on 32-bit CPUs.
> > 
> > This gets us one small step closer to lifting the VFS limit by using
> > struct inode_time in ext3. The on-disk format limit is lifted in ext4,
> > which will work until 2514.
> > 
> 
> This may be what the spec says, but when I experimented with this just
> now it does seem that both ext2 and ext3 actually interpret timestamps
> as *signed* 32-bit seconds.

Right, I can see that in ext3_iget() now:

        inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);

I may have just looked at ext3_do_update_inode(), which uses this
unsigned conversion:

	raw_inode->i_ctime = cpu_to_le32(inode->i_ctime.tv_sec);

and didn't realize that this is only half of the story, and since it
converts from (potentially 64-bit) long to u32, it doesn't matter
whether that is signed or unsigned.

I may have to go through all of them again to see if I made the same
mistake in other file systems as well.

	Arnd
