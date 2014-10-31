Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbaJaQEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:04:40 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39752 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbaJaQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:04:38 -0400
MIME-Version: 1.0
In-Reply-To: <1414714461-4999-1-git-send-email-benzh@chromium.org>
References: <1414714461-4999-1-git-send-email-benzh@chromium.org>
Date: Fri, 31 Oct 2014 09:04:37 -0700
X-Google-Sender-Auth: RN22FpyYazdi2EvOEt-48yQWBvg
Message-ID: <CAGXu5j+6+R9c3pMRXeij+ns8hjG5-NCpvxyBiY1fkhrLONqB=A@mail.gmail.com>
Subject: Re: [PATCH] pstore/ram: strip ramoops header for correct decompression
From: Kees Cook <keescook@chromium.org>
To: Ben Zhang <benzh@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 5:14 PM, Ben Zhang <benzh@chromium.org> wrote:
> pstore compression/decompression was added during 3.12.
> The ramoops driver prepends a "====timestamp.timestamp-C|D\n"
> header to the compressed record before handing it over to pstore
> driver which doesn't know about the header. In pstore_decompress(),
> the pstore driver reads the first "==" as a zlib header, so the
> decompression always fails. For example, this causes the driver
> to write /dev/pstore/dmesg-ramoops-0.enc.z instead of
> /dev/pstore/dmesg-ramoops-0.
>
> This patch makes the ramoops driver remove the header before
> pstore decompression.
>
> Signed-off-by: Ben Zhang <benzh@chromium.org>

Ah, good catch. Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/pstore/ram.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 3b57443..ec881b3 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -135,25 +135,27 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
>         return prz;
>  }
>
> -static void ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
> +static int ramoops_read_kmsg_hdr(char *buffer, struct timespec *time,
>                                   bool *compressed)
>  {
>         char data_type;
> +       int header_length = 0;
>
> -       if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu-%c\n",
> -                       &time->tv_sec, &time->tv_nsec, &data_type) == 3) {
> +       if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu-%c\n%n", &time->tv_sec,
> +                       &time->tv_nsec, &data_type, &header_length) == 3) {
>                 if (data_type == 'C')
>                         *compressed = true;
>                 else
>                         *compressed = false;
> -       } else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
> -                       &time->tv_sec, &time->tv_nsec) == 2) {
> +       } else if (sscanf(buffer, RAMOOPS_KERNMSG_HDR "%lu.%lu\n%n",
> +                       &time->tv_sec, &time->tv_nsec, &header_length) == 2) {
>                         *compressed = false;
>         } else {
>                 time->tv_sec = 0;
>                 time->tv_nsec = 0;
>                 *compressed = false;
>         }
> +       return header_length;
>  }
>
>  static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
> @@ -165,6 +167,7 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>         ssize_t ecc_notice_size;
>         struct ramoops_context *cxt = psi->data;
>         struct persistent_ram_zone *prz;
> +       int header_length;
>
>         prz = ramoops_get_next_prz(cxt->przs, &cxt->dump_read_cnt,
>                                    cxt->max_dump_cnt, id, type,
> @@ -178,7 +181,13 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>         if (!prz)
>                 return 0;
>
> +       if (!persistent_ram_old(prz))
> +               return 0;
> +
>         size = persistent_ram_old_size(prz);
> +       header_length = ramoops_read_kmsg_hdr(persistent_ram_old(prz), time,
> +                       compressed);
> +       size -= header_length;
>
>         /* ECC correction notice */
>         ecc_notice_size = persistent_ram_ecc_string(prz, NULL, 0);
> @@ -187,8 +196,7 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>         if (*buf == NULL)
>                 return -ENOMEM;
>
> -       memcpy(*buf, persistent_ram_old(prz), size);
> -       ramoops_read_kmsg_hdr(*buf, time, compressed);
> +       memcpy(*buf, (char *)persistent_ram_old(prz) + header_length, size);
>         persistent_ram_ecc_string(prz, *buf + size, ecc_notice_size + 1);
>
>         return size + ecc_notice_size;
> --
> 2.1.0.rc2.206.gedb03e5
>



-- 
Kees Cook
Chrome OS Security
