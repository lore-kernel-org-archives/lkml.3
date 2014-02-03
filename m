Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaBCLNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:13:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41188 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaBCLNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:13:37 -0500
Date: Mon, 3 Feb 2014 11:13:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
Message-ID: <20140203111326.GV10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
 <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
 <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
 <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
 <20140203102943.GF11829@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203102943.GF11829@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:29:43AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 30, 2014 at 02:01:38PM -0800, Linus Torvalds wrote:
> > In the end, all the original call-sites should have a dentry, and none
> > of this is "fundamental". But you're right, it looks like an absolute
> > nightmare to add the dentry pointer through the whole chain. Damn.
> > 
> > So I'm not thrilled about it, but maybe that "d_find_alias(inode)" to
> > find the dentry is good enough in practice. It feels very much
> > incorrect (it could find a dentry with a path that you cannot actually
> > access on the server, and result in user-visible errors), but I
> > definitely see your argument. It may just not be worth the pain for
> > this odd ceph case.
> 
> It's not just ceph.  9p fundamentally needs it and I really want to
> convert 9p to the new code so that we can get rid of the lower level
> interfaces entirely and eventually move ACL dispatching entirely
> into the VFS.  The same d_find_alias hack should work for 9p as well,
> although spreading this even more gets uglier and uglier.  Similarly
> for CIFS which pretends to understand the Posix ACL xattrs, but doesn't
> use any of the infrastructure as it seems to rely on server side
> enforcement.

9P is going to be fun to deal with; that's why I've ended up abandoning
vfs.git#experimental-xattr last year.  We probably want to move FIDs
from dentries to inodes there, and rely in ->getxattr() et.al. upon
having already done ->d_revalidate() on some dentry for that inode.

Another pile of fun is fsnotify_xattr() call in __vfs_setxattr_noperm()
and the whole misbegotten IMA/EVM mess ;-/  

See #experimental-xattr - a lot of stuff in that direction is sitting there;
might turn out to be useful.
