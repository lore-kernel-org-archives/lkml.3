Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157AbaE3P64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:58:56 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60405 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965050AbaE3P6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <1401289784-31340-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1401289784-31340-2-git-send-email-zohar@linux.vnet.ibm.com>
Date: Fri, 30 May 2014 18:58:52 +0300
Message-ID: <CACE9dm8OMGH5V19iRkytPtQXt9qNha9Ca81P6dpy-cqE2s5NYg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/4] KEYS: special dot prefixed keyring name bug fix
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 18:09, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Dot prefixed keyring names are supposed to be reserved for the
> kernel, but add_key() calls key_get_type_from_user(), which
> incorrectly verifies the 'type' field, not the 'description' field.
> This patch verifies the 'description' field isn't dot prefixed,
> when creating a new keyring, and removes the dot prefix test in
> key_get_type_from_user().
>
> Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  security/keys/keyctl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index cd5bd0c..9e9a762 100644
> --- a/security/keys/keyctl.c
> +++ b/security/keys/keyctl.c
> @@ -37,8 +37,6 @@ static int key_get_type_from_user(char *type,
>                 return ret;
>         if (ret == 0 || ret >= len)
>                 return -EINVAL;
> -       if (type[0] == '.')
> -               return -EPERM;
>         type[len - 1] = '\0';
>         return 0;
>  }
> @@ -87,6 +85,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
>                         kfree(description);
>                         description = NULL;
>                 }
> +               if (description[0] == '.') {
> +                       ret = -EPERM;
> +                       goto error2;
> +               }

1. 3 lines above "discription = NULL" will cause kernel oops...
It happens when using empty description... like:

cat x509_ima.der | keyctl padd asymmetric "" keyid

2. It prevents adding trusted keys to ".ima" from user space...
This is NOT what we want... right?


- Dmitry


>         }
>
>         /* pull the payload in if one was supplied */
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,
Dmitry
