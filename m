Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaGTDG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 23:06:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaGTDG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 23:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <1405373897-31671-6-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-6-git-send-email-keescook@chromium.org>
Date: Sun, 20 Jul 2014 11:06:55 +0800
Message-ID: <CACVXFVOwG8ekCdrKuCndsqaJS1H7uVwJuEP-B6hxNsu9yM-g9w@mail.gmail.com>
Subject: Re: [PATCH 5/7] firmware_class: extract start loading logic
From: Ming Lei <ming.lei@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:38 AM, Kees Cook <keescook@chromium.org> wrote:
> Extract the logic performed when starting a new firmware load.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ming Lei <ming.lei@canonical.com>

> ---
>  drivers/base/firmware_class.c |   29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 7399bab71ced..b38cbcd6ebb1 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -604,6 +604,23 @@ static int fw_map_pages_buf(struct firmware_buf *buf)
>         return 0;
>  }
>
> +/* fw_lock must be held */
> +static void fw_load_start(struct firmware_buf *fw_buf)
> +{
> +       /* discarding any previous partial load */
> +       if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
> +               int i;
> +
> +               for (i = 0; i < fw_buf->nr_pages; i++)
> +                       __free_page(fw_buf->pages[i]);
> +               kfree(fw_buf->pages);
> +               fw_buf->pages = NULL;
> +               fw_buf->page_array_size = 0;
> +               fw_buf->nr_pages = 0;
> +               set_bit(FW_STATUS_LOADING, &fw_buf->status);
> +       }
> +}
> +
>  /**
>   * firmware_loading_store - set value in the 'loading' control file
>   * @dev: device pointer
> @@ -624,7 +641,6 @@ static ssize_t firmware_loading_store(struct device *dev,
>         struct firmware_priv *fw_priv = to_firmware_priv(dev);
>         struct firmware_buf *fw_buf;
>         int loading = simple_strtol(buf, NULL, 10);
> -       int i;
>
>         mutex_lock(&fw_lock);
>         fw_buf = fw_priv->buf;
> @@ -633,16 +649,7 @@ static ssize_t firmware_loading_store(struct device *dev,
>
>         switch (loading) {
>         case 1:
> -               /* discarding any previous partial load */
> -               if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
> -                       for (i = 0; i < fw_buf->nr_pages; i++)
> -                               __free_page(fw_buf->pages[i]);
> -                       kfree(fw_buf->pages);
> -                       fw_buf->pages = NULL;
> -                       fw_buf->page_array_size = 0;
> -                       fw_buf->nr_pages = 0;
> -                       set_bit(FW_STATUS_LOADING, &fw_buf->status);
> -               }
> +               fw_load_start(fw_buf);
>                 break;
>         case 0:
>                 if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
