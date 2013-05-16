Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3EPQQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:16:35 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57459 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3EPQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130516154355.GB19060@redhat.com>
References: <20130515201158.GA14606@redhat.com> <20130516154323.GA19060@redhat.com>
 <20130516154355.GB19060@redhat.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 16 May 2013 13:16:08 -0300
Message-ID: <CAKi4VAKj+s0Z9QHfqwG3+y33puL4dVaou5ys+eiD-yLf8h5QrA@mail.gmail.com>
Subject: Re: [PATCH 1/1] usermodehelper: check subprocess_info->path != NULL
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Neil Horman <nhorman@tuxdriver.com>, security@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

On Thu, May 16, 2013 at 12:43 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> argv_split(empty_or_all_spaces) happily succeeds, it simply returns
> argc == 0 and argv[0] == NULL. Change call_usermodehelper_exec() to
> check sub_info->path != NULL to avoid the crash.
>
> This is the minimal fix, todo:
>
>         - perhaps we should change argv_split() to return NULL or
>           change the callers.

Changing argv_split() would be the easiest way, but then we can't
differentiate the errors. Right now it returns NULL only on ENOMEM.


>
>         - kill or justify ->path[0] check

I'm not sure about this, it's already there before my refactor and I
don't think it makes any good. From modprobe pespective, I'd say it
would be better to give an error than say everything went ok.


>
>         - narrow the scope of helper_lock()
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  kernel/kmod.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 1296e72..8241906 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -569,6 +569,11 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>         int retval = 0;
>
>         helper_lock();
> +       if (!sub_info->path) {
> +               retval = -EINVAL;
> +               goto out;
> +       }
> +
>         if (sub_info->path[0] == '\0')
>                 goto out;
>
> --

Acked-By: Lucas De Marchi <lucas.demarchi@intel.com>


Lucas De Marchi
