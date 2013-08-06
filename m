Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3HFSOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:14:46 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:63699 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3HFSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:14:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130806173855.GB24908@redhat.com>
References: <20130806143148.GG15178@dhcp-25-225.brq.redhat.com>
 <20130806164745.GA17343@redhat.com> <20130806173827.GA24908@redhat.com> <20130806173855.GB24908@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 6 Aug 2013 11:14:24 -0700
Message-ID: <CALCETrWbsT+HGvVQMV_fUEDa1otG+er0gU3H4v-_9FdWgYpY1g@mail.gmail.com>
Subject: Re: [PATCH 1/1] userns: unshare_userns(&cred) should not populate
 cred on failure
To: Oleg Nesterov <oleg@redhat.com>
Cc: security@kernel.org, oss-security@lists.openwall.com,
        Petr Matousek <pmatouse@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 10:38 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> unshare_userns(new_cred) does *new_cred = prepare_creds() before
> create_user_ns() which can fail. However, the caller expects that
> it doesn't need to take care of new_cred if unshare_userns() fails.
>
> We could change the single caller, sys_unshare(), but I think it
> would be more clean to avoid the side effects on failure, so with
> this patch unshare_userns() does put_cred() itself and initializes
> *new_cred only if create_user_ns() succeeeds.
>
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
>         struct cred *cred;
> +       int err = -ENOMEM;
>
>         if (!(unshare_flags & CLONE_NEWUSER))
>                 return 0;
>
>         cred = prepare_creds();
> -       if (!cred)
> -               return -ENOMEM;
> +       if (cred) {
> +               err = create_user_ns(cred);
> +               if (err)
> +                       put_cred(cred);
> +               else
> +                       *new_cred = cred;
> +       }
>
> -       *new_cred = cred;
> -       return create_user_ns(cred);
> +       return err;
>  }
>
>  void free_user_ns(struct user_namespace *ns)
> --
> 1.5.5.1
>
>

Reviewed-by: Andy Lutomirski <luto@amacapital.net>


-- 
Andy Lutomirski
AMA Capital Management, LLC
