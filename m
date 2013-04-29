Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3D2X3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:29:54 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52930 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258Ab3D2X3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:29:52 -0400
Message-ID: <517F026D.2080701@linaro.org>
Date: Mon, 29 Apr 2013 16:29:49 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 06/15] clocksource: Split out user string input
References: <20130425142452.908423538@linutronix.de> <20130425143435.895851338@linutronix.de>
In-Reply-To: <20130425143435.895851338@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 1:31 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> Split out the user string input for clocksource override. Preparatory
> patch for unbind.

This patch has a bug that causes the shell to hang when \n terminated 
clocksource strings are sent to the sysfs interface.

echo hpet > /sys/devices/system/clocksource/clocksource0/current_clocksource
<shell hang>


> +static size_t clocksource_get_uname(const char *buf, char *dst, size_t
> cnt)
> +{
> +       /* strings from sysfs write are not 0 terminated! */
> +       if (!cnt || cnt >= CS_NAME_LEN)
> +               return -EINVAL;
> +
> +       /* strip of \n: */
> +       if (buf[cnt-1] == '\n')
> +               cnt--;
> +       if (cnt > 0)
> +               memcpy(dst, buf, cnt);
> +       dst[cnt] = 0;
> +       return cnt;
> +}
> +
>  /**
>   * sysfs_override_clocksource - interface for manually overriding
> clocksource
>   * @dev:       unused
> @@ -847,22 +863,13 @@ static ssize_t sysfs_override_clocksourc
>                                           struct device_attribute *attr,
>                                           const char *buf, size_t count)
>  {
> -       size_t ret = count;
> -
> -       /* strings from sysfs write are not 0 terminated! */
> -       if (count >= sizeof(override_name))
> -               return -EINVAL;
> -
> -       /* strip of \n: */
> -       if (buf[count-1] == '\n')
> -               count--;
> +       size_t ret;
>
>         mutex_lock(&clocksource_mutex);
>
> -       if (count > 0)
> -               memcpy(override_name, buf, count);
> -       override_name[count] = 0;
> -       clocksource_select(false);
> +       ret = clocksource_get_uname(buf, override_name, count);
> +       if (ret >= 0)
> +               clocksource_select(false);
>
>         mutex_unlock(&clocksource_mutex);


The change above *looks* ok, but is subtlly different then what we had 
before. Note, in the old code, we saved count to ret, and never modified 
ret before returning it.

With the new code, we modify cnt, as we process the copied clocksource 
name, and return cnt, thus we don't return to the sysfs interface the 
same count value we were given, causing the write call to loop.

So you probably want something like the following patch to fix this.

thanks
-john



diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e9c4f04..5f6c324 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -836,6 +836,8 @@ sysfs_show_current_clocksources(struct device *dev,

  static size_t clocksource_get_uname(const char *buf, char *dst, size_t 
cnt)
  {
+	size_t ret = cnt;
+
  	/* strings from sysfs write are not 0 terminated! */
  	if (!cnt || cnt >= CS_NAME_LEN)
  		return -EINVAL;
@@ -846,7 +848,7 @@ static size_t clocksource_get_uname(const char *buf, 
char *dst, size_t cnt)
  	if (cnt > 0)
  		memcpy(dst, buf, cnt);
  	dst[cnt] = 0;
-	return cnt;
+	return ret;
  }

  /**
