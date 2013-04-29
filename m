Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab3D2S5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:57:22 -0400
Received: from fieldses.org ([174.143.236.118]:57057 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3D2S5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:57:20 -0400
Date: Mon, 29 Apr 2013 14:57:12 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Simo Sorce <simo@redhat.com>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20130429185712.GP17268@fieldses.org>
References: <20130429112434.dcc80cfce804beeacc68793a@canb.auug.org.au>
 <CA52A586-E4DF-42D0-9020-D17F8822BF7C@oracle.com>
 <20130429154541.GI17268@fieldses.org>
 <09A69F90-5D9A-4AF6-9B7D-CC1D74A237EA@oracle.com>
 <1367252460.19515.7.camel@leira.trondhjem.org>
 <DBD3CE27-3A93-4BC0-B390-2EDB9D0D2BBE@oracle.com>
 <20130429173821.GJ17268@fieldses.org>
 <BD32EC01-EA3A-403C-A8D2-904B77EB79BA@oracle.com>
 <20130429175902.GK17268@fieldses.org>
 <756994C4-53FE-4723-A37C-A5E4DAB905D2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756994C4-53FE-4723-A37C-A5E4DAB905D2@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:30:33PM -0400, Chuck Lever wrote:
> 
> On Apr 29, 2013, at 1:59 PM, "J. Bruce Fields" <bfields@fieldses.org>
> wrote:
> 
> > On Mon, Apr 29, 2013 at 01:47:16PM -0400, Chuck Lever wrote:
> >> 
> >> On Apr 29, 2013, at 1:38 PM, "J. Bruce Fields"
> >> <bfields@fieldses.org> wrote:
> >> 
> >>> On Mon, Apr 29, 2013 at 01:04:01PM -0400, Chuck Lever wrote:
> >>>> Trond's nfs-for-next now has the new rpcauth_get_gssinfo() and
> >>>> rpcauth_get_pseudoflavor() APIs, which are replacements for
> >>>> direct calls into the GSS mech switch.  These APIs are a little
> >>>> more generic, and more robust in the face of unloaded GSS kernel
> >>>> modules.
> >>>> 
> >>>> Instead of gss_mech_get_by_OID(), I suspect you want
> >>>> rpcauth_get_pseudoflavor(), but I haven't looked at the gssproxy
> >>>> code.
> >>> 
> >>> It's doing
> >>> 
> >>> 		status = -EOPNOTSUPP; gm =
> >>> 		gss_mech_get_by_OID(&ud->mech_oid); if (!gm) goto out;
> >>> 		status = -EINVAL; status =
> >>> 		gss_import_sec_context(ud->out_handle.data,
> >>> 		ud->out_handle.len, gm, &rsci.mechctx, &expiry,
> >>> 		GFP_KERNEL); if (status) goto out;
> >>> 
> >>> So we need a way to get from an OID and some mechanism-specific
> >>> data to a context.
> >>> 
> >>> Looks to me like we just want to re-export gss_mech_get_by_OID().
> >> 
> >> The reason for the new wrappers is to load the kernel modules
> >> properly before trying to discover the OID -> mechanism mapping.
> >> 
> >> Where are you calling it from?  If it's from outside of the GSS
> >> module, how do you guarantee the rpc_gss_auth module is loaded?
> >> What if the GSS mechanism for that OID isn't loaded?
> > 
> > Sorry, I should have said just "remove static from", not
> > "re-export"--it's in the same module.  So there should be no problem
> > here, right?
> 
> OK, gotcha.  Architecturally outside of the mech switch I'd like to
> see OIDs passed around embedded in GSS tuples rather than by
> themselves.

I'm not sure what you mean.  When I accept a gss context I don't yet
know what service or qop it's going to be used with, I only know the
mechanism OID.

> An alternative would be to use gss_mech_get_by_name(), which is
> already visible, loads GSS mechanism modules automatically, and
> returns struct gss_api_mech *.  For NFS, we should already have a
> clean mapping of mechanism name to pseudoflavor to GSS tuple.  Looks
> like rsc_parse() already uses this API.

We don't have a name here, only an OID.

> Do you have gssproxy patches published in a git tree somewhere I could
> review?

It's in my for-3.10 branch.

Which is more or less what I plan to submit for 3.10, so I'd prefer not
to rebase it at this point.

It looks like just removing "static" would resolve the immediate
conflict, is that right?  And then I'd happily help deal with cleaning
up the API as followup work.

--b.
