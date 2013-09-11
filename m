Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3IKLyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:54:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3IKLyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
References: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
Date: Wed, 11 Sep 2013 19:54:28 +0800
Message-ID: <CACVXFVPRWEXMHyGhfZVGX2HrL3cguqVBUjTS51r2p8EGt=EPdg@mail.gmail.com>
Subject: Re: [PATCH] firmware: Be a bit more verbose about direct firmware
 loading failure
From: Ming Lei <ming.lei@canonical.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 3:36 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> The direct firmware loading interface is a bit quiet about failures.  Failures

Because there are several pre-defined search paths, and generally the
requested firmware only exists in one of these paths.

> that occur during loading are masked if firmware exists in multiple locations,
> and may be masked entirely in the event that we fall back to the user mode

You still can figure out the request falls back to user mode loading since we
have the "firmware: direct-loading firmware %s" log.

> helper code.  It would be nice to see some of the more unexpected errors get

What are the unexpected errors?

> logged, so in the event that you expect the direct firmware loader to work (like
> if CONFIG_FW_LOADER_USER_HELPER is enabled), and something goes wrong, you can
> figure out what happened.

Looks we didn't meet this case, do you have real examples?

>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Ming Lei <ming.lei@canonical.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/firmware_class.c | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 10a4467..eb8fb94 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -282,31 +282,35 @@ static noinline_for_stack long fw_file_size(struct file *file)
>         return st.size;
>  }
>
> -static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
> +static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
>  {
>         long size;
>         char *buf;
> +       int rc;
>
>         size = fw_file_size(file);
>         if (size <= 0)
> -               return false;
> +               return -EINVAL;
>         buf = vmalloc(size);
>         if (!buf)
> -               return false;
> -       if (kernel_read(file, 0, buf, size) != size) {
> +               return -ENOMEM;
> +       rc = kernel_read(file, 0, buf, size);
> +       if (rc != size) {
> +               if (rc > 0)
> +                       rc = -EIO;
>                 vfree(buf);
> -               return false;
> +               return rc;
>         }
>         fw_buf->data = buf;
>         fw_buf->size = size;
> -       return true;
> +       return 0;
>  }
>
> -static bool fw_get_filesystem_firmware(struct device *device,
> +static int fw_get_filesystem_firmware(struct device *device,
>                                        struct firmware_buf *buf)
>  {
>         int i;
> -       bool success = false;
> +       int rc = -ENOENT;
>         char *path = __getname();
>
>         for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
> @@ -321,14 +325,17 @@ static bool fw_get_filesystem_firmware(struct device *device,
>                 file = filp_open(path, O_RDONLY, 0);
>                 if (IS_ERR(file))
>                         continue;
> -               success = fw_read_file_contents(file, buf);
> +               rc = fw_read_file_contents(file, buf);
>                 fput(file);
> -               if (success)
> +               if (rc)
> +                       dev_warn(device, "firmware, attempted to load %s, but failed with error %d\n",
> +                               path, rc);

The above may introduce noises.

> +               else
>                         break;
>         }
>         __putname(path);
>
> -       if (success) {
> +       if (!rc) {
>                 dev_dbg(device, "firmware: direct-loading firmware %s\n",
>                         buf->fw_id);
>                 mutex_lock(&fw_lock);
> @@ -337,7 +344,7 @@ static bool fw_get_filesystem_firmware(struct device *device,
>                 mutex_unlock(&fw_lock);
>         }
>
> -       return success;
> +       return rc;
>  }
>
>  /* firmware holds the ownership of pages */
> @@ -1086,9 +1093,14 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>                 }
>         }
>
> -       if (!fw_get_filesystem_firmware(device, fw->priv))
> +       ret = fw_get_filesystem_firmware(device, fw->priv);
> +       if (ret) {
> +               dev_warn(device, "Direct firmware load failed with error %d\n",
> +                        ret);
> +               dev_warn(device, "Falling back to user helper\n");

You should merge the two warnings to into one?

>                 ret = fw_load_from_user_helper(fw, name, device,
>                                                uevent, nowait, timeout);
> +       }
>
>         /* don't cache firmware handled without uevent */
>         if (!ret)


Thanks,
--
Ming Lei
