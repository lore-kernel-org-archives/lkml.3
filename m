Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3KAQ3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:29:05 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:32853 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab3KAQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:29:00 -0400
MIME-Version: 1.0
In-Reply-To: <87ppqk6qvx.fsf@redhat.com>
References: <87ppqk6qvx.fsf@redhat.com>
Date: Fri, 1 Nov 2013 17:28:59 +0100
Message-ID: <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Madper Xie <cxie@redhat.com>
Cc: Tony Luck <tony.luck@gmail.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?UTF-8?B?6LCi5oiQ6aqP?= <bbboson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 5:14 PM, Madper Xie <cxie@redhat.com> wrote:
>
> Pstore fs expects that backends provide a uniqued id which could avoid
> pstore making entries as duplication or denominating entries the same
> name. So I combine the timestamp, part and count into id.
>
> Signed-off-by: Madper Xie <cxie@redhat.com>
> ---
>  drivers/firmware/efi/efi-pstore.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> index 5002d50..0de9179 100644
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -39,6 +39,17 @@ struct pstore_read_data {
>         char **buf;
>  };
>
> +static u64 efi_generate_id(unsigned long timestamp, unsigned int part, int count)
> +{
> +       char id_str[64];
> +       u64 id = 0;
> +
> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
> +       if (kstrtoull(id_str, 10, &id))
> +               pr_warn("efi-pstore: failed to generate id\n");
> +       return id;
> +}

This is just odd. You make a string from three ints and then a parse
it to a int again.

>  static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>  {
>         efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> @@ -57,17 +68,18 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>
>         if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
>                    cb_data->type, &part, &cnt, &time, &data_type) == 5) {
> -               *cb_data->id = part;
> +               *cb_data->id = efi_generate_id(time, part, cnt);
>                 *cb_data->count = cnt;
>                 cb_data->timespec->tv_sec = time;
>                 cb_data->timespec->tv_nsec = 0;
> +
>                 if (data_type == 'C')
>                         *cb_data->compressed = true;
>                 else
>                         *cb_data->compressed = false;
>         } else if (sscanf(name, "dump-type%u-%u-%d-%lu",
>                    cb_data->type, &part, &cnt, &time) == 4) {
> -               *cb_data->id = part;
> +               *cb_data->id = efi_generate_id(time, part, cnt);
>                 *cb_data->count = cnt;
>                 cb_data->timespec->tv_sec = time;
>                 cb_data->timespec->tv_nsec = 0;
> @@ -79,7 +91,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>                  * which doesn't support holding
>                  * multiple logs, remains.
>                  */
> -               *cb_data->id = part;
> +               *cb_data->id = efi_generate_id(time, part, 0);
>                 *cb_data->count = 0;
>                 cb_data->timespec->tv_sec = time;
>                 cb_data->timespec->tv_nsec = 0;
> @@ -125,9 +137,11 @@ static int efi_pstore_write(enum pstore_type_id type,
>         efi_char16_t efi_name[DUMP_NAME_LEN];
>         efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>         int i, ret = 0;
> +       unsigned long timestamp;
>
> +       timestamp = get_seconds();
>         sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
> -               get_seconds(), compressed ? 'C' : 'D');
> +               timestamp, compressed ? 'C' : 'D');
>
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = name[i];
> --
> 1.8.4.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
