Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3LQH0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:26:05 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:32916 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3LQH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <1387256873-21350-3-git-send-email-john.stultz@linaro.org>
References: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
	<1387256873-21350-3-git-send-email-john.stultz@linaro.org>
Date: Mon, 16 Dec 2013 23:26:02 -0800
X-Google-Sender-Auth: 4s5iBgHQwegRBcwHdcDwTu83ehk
Message-ID: <CAMbhsRTczY7zwCAYtrXm9EsfT+BLnJy_rnbf35cFOQ_303ODCA@mail.gmail.com>
Subject: Re: [PATCH 2/3] staging: ion: Fix possible null pointer dereference
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        kbuild test robot <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 9:07 PM, John Stultz <john.stultz@linaro.org> wrote:
> The kbuild test robot reported:
>
> drivers/staging/android/ion/ion_system_heap.c:122 alloc_largest_available() error: potential null dereference 'info'.  (kmalloc returns null)
>
> Where the pointer returned from kmalloc goes unchecked for failure.
>
> This patch checks the return for NULL, and reworks the logic, as
> suggested by Colin, so we allocate the page_info structure first.
>
> Cc: Colin Cross <ccross@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: kbuild test robot <fengguang.wu@intel.com>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/ion_system_heap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index 144b2272..7f07291 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -108,6 +108,10 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
>         struct page_info *info;
>         int i;
>
> +       info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
> +       if (!info)
> +               return NULL;
> +
>         for (i = 0; i < num_orders; i++) {
>                 if (size < order_to_size(orders[i]))
>                         continue;
> @@ -118,11 +122,12 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
>                 if (!page)
>                         continue;
>
> -               info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
>                 info->page = page;
>                 info->order = orders[i];
>                 return info;
>         }
> +       kfree(info);
> +
>         return NULL;
>  }
>

Acked-by: Colin Cross <ccross@android.com>
