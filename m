Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaBDP6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:58:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaBDP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:57:56 -0500
Date: Tue, 4 Feb 2014 07:57:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140204155744.GA3974@infradead.org>
References: <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
 <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
 <20140203102943.GF11829@infradead.org>
 <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
 <20140203215908.GD10323@ZenIV.linux.org.uk>
 <CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
 <20140203224034.GF10323@ZenIV.linux.org.uk>
 <1391513615.2766.18.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391513615.2766.18.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 11:33:35AM +0000, Steven Whitehouse wrote:
> To diverge from that topic for a moment, this thread has also brought
> together some discussion on another issue which I've been pondering
> recently.... that of whether the inode operations for get/set_xattr
> should take a dentry or not. I had thought that we'd come to the
> conclusion that 9p made it impossible to swap the current dentry
> argument for an inode, and I was about to send a patch for selinux
> support on clustered fs on that basis. However the discussion in this
> thread has made me wonder whether that really is the case or not.... Al,
> can you confirm whether your xattr-experimental patches are still under
> active consideration?

My plan was to work on the 9p and cifs conversions using the
d_find_alias hack we have in ceph right now.  That means the base work
could switch to passed in dentries or in case of 9p the per-inode fids
easily.

> The other question that I have relating to that side of things, is why
> security_inode_permission() is called from __inode_permission() rather
> than from generic_permission() ? Maybe there is a good reason, but I
> can't immediately see what it is at the moment.

Seems like almost everything of the security_* family is called from the
VFS instead of the filesystem.  There's also some very odd other
behaviour in there, e.g. for the xattrs sets are handed to the
filesystem first, and then the xattr layer calls into the security
layer, which for reads the filesystems is never reached at all.

> In response to the question elsewhere about GFS2 calling
> gfs2_permission() after the vfs has already done its checks, that is
> indeed down to needing to ensure that we have the cluster locks when
> this check is called. More importantly to know that things haven't
> changed since the VFS called the same function in case we've raced with
> another node changing the permissions, for example. There are a number
> of cases where we redo vfs level checks for this reason,

Seems like we should be able to grab a cluster lock where we grab
i_mutex in the namespace code to avoid having to redo all these checks.

