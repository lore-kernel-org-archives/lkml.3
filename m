Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaDICaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:30:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55671 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDICah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:30:37 -0400
Date: Wed, 9 Apr 2014 03:30:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15-rc1
Message-ID: <20140409023027.GX18016@ZenIV.linux.org.uk>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <874n3n7czm.fsf_-_@xmission.com>
 <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:21:32PM -0700, Eric W. Biederman wrote:

> This set of changes has been reviewed and been sitting idle for the last
> 6 weeks.  In that time the vfs has slightly shifted under me the new
> version of rename and the mount hash list becoming a hlist.  None of
> those changes has caused changed the code in ways to invalidate these
> changes, but small conflicts do result and I have attached my conflict
> resolution at the end of this email in case it helps.
> 
> To recap these changes allow a file or a directory that is a mount point
> in one mount namespace to be unlinked/rmdired elsewhere where it is not
> a mount point (either a remote filesystem or another mount namespace).
> As has been agreed during review semantics when only a single mount
> namespace exists remain unchanged.
> 
> This removes a long standing need to lie to the vfs when a mount point
> has been removed behind it's back.  This also removes a DOS attack where
> an unprivileged user could prevent root from renaming or deleting files
> and directories by using them as mountpoints in another mount namespace.
> 
> This change also fixes a few cases where because we were not lying to
> the vfs we could leak mount points.
> 
> When renaming or unlinking directory entries that are not mountpoints
> no additional locks are taken so no performance differences can result,
> and my benchmark reflected that.

It also means that d_invalidate() now might trigger fs shutdown.  Which
has bloody huge stack footprint, for obvious reasons.  And d_invalidate()
can be called with pretty deep stack - walk into wrong dentry while
resolving a deeply nested symlink and there you go...
