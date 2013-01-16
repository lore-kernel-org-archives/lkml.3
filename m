Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3APDnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:43:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab3APDnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <1358239423-9884-1-git-send-email-coelho@ti.com>
References: <1358239423-9884-1-git-send-email-coelho@ti.com>
Date: Wed, 16 Jan 2013 11:43:20 +0800
Message-ID: <CACVXFVNgBWZueOwvM_F58W0rCXG5Zhep=vu0XLbSsv3L7THVXg@mail.gmail.com>
Subject: Re: [PATCH] firmware: make sure the fw file size is not 0
From: Ming Lei <ming.lei@canonical.com>
To: Luciano Coelho <coelho@ti.com>
Cc: gregkh@linuxfoundation.org, torvalds@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 4:43 PM, Luciano Coelho <coelho@ti.com> wrote:
> If the requested firmware file size is 0 bytes in the filesytem, we
> will try to vmalloc(0), which causes a warning:
>
> [37834.750274] vmalloc: allocation failure: 0 bytes
> [37834.756347] kworker/1:1: page allocation failure: order:0, mode:0xd2
> [37834.763214] [<c001ec60>] (unwind_backtrace+0x0/0x13c) from [<c07171ac>] (dump_stack+0x20/0x24)
> [37834.772430] [<c07171ac>] (dump_stack+0x20/0x24) from [<c010c7ac>] (warn_alloc_failed+0xc8/0x120)
> [37834.781799] [<c010c7ac>] (warn_alloc_failed+0xc8/0x120) from [<c0142860>] (__vmalloc_node_range+0x16)
> [37834.792663] [<c0142860>] (__vmalloc_node_range+0x164/0x208) from [<c0142950>] (__vmalloc_node+0x4c/0)
> [37834.802703] [<c0142950>] (__vmalloc_node+0x4c/0x58) from [<c0142994>] (vmalloc+0x38/0x44)
> [37834.811401] [<c0142994>] (vmalloc+0x38/0x44) from [<c03f729c>] (_request_firmware_load+0x220/0x6b0)
> [37834.820983] [<c03f729c>] (_request_firmware_load+0x220/0x6b0) from [<c03f7f68>] (request_firmware+0x)
> [37834.831451] [<c03f7f68>] (request_firmware+0x64/0xc8) from [<bf51b9a8>] (wl18xx_setup+0xb4/0x570 [wl)
> [37834.841918] [<bf51b9a8>] (wl18xx_setup+0xb4/0x570 [wl18xx]) from [<bf4dfdac>] (wlcore_nvs_cb+0x64/0x)
> [37834.852844] [<bf4dfdac>] (wlcore_nvs_cb+0x64/0x9f8 [wlcore]) from [<c03f7e98>] (request_firmware_wor)
> [37834.864227] [<c03f7e98>] (request_firmware_work_func+0x94/0x100) from [<c0072d7c>] (process_one_work)
> [37834.875122] [<c0072d7c>] (process_one_work+0x1d0/0x750) from [<c00736f8>] (worker_thread+0x184/0x4ac)
> [37834.884918] [<c00736f8>] (worker_thread+0x184/0x4ac) from [<c007a2d4>] (kthread+0xb4/0xc0)
> [37834.893707] [<c007a2d4>] (kthread+0xb4/0xc0) from [<c0015490>] (ret_from_fork+0x14/0x20)
>
> To fix this, check whether the file size is less than or equal to zero
> in fw_read_file_contents().
>
> Cc: stable <stable@vger.kernel.org> [3.7]
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
>  drivers/base/firmware_class.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index d814603..b392b35 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -305,7 +305,7 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
>         char *buf;
>
>         size = fw_file_size(file);
> -       if (size < 0)
> +       if (size <= 0)
>                 return false;

One trivial thing is that if we should return false on zero size firmware?

If we think zero size firmware file as a good fw image, we should handle
the case and return true. Otherwise, false should be returned. But that is
not a big deal, so looks fine for me.

Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei
