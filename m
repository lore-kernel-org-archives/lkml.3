Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaKLNJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:09:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41850 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaKLNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:09:15 -0500
Date: Wed, 12 Nov 2014 14:09:15 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of
 init_user_ns
Message-ID: <20141112130915.GG333@tucsk>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk>
 <87mw7xd9zt.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mw7xd9zt.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:37:10AM -0600, Eric W. Biederman wrote:

> > Maybe I'm being dense, but can someone give a concrete example of such an
> > attack?
> 
> There are two variants of things at play here.
> 
> There is the classic if you don't freeze your context at open time when
> you pass that file descriptor to another process unexpected things can
> happen.  
> 
> An essentially harmless but extremely confusing example is what happens
> to a partial read when it stops halfway through a uid value and the next
> read on the same file descriptor is from a process in a different user
> namespace.  Which uid value should be returned to userspace.

Fuse device doesn't currently do partial reads, so that's a non-issue.

> Now if I am in a nefarious mood I can create a unprivileged user
> namespace, open /dev/fuse and mount a fuse filesystem.  Pass the file
> descriptor to /dev/fuse to a processes that is in the default user
> namespace (and thus can use any uid/gid).   With that file desctipor
> report that there is a setuid 0 exectuable on that file system.

Yes, and this would also be prevented by MNT_NOSUID, which would be a good idea
anyway.  I just don't see the reason we'd want to allow clearing MNT_NOSUID in a
private namespace.

So we don't currently see a use case for relaxing either the MNT_NOSUID
restriction or for relaxing the requirement on the user namespace the fuse
server is in.  Is that correct?

If so, we should leave both restrictions in place since that allows the greatest
flexibility in the future, is either of those needs to be relaxed.

> > That might also help me understand how exactly user/pid namespaces work...
> 
> The idea of user/pid namespaces is to translate uid, gids and pids at
> the edge of userspace into a kernel internal form that can be use
> everywhere.  In this case we get into the subtlties of which
> translations make sense.

I mean, what's the point of translating uid, gids and pids?  What are the use
cases?

What are the rules on the translations between parent and child namespaces?

Is all this documented anywhere?

Thanks,
Miklos
