Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3CEXKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:10:07 -0500
Received: from fieldses.org ([174.143.236.118]:40380 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab3CEXKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:10:04 -0500
Date: Tue, 5 Mar 2013 18:10:01 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH review 49/85] sunrpc: Update svcgss xdr handle to
 rpsec_contect cache
Message-ID: <20130305231001.GJ15816@fieldses.org>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-49-git-send-email-ebiederm@xmission.com>
 <20130304141230.GE20389@fieldses.org>
 <87txorjdjf.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txorjdjf.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:11:16AM -0800, Eric W. Biederman wrote:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
> 
> 
> > krb5 mounts started failing for me as of this patch (upstream as
> > 683428fae8c73d7d7da0fa2e0b6beb4d8df4e808),
> 
> Ouch!
> 
> >  and I believe the problem is
> > these uid/gid_valid checks: if I recall correctly, gssd uses -1 uid/gid
> > values to indicate "authentication succeeded, but treat this user as
> > anonymous".  We delay mapping -1 id's to the (configurable-per-export)
> > anonymous id's till fs/nfsd/auth.c:nfsd_setuser():
> >
> >         if (uid_eq(new->fsuid, INVALID_UID))
> > 		new->fsuid = exp->ex_anon_uid;
> > 	if (gid_eq(new->fsgid, INVALID_GID))
> > 		new->fsgid = exp->ex_anon_gid;
> >
> > (We wouldn't be able to do that earlier because we don't know the export
> > yet.)
> >
> > Confirmed that the following fixes the regression.
> >
> > Eric, any objection to removing those checks?
> 
> Not strongly.  As long as we have the uid ang gid valid checks in
> there somewhere before we start using these uids and gids much.
> This does seems to be the case of using out of range uids and gids
> to mean out of range uids and gids.
> 
> In the description of my original patch before I split it up, I
> noted that one of the small dangers might be that I had added
> some possibly unneceessary uid and gid valid checks.  So it seems I had
> even considered this slight possibility once and noted that there was a
> slight chance we might have to remove a few of these.

Ah, I should have seen that and checked that, my bad.

> It would be nice to have a comment to say that we expect this to happen
> so people don't start wondering why there are missing checks on this
> path.

OK--something like the appended?

> There is also a gid_valid check in the secondary uids.  It looks like we
> should keep that as we don't have any checks for invalid gids in
> nfsd_setuser.  Is that possibly an oversight in nfsd_setuser?

Honestly I don't think anyone's thought that through....

But it would seem odd to pass down an "anonymous" supplementary gid--why
not just leave it off the list instead?

(BTW, dumb question: is it legal for userspace to use a uid -1?  And was
it illegal before the user namespace patches?)

> Also looking towards a future in which all of these things don't reside
> in the initial user namespace.  Is mapping any out of range uid to
> INVALID_UID and then into ex_anon_uid the always the right thing to do?
> 
> Or is -1 a very special case in this instance.  In which case we
> probably want checks that look like:

svcgssd should pass down either -1 or a valid uid, so I don't think
we're committed to any particular handling of invalid id's other than
-1--whatever's easiest.

--b.

commit d78f5cd062edb400190521e9540b042b4805875b
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Mon Mar 4 08:44:01 2013 -0500

    nfsd: fix krb5 handling of anonymous principals
    
    krb5 mounts started failing as of
    683428fae8c73d7d7da0fa2e0b6beb4d8df4e808 "sunrpc: Update svcgss xdr
    handle to rpsec_contect cache".
    
    The problem is that mounts are usually done with some host principal
    which isn't normally mapped to any user, in which case svcgssd passes
    down uid -1, which the kernel is then expected to map to the
    export-specific anonymous uid or gid.
    
    The new uid_valid/gid_valid checks were therefore causing that downcall
    to fail.
    
    (Note the regression may not have been seen with older userspace that
    tended to map unknown principals to an anonymous id on their own rather
    than leaving it to the kernel.)
    
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index f7d34e7..c2ab26f 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -447,17 +447,21 @@ static int rsc_parse(struct cache_detail *cd,
 	else {
 		int N, i;
 
+		/*
+		 * NOTE: we don't check uid_valid() or gid_valid(): instead,
+		 * -1 id's are later mapped to the (export-specific)
+		 * anonymous id by nfsd_setuser.
+		 *
+		 * (But supplementary gid's get no such special
+		 * treatment so are checked for validity here.)
+		 */
 		/* uid */
 		rsci.cred.cr_uid = make_kuid(&init_user_ns, id);
-		if (!uid_valid(rsci.cred.cr_uid))
-			goto out;
 
 		/* gid */
 		if (get_int(&mesg, &id))
 			goto out;
 		rsci.cred.cr_gid = make_kgid(&init_user_ns, id);
-		if (!gid_valid(rsci.cred.cr_gid))
-			goto out;
 
 		/* number of additional gid's */
 		if (get_int(&mesg, &N))
