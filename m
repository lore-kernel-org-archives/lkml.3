Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaAaAO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:14:28 -0500
Received: from cobra.newdream.net ([66.33.216.30]:48187 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaAaAO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:14:26 -0500
Date: Thu, 30 Jan 2014 16:14:25 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
In-Reply-To: <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1401301434420.25181@cobra.newdream.net>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com> <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com> <CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com> <20140130075421.GA10050@infradead.org>
 <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Linus Torvalds wrote:
> On Wed, Jan 29, 2014 at 11:54 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > For ->set_acl that's fairly easily doable and I actually had a version
> > doing that to be able to convert 9p.  But for ->get_acl the path walking
> > caller didn't seem easily feasible.  ->get_acl actually is an invention
> > of yours, so if you got a good idea to get the dentry to it I'd love
> > to be able to pass it.
> 
> Yeah, that's pretty annoying, largely because that path is also
> RCU-walk aware, which does *not* need this all (because it will never
> call down into the filesystem - if the acl isn't found in the cached
> acl's, we just abort).
> 
> And we're going through that very common "generic_permission()" thing
> that in turn is also often called from the low-level filesystens, and
> it's all fairly tightly integrated with __inode_permission() etc.
> 
> In the end, all the original call-sites should have a dentry, and none
> of this is "fundamental". But you're right, it looks like an absolute
> nightmare to add the dentry pointer through the whole chain. Damn.
> 
> So I'm not thrilled about it, but maybe that "d_find_alias(inode)" to
> find the dentry is good enough in practice. It feels very much
> incorrect (it could find a dentry with a path that you cannot actually
> access on the server, and result in user-visible errors), but I
> definitely see your argument. It may just not be worth the pain for
> this odd ceph case.
> 
> That said, if the ceph people decide to try to bite the bullet and do
> the required conversions to pass the dentry to the permissions
> functions, I think I'd take it unless it ends up being *too* horribly
> messy.

FWIW the dentry isn't useful in the get case; it's only on put that it is 
currently used.  And now that I look closely, it is only being used by 
ceph_setattr to associate the update with the parent directory for the 
purposes of fsync(dirfd)... which is, I think, incorrect anyway (that 
should only flush out/wait for namespace modifications, not inode attr 
updates).

So I think it's fine as is, and we'll clean this up later.

I do have a couple patches on top of what's in your tree, though, that 
clean up a couple duplicated lines in your fix and apply Christoph's 
cleanup:

 git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

Thanks!
sage
