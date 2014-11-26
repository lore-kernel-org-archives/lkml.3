Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaKZW5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:57:24 -0500
Received: from fieldses.org ([174.143.236.118]:35078 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaKZW5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:57:23 -0500
Date: Wed, 26 Nov 2014 17:57:20 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Ian Kent <ikent@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
Message-ID: <20141126225720.GA28428@fieldses.org>
References: <87y4qy7wci.fsf@x220.int.ebiederm.org>
 <20141125005255.4974.54193.stgit@pluto.fritz.box>
 <20141125010734.4974.85347.stgit@pluto.fritz.box>
 <20141125215248.GA7958@redhat.com>
 <20141125220637.GA10008@redhat.com>
 <1369.1417002382@warthog.procyon.org.uk>
 <87k32i0zyc.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k32i0zyc.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:00:11AM -0600, Eric W. Biederman wrote:
> David Howells <dhowells@redhat.com> writes:
> 
> > Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >> Ian if we were to merge this I believe you would win the award for
> >> easiest path to a root shell.
> >
> > Is there any particular reason the upcalled program has to be run as root?
> > Could the kernel not run it as something else - perhaps the caller's UID,GID
> > or even something anonymous?
> >
> > Also, call_sbin_request_key() could be given a parameter to call something
> > other than /sbin/request-key, and key_type::request_key could be used.
> 
> Fundamentally the upcall needs to happen with enough privileges to do
> the job, and that means running in practice running as root in the
> appropriate context.  If we didn't need to gain privileges we wouldn't
> need an upcall.
> 
> In the code I was critisizing struct cred was not being changed because
> of what I believe was an ignorance of what task->nsproxy was about and
> is for.
> 
> It is straight forward to save off a for a kernel thread from the
> process calling mount and make it responsible for the upcall and use
> that as the parent for all of the containerized upcalls, and we could
> easily run with that threads permissions.
> 
> We can't use the context of the triggering user but we instead need to
> use the context of the mounter of the filesystem.  As otherwise the
> triggering user can control what is /sbin/request-key and cause problems
> that way.

That makes sense to me.  There are three cases I think we care about:

	- client idmapper upcall: translates between on-the-wire
	  "user@domain" names and local uid's/gid's.  The results may be
	  cached and used by other users, and you certainly don't want
	  the user who happened to trigger the upcall by doing a "ls" to
	  poison the cache with weird values.

	- server-side state recovery call: used to record some
	  information about which clients hold active state.  There's no
	  "mount" on the server side, but "root in the appropriate
	  context" still sounds right--we probably want to save the
	  context of whoever started the server.  One extra thread per
	  server would certainly be no big deal, so if that's how we
	  need to save the context, fine.

	- client request-key call: this isn't actually implemented yet
	  and I don't feel like I understand it.

--b.
