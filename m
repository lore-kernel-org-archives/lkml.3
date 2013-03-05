Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3CEXnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:43:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58233 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3CEXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:43:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-49-git-send-email-ebiederm@xmission.com>
	<20130304141230.GE20389@fieldses.org> <87txorjdjf.fsf@xmission.com>
	<20130305231001.GJ15816@fieldses.org>
Date: Tue, 05 Mar 2013 15:43:36 -0800
In-Reply-To: <20130305231001.GJ15816@fieldses.org> (J. Bruce Fields's message
	of "Tue, 5 Mar 2013 18:10:01 -0500")
Message-ID: <87ip5576qf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/ayJslxq0yjhfA87vKgpp0FLvIqqS8q/E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 49/85] sunrpc: Update svcgss xdr handle to rpsec_contect cache
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Mon, Mar 04, 2013 at 09:11:16AM -0800, Eric W. Biederman wrote:
>> "J. Bruce Fields" <bfields@fieldses.org> writes:
>> 

>> Not strongly.  As long as we have the uid ang gid valid checks in
>> there somewhere before we start using these uids and gids much.
>> This does seems to be the case of using out of range uids and gids
>> to mean out of range uids and gids.
>> 
>> In the description of my original patch before I split it up, I
>> noted that one of the small dangers might be that I had added
>> some possibly unneceessary uid and gid valid checks.  So it seems I had
>> even considered this slight possibility once and noted that there was a
>> slight chance we might have to remove a few of these.
>
> Ah, I should have seen that and checked that, my bad.

I think that text was lost when I split my nfs patch into all of those
patches so I don't expect  you ever saw that text.

>> It would be nice to have a comment to say that we expect this to happen
>> so people don't start wondering why there are missing checks on this
>> path.
>
> OK--something like the appended?

It looks good to me.

>> There is also a gid_valid check in the secondary uids.  It looks like we
>> should keep that as we don't have any checks for invalid gids in
>> nfsd_setuser.  Is that possibly an oversight in nfsd_setuser?
>
> Honestly I don't think anyone's thought that through....

I try and take these moments of that's weird to spark the thinking of
things through.  Just in case there is something important was
overlooked.

> But it would seem odd to pass down an "anonymous" supplementary gid--why
> not just leave it off the list instead?

True.

> (BTW, dumb question: is it legal for userspace to use a uid -1?  And was
> it illegal before the user namespace patches?)

It is now impossible and thus illegal for userspace to use a uid value
of -1.  Previously to use a uid of -1 you had to jump through hoops as
some system calls would allow it (setuid) and some system calls special
cased the value of -1 (setresuid).  Which mean using a uid value of -1
was while possible but a bad idea because various things would break in
strange ways.

>> Also looking towards a future in which all of these things don't reside
>> in the initial user namespace.  Is mapping any out of range uid to
>> INVALID_UID and then into ex_anon_uid the always the right thing to do?
>> 
>> Or is -1 a very special case in this instance.  In which case we
>> probably want checks that look like:
>
> svcgssd should pass down either -1 or a valid uid, so I don't think
> we're committed to any particular handling of invalid id's other than
> -1--whatever's easiest.

Sounds good.  I won't worry about them in future development then.

> commit d78f5cd062edb400190521e9540b042b4805875b
> Author: J. Bruce Fields <bfields@redhat.com>
> Date:   Mon Mar 4 08:44:01 2013 -0500
>
>     nfsd: fix krb5 handling of anonymous principals
>     
>     krb5 mounts started failing as of
>     683428fae8c73d7d7da0fa2e0b6beb4d8df4e808 "sunrpc: Update svcgss xdr
>     handle to rpsec_contect cache".
>     
>     The problem is that mounts are usually done with some host principal
>     which isn't normally mapped to any user, in which case svcgssd passes
>     down uid -1, which the kernel is then expected to map to the
>     export-specific anonymous uid or gid.
>     
>     The new uid_valid/gid_valid checks were therefore causing that downcall
>     to fail.
>     
>     (Note the regression may not have been seen with older userspace that
>     tended to map unknown principals to an anonymous id on their own rather
>     than leaving it to the kernel.)
>     
>     Signed-off-by: J. Bruce Fields <bfields@redhat.com>

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> index f7d34e7..c2ab26f 100644
> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> @@ -447,17 +447,21 @@ static int rsc_parse(struct cache_detail *cd,
>  	else {
>  		int N, i;
>  
> +		/*
> +		 * NOTE: we don't check uid_valid() or gid_valid(): instead,
> +		 * -1 id's are later mapped to the (export-specific)
> +		 * anonymous id by nfsd_setuser.
> +		 *
> +		 * (But supplementary gid's get no such special
> +		 * treatment so are checked for validity here.)
> +		 */
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
