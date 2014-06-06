Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaFFVs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:48:58 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54632 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFFVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1401818318-15780-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1401818318-15780-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1401818318-15780-2-git-send-email-zohar@linux.vnet.ibm.com>
Date: Sat, 7 Jun 2014 00:48:55 +0300
Message-ID: <CACE9dm909SGRBOybkh8z8jNiGPc_ksKHzsMuvNB+ro9furQ_tQ@mail.gmail.com>
Subject: Re: [RFC PATCH v5 1/4] KEYS: special dot prefixed keyring name bug fix
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

On 3 June 2014 20:58, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> Dot prefixed keyring names are supposed to be reserved for the
> kernel, but add_key() calls key_get_type_from_user(), which
> incorrectly verifies the 'type' field, not the 'description' field.
> This patch verifies the 'description' field isn't dot prefixed,
> when creating a new keyring, and removes the dot prefix test in
> key_get_type_from_user().
>
> Changelog v5:
> - Only prevent userspace from creating a dot prefixed keyring, not
>   regular keys  - Dmitry
>
> Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  security/keys/keyctl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
> index cd5bd0c..62a9952 100644
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
> @@ -86,6 +84,10 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
>                 if (!*description) {
>                         kfree(description);
>                         description = NULL;
> +               } else if ((description[0] == '.') &&
> +                          (strncmp(type, "keyring", 7) == 0)) {
> +                               ret = -EPERM;
> +                               goto error2;
>                 }
>         }
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I think it does not another problem...
It is not only prevent creating new keyring with ".abc" name but also
prevent adding new key...

this is wrong...

- Dmitry
