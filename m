Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161510Ab3DEG2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:28:03 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:59736 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab3DEG2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:28:02 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
In-Reply-To: <1362038529.6212.22.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362037892.6212.13.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362038236.6212.18.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <1362038529.6212.22.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 5 Apr 2013 09:27:40 +0300
Message-ID: <CAK=WgbbDhfLa1uQn3v0Lu5iOLL5QgGxKuOVrq9AKD9fLtb42FQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] hwspinlock/core: call pm_runtime_put in
 pm_runtime_get_sync failed case
To: Li Fei <fei.li@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Thu, Feb 28, 2013 at 10:02 AM, Li Fei <fei.li@intel.com> wrote:
>
> Even in failed case of pm_runtime_get_sync, the usage_count
> is incremented. In order to keep the usage_count with correct
> value and runtime power management to behave correctly, call
> pm_runtime_put(_sync) in such case.

Is it better then to call pm_runtime_put_noidle instead? This way
we're sure to only take care of usage_count without ever calling any
underlying pm handler.

Thanks,
Ohad.

> In __hwspin_lock_request, module_put is also called before
> return in pm_runtime_get_sync failed case.
>
> Signed-off-by Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  drivers/hwspinlock/hwspinlock_core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
> index db713c0..5a5076d 100644
> --- a/drivers/hwspinlock/hwspinlock_core.c
> +++ b/drivers/hwspinlock/hwspinlock_core.c
> @@ -416,6 +416,8 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
>         ret = pm_runtime_get_sync(dev);
>         if (ret < 0) {
>                 dev_err(dev, "%s: can't power on device\n", __func__);
> +               pm_runtime_put(dev);
> +               module_put(dev->driver->owner);
>                 return ret;
>         }
>
> --
> 1.7.4.1
>
>
>
