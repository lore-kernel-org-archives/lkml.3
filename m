Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab3CDRL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:11:27 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40196 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3CDRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:11:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-49-git-send-email-ebiederm@xmission.com>
	<20130304141230.GE20389@fieldses.org>
Date: Mon, 04 Mar 2013 09:11:16 -0800
In-Reply-To: <20130304141230.GE20389@fieldses.org> (J. Bruce Fields's message
	of "Mon, 4 Mar 2013 09:12:30 -0500")
Message-ID: <87txorjdjf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/jDh23Elld32gL6fZlGJSRTFSg164NeYI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0139]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 49/85] sunrpc: Update svcgss xdr handle to rpsec_contect cache
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:


> krb5 mounts started failing for me as of this patch (upstream as
> 683428fae8c73d7d7da0fa2e0b6beb4d8df4e808),

Ouch!

>  and I believe the problem is
> these uid/gid_valid checks: if I recall correctly, gssd uses -1 uid/gid
> values to indicate "authentication succeeded, but treat this user as
> anonymous".  We delay mapping -1 id's to the (configurable-per-export)
> anonymous id's till fs/nfsd/auth.c:nfsd_setuser():
>
>         if (uid_eq(new->fsuid, INVALID_UID))
> 		new->fsuid = exp->ex_anon_uid;
> 	if (gid_eq(new->fsgid, INVALID_GID))
> 		new->fsgid = exp->ex_anon_gid;
>
> (We wouldn't be able to do that earlier because we don't know the export
> yet.)
>
> Confirmed that the following fixes the regression.
>
> Eric, any objection to removing those checks?

Not strongly.  As long as we have the uid ang gid valid checks in
there somewhere before we start using these uids and gids much.
This does seems to be the case of using out of range uids and gids
to mean out of range uids and gids.

In the description of my original patch before I split it up, I
noted that one of the small dangers might be that I had added
some possibly unneceessary uid and gid valid checks.  So it seems I had
even considered this slight possibility once and noted that there was a
slight chance we might have to remove a few of these.

It would be nice to have a comment to say that we expect this to happen
so people don't start wondering why there are missing checks on this
path.

There is also a gid_valid check in the secondary uids.  It looks like we
should keep that as we don't have any checks for invalid gids in
nfsd_setuser.  Is that possibly an oversight in nfsd_setuser?

Also looking towards a future in which all of these things don't reside
in the initial user namespace.  Is mapping any out of range uid to
INVALID_UID and then into ex_anon_uid the always the right thing to do?

Or is -1 a very special case in this instance.  In which case we
probably want checks that look like:

        if (-1 == id) {
        	rsci.cred.cr_uid = INVALID_UID;
	} else {
	  	rsci.cred.cr_uid = make_kuid(&init_user_ns, id);
        	if (!uid_valid(rsci.cred.cr_uid))
			goto out;
        }

Eric

> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> index f7d34e7..59a089d 100644
> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> @@ -449,15 +449,11 @@ static int rsc_parse(struct cache_detail *cd,
>  
>  		/* uid */
>  		rsci.cred.cr_uid = make_kuid(&init_user_ns, id);
> -		if (!uid_valid(rsci.cred.cr_uid))
> -			goto out;
>  
>  		/* gid */
>  		if (get_int(&mesg, &id))
>  			goto out;
>  		rsci.cred.cr_gid = make_kgid(&init_user_ns, id);
> -		if (!gid_valid(rsci.cred.cr_gid))
> -			goto out;
>  
>  		/* number of additional gid's */
>  		if (get_int(&mesg, &N))
