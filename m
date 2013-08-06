Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab3HFUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:21:52 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62091 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3HFUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:21:51 -0400
Message-ID: <52015ADB.30408@mit.edu>
Date: Tue, 06 Aug 2013 13:21:47 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel/sys.c: return the current gid when error occurs
References: <5200AD26.8070701@asianux.com> <5200AD67.1030109@asianux.com>
In-Reply-To: <5200AD67.1030109@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 01:01 AM, Chen Gang wrote:
> According to the API definition, when error occurs, need return current
> fsgid instead of the previous one.
> 
> The related informations ("man setfsgid"):
> 
>   RETURN VALUE
>          On success, the previous value of fsgid is returned.  On error, the current value of fsgid is returned.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/sys.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 771129b..9356dc8 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -775,11 +775,11 @@ SYSCALL_DEFINE1(setfsgid, gid_t, gid)
>  
>  	kgid = make_kgid(old->user_ns, gid);
>  	if (!gid_valid(kgid))
> -		return old_fsgid;
> +		return gid;

Huh?  So if 1234567 is not a valid gid, then setfsgid(1234567) is
supposed to return 1234567?  This makes no sense.

I assume that what the man page means is that the return value is
whatever fsgid was prior to the call.  On error, fsgid isn't changed, so
the return value is still "current".

(FWIW, this behavior is awful and is probably the cause of a security
bug or three, since success and failure are indistinguishable.  But I
think your patch is wrong.)

--Andy
