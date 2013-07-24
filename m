Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859Ab3GXBP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:15:26 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47633 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3GXBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:15:25 -0400
MIME-Version: 1.0
In-Reply-To: <877gghruwq.fsf@xmission.com>
References: <877gghruwq.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 23 Jul 2013 18:15:03 -0700
Message-ID: <CALCETrXXGhVbkG6AnRck+W1kMns5TJuNYAqe_tV44JvWgDoUzA@mail.gmail.com>
Subject: Re: [REVIEW][PATCH] vfs: Lock in place mounts from more privileged users
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:30 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> When creating a less privileged mount namespace or propogating mounts
> from a more privileged to a less privileged mount namespace lock the
> submounts so they may not be unmounted individually in the child mount
> namespace revealing what is under them.

I would propose a different rule: if vfsmount b is mounted on vfsmount
a, then to unmount b, you must be ns_capable(CAP_SYS_MOUNT) on either
a's namespace or b's namespace.  The idea is that you should be able
to see under a mount if you own the parent (because it's yours) or if
you own the child (because you, or someone no more privileged than
you, put it there).  This may result in a simpler patch and should do
much the same thing.

>
> This enforces the reasonable expectation that it is not possible to
> see under a mount point.  Most of the time mounts are on empty
> directories and revealing that does not matter, however I have seen an
> occassionaly sloppy configuration where there were interesting things
> concealed under a mount point that probably should not be revealed.
>
> Expirable submounts are not locked because they will eventually
> unmount automatically so whatever is under them already needs
> to be safe for unprivileged users to access.
>
> From a practical standpoint these restrictions do not appear to be
> significant for unprivileged users of the mount namespace.  Recursive
> bind mounts and pivot_root continues to work, and mounts that are
> created in a mount namespace may be unmounted there.  All of which
> means that the common idiom of keeping a directory of interesting
> files and using pivot_root to throw everything else away continues to
> work just fine.

Is there some kind of recursive unmount that will get rid of the
pivot_root result and everything under it?

In any case, I think that something like this patch is probably
-stable material: I suspect that things like seunshare and systemd's
instance directories are currently insecure.

--Andy
