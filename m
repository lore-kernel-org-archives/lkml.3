Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab3HFU5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:57:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36565 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab3HFU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:56:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: security@kernel.org, oss-security@lists.openwall.com,
        Petr Matousek <pmatouse@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
References: <20130806143148.GG15178@dhcp-25-225.brq.redhat.com>
	<20130806164745.GA17343@redhat.com>
	<20130806173827.GA24908@redhat.com>
	<20130806173855.GB24908@redhat.com>
Date: Tue, 06 Aug 2013 13:56:41 -0700
In-Reply-To: <20130806173855.GB24908@redhat.com> (Oleg Nesterov's message of
	"Tue, 6 Aug 2013 19:38:55 +0200")
Message-ID: <8738qmilme.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19aTp0p8sdI30qdWtSYM7lfxw1hO1LDK0s=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3500]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/1] userns: unshare_userns(&cred) should not populate cred on failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> unshare_userns(new_cred) does *new_cred = prepare_creds() before
> create_user_ns() which can fail. However, the caller expects that
> it doesn't need to take care of new_cred if unshare_userns() fails.
>
> We could change the single caller, sys_unshare(), but I think it
> would be more clean to avoid the side effects on failure, so with
> this patch unshare_userns() does put_cred() itself and initializes
> *new_cred only if create_user_ns() succeeeds.

Doh!

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Cc: stable@vger.kernel.org
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/user_namespace.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index d8c30db..6e50a44 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -105,16 +105,21 @@ int create_user_ns(struct cred *new)
>  int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
>  {
>  	struct cred *cred;
> +	int err = -ENOMEM;
>  
>  	if (!(unshare_flags & CLONE_NEWUSER))
>  		return 0;
>  
>  	cred = prepare_creds();
> -	if (!cred)
> -		return -ENOMEM;
> +	if (cred) {
> +		err = create_user_ns(cred);
> +		if (err)
> +			put_cred(cred);
> +		else
> +			*new_cred = cred;
> +	}
>  
> -	*new_cred = cred;
> -	return create_user_ns(cred);
> +	return err;
>  }
>  
>  void free_user_ns(struct user_namespace *ns)
