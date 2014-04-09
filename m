Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaDICjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:39:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55683 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbaDICju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:39:50 -0400
Date: Wed, 9 Apr 2014 03:39:47 +0100
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
Message-ID: <20140409023947.GY18016@ZenIV.linux.org.uk>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
 <874n3n7czm.fsf_-_@xmission.com>
 <87wqezl5df.fsf_-_@x220.int.ebiederm.org>
 <20140409023027.GX18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409023027.GX18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 03:30:27AM +0100, Al Viro wrote:

> > When renaming or unlinking directory entries that are not mountpoints
> > no additional locks are taken so no performance differences can result,
> > and my benchmark reflected that.
> 
> It also means that d_invalidate() now might trigger fs shutdown.  Which
> has bloody huge stack footprint, for obvious reasons.  And d_invalidate()
> can be called with pretty deep stack - walk into wrong dentry while
> resolving a deeply nested symlink and there you go...

PS: I thought I actually replied with that point back a month or so ago,
but having checked sent-mail...  Looks like I had not.  My deep apologies.

FWIW, I think that overall this thing is a good idea, provided that we can
live with semantics changes.  The implementation is too optimistic, though -
at the very least, we want this work done upon namespace_unlock() held
back until we are not too deep in stack.  task_work_add() fodder, perhaps?
