Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab3EXAtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 20:49:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758014Ab3EXAtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 20:49:13 -0400
Date: Thu, 23 May 2013 20:49:06 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524004906.GA21171@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <20130522001603.GZ29466@dastard>
 <20130522025605.GA29767@redhat.com>
 <20130522040318.GG29466@dastard>
 <20130522041521.GA1837@redhat.com>
 <20130522051243.GH29466@dastard>
 <20130522052938.GA2573@redhat.com>
 <20130522055147.GI29466@dastard>
 <20130522215454.GL29466@dastard>
 <20130523184948.GA11151@redhat.com>
 <20130523223038.GB24543@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523223038.GB24543@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 08:30:38AM +1000, Dave Chinner wrote:

 > >  > Which I put just before the assert that is firing on your machine.
 > >  > 
 > >  > And, obviously, it isn't firing on mine and obviously shouldn't be firing on a
 > >  > mask of 0xa068.
 > > 
 > > With this, I get a spew of these when I start a kernel build..
 > > 
 > > [  964.378690] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff880221b5d970 path /davej/tmp/ccN2RrM5.s
 > > [  964.651927] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff88020ff80b90 path /davej/tmp/ccB1Cdmo.s
 > > [  964.867444] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff8802218a5bc0 path /davej/tmp/ccCUaXbG.s
 > > [  965.102661] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a95dac0, d 0xffff88020ffacde0 path /davej/tmp/cckMLf2X.s
 > > [  967.743312] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a93c200, d 0xffff88022212c250 path /davej/tmp/ccFMkBbA.s
 > > [  967.947154] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a93c200, d 0xffff8802226cc6f0 path /davej/tmp/cc5iX4SR.s
 > > [  968.009414] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a988000, d 0xffff8802219f1970 path /davej/tmp/ccvWCHTZ.o
 > > [  968.091504] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a9898c0, d 0xffff88022208de10 path /davej/tmp/cc9n6fnm.ld
 > > [  968.107997] XFS (sda2): xfs_setattr_size: mask 0xa068, masked 0x0 ii 0xffff88020a98dac0, d 0xffff880221160de0 path /davej/tmp/cc5rlvHu.le
 > 
 > Right, It's printing them out for every truncate that is done.
 > Just print on the conditional that is was triggering the assert...

I'm missing something.. That's what I did ?

-       ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+
+       if ((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
                        ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+                       ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0) {
+               struct dentry *d = d_find_alias(VFS_I(ip));
+               char buf[MAXPATHLEN];
+               char *ptr;
+
+               memset(buf, 0, MAXPATHLEN);
+               ptr = dentry_path(d, buf, MAXPATHLEN);
+               xfs_warn(mp, "%s: mask 0x%x, masked 0x%x ii 0x%p, d 0x%p path %s",
+                               __func__, mask,
+               (mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+                               ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
+                               ATTR_KILL_PRIV|ATTR_TIMES_SET)),
+                               ip, d, ptr);
+                       dput(d);
+       }

