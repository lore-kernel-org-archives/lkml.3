Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3HTOKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:10:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3HTOKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:10:51 -0400
Date: Tue, 20 Aug 2013 09:10:32 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: user_namespace: always set the return parameter
 'new_cred' when call unshare_userns() successfully.
Message-ID: <20130820141032.GA4766@sergelap>
References: <5212DA37.1090101@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212DA37.1090101@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Gang (gang.chen@asianux.com):
> When unshare_userns() succeed, recommend to always set the return
> parameter which may be used by caller.
> 
> The caller has rights to call it with 'new_cred' uninitialized, if
> succeed, the caller can assume the 'new_cred' has been initialized.

But the only existing caller (sys_unshare) does in fact initialize it to
NULL.  So while this patch does no harm, is it necessary?

> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/user_namespace.h |    1 +
>  kernel/user_namespace.c        |    4 +++-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index b6b215f..3159af5 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -75,6 +75,7 @@ static inline int unshare_userns(unsigned long unshare_flags,
>  {
>  	if (unshare_flags & CLONE_NEWUSER)
>  		return -EINVAL;
> +	*new_cred = NULL;
>  	return 0;
>  }
>  
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 6e50a44..6b90818 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -107,8 +107,10 @@ int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
>  	struct cred *cred;
>  	int err = -ENOMEM;
>  
> -	if (!(unshare_flags & CLONE_NEWUSER))
> +	if (!(unshare_flags & CLONE_NEWUSER)) {
> +		*new_cred = NULL;
>  		return 0;
> +	}
>  
>  	cred = prepare_creds();
>  	if (cred) {
> -- 
> 1.7.7.6
