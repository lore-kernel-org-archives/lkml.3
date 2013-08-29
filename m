Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3H2Xd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:33:26 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49181 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050Ab3H2XdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:33:24 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 19:33:24 EDT
X-Sasl-enc: B2H1x0/3kFDXVKGH5CQEO0Lx606Lqmc14rXAfOi+CEal 1377818679
Message-ID: <1377818677.2355.25.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed
 revalidate
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        rwheeler@redhat.com, avati@redhat.com, bfoster@redhat.com,
        dhowells@redhat.com, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Date: Fri, 30 Aug 2013 07:24:37 +0800
In-Reply-To: <1377748272.9297.47.camel@tucsk.piliscsaba.szeredi.hu>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	 <20130821054055.GN27005@ZenIV.linux.org.uk>
	 <1377748272.9297.47.camel@tucsk.piliscsaba.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 05:51 +0200, Miklos Szeredi wrote:
> Ian,
> 
> I'm having problems fully understanding what autofs4 is trying to do
> with have_submounts().

OK, I don't really care how I do it so I'm happy to change.

> 
> 
> > On Wed, 2013-08-21 at 06:40 +0100, Al Viro wrote:
> 
> > fs/autofs4/dev-ioctl.c:542:             err = have_submounts(path.dentry);
> 
> This is an ioctl() asking whether we have anything mounted on the autofs
> mount.  Using have_submounts() and then a separate follow_down() looks
> racy.  have_submounts() could succeed and then follow_down() could fail.
> Or the other way round.  Shouldn't the two cases be handled separately
> here?  If the autofs is a just a simple trigger then use follow_down().
> If it's a multi-mount thing, then use have_submounts().

Right but IIRC I don't think I actually use the returned s_magic ATM but
I use the return of have_submounts() a lot.

> 
> What is the userspace automount daemon using this for?  Do we really
> need the recursive check for submounts?
> 
> 
> > fs/autofs4/root.c:381:                  if (have_submounts(dentry)) {
> 
> Here it explicitly says it's for v5 and for rootless mutli-mount.  So
> for example:
> 
> /mnt/auto/            root of an indirect mount

or the root of direct mount for that matter.

> /mnt/auto/foo         directory with DCACHE_NEED_AUTOMOUNT
> /mnt/auto/foo/bar     directory without DCACHE_NEED_AUTOMOUNT
> /mnt/auto/foo/bar/baz directory with an automount trigger mounted on it
> 
> In this case when d_automount for "foo" is called we don't call the
> userspace daemon because things are mounted under foo.  If there was no
> trigger under baz, then we would try to handle "foo" as an indirect
> mount and call userspace.
> 
> But it's pretty confusing.  Do we really *ever* need to call automount
> on "foo" if it was part of a multi-mount thing? 

That's right, the directory isn't simple_empty() so there's no callback.

The problem is we can't just use the fact that the directory is empty to
determine that there are no mounts at all underneath.

I understand your thinking, about deciding whether to callback to the
daemon, but that's not what the ioctl above is used for.

The main use is to be able to find out if the given directory is a
mountpoint as defined by the description in the comment above the
function. This saves having to scan the mount table to find out and is a
huge saving on systems with lots of mounts. In the past I've often
needed an answer the question "is this an autofs mount or some other
type" and that's why I stick s_magic in the return as well.

> 
> > fs/autofs4/waitq.c:338:         if (have_submounts(dentry))
> 
> And here we re-validate the thing after taking another autofs4 lock.
> Why this double checking?

This is a different case and is often not in play at times when autofs
is checking if the directory is a "mountpoint". Such as when trying to
re-construct a tree of mounts at startup.

The check in waitq.c above "is" used to validate the need to callback to
the daemon to request a mount.

As I said, any suggestions how to achieve this without calling
have_submounts() are welcome.

Ian


