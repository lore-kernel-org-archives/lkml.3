Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab3EWT4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:56:24 -0400
Received: from fieldses.org ([174.143.236.118]:35860 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758521Ab3EWT4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:56:22 -0400
Date: Thu, 23 May 2013 15:55:47 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk,
        serge.hallyn@canonical.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, oleg@redhat.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
Message-ID: <20130523195547.GA13640@fieldses.org>
References: <878v36ex6n.fsf@xmission.com>
 <519DCE5D.6070204@parallels.com>
 <87k3mq9fsu.fsf@xmission.com>
 <519DF109.9010309@parallels.com>
 <20130523073108.13afafa6@tlielax.poochiereds.net>
 <519DFFA9.3010606@parallels.com>
 <20130523075620.21abf79a@tlielax.poochiereds.net>
 <519E0474.5000606@parallels.com>
 <519E0AB0.7040704@panasas.com>
 <20130523090526.63fc153e@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523090526.63fc153e@corrin.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 09:05:26AM -0400, Jeff Layton wrote:
> On Thu, 23 May 2013 15:25:20 +0300
> > I'm not familiar with nfsdcltrack but I would imagine it receives it's information from
> > Kernel as a command line parameters.
> > 
> > Would it not be the simplest approach to add a --chroot=/path/to/root optional
> > parameter to nfsdcltrack so it should access an alternate DB relative to 
> > --chroot.
> > 
> > This would address Eric's concern of not executing user-privileged executable
> > from Kernel. I think
> > 
> > Just my $0.017
> > Boaz
> > 
> 
> I think that sounds reasonable. Is it always the case
> that /path/to/root is reachable from the "primary" namespace?

I don't think we can assume that.

> If not, you may need to do something more exotic there.

We should be able to pass a file descriptor and then work relative to
that.

> Also, do you have to do anything like change the uid/gid to a different
> user who is root within the container?

Yeah, you may need to create files, for example, right?

> What might help most here is to lay out a particular scenario for how
> you envision setting up knfsd in a container so we can ensure that it's
> addressed properly by whatever solution you settle on.

It would seem cleaner to me the less userspace has to understand about
containers--ideally someone could run a general-purpose distro with its
nfs-utils in a container and have nfs and nfsd just work.

So I'd like to understand whether it is feasible to spawn helpers from a
thread that's descended from whoever started nfsd (or whatever the
proper ancestor is).

(And, what about the nfsd threads themselves?  If we're going to allow
unprivileged users to start nfsd, then we probably want the nfsd threads
to inherit from the user somehow, don't we?)

As I understand it recent clients use request_key to do idmapping.  I
don't understand that (or keyrings) well.  How should they work?  I
would have expected that you'd want a separate request-key for each
container rather than a single request-key working on behalf of all
containers.

--b.
