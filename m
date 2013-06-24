Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3FXR5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:57:37 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35824 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3FXR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:57:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130624062316.12963.87911.stgit@aruna-ThinkPad-T420>
References: <20130624061936.12963.72529.stgit@aruna-ThinkPad-T420>
	<20130624062316.12963.87911.stgit@aruna-ThinkPad-T420>
Date: Mon, 24 Jun 2013 10:57:35 -0700
X-Google-Sender-Auth: SIKqPWFWLMCmUtl-KM9B1PBiWDY
Message-ID: <CAGXu5jJezRynWEBmmH8wp=pt1yEjukhe6Pg_aRcZP7E6t-1R=g@mail.gmail.com>
Subject: Re: [PATCH 3/3] powerpc/pseries: Support compression of oops text via pstore
From: Kees Cook <keescook@chromium.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
        LKML <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        jkenisto@linux.vnet.ibm.com, Tony Luck <tony.luck@intel.com>,
        ananth@in.ibm.com, mahesh@linux.vnet.ibm.com,
        Colin Cross <ccross@android.com>, Anton Blanchard <anton@samba.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 11:23 PM, Aruna Balakrishnaiah
<aruna@linux.vnet.ibm.com> wrote:
> The patch set supports compression of oops messages while writing to NVRAM,
> this helps in capturing more of oops data to lnx,oops-log. The pstore file
> for oops messages will be in decompressed format making it readable.
>
> In case compression fails, the patch takes care of copying the header added
> by pstore and last oops_data_sz bytes of big_oops_buf to NVRAM so that we
> have recent oops messages in lnx,oops-log.
>
> In case decompression fails, it will result in absence of oops file but still
> have files (in /dev/pstore) for other partitions.
>
> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/nvram.c |  132 +++++++++++++++++++++++++++++---
>  1 file changed, 118 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
> index 0159d74..b5ba5e2 100644
> --- a/arch/powerpc/platforms/pseries/nvram.c
> +++ b/arch/powerpc/platforms/pseries/nvram.c
> @@ -539,6 +539,65 @@ static int zip_oops(size_t text_len)
>  }
>
>  #ifdef CONFIG_PSTORE
> +/* Derived from logfs_uncompress */
> +int nvram_decompress(void *in, void *out, size_t inlen, size_t outlen)
> +{
> +       int err, ret;
> +
> +       ret = -EIO;
> +       err = zlib_inflateInit(&stream);
> +       if (err != Z_OK)
> +               goto error;
> +
> +       stream.next_in = in;
> +       stream.avail_in = inlen;
> +       stream.total_in = 0;
> +       stream.next_out = out;
> +       stream.avail_out = outlen;
> +       stream.total_out = 0;
> +
> +       err = zlib_inflate(&stream, Z_FINISH);
> +       if (err != Z_STREAM_END)
> +               goto error;
> +
> +       err = zlib_inflateEnd(&stream);
> +       if (err != Z_OK)
> +               goto error;
> +
> +       ret = stream.total_out;
> +error:
> +       return ret;
> +}
> +
> +static int unzip_oops(char *oops_buf, char *big_buf)
> +{
> +       struct oops_log_info *oops_hdr = (struct oops_log_info *)oops_buf;
> +       u64 timestamp = oops_hdr->timestamp;
> +       char *big_oops_data = NULL;
> +       char *oops_data_buf = NULL;
> +       size_t big_oops_data_sz;
> +       int unzipped_len;
> +
> +       big_oops_data = big_buf + sizeof(struct oops_log_info);
> +       big_oops_data_sz = big_oops_buf_sz - sizeof(struct oops_log_info);
> +       oops_data_buf = oops_buf + sizeof(struct oops_log_info);
> +
> +       unzipped_len = nvram_decompress(oops_data_buf, big_oops_data,
> +                                       oops_hdr->report_length,
> +                                       big_oops_data_sz);
> +
> +       if (unzipped_len < 0) {
> +               pr_err("nvram: decompression failed; returned %d\n",
> +                                                               unzipped_len);
> +               return -1;
> +       }
> +       oops_hdr = (struct oops_log_info *)big_buf;
> +       oops_hdr->version = OOPS_HDR_VERSION;
> +       oops_hdr->report_length = (u16) unzipped_len;
> +       oops_hdr->timestamp = timestamp;
> +       return 0;
> +}
> +
>  static int nvram_pstore_open(struct pstore_info *psi)
>  {
>         /* Reset the iterator to start reading partitions again */
> @@ -567,6 +626,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
>                                 size_t size, struct pstore_info *psi)
>  {
>         int rc;
> +       unsigned int err_type = ERR_TYPE_KERNEL_PANIC;
>         struct oops_log_info *oops_hdr = (struct oops_log_info *) oops_buf;
>
>         /* part 1 has the recent messages from printk buffer */
> @@ -577,8 +637,31 @@ static int nvram_pstore_write(enum pstore_type_id type,
>         oops_hdr->version = OOPS_HDR_VERSION;
>         oops_hdr->report_length = (u16) size;
>         oops_hdr->timestamp = get_seconds();
> +
> +       if (big_oops_buf) {
> +               rc = zip_oops(size);
> +               /*
> +                * If compression fails copy recent log messages from
> +                * big_oops_buf to oops_data.
> +                */
> +               if (rc != 0) {
> +                       int hsize = pstore_get_header_size();

I think I would rather see the API to pstore_write() changed to
include explicit details about header sizes. Mkaing hsize a global
seems unwise, since it's not strictly going to be a constant value. It
could change between calls to the writer, for example.

Beyond that, this all seems sensible, though it would be kind of cool
to move this compression logic into the pstore core so it would get
used by default (or through a module parameter).

-Kees

> +                       size_t diff = size - oops_data_sz + hsize;
> +
> +                       if (size > oops_data_sz) {
> +                               memcpy(oops_data, big_oops_buf, hsize);
> +                               memcpy(oops_data + hsize, big_oops_buf + diff,
> +                                       oops_data_sz - hsize);
> +
> +                               oops_hdr->report_length = (u16) oops_data_sz;
> +                       } else
> +                               memcpy(oops_data, big_oops_buf, size);
> +               } else
> +                       err_type = ERR_TYPE_KERNEL_PANIC_GZ;
> +       }
> +
>         rc = nvram_write_os_partition(&oops_log_partition, oops_buf,
> -               (int) (sizeof(*oops_hdr) + size), ERR_TYPE_KERNEL_PANIC,
> +               (int) (sizeof(*oops_hdr) + oops_hdr->report_length), err_type,
>                 count);
>
>         if (rc != 0)
> @@ -600,10 +683,11 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
>         struct oops_log_info *oops_hdr;
>         unsigned int err_type, id_no, size = 0;
>         struct nvram_os_partition *part = NULL;
> -       char *buff = NULL;
> -       int sig = 0;
> +       char *buff = NULL, *big_buff = NULL;
> +       int rc, sig = 0;
>         loff_t p;
>
> +read_partition:
>         read_type++;
>
>         switch (nvram_type_ids[read_type]) {
> @@ -666,6 +750,25 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
>         if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
>                 oops_hdr = (struct oops_log_info *)buff;
>                 *buf = buff + sizeof(*oops_hdr);
> +
> +               if (err_type == ERR_TYPE_KERNEL_PANIC_GZ) {
> +                       big_buff = kmalloc(big_oops_buf_sz, GFP_KERNEL);
> +                       if (!big_buff)
> +                               return -ENOMEM;
> +
> +                       rc = unzip_oops(buff, big_buff);
> +
> +                       if (rc != 0) {
> +                               kfree(buff);
> +                               kfree(big_buff);
> +                               goto read_partition;
> +                       }
> +
> +                       oops_hdr = (struct oops_log_info *)big_buff;
> +                       *buf = big_buff + sizeof(*oops_hdr);
> +                       kfree(buff);
> +               }
> +
>                 time->tv_sec = oops_hdr->timestamp;
>                 time->tv_nsec = 0;
>                 return oops_hdr->report_length;
> @@ -687,17 +790,18 @@ static int nvram_pstore_init(void)
>  {
>         int rc = 0;
>
> -       nvram_pstore_info.buf = oops_data;
> -       nvram_pstore_info.bufsize = oops_data_sz;
> +       if (big_oops_buf) {
> +               nvram_pstore_info.buf = big_oops_buf;
> +               nvram_pstore_info.bufsize = big_oops_buf_sz;
> +       } else {
> +               nvram_pstore_info.buf = oops_data;
> +               nvram_pstore_info.bufsize = oops_data_sz;
> +       }
>
>         rc = pstore_register(&nvram_pstore_info);
>         if (rc != 0)
>                 pr_err("nvram: pstore_register() failed, defaults to "
>                                 "kmsg_dump; returned %d\n", rc);
> -       else
> -               /*TODO: Support compression when pstore is configured */
> -               pr_info("nvram: Compression of oops text supported only when "
> -                               "pstore is not configured");
>
>         return rc;
>  }
> @@ -731,11 +835,6 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
>         oops_data = oops_buf + sizeof(struct oops_log_info);
>         oops_data_sz = oops_log_partition.size - sizeof(struct oops_log_info);
>
> -       rc = nvram_pstore_init();
> -
> -       if (!rc)
> -               return;
> -
>         /*
>          * Figure compression (preceded by elimination of each line's <n>
>          * severity prefix) will reduce the oops/panic report to at most
> @@ -759,6 +858,11 @@ static void __init nvram_init_oops_partition(int rtas_partition_exists)
>                 stream.workspace = NULL;
>         }
>
> +       rc = nvram_pstore_init();
> +
> +       if (!rc)
> +               return;
> +
>         rc = kmsg_dump_register(&nvram_kmsg_dumper);
>         if (rc != 0) {
>                 pr_err("nvram: kmsg_dump_register() failed; returned %d\n", rc);
>



--
Kees Cook
Chrome OS Security
