Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab3HFI4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:56:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1980 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3HFI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:56:47 -0400
X-Spam-Score: -100.8
Message-ID: <5200BA10.6090102@asianux.com>
Date: Tue, 06 Aug 2013 16:55:44 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/sys.c: remove useless variable 'old_fsuid'
 for setfsuid()
References: <5200AD26.8070701@asianux.com> <5200B017.7030401@asianux.com> <5200B088.9040305@asianux.com> <5200B0FB.9040202@asianux.com>
In-Reply-To: <5200B0FB.9040202@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:16 PM, Chen Gang wrote:
> Remove useless variable 'old_fsuid' to make code clearer for readers.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/sys.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 558ccdb..e3983b2 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -728,11 +728,9 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
>  {
>  	const struct cred *old;
>  	struct cred *new;
> -	uid_t old_fsuid;
>  	kuid_t kuid;
>  
>  	old = current_cred();
> -	old_fsuid = from_kuid_munged(old->user_ns, old->fsuid);
>  

Oh... should old_fsuid be get before commit_creds() or prepare_creds() ?

>  	kuid = make_kuid(old->user_ns, uid);
>  	if (!uid_valid(kuid))
> @@ -747,17 +745,17 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
>  	    nsown_capable(CAP_SETUID)) {
>  		if (!uid_eq(kuid, old->fsuid)) {
>  			new->fsuid = kuid;
> -			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
> -				goto change_okay;
> +			if (security_task_fix_setuid(new,
> +			    old, LSM_SETID_FS) == 0) {
> +				commit_creds(new);
> +				return from_kuid_munged(old->user_ns,
> +							old->fsuid);
> +			}

Oh... should old_fsuid be get before commit_creds() or prepare_creds() ?

>  		}
>  	}
>  
>  	abort_creds(new);
>  	return uid;
> -
> -change_okay:
> -	commit_creds(new);
> -	return old_fsuid;
>  }
>  
>  /*
> 


-- 
Chen Gang
