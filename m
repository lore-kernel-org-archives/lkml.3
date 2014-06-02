Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaFBMwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:52:49 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60636 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaFBMwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:52:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 14:52:13 +0200
Message-ID: <15496653.1vSv1RUCC0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140602115737.GB14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <4178301.j9kWdGCRLC@wuerfel> <20140602115737.GB14276@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Og6uvkG7nhSQ3FBH+zzsRjY83ZWdKEvQC6Cgd1rzE79
 LgH0wKzyn8AkTY/kJQQ2b1U/wW0ETUZgy/E0p2mJpAiy87I5mi
 OtgXeNND/vPcNTI8Oi4L4MzkfFa/yaPC38RiixMusSUJHSU6pT
 L9oW8z4Hf1R+in1vhlkdbaOQ2VLHVLlx3DRxhK7Wn9t86tdZkH
 L85M0RtSOv8exNH+ymxWV/C9Vwr9v0DjIOJXk0HEZGj7iX3ylL
 6CYYstSCakFz/TIdH6CVCWp7uzWuPZ0u7vOSR4FEBI1PHx47e/
 BgJq68NoNSnBm71/O1I7gchdMFtaY+59jRkD2WOdMDBhDJpXWZ
 tMlVXunpEkCUlDkvgu2g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 07:57:37 Theodore Ts'o wrote:
> On Mon, Jun 02, 2014 at 12:56:42PM +0200, Arnd Bergmann wrote:
> > 
> > I think you misunderstood what I suggested: the intent is to avoid
> > seeing things break in 2038 by making them break much earlier. We have
> > a solution for ext2 file systems, it's called ext4, and we just need
> > to ensure that everybody knows they have to migrate eventually.
> > 
> > At some point before the mid 2030ies, you should no longer be able to
> > build a kernel that has support for ext2 or any other module that will
> > run into bugs later....
> 
> Even for ext4, it's not quite so simple as that.  You only have
> support for times post 2038 if you are using an inode size > 128
> bytes.  There are a very, very large number of machines which even
> today, are using 128 byte inodes with ext4 for performance reasons.
> 
> The vast majority of those machines which I know of can probably move
> to 256 byte inodes relatively easily, since hard drive replacement
> cycles are order 5-6 years tops, so I'm not that concerned, but it
> just goes to show this is a very complicated problem.

One stupid question about the current code:

static inline void ext4_decode_extra_time(struct inode_time *time, __le32 extra)
{                               
       if (sizeof(time->tv_sec) > 4)
               time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
                               << 32;
       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
}       

#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)                        \
do {                                                                           \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))                      \
                (einode)->xtime.tv_sec =                                       \
                        (signed)le32_to_cpu((raw_inode)->xtime);               \
        else                                                                   \
                (einode)->xtime.tv_sec = 0;                                    \
        if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))            \
                ext4_decode_extra_time(&(einode)->xtime,                       \
                                       raw_inode->xtime ## _extra);            \
        else                                                                   \
                (einode)->xtime.tv_nsec = 0;                                   \
} while (0)

For a time between 2038 and 2106, this looks like xtime.tv_sec is
negative when ext4_decode_extra_time gets called, so the '|=' operator
doesn't actually do anything. Shouldn't that be '+='?

	Arnd
