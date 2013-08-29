Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3H2DvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 23:51:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab3H2DvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 23:51:17 -0400
Message-ID: <1377748272.9297.47.camel@tucsk.piliscsaba.szeredi.hu>
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed
 revalidate
From: Miklos Szeredi <mszeredi@suse.cz>
To: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        rwheeler@redhat.com, avati@redhat.com, bfoster@redhat.com,
        dhowells@redhat.com, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Date: Thu, 29 Aug 2013 05:51:12 +0200
In-Reply-To: <20130821054055.GN27005@ZenIV.linux.org.uk>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	 <20130821054055.GN27005@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian,

I'm having problems fully understanding what autofs4 is trying to do
with have_submounts().


> On Wed, 2013-08-21 at 06:40 +0100, Al Viro wrote:

> fs/autofs4/dev-ioctl.c:542:             err = have_submounts(path.dentry);

This is an ioctl() asking whether we have anything mounted on the autofs
mount.  Using have_submounts() and then a separate follow_down() looks
racy.  have_submounts() could succeed and then follow_down() could fail.
Or the other way round.  Shouldn't the two cases be handled separately
here?  If the autofs is a just a simple trigger then use follow_down().
If it's a multi-mount thing, then use have_submounts().

What is the userspace automount daemon using this for?  Do we really
need the recursive check for submounts?


> fs/autofs4/root.c:381:                  if (have_submounts(dentry)) {

Here it explicitly says it's for v5 and for rootless mutli-mount.  So
for example:

/mnt/auto/            root of an indirect mount
/mnt/auto/foo         directory with DCACHE_NEED_AUTOMOUNT
/mnt/auto/foo/bar     directory without DCACHE_NEED_AUTOMOUNT
/mnt/auto/foo/bar/baz directory with an automount trigger mounted on it

In this case when d_automount for "foo" is called we don't call the
userspace daemon because things are mounted under foo.  If there was no
trigger under baz, then we would try to handle "foo" as an indirect
mount and call userspace.

But it's pretty confusing.  Do we really *ever* need to call automount
on "foo" if it was part of a multi-mount thing? 

> fs/autofs4/waitq.c:338:         if (have_submounts(dentry))

And here we re-validate the thing after taking another autofs4 lock.
Why this double checking?

Thanks,
Miklos

