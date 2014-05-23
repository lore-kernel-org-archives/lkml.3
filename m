Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbaEWBJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:09:13 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:63066 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaEWBJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:09:11 -0400
MIME-Version: 1.0
In-Reply-To: <1400806281-32716-1-git-send-email-mitchelh@codeaurora.org>
References: <1400806281-32716-1-git-send-email-mitchelh@codeaurora.org>
Date: Thu, 22 May 2014 18:09:11 -0700
X-Google-Sender-Auth: tatrLI87oHg7YJDJhEBpOby-Cro
Message-ID: <CAMbhsRQpR-Q=kgr92ezauBj200_2cfnsXHkk+3oPD51ZKD=4RQ@mail.gmail.com>
Subject: Re: [PATCH] staging: ion: WARN when the handle kmap_cnt is going to
 wrap around
From: Colin Cross <ccross@android.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: Linux-MM <linux-mm@kvack.org>, John Stultz <john.stultz@linaro.org>,
        Android Kernel Team <kernel-team@android.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 5:51 PM, Mitchel Humpherys
<mitchelh@codeaurora.org> wrote:
> There are certain client bugs (double unmap, for example) that can cause
> the handle->kmap_cnt (an unsigned int) to wrap around from zero. This
> causes problems when the handle is destroyed because we have:
>
>         while (handle->kmap_cnt)
>                 ion_handle_kmap_put(handle);
>
> which takes a long time to complete when kmap_cnt starts at ~0 and can
> result in a watchdog timeout.
>
> WARN and bail when kmap_cnt is about to wrap around from zero.
>
> Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
> ---
>  drivers/staging/android/ion/ion.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index 3d5bf14722..f55f61a4cc 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -626,6 +626,10 @@ static void ion_handle_kmap_put(struct ion_handle *handle)
>  {
>         struct ion_buffer *buffer = handle->buffer;
>
> +       if (!handle->kmap_cnt) {
> +               WARN(1, "%s: Double unmap detected! bailing...\n", __func__);
> +               return;
> +       }
>         handle->kmap_cnt--;
>         if (!handle->kmap_cnt)
>                 ion_buffer_kmap_put(buffer);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.

Acked-by: Colin Cross <ccross@android.com>
