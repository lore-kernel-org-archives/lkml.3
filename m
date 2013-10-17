Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191Ab3JQDgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:36:15 -0400
Received: from natasha.panasas.com ([67.152.220.90]:39089 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3JQDgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:36:14 -0400
From: Jim Lieb <jlieb@panasas.com>
To: Al Viro <viro@zeniv.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, <tytso@mit.edu>,
        <viro@zeniv.linux.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bfields@redhat.com>,
        <jlayton@redhat.com>
Subject: Re: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file server ops
Date: Wed, 16 Oct 2013 20:35:56 -0700
Message-ID: <12126075.0PGVvhDUvN@jlieb-e6410>
Organization: Panasas Inc.
User-Agent: KMail/4.11.2 (Linux/3.11.4-201.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131017012050.GR13318@ZenIV.linux.org.uk>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com> <87ppr4lmp3.fsf@xmission.com> <20131017012050.GR13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 17, 2013 02:20:50 Al Viro wrote:
> On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:
> > That doesn't look bad but it does need capable(CAP_SETUID) &&
> > capable(CAP_SETGID) or possibly something a little more refined.
> 
> D'oh
> 
> > I don't think we want file descriptor passing to all of a sudden become
> > a grant of privilege, beyond what the passed fd can do.
> 
> Definitely.  And an extra ) to make it compile wouldn't hurt either...

Ok, I'll rework this, dropping the void arg etc.  How about this:

1. have one arg, the fd, i.e. SYSCALL_DEFINE1(switch_cred, int, fd)

2. if the fd >=0 do the override in my "use the fd" variation.  This would do 
the capability check after the valid fd check.  This means that you must have
privs to mess with privs.  Returns 0 or either EBADF or EPERM

3. if the fd == -1 do the revert case.  The reason for this is there are 4 
syscalls needed to change the creds and each has an error return.  We need
a way to escape the damage and a revert to the real creds set is the best way 
to return to a known state.  This does not require a capability check because
all that can happen is to return to the immutable real set.  Also, I don't 
need the initial open of /dev/null.

Does this fit?

Jim
-- 
Jim Lieb
Linux Systems Engineer
Panasas Inc.

"If ease of use was the only requirement, we would all be riding tricycles"
- Douglas Engelbart 1925–2013
