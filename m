Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3FCLBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:01:44 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:48964 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3FCLBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:01:42 -0400
MIME-Version: 1.0
In-Reply-To: <001601ce6039$e7807180$b6815480$@samsung.com>
References: <001601ce6039$e7807180$b6815480$@samsung.com>
Date: Mon, 3 Jun 2013 14:01:39 +0300
Message-ID: <CAHp75VfHj9JZqrF+QjxjC0OCkansDbnuOSSX9SGH5rqpjf556g@mail.gmail.com>
Subject: Re: [PATCH V2] misc: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Dimitri Sivanich <sivanich@sgi.com>, Robin Holt <holt@sgi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 12:08 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

There are few issues. Afrter addressing them take my
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> --- a/drivers/misc/isl29003.c
> +++ b/drivers/misc/isl29003.c
> @@ -208,8 +208,9 @@ static ssize_t isl29003_store_range(struct device *dev,
>         unsigned long val;
>         int ret;
>
> -       if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
> -               return -EINVAL;
> +       ret = (kstrtoul(buf, 10, &val) < 0) || (val > 3);
> +       if (ret)
> +               return ret;

It's not correct.
You have to get return code from kstrtoul() separately and use it,
after check top boundary and return -EINVAL.

Three more cases below.

> @@ -239,8 +240,9 @@ static ssize_t isl29003_store_resolution(struct device *dev,
>         unsigned long val;
>         int ret;
>
> -       if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
> -               return -EINVAL;
> +       ret = (kstrtoul(buf, 10, &val) < 0) || (val > 3);
> +       if (ret)
> +               return ret;
>
>         ret = isl29003_set_resolution(client, val);
>         if (ret < 0)
> @@ -267,8 +269,9 @@ static ssize_t isl29003_store_mode(struct device *dev,
>         unsigned long val;
>         int ret;
>
> -       if ((strict_strtoul(buf, 10, &val) < 0) || (val > 2))
> -               return -EINVAL;
> +       ret = (kstrtoul(buf, 10, &val) < 0) || (val > 2);
> +       if (ret)
> +               return ret;
>
>         ret = isl29003_set_mode(client, val);
>         if (ret < 0)
> @@ -298,8 +301,9 @@ static ssize_t isl29003_store_power_state(struct device *dev,
>         unsigned long val;
>         int ret;
>
> -       if ((strict_strtoul(buf, 10, &val) < 0) || (val > 1))
> -               return -EINVAL;
> +       ret = (kstrtoul(buf, 10, &val) < 0) || (val > 1);
> +       if (ret)
> +               return ret;
>
>         ret = isl29003_set_power_state(client, val);
>         return ret ? ret : count;

> --- a/drivers/misc/sgi-gru/gruprocfs.c
> +++ b/drivers/misc/sgi-gru/gruprocfs.c
> @@ -161,14 +161,17 @@ static ssize_t options_write(struct file *file, const char __user *userbuf,
>                              size_t count, loff_t *data)
>  {
>         char buf[20];
> +       int ret;
>
>         if (count >= sizeof(buf))
>                 return -EINVAL;
>         if (copy_from_user(buf, userbuf, count))
>                 return -EFAULT;
>         buf[count] = '\0';
> -       if (strict_strtoul(buf, 0, &gru_options))
> -               return -EINVAL;
> +
> +       ret = kstrtoul(buf, 0, &gru_options);

kstrtoul_from_user(), please.

> +       if (ret)
> +               return ret;
>
>         return count;
>  }

--
With Best Regards,
Andy Shevchenko
