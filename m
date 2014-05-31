Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaEaPjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:39:44 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52806 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaEaPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:39:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Sat, 31 May 2014 17:37:52 +0200
Message-ID: <5507340.nVBP5LFtqn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140531011450.GJ14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:I0EaPCPKe5JS1JtAjHeyhRoq19yhlI5OCVJGOrSk81w
 rzPaBLIBxT2J3AX5SmzFYM1MxGs5GwJdKFNK//xH/7issJIqcF
 MHb74haE6LfqeZy3uLcbPscr05zijTx4Ac5TxtZgYR0Ur7I0yc
 3/fEPruZnMDyoVopR/ey83XeCiWwflqCJ6O7exgwBcoPuy/KII
 1UfVFpQvVAa1oACZxthac47ARb8jxojzXgtE4cgUUfTxc9sgit
 zzNMGFUpDh1aqNoWOSImTIy1GWpwiQsWjTxutwqR9Wmd5AHnl1
 bcpOAWbbHdq8zSG4YYkLS07JmOY25fXwPnAHu+Jgq8divR5pxN
 TN9PZ0hJXi5G8GUa6tNQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 11:14:50 Dave Chinner wrote:
> On Fri, May 30, 2014 at 05:41:14PM -0700, H. Peter Anvin wrote:
> > On 05/30/2014 05:37 PM, Dave Chinner wrote:
> > > 
> > > IOWs, the filesystem has to be able to reject any attempt to set a
> > > timestamp that is can't represent on disk otherwise Bad Stuff will
> > > happen,
> > 
> > Actually it is questionable if it is worse to reject a timestamp or just
> > let it wrap.  Rejecting a valid timestamp is a bit like "You don't
> > exist, go away."
> 
> I think having the new systems calls being able to
> return EINVAL if the value cannot be stored permanently on disk
> correctly is the right thing to do. Having it silently mangled
> by the filesystem and returning "everything is just fine, trust me"
> is close to the worst solution I can think of. That's exactly what
> leads to overflow bugs occurring....

While going through the file systems, I was wondering whether
we should have the times stop at the end of each file systems
epoch rather than wrap around.

> > > and filesystems have to be able to specify in their on
> > > disk format what timestamp encoding is being used. The solution will
> > > be different for every filesystem that needs to support time beyond
> > > 2038.
> > 
> > Actually the cutoff can be really different for each filesystem, not
> > necessarily 2038.  However, I maintain the above still holds.
> 
> Sure, but all filesystems are supposed to handle at least the
> current unix epoch.

In my list at http://kernelnewbies.org/y2038, I found that almost
all file systems at least times until 2106, because they treat
the on-disk value as unsigned on 64-bit systems, or they use
a completely different representation. My guess is that somebody
earlier spent a lot of work on making that happen.

The exceptions are:

* exofs uses signed values, which can probably be changed to be
  consistent with the others.
* isofs has a bug that limits it until 2027 on architectures with
  a signed 'char' type (otherwise it's 2155).
* udf can represent times for many thousands of years through a
  16-bit year representation, but the code to convert to epoch
  uses a const array that ends at 2038.
* afs uses signed seconds and can probably be fixed
* coda relies on user space time representation getting passed
  through an ioctl.
* I miscategorized xfs/ext2/ext3 as having unsigned 32-bit seconds,
  where they really use signed.

I was confused about XFS since I didn't noticed that there are
separate xfs_ictimestamp_t and xfs_timestamp_t types, so I expected
XFS to also use the 1970-2106 time range on 64-bit systems today.

If we are using the variant of my patch that extends
indode_time->tv_sec to s64, nothing should change for XFS
at all, the main difference is that we if it gets extended
to wider on-disk timestamps, they will work the same way on
32-bit and 64-bit kernels. 

	Arnd
