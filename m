Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3HFI5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:57:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2589 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3HFI5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:57:34 -0400
X-Spam-Score: -100.8
Message-ID: <5200BA3F.3090809@asianux.com>
Date: Tue, 06 Aug 2013 16:56:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kernel/sys.c: remove useless variable 'old_fsgid'
 for setfsgid()
References: <5200AD26.8070701@asianux.com> <5200ADB0.7020206@asianux.com>
In-Reply-To: <5200ADB0.7020206@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:02 PM, Chen Gang wrote:
> Remove useless variable 'old_fsgid' to make code clearer for readers.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/sys.c |    9 ++-------
>  1 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 9356dc8..fc169d8 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -767,11 +767,9 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
>  {
>  	const struct cred *old;
>  	struct cred *new;
> -	gid_t old_fsgid;
>  	kgid_t kgid;
>  
>  	old = current_cred();
> -	old_fsgid = from_kgid_munged(old->user_ns, old->fsgid);
>  
>  	kgid = make_kgid(old->user_ns, gid);
>  	if (!gid_valid(kgid))
> @@ -786,16 +784,13 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
>  	    nsown_capable(CAP_SETGID)) {
>  		if (!gid_eq(kgid, old->fsgid)) {
>  			new->fsgid = kgid;
> -			goto change_okay;
> +			commit_creds(new);
> +			return from_kgid_munged(old->user_ns, old->fsgid);

The same, should old_fsgid be get before commit_creds() or prepare_creds() ?

Thanks.

>  		}
>  	}
>  
>  	abort_creds(new);
>  	return gid;
> -
> -change_okay:
> -	commit_creds(new);
> -	return old_fsgid;
>  }
>  
>  /**
> 


-- 
Chen Gang
