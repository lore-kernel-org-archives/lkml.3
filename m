Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaIEUlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:41:05 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:45997 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaIEUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:41:03 -0400
Date: Fri, 5 Sep 2014 15:40:54 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, seth.forshee@canonical.com
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user
 namespaces
Message-ID: <20140905204054.GC84919@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:44:53AM -0500, Seth Forshee wrote:
> Here's an updated set of patches for allowing fuse mounts from pid and
> user namespaces. I discussed some of the issues we debated with the last
> patch set (and a few others) with Eric at LinuxCon, and the updates here
> mainly reflect the outcome of those discussions.
> 
> The stickiest issue in the v1 patches was the question of where to get
> the user and pid namespaces from that are used for translating ids for
> communication with userspace. Eric told me that for user namespaces at
> least we need to grab a namespace at open or mount time and use only
> that namespace to prevent certain types of attacks. That rules out the
> suggestion of using the user ns of current in the read/write paths, and
> I think it makes sense to handle pid and user namespaces similarly. So
> in these patches I'm still grabbing the namespaces of current during
> mount, but I've added an additional check to fail the mount if the
> f_cred's userns for the fd to userspace doesn't match.
> 
> Another issue mentioned by Eric was what to use for i_[ug]id if the ids
> from userspace don't map into the user namespace, which is going to be a
> problem for any other filesystems which become mountable from user
> namespaces as well. We discussed a few options for addressing this, the
> most promising of which seems to be either using INVALID_[UG]ID for
> these inodes or creating vfs-wide "nobody" ids for this purpose. After
> thinking about it for a while I'm favoring using the invalid ids, but
> I'm hoping to solicit some more feedback.
> 
> For now these patches are using invalid ids if the user doesn't map into
> the namespace. I went through the vfs code and found one place where
> this could be handled better (addressed in patch 1 of the series). The
> only other issue I found was that currently no one, not even root, can
> change onwership of such inodes, but I suspect we can find a way around
> this.
> 
> The only other change since v1 is that I now fail changing file
> ownership if the new uid or gid does not map into the namespace used for
> userspace communication.

I forgot that I did change one other thing. In v1 I didn't allow fuseblk
mounts from user namespaces since I hadn't gotten around to testing or
looking at the differences between it and normal fuse mounts yet. I've
found time to do so since then and everything seems to be in good order,
so I've enabled mounting fuseblk in user namespaces as well in the v2
patches.

Thanks,
Seth
