Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaA3WBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:01:42 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36100 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaA3WBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140130075421.GA10050@infradead.org>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	<CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	<20140130075421.GA10050@infradead.org>
Date: Thu, 30 Jan 2014 14:01:38 -0800
X-Google-Sender-Auth: _DIEWyFus7OQvVzPyVbsjtw6GVw
Message-ID: <CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 11:54 PM, Christoph Hellwig <hch@infradead.org> wrote:
>
> For ->set_acl that's fairly easily doable and I actually had a version
> doing that to be able to convert 9p.  But for ->get_acl the path walking
> caller didn't seem easily feasible.  ->get_acl actually is an invention
> of yours, so if you got a good idea to get the dentry to it I'd love
> to be able to pass it.

Yeah, that's pretty annoying, largely because that path is also
RCU-walk aware, which does *not* need this all (because it will never
call down into the filesystem - if the acl isn't found in the cached
acl's, we just abort).

And we're going through that very common "generic_permission()" thing
that in turn is also often called from the low-level filesystens, and
it's all fairly tightly integrated with __inode_permission() etc.

In the end, all the original call-sites should have a dentry, and none
of this is "fundamental". But you're right, it looks like an absolute
nightmare to add the dentry pointer through the whole chain. Damn.

So I'm not thrilled about it, but maybe that "d_find_alias(inode)" to
find the dentry is good enough in practice. It feels very much
incorrect (it could find a dentry with a path that you cannot actually
access on the server, and result in user-visible errors), but I
definitely see your argument. It may just not be worth the pain for
this odd ceph case.

That said, if the ceph people decide to try to bite the bullet and do
the required conversions to pass the dentry to the permissions
functions, I think I'd take it unless it ends up being *too* horribly
messy.

               Linus
