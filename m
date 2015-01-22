Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbbAVB3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:29:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbbAVB3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:29:03 -0500
Message-ID: <1421890125.2673.32.camel@pluto.fritz.box>
Subject: Re: [RFC PATCH 0/5] Second attempt at contained helper execution
From: Ian Kent <ikent@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 22 Jan 2015 09:28:45 +0800
In-Reply-To: <20150121143819.GA28392@fieldses.org>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
	 <20150114215525.GB7071@fieldses.org> <20150114221011.GC7071@fieldses.org>
	 <1421281572.2688.4.camel@pluto.fritz.box>
	 <20150115162741.GA14902@fieldses.org>
	 <1421370073.2630.4.camel@pluto.fritz.box>
	 <20150116152527.GD17315@fieldses.org>
	 <1421823925.2789.3.camel@pluto.fritz.box>
	 <20150121143819.GA28392@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 09:38 -0500, J. Bruce Fields wrote:
> On Wed, Jan 21, 2015 at 03:05:25PM +0800, Ian Kent wrote:
> > On Fri, 2015-01-16 at 10:25 -0500, J. Bruce Fields wrote:
> > > On Fri, Jan 16, 2015 at 09:01:13AM +0800, Ian Kent wrote:
> > > > On Thu, 2015-01-15 at 11:27 -0500, J. Bruce Fields wrote:
> > > > > On Thu, Jan 15, 2015 at 08:26:12AM +0800, Ian Kent wrote:
> > > > > > On Wed, 2015-01-14 at 17:10 -0500, J. Bruce Fields wrote:
> > > > > > > > On Wed, Jan 14, 2015 at 05:32:22PM +0800, Ian Kent wrote:
> > > > > > > > > There are other difficulties to tackle as well, such as how to decide
> > > > > > > > > if contained helper execution is needed. For example, if a mount has
> > > > > > > > > been propagated to a container or bound into the container tree (such
> > > > > > > > > as with the --volume option of "docker run") the root init namespace
> > > > > > > > > may need to be used and not the container namespace.
> > > > > > > 
> > > > > > > I think you have to go through each of the existing upcall examples and
> > > > > > > decide what's needed for each.
> > > > > > > 
> > > > > > > At least for the nfsv4 idmapper I would've thought the namespace the
> > > > > > > mount was done in would be the right choice, hence my previous question.
> > > > > > 
> > > > > > Probably but you don't necessarily know what namespace the mount was
> > > > > > done in. It may have been propagated from another namespace or (although
> > > > > > I don't think it works yet) bound from another container using the
> > > > > > volumes-from docker option.
> > > > > 
> > > > > Name-id mappings should be associated with the superblock, I guess--so
> > > > > don't you store a pointer to the right thing there?
> > > > 
> > > > Quite possibly but my original point was, without an acceptable
> > > > mechanism to execute the helper we can't know what might need to be done
> > > > to use it.
> > > 
> > > At least for me it would be easier to review if it came with at least
> > > one example user.
> > 
> > Haven't seen any negative responses but perhaps people are still away
> > over Xmas.
> > 
> > In the mean time it's probably a good idea to add some use cases to the
> > series in case the approach is OK.
> > 
> > I'll have a look at the nfsd code and see if I can spot the places.
> 
> On the nfsd side it's just the one call_usermodehelper in
> fs/nfsd/nfs4recover.c.  The tricky part is figuring out where the
> namespace information should come from.

I had a look at the nfsd code but haven't looked at the nfsdcltrack to
see what it does and if it expects anything that wouldn't be available.
There's also the assumption that the external application is present
within the container filesystem at the same location.

The whole idea of the current approach is that the namespace information
comes from the init process of the container it's executing in.

I believe that if nfsd is running in a container it should be able to
function entirely within the container, except for the callback issue.

I see there's a check in the callback init function to see if the net
namespace in use is the root net namespace. It looks like that check
would be enough to determine that container execution is needed.

Assuming that the various locations all contain the same struct net,
such as is stored in (struct nfs4_client) clp, then it's probably enough
to change nfsd4_umh_cltrack_upcall() to also take net as a parameter. 

Then the same check (which would be removed) used in the init function
could be used to determine if the UMH_USE_NS flag needs to be passed to
call_usermodehelper().

Passing the UMH_USE_NS flag to call_usermodehelper() will cause the
helper to be executed within the init namespace (including the net
namespace) of the container.

If that is what's needed then it might be sensible to change
nfsd4_umh_cltrack_upcall() to take a structure containing parameters to
keep it clean.

I could create patches to demonstrate the procedure but we probably
should keep that discussion separate from this one for the moment.

Ian

