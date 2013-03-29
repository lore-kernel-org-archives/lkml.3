Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3C2BBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:01:50 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:35027 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3C2BBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <1363844081-17182-1-git-send-email-kpark3469@gmail.com>
References: <1363844081-17182-1-git-send-email-kpark3469@gmail.com>
Date: Fri, 29 Mar 2013 10:01:48 +0900
Message-ID: <CA+KhAHbCJY915ARbBsTa3Ud1GD4LOPjHCWXcna69V3JbYLG1OQ@mail.gmail.com>
Subject: Re: [PATCH v2] tracepoints: prevents null probe from being added
From: Keun-O Park <kpark3469@gmail.com>
To: rostedt@goodmis.org
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org,
        kpark3469@gmail.com, mathieu.desnoyers@efficios.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 2:34 PM,  <kpark3469@gmail.com> wrote:
> From: Sahara <keun-o.park@windriver.com>
>
> Somehow tracepoint_entry_add_probe function allows a null probe function.
> And, this may lead to unexpected result since the number of probe
> functions in an entry can be counted by checking whether probe is null
> or not in for-loop.
> This patch prevents the null probe from being added.
> In tracepoint_entry_remove_probe function, checking probe parameter
> within for-loop is moved out for code efficiency leaving the null probe
> feature which removes all probe functions in the entry.
>
> Signed-off-by: Sahara <keun-o.park@windriver.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/tracepoint.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 0c05a45..7d69348 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
>         int nr_probes = 0;
>         struct tracepoint_func *old, *new;
>
> -       WARN_ON(!probe);
> +       if (WARN_ON(!probe))
> +               return ERR_PTR(-EINVAL);
>
>         debug_print_probes(entry);
>         old = entry->funcs;
> @@ -152,13 +153,15 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>
>         debug_print_probes(entry);
>         /* (N -> M), (N > 1, M >= 0) probes */
> -       for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> -               if (!probe ||
> -                   (old[nr_probes].func == probe &&
> -                    old[nr_probes].data == data))
> -                       nr_del++;
> +       if (probe) {
> +               for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
> +                       if (old[nr_probes].func == probe &&
> +                            old[nr_probes].data == data)
> +                               nr_del++;
> +               }
>         }
>
> +       /* If probe is NULL, all funcs in the entry will be removed. */
>         if (nr_probes - nr_del == 0) {
>                 /* N -> 0, (N > 1) */
>                 entry->funcs = NULL;
> @@ -173,8 +176,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
>                 if (new == NULL)
>                         return ERR_PTR(-ENOMEM);
>                 for (i = 0; old[i].func; i++)
> -                       if (probe &&
> -                           (old[i].func != probe || old[i].data != data))
> +                       if (old[i].func != probe || old[i].data != data)
>                                 new[j++] = old[i];
>                 new[nr_probes - nr_del].func = NULL;
>                 entry->refcount = nr_probes - nr_del;
> --
> 1.7.1
>

Hi Steve,
Please check out this v2 patch. Seemingly I got no response from you.
Thanks.

-- Kpark
