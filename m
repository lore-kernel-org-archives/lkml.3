Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3KHL64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 06:58:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab3KHL6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 06:58:55 -0500
Date: Fri, 8 Nov 2013 06:58:03 -0500
From: Jeff Layton <jlayton@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        viro@zeniv.linux.org.uk, serge.hallyn@canonical.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20131108065803.72857e77@tlielax.poochiereds.net>
In-Reply-To: <87obc12xh8.fsf@xmission.com>
References: <519DCE5D.6070204@parallels.com>
	<87k3mq9fsu.fsf@xmission.com>
	<519DF109.9010309@parallels.com>
	<20130523073108.13afafa6@tlielax.poochiereds.net>
	<519DFFA9.3010606@parallels.com>
	<20130523075620.21abf79a@tlielax.poochiereds.net>
	<519E0474.5000606@parallels.com>
	<519E0AB0.7040704@panasas.com>
	<20130523090526.63fc153e@corrin.poochiereds.net>
	<20130523195547.GA13640@fieldses.org>
	<20130523201431.GB13640@fieldses.org>
	<87obc12xh8.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013 14:32:51 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Thu, May 23, 2013 at 03:55:47PM -0400, J. Bruce Fields wrote:
> >> On Thu, May 23, 2013 at 09:05:26AM -0400, Jeff Layton wrote:
> >> > What might help most here is to lay out a particular scenario for how
> >> > you envision setting up knfsd in a container so we can ensure that it's
> >> > addressed properly by whatever solution you settle on.
> >
> > BTW the problem I have here is that the only case I've personally had
> > any interest in is using network and file namespaces to isolate nfsd's
> > to make them safe to migrate across nodes of a cluster.
> >
> > So while the idea of making user namespaces and unprivileged knfsd and
> > the rest work is really interesting and I'm happy to think about it, I'm
> > not sure how feasible or useful it is.
> >
> > I'd therefore actually prefer just to take something like Stanislav's
> > patch now and put off the problem of how to make it work correctly with
> > user namespaces until we actually turn that on.  His patch fixes a real
> > bug that we have now, while user-namespaced-nfsd still sounds a bit
> > pie-in-the-sky to me.
> >
> >
> > But maybe I don't understand why Eric thinks nfsd in usernamespaces is
> > imminent.  Or maybe I'm missing some security problem that Stanislav's
> > patch would introduce now without allowing nfsd to run in a user
> > namespace.
> 
> The problem I saw is less pronounced but I think actually exists without
> user namespaces as well.  In particular if we let root in the container
> start knfsd in a network and mount namespace.  Then if that container
> does not have certain capabilities like say CAP_MKNOD all of a sudden
> we have a process running in the container with CAP_MKNOD.
> 
> I haven't had time to look at everything just yet but I don't think
> solving this is particularly hard.
> 
> There are really two very simple solutions.
> 1) When we start knfsd in the container we create a kernel thread that
>    is a child of the userspace process that started knfsd.  That kernel
>    thread can then be used to launch user mode helpers.
> 
>    This uses the same code as is needed today to launch user mode
>    helpers with just a different parent thread.
> 
> 2) We pass enough information for the user mode helper to figure out
>    what container this is all for.  File descriptors or whatever.
>    Then the user mode helper outside the container using chdir and setns
>    sets up the environment that the user mode helper typically expects
>    and runs the process inside of the container.
> 
> Or we look at what the user mode helper is doing and realize we don't
> need to run the user mode binary inside of the container.  If all it
> does is query /etc/passwd for username to uid mapping for example (for
> user namespaces we will probably care but not without them).
> 
> I don't think any of this is hard to implement.
> 
> I think user namespaces are imminent because after my last pass through
> the code the remaining work looked pretty trivial, and as soon as the
> dust settles I expect user namespaces become the common way to run code
> in containers, which should greatly increase the demand for this feature
> in user namespaces.
> 
> Eric
> 

Resurrecting this discussion after some time with some questions:

If we went with option #2 above, would it be sufficient to simply pass
a pid to the process? Then, since it runs as root, it could
open /proc/<pid>/ns/mnt and pass that fd to setns()?

Do you also have to chdir()/chroot() too? If so, how would one get the
path for that?

-- 
Jeff Layton <jlayton@redhat.com>
