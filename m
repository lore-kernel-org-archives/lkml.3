Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3D2Ric (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:38:32 -0400
Received: from fieldses.org ([174.143.236.118]:58959 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab3D2Rib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:38:31 -0400
Date: Mon, 29 Apr 2013 13:38:21 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simo Sorce <simo@redhat.com>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20130429173821.GJ17268@fieldses.org>
References: <20130429112434.dcc80cfce804beeacc68793a@canb.auug.org.au>
 <CA52A586-E4DF-42D0-9020-D17F8822BF7C@oracle.com>
 <20130429154541.GI17268@fieldses.org>
 <09A69F90-5D9A-4AF6-9B7D-CC1D74A237EA@oracle.com>
 <1367252460.19515.7.camel@leira.trondhjem.org>
 <DBD3CE27-3A93-4BC0-B390-2EDB9D0D2BBE@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBD3CE27-3A93-4BC0-B390-2EDB9D0D2BBE@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 01:04:01PM -0400, Chuck Lever wrote:
> 
> On Apr 29, 2013, at 12:21 PM, Trond Myklebust
> <trond.myklebust@fys.uio.no> wrote:
> 
> > On Mon, 2013-04-29 at 12:05 -0400, Chuck Lever wrote:
> >> On Apr 29, 2013, at 11:45 AM, "J. Bruce Fields"
> >> <bfields@fieldses.org> wrote:
> >> 
> >>> On Mon, Apr 29, 2013 at 10:53:37AM -0400, Chuck Lever wrote:
> >>>> 
> >>>> On Apr 28, 2013, at 9:24 PM, Stephen Rothwell
> >>>> <sfr@canb.auug.org.au> wrote:
> >>>> 
> >>>>> Hi J.,
> >>>>> 
> >>>>> After merging the nfsd tree, today's linux-next build (powerpc
> >>>>> ppc64_defconfig) failed like this:
> >>>>> 
> >>>>> net/sunrpc/auth_gss/svcauth_gss.c: In function
> >>>>> 'gss_proxy_save_rsc': net/sunrpc/auth_gss/svcauth_gss.c:1182:3:
> >>>>> error: implicit declaration of function 'gss_mech_get_by_OID'
> >>>>> [-Werror=implicit-function-declaration]
> >>>>> 
> >>>>> Caused byc ommit 030d794bf498 ("SUNRPC: Use gssproxy upcall for
> >>>>> server RPCGSS authentication").  gss_mech_get_by_OID() made
> >>>>> static to net/sunrpc/auth_gss/gss_mech_switch.c by commit
> >>>>> 9568c5e9a61d ("SUNRPC: Introduce rpcauth_get_pseudoflavor()") in
> >>>>> the nfs tree (part of the nfs tree that you did not merge).
> >>>>> 
> >>>>> I don't know how to fix this, so I have used the nfsd tree from
> >>>>> next-20130426 for today.
> >>>> 
> >>>> Bruce, it might make sense for me to submit the three server-side
> >>>> RPC GSS patches, and then you can rebase the gssproxy work on top
> >>>> of those.  Let me know how you would like to proceed.
> >>> 
> >>> I'm happy to take those patches whenever you consider them ready.
> >>> Would that fix the problem?
> >> 
> >> Someone would need to modify the gssproxy patches to use the new
> >> interfaces.
> >> 
> >>> Also: it looks like 030d794bf498 "SUNRPC: Introduce
> >>> rpcauth_get_pseudoflavor()" is in Trond's linux-next, but not his
> >>> nfs-for-next.  I'm not sure what that means--is it safe to rebase
> >>> on top of *that*?
> >> 
> >> That doesn't seem right to me.
> > 
> > I've now pulled the rpcsec_gss changes into the nfs-for-next. The
> > main reason why they were not pulled in earlier was due to
> > uncertainty what to do about the increase in "AUTH_GSS upcall timed
> > out." syslog warnings.
> 
> Trond's nfs-for-next now has the new rpcauth_get_gssinfo() and
> rpcauth_get_pseudoflavor() APIs, which are replacements for direct
> calls into the GSS mech switch.  These APIs are a little more generic,
> and more robust in the face of unloaded GSS kernel modules.
> 
> Instead of gss_mech_get_by_OID(), I suspect you want
> rpcauth_get_pseudoflavor(), but I haven't looked at the gssproxy code.

It's doing

		status = -EOPNOTSUPP;
		gm = gss_mech_get_by_OID(&ud->mech_oid);
		if (!gm)
			goto out;
		status = -EINVAL;
		status = gss_import_sec_context(ud->out_handle.data,
						ud->out_handle.len,
						gm, &rsci.mechctx,
						&expiry, GFP_KERNEL);
		if (status)
			goto out;

So we need a way to get from an OID and some mechanism-specific data to
a context.

Looks to me like we just want to re-export gss_mech_get_by_OID().

--b.
