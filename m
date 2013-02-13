Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999Ab3BMVuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:50:52 -0500
Received: from fieldses.org ([174.143.236.118]:41746 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab3BMVuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:50:50 -0500
Date: Wed, 13 Feb 2013 16:50:47 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids in
 auth.unix.gid rpc pipe upcalls.
Message-ID: <20130213215047.GR14195@fieldses.org>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-52-git-send-email-ebiederm@xmission.com>
 <20130213210545.GO14195@fieldses.org>
 <874nhfrjgg.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nhfrjgg.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 01:29:35PM -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> > On Wed, Feb 13, 2013 at 09:51:41AM -0800, Eric W. Biederman wrote:
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >> 
> >> When a new rpc connection is established with an in-kernel server, the
> >> traffic passes through svc_process_common, and svc_set_client and down
> >> into svcauth_unix_set_client if it is of type RPC_AUTH_NULL or
> >> RPC_AUTH_UNIX.
> >> 
> >> svcauth_unix_set_client then looks at the uid of the credential we
> >> have assigned to the incomming client and if we don't have the groups
> >> already cached makes an upcall to get a list of groups that the client
> >> can use.
> >> 
> >> The upcall encodes send a rpc message to user space encoding the uid
> >> of the user whose groups we want to know.  Encode the kuid of the user
> >> in the initial user namespace as nfs mounts can only happen today in
> >> the initial user namespace.
> >
> > OK, I didn't know that.
> >
> > (Though I'm unclear how it should matter to the server what user
> > namespace the client is in?)
> 
> Perhaps I have the description a little scrambled.  The short version
> is that to start I only support the initial network namespace.
> 
> If I haven't succeeded it is my intent to initially limit the servers
> to the initial user namespace as well.  I should see if I can figure
> that out.
> 
> >> When a reply to an upcall comes in convert interpret the uid and gid values
> >> from the rpc pipe as uids and gids in the initial user namespace and convert
> >> them into kuids and kgids before processing them further.
> >> 
> >> When reading proc files listing the uid to gid list cache convert the
> >> kuids and kgids from into uids and gids the initial user namespace.  As we are
> >> displaying server internal details it makes sense to display these values
> >> from the servers perspective.
> >
> > All of these caches are already per-network-namespace.  Ideally wouldn't
> > we also like to associate a user namespace with each cache somehow?
> 
> Ideally yes.  I read through the caches enough to figure out where there
> user space interfaces were, and to make certain we had conversions
> to/from kuids and kgids.
> 
> I haven't looked at what user namespace makes sense for these
> caches.  For this cache my first guess is that net->user_ns
> is what we want as it will be shared by all users in network namespace I
> presume.

Oh, I didn't know about net->user_ns--so each network namespace is
associated with a single user namespace, great, that simplifies life.
Yes, that sounds exactly right.

--b.
