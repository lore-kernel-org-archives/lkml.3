Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaBCVXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:23:43 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaBCVXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:23:41 -0500
Date: Mon, 3 Feb 2014 13:23:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140203212336.GA31966@infradead.org>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
 <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
 <20140203102943.GF11829@infradead.org>
 <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:03:32PM -0800, Linus Torvalds wrote:
> Now, to be honest, pushing it down one more level (to
> generic_permission()) will actually start causing some trouble. In
> particular, gfs2_permission() fundamentally does not have a dentry for
> several of the callers.

Looking over the gfs2 code the problem seems to be that it duplicates
permissions checks from the may_{lookup,create,linkat,delete}, most
likely because it needs cluster locking in place for them.  The right
fix seems to be to optionally call the filesystem from those.  That
being said I wonder how ocfs2 or network filesystems get away without
that.

> What do you think? I guess this patch could be split up into two: one
> that does the "vfs_xyz()" helper functions, and another that does the
> inode_permission() change. I tied them together mainly because I
> started with the inode_permission() change, and that required the
> vfs_xyz() change.

The changes look good to me, and yes I think they should be split.
I'll see if I can take this further, but doing something non-hacky
in GFS2 would be the first step here.

