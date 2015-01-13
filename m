Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbAMXId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 18:08:33 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:62335 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbAMXIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 18:08:31 -0500
MIME-Version: 1.0
In-Reply-To: <1421188372-1783-1-git-send-email-salyzyn@android.com>
References: <1421188372-1783-1-git-send-email-salyzyn@android.com>
Date: Tue, 13 Jan 2015 15:08:31 -0800
X-Google-Sender-Auth: bJg7EW9Oimzk0iFDdBSaFcdrxbU
Message-ID: <CAGXu5jKeTzBepFogZvi0JbXnU8MuEi2tcQ45pQLdFMymmugvgw@mail.gmail.com>
Subject: Re: [PATCH 3/5] pstore: handle zero-sized prz in series
From: Kees Cook <keescook@chromium.org>
To: Mark Salyzyn <salyzyn@android.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 2:32 PM, Mark Salyzyn <salyzyn@android.com> wrote:
> ramoops_pstore_read fails to return the next in a prz
> series after first zero-sized entry, not venturing to
> the next non-zero entry.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>

This seems fine. Out of curiosity, when was the bad behavior this encountered?

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>  fs/pstore/ram.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 34ed8f8..6150e54 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -164,6 +164,12 @@ static int ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
>         return header_length;
>  }
>
> +static bool prz_ok(struct persistent_ram_zone *prz)
> +{
> +       return !!prz && !!(persistent_ram_old_size(prz) +
> +                          persistent_ram_ecc_string(prz, NULL, 0));
> +}
> +
>  static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>                                    int *count, struct timespec *time,
>                                    char **buf, bool *compressed,
> @@ -178,13 +184,13 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>         prz = ramoops_get_next_prz(cxt->przs, &cxt->dump_read_cnt,
>                                    cxt->max_dump_cnt, id, type,
>                                    PSTORE_TYPE_DMESG, 1);
> -       if (!prz)
> +       if (!prz_ok(prz))
>                 prz = ramoops_get_next_prz(&cxt->cprz, &cxt->console_read_cnt,
>                                            1, id, type, PSTORE_TYPE_CONSOLE, 0);
> -       if (!prz)
> +       if (!prz_ok(prz))
>                 prz = ramoops_get_next_prz(&cxt->fprz, &cxt->ftrace_read_cnt,
>                                            1, id, type, PSTORE_TYPE_FTRACE, 0);
> -       if (!prz)
> +       if (!prz_ok(prz))
>                 return 0;
>
>         if (!persistent_ram_old(prz))
> --
> 2.2.0.rc0.207.ga3a616c
>



-- 
Kees Cook
Chrome OS Security
