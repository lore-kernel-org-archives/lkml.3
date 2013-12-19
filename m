Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3LSWwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:52:40 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63160 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3LSWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:52:39 -0500
MIME-Version: 1.0
In-Reply-To: <1387492830-7988-1-git-send-email-john.stultz@linaro.org>
References: <1387492830-7988-1-git-send-email-john.stultz@linaro.org>
Date: Thu, 19 Dec 2013 14:52:38 -0800
X-Google-Sender-Auth: _5wYqbZo3BuzAm5gZlByDhusSYY
Message-ID: <CAMbhsRTLL7UfccyLeXraDx53SHXmBoVnKZE8fPcWzB1wsywo_Q@mail.gmail.com>
Subject: Re: [PATCH] ion_test: Add compat_ioctl support
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 2:40 PM, John Stultz <john.stultz@linaro.org> wrote:
> Prior to subitting this, Colin reworked the compat_ioctl support
> for the ion_test driver, moving the structure to be the same size
> on both 32 and 64 bit architectures.
>
> Two small things were left out. The compat_ioctl ptr assignment,
> and the fact that despite having uniform sized types in the
> structure, the structure pads out to different sizes on different
> arches.
>
> This patch resolves this issue by setting the write flag as
> a __u64, and adding the compat_ioctl ptr.
>
> While this does affect the ABI for 32bit users, its only
> the ABI for the ion_test driver, not ion itself.
>
> Cc: Colin Cross <ccross@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/ion_test.c  | 1 +
>  drivers/staging/android/uapi/ion_test.h | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/android/ion/ion_test.c b/drivers/staging/android/ion/ion_test.c
> index 3e20349..654acb5 100644
> --- a/drivers/staging/android/ion/ion_test.c
> +++ b/drivers/staging/android/ion/ion_test.c
> @@ -231,6 +231,7 @@ static int ion_test_release(struct inode *inode, struct file *file)
>  static const struct file_operations ion_test_fops = {
>         .owner = THIS_MODULE,
>         .unlocked_ioctl = ion_test_ioctl,
> +       .compat_ioctl = ion_test_ioctl,

Setting the compat_ioctl to the same thing as unlocked_ioctl shouldn't
be necessary, compat_sys_ioctl will fall through to do_vfs_ioctl if
compat_ioctl is not set, which will call unlocked_ioctl.

>         .open = ion_test_open,
>         .release = ion_test_release,
>  };
> diff --git a/drivers/staging/android/uapi/ion_test.h b/drivers/staging/android/uapi/ion_test.h
> index 614d1e3..f1727f5 100644
> --- a/drivers/staging/android/uapi/ion_test.h
> +++ b/drivers/staging/android/uapi/ion_test.h
> @@ -31,7 +31,7 @@ struct ion_test_rw_data {
>         __u64 ptr;
>         __u64 offset;
>         __u64 size;
> -       int write;
> +       __u64 write;
>  };

Whoops, missed that one.  Can you add "int padding" after "int write"
instead?  That at least lets us use the 32 bits later.
