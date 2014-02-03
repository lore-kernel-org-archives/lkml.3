Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaBCVUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:20:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42364 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaBCVUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:20:19 -0500
Date: Mon, 3 Feb 2014 21:19:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140203211955.GY10323@ZenIV.linux.org.uk>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 01:03:32PM -0800, Linus Torvalds wrote:

> What do you think? I guess this patch could be split up into two: one
> that does the "vfs_xyz()" helper functions, and another that does the
> inode_permission() change. I tied them together mainly because I
> started with the inode_permission() change, and that required the
> vfs_xyz() change.

Please, don't do that.  Half of that is pointless (e.g. what you are
doing with vfs_rmdir() - if anything, we could get rid of the first
argument completely, it's always victim->d_parent->d_inode and we are
holding enough locks for that to be stable) and ->permission() is
just plain wrong.

Result *is* a function of inode alone; the problem with 9P is that we
are caching FIDs in the wrong place.

What really happens is that protocol refers to objects by 32bit tokens,
given by server out to client.  Many of those can correspond to the
same file; think of those as file descriptors.  We are associating them
with dentries, but if you have several links to the same file a FID
acquired for either of them will do.

What we ought to do, AFAICS, is moving these guys from dentry to inode;
sure, to *get* one in the first place we need some dentry.  But by the
time ->setxattr() and friends get to see the inode, the caller has already
done things that make sure that some FID of his exists.

IOW, NAK.
