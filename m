Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3JRJBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:01:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41891 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3JRJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:01:52 -0400
MIME-Version: 1.0
In-Reply-To: <1382086049-14386-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382086049-14386-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Fri, 18 Oct 2013 10:01:50 +0100
Message-ID: <CAB3z_Ro7gEx70rNO91id1ncJH6a6RXfO1j4paXxREmnR2zdMWA@mail.gmail.com>
Subject: Re: [PATCH] init: make init failures more explicit
From: Kieran Bingham <kieranbingham@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fantastic

I've been hurt by this in the past
 - and this patch would certainly would have helped save some time!

--
Kieran

On 18 October 2013 09:47, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This patch proposes to make init failures more explicit.
>
> Before this, the "No init found" message didn't help much.
> It could sometimes be misleading and actually mean
> "No *working* init found".
>
> This message could hide many different issues:
> - no init program candidates found at all
> - some init program candidates exist but can't be executed
>   (missing execute permissions, failed to load shared libraries,
>   executable compiled for an unknown architecture...)
>
> This patch notifies the kernel user when a candidate
> init program is found but can't be executed. It also replaces
> "No init found" by "No working init found", which is more correct.
>
> This will help embedded Linux developers (especially the new comers),
> regularly making and debugging new root filesystems.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  init/main.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 63d3e8f..a9a2833 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -811,6 +811,20 @@ static int run_init_process(const char *init_filename)
>                 (const char __user *const __user *)envp_init);
>  }
>
> +static int try_to_run_init_process(const char *init_filename)
> +{
> +       int ret;
> +
> +       ret = run_init_process(init_filename);
> +
> +       if (ret && ret != -ENOENT) {
> +               pr_err("Starting init: %s exists but couldn't execute it\n",
> +                      init_filename);
> +       }
> +
> +       return ret;
> +}
> +
>  static noinline void __init kernel_init_freeable(void);
>
>  static int __ref kernel_init(void *unused)
> @@ -843,13 +857,13 @@ static int __ref kernel_init(void *unused)
>                 pr_err("Failed to execute %s.  Attempting defaults...\n",
>                         execute_command);
>         }
> -       if (!run_init_process("/sbin/init") ||
> -           !run_init_process("/etc/init") ||
> -           !run_init_process("/bin/init") ||
> -           !run_init_process("/bin/sh"))
> +       if (!try_to_run_init_process("/sbin/init") ||
> +           !try_to_run_init_process("/etc/init") ||
> +           !try_to_run_init_process("/bin/init") ||
> +           !try_to_run_init_process("/bin/sh"))
>                 return 0;
>
> -       panic("No init found.  Try passing init= option to kernel. "
> +       panic("No working init found.  Try passing init= option to kernel. "
>               "See Linux Documentation/init.txt for guidance.");
>  }
>
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
