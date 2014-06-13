Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaFMO40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:56:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFMO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <2fedf03f1007357f68f655d0a629dd1c390c242e.1402607108.git.d.kasatkin@samsung.com>
References: <2fedf03f1007357f68f655d0a629dd1c390c242e.1402607108.git.d.kasatkin@samsung.com>
Date: Fri, 13 Jun 2014 22:56:22 +0800
Message-ID: <CACVXFVPn4muw+zD+TPAJh2miB5R326iFT4ZBS-Tdehz0XrsyDQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] firmware: read firmware size using i_size_read()
From: Ming Lei <ming.lei@canonical.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 5:05 AM, Dmitry Kasatkin
<dmitry.kasatkin@gmail.com> wrote:
> There is no need to read attr because inode structure contains size
> of the file. Use i_size_read() instead.
>
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  drivers/base/firmware_class.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index c30df50e..9aaa97b 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -279,26 +279,13 @@ static const char * const fw_path[] = {
>  module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
>  MODULE_PARM_DESC(path, "customized firmware image search path with a higher priority than default path");
>
> -/* Don't inline this: 'struct kstat' is biggish */
> -static noinline_for_stack int fw_file_size(struct file *file)
> -{
> -       struct kstat st;
> -       if (vfs_getattr(&file->f_path, &st))
> -               return -1;
> -       if (!S_ISREG(st.mode))
> -               return -1;
> -       if (st.size != (int)st.size)
> -               return -1;
> -       return st.size;
> -}
> -
>  static int fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
>  {
>         int size;
>         char *buf;
>         int rc;
>
> -       size = fw_file_size(file);
> +       size = i_size_read(file_inode(file));
>         if (size <= 0)
>                 return -EINVAL;
>         buf = vmalloc(size);
> --

fw_file_size() not only return size of the file, but also
check if it is a regular file, and its size.

Thanks,
--
Ming Lei
