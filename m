Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbaD3Nd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:33:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57459 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaD3Ndz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:33:55 -0400
Date: Wed, 30 Apr 2014 13:33:48 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Marian Marinov <mm@1h.com>, containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140430133348.GB29994@ubuntumail>
References: <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail>
 <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail>
 <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail>
 <53602B84.1020304@mit.edu>
 <20140430001641.GA28969@ubuntumail>
 <20140430003236.GA6472@thunk.org>
 <87ha5bntqm.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha5bntqm.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > On Wed, Apr 30, 2014 at 12:16:41AM +0000, Serge Hallyn wrote:
> >> I forget the details, but there was another case where I wanted to
> >> have the userns which 'owns' the whole fs available.  I guess we'd
> >> have to check against that instead of using inode_capable.
> >
> > Yes, that sounds right.
> >
> > And *please* tell me that that under no circumstances can anyone other
> > than root@init_user_ns is allowed to use mknod....
> 
> Nope.  mknod not allowed.  capable(CAP_MKNOD) is required is required
> and I can't see any reason to change that.
> 
> As a rule of thumb, the only additional actions allowed in a user
> namespace above and beyond what an ordinary unpriviliged user would be
> allowed to do are those things which we only don't allow because they
> could confuse a setuid root executable.
> 
> 
> If we ever allow the creation of immutable files by unprivileged users
> those files would at least have to be kept completely separate from the
> files the global root encounters (aka a disjoint mount namespace).
> 
> I do not currently see a path to safely using immutable files with just
> user namespace root permission.

It's very far off, but I think the path is:

1. at first mount of a blockdev, note the cred (or just userns) which
mounted it
2. work on auditing superblock readers so we can start allowing some
blockdev mounts in user namespaces :)
3. check for privilege against the userns owning a superblock

-serge
