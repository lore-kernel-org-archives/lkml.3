Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaG1ObP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:31:15 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:53671 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaG1ObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:31:10 -0400
From: "Zuckerman, Boris" <borisz@hp.com>
To: Abhijith Das <adas@redhat.com>, Dave Chinner <david@fromorbit.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Subject: RE: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
Thread-Topic: [RFC] readdirplus implementations: xgetdents vs dirreadahead
 syscalls
Thread-Index: Ac+qcIB3ISdxdNsSQ8uB03pqGYlSRQ==
Date: Mon, 28 Jul 2014 14:30:40 +0000
Message-ID: <4C30833E5CDF444D84D942543DF65BDA6DFE7D5A@G4W3303.americas.hpqcorp.net>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com>
 <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com>
 <20140725175257.GK17798@lenny.home.zabbo.net>
 <20140726003859.GF20518@dastard>
 <308078610.14129388.1406550142526.JavaMail.zimbra@redhat.com>
In-Reply-To: <308078610.14129388.1406550142526.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6SEVIPX016655

2 years ago I had that type of functionality implemented for Ibrix. It included readdir-ahead and lookup-ahead. We did not assume any new syscalls, simply detected readdir+ like interest on VFS level and pushed a wave of populating directory caches and plugging in dentry cache entries. It improved productivity of NFS readdir+ and SMB QueryDirectories more than 4x.

Regards, Boris



> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-
> owner@vger.kernel.org] On Behalf Of Abhijith Das
> Sent: Monday, July 28, 2014 8:22 AM
> To: Dave Chinner
> Cc: linux-kernel@vger.kernel.org; linux-fsdevel; cluster-devel
> Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead syscalls
> 
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "Zach Brown" <zab@redhat.com>
> > Cc: "Abhijith Das" <adas@redhat.com>, linux-kernel@vger.kernel.org,
> > "linux-fsdevel" <linux-fsdevel@vger.kernel.org>, "cluster-devel"
> > <cluster-devel@redhat.com>
> > Sent: Friday, July 25, 2014 7:38:59 PM
> > Subject: Re: [RFC] readdirplus implementations: xgetdents vs
> > dirreadahead syscalls
> >
> > On Fri, Jul 25, 2014 at 10:52:57AM -0700, Zach Brown wrote:
> > > On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
> > > > Hi all,
> > > >
> > > > The topic of a readdirplus-like syscall had come up for discussion
> > > > at last year's LSF/MM collab summit. I wrote a couple of syscalls
> > > > with their GFS2 implementations to get at a directory's entries as
> > > > well as stat() info on the individual inodes.
> > > > I'm presenting these patches and some early test results on a
> > > > single-node
> > > > GFS2
> > > > filesystem.
> > > >
> > > > 1. dirreadahead() - This patchset is very simple compared to the
> > > > xgetdents() system
> > > > call below and scales very well for large directories in GFS2.
> > > > dirreadahead() is
> > > > designed to be called prior to getdents+stat operations.
> > >
> > > Hmm.  Have you tried plumbing these read-ahead calls in under the
> > > normal
> > > getdents() syscalls?
> >
> > The issue is not directory block readahead (which some filesystems
> > like XFS already have), but issuing inode readahead during the
> > getdents() syscall.
> >
> > It's the semi-random, interleaved inode IO that is being optimised
> > here (i.e. queued, ordered, issued, cached), not the directory blocks
> > themselves. As such, why does this need to be done in the kernel?
> > This can all be done in userspace, and even hidden within the
> > readdir() or ftw/ntfw() implementations themselves so it's OS, kernel
> > and filesystem independent......
> >
> 
> I don't see how the sorting of the inode reads in disk block order can be accomplished in
> userland without knowing the fs-specific topology. From my observations, I've seen that
> the performance gain is the most when we can order the reads such that seek times are
> minimized on rotational media.
> 
> I have not tested my patches against SSDs, but my guess would be that the
> performance impact would be minimal, if any.
> 
> Cheers!
> --Abhi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
