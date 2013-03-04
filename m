Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3CDOMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:12:41 -0500
Received: from fieldses.org ([174.143.236.118]:51602 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab3CDOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:12:40 -0500
Date: Mon, 4 Mar 2013 09:12:30 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH review 49/85] sunrpc: Update svcgss xdr handle to
 rpsec_contect cache
Message-ID: <20130304141230.GE20389@fieldses.org>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-49-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360777934-5663-49-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:51:38AM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> For each received uid call make_kuid and validate the result.
> For each received gid call make_kgid and validate the result.
> 
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  net/sunrpc/auth_gss/svcauth_gss.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> index 73e9573..ecd1d58 100644
> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> @@ -418,6 +418,7 @@ static int rsc_parse(struct cache_detail *cd,
>  {
>  	/* contexthandle expiry [ uid gid N <n gids> mechname ...mechdata... ] */
>  	char *buf = mesg;
> +	int id;
>  	int len, rv;
>  	struct rsc rsci, *rscp = NULL;
>  	time_t expiry;
> @@ -444,7 +445,7 @@ static int rsc_parse(struct cache_detail *cd,
>  		goto out;
>  
>  	/* uid, or NEGATIVE */
> -	rv = get_int(&mesg, &rsci.cred.cr_uid);
> +	rv = get_int(&mesg, &id);
>  	if (rv == -EINVAL)
>  		goto out;
>  	if (rv == -ENOENT)
> @@ -452,8 +453,16 @@ static int rsc_parse(struct cache_detail *cd,
>  	else {
>  		int N, i;
>  
> +		/* uid */
> +		rsci.cred.cr_uid = make_kuid(&init_user_ns, id);
> +		if (!uid_valid(rsci.cred.cr_uid))
> +			goto out;
> +
>  		/* gid */
> -		if (get_int(&mesg, &rsci.cred.cr_gid))
> +		if (get_int(&mesg, &id))
> +			goto out;
> +		rsci.cred.cr_gid = make_kgid(&init_user_ns, id);
> +		if (!gid_valid(rsci.cred.cr_gid))
>  			goto out;

krb5 mounts started failing for me as of this patch (upstream as
683428fae8c73d7d7da0fa2e0b6beb4d8df4e808), and I believe the problem is
these uid/gid_valid checks: if I recall correctly, gssd uses -1 uid/gid
values to indicate "authentication succeeded, but treat this user as
anonymous".  We delay mapping -1 id's to the (configurable-per-export)
anonymous id's till fs/nfsd/auth.c:nfsd_setuser():

        if (uid_eq(new->fsuid, INVALID_UID))
		new->fsuid = exp->ex_anon_uid;
	if (gid_eq(new->fsgid, INVALID_GID))
		new->fsgid = exp->ex_anon_gid;

(We wouldn't be able to do that earlier because we don't know the export
yet.)

Confirmed that the following fixes the regression.

Eric, any objection to removing those checks?

--b.

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index f7d34e7..59a089d 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -449,15 +449,11 @@ static int rsc_parse(struct cache_detail *cd,
 
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
