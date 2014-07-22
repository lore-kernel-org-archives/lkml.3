Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaGVCT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:19:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaGVCT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:19:57 -0400
MIME-Version: 1.0
In-Reply-To: <1405969601-4234-3-git-send-email-keescook@chromium.org>
References: <1405969601-4234-1-git-send-email-keescook@chromium.org>
	<1405969601-4234-3-git-send-email-keescook@chromium.org>
Date: Tue, 22 Jul 2014 10:19:52 +0800
Message-ID: <CACVXFVO8=naiMG-S41_KRmbyOKLBna2=t5nafmYWGar5fSt3sQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] firmware_class: perform new LSM checks
From: Ming Lei <ming.lei@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 3:06 AM, Kees Cook <keescook@chromium.org> wrote:
> This attaches LSM hooks to the existing firmware loading interfaces:
> filesystem-found firmware and demand-loaded blobs.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/firmware_class.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d276e33880be..7399bab71ced 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -28,6 +28,7 @@
>  #include <linux/suspend.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/reboot.h>
> +#include <linux/security.h>
>
>  #include <generated/utsrelease.h>
>
> @@ -308,12 +309,17 @@ static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
>         if (rc != size) {
>                 if (rc > 0)
>                         rc = -EIO;
> -               vfree(buf);
> -               return rc;
> +               goto fail;
>         }
> +       rc = security_kernel_fw_from_file(file, buf, size);
> +       if (rc)
> +               goto fail;
>         fw_buf->data = buf;
>         fw_buf->size = size;
>         return 0;
> +fail:
> +       vfree(buf);
> +       return rc;
>  }
>
>  static int fw_get_filesystem_firmware(struct device *device,
> @@ -640,6 +646,12 @@ static ssize_t firmware_loading_store(struct device *dev,
>                 break;
>         case 0:
>                 if (test_bit(FW_STATUS_LOADING, &fw_buf->status)) {
> +                       if (security_kernel_fw_from_file(NULL, fw_buf->data,
> +                                                        fw_buf->size)) {
> +                               fw_load_abort(fw_priv);
> +                               break;

It may be more friendly to return -EPERM or sort of failure
to user, otherwise it might cause userspace loader a bit confused.


Thanks,
