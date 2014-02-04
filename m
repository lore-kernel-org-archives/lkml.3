Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaBDLe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:34:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbaBDLex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:34:53 -0500
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Steven Whitehouse <swhiteho@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
In-Reply-To: <20140203224034.GF10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	 <20140130075421.GA10050@infradead.org>
	 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
	 <20140203102943.GF11829@infradead.org>
	 <CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
	 <20140203215908.GD10323@ZenIV.linux.org.uk>
	 <CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
	 <20140203224034.GF10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 04 Feb 2014 11:33:35 +0000
Message-ID: <1391513615.2766.18.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 22:40 +0000, Al Viro wrote:
> > >> +static int gfs2_vfs_permission(struct dentry *dentry, struct inode *inode, int mask)
> > >> +{
> > >> +     return gfs2_permission(inode, mask);
> > >> +}
> > >
> > > Er...  You do realize that callers of gfs2_permission() tend to have
> > > the dentry in question, either directly or as ->d_parent of something
> > > they have?
> > 
> > Not true. Look closer.
> > 
> > Look at gfs2_lookupi() in particular, and check how it is called.
> 
> Yeowch...  gfs2_ok_to_move() is particulary nasty...  WTF do we need
> it for and why is it not racy as hell?

Well, the original intent was to prevent us from moving a directory into
one of its subdirectories, and thus creating a loop. It is only called
when the rename is moving a directory, and when the parent directories
(source and destination) are different.

I know there is a problem there, recently reported by Bruce Fields which
he came across when looking at the d_splice_alias issue. The bug that
Bruce found only shows up in the clustered case, and not in the single
node case though.

Which particular race are you worried about? This check is covered by
the rename glock, which is basically a cluster wide version of the vfs
level ->s_vfs_rename_mutex.

To diverge from that topic for a moment, this thread has also brought
together some discussion on another issue which I've been pondering
recently.... that of whether the inode operations for get/set_xattr
should take a dentry or not. I had thought that we'd come to the
conclusion that 9p made it impossible to swap the current dentry
argument for an inode, and I was about to send a patch for selinux
support on clustered fs on that basis. However the discussion in this
thread has made me wonder whether that really is the case or not.... Al,
can you confirm whether your xattr-experimental patches are still under
active consideration?

The other question that I have relating to that side of things, is why
security_inode_permission() is called from __inode_permission() rather
than from generic_permission() ? Maybe there is a good reason, but I
can't immediately see what it is at the moment.

In response to the question elsewhere about GFS2 calling
gfs2_permission() after the vfs has already done its checks, that is
indeed down to needing to ensure that we have the cluster locks when
this check is called. More importantly to know that things haven't
changed since the VFS called the same function in case we've raced with
another node changing the permissions, for example. There are a number
of cases where we redo vfs level checks for this reason,

Steve.


