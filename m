Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaHDTgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:36:04 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39269 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaHDTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <1407177340-29359-1-git-send-email-john.stultz@linaro.org>
References: <CAGXu5jKD5X4ZZreierjWsB659pXJgc9eXJX==Wm+-R22nKY+xQ@mail.gmail.com>
	<1407177340-29359-1-git-send-email-john.stultz@linaro.org>
Date: Mon, 4 Aug 2014 12:35:57 -0700
X-Google-Sender-Auth: KApeg_mqZC87N1NL7ov55yGXexA
Message-ID: <CAGXu5jLS1SGo9dsoYAbjNOSJ-oCHpy_UD-_1Me+jhRGMu7TAZA@mail.gmail.com>
Subject: Re: [PATCH] time: Rename udelay_test.c to test_udelay.c
From: Kees Cook <keescook@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-Next <linux-next@vger.kernel.org>,
        David Riley <davidriley@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2014 at 11:35 AM, John Stultz <john.stultz@linaro.org> wrote:
> Kees requested that this test module be renamed for consistency sake,
> so this patch renames the udelay_test.c file (recently added to
> tip/timers/core for 3.17) to test_udelay.c
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Linux-Next <linux-next@vger.kernel.org>
> Cc: David Riley <davidriley@chromium.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Thank you! :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  kernel/time/Makefile      |   2 +-
>  kernel/time/test_udelay.c | 168 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/time/udelay_test.c | 168 ----------------------------------------------
>  3 files changed, 169 insertions(+), 169 deletions(-)
>  create mode 100644 kernel/time/test_udelay.c
>  delete mode 100644 kernel/time/udelay_test.c
>
> diff --git a/kernel/time/Makefile b/kernel/time/Makefile
> index 7347426..f622cf2 100644
> --- a/kernel/time/Makefile
> +++ b/kernel/time/Makefile
> @@ -13,7 +13,7 @@ obj-$(CONFIG_TICK_ONESHOT)                    += tick-oneshot.o
>  obj-$(CONFIG_TICK_ONESHOT)                     += tick-sched.o
>  obj-$(CONFIG_TIMER_STATS)                      += timer_stats.o
>  obj-$(CONFIG_DEBUG_FS)                         += timekeeping_debug.o
> -obj-$(CONFIG_TEST_UDELAY)                      += udelay_test.o
> +obj-$(CONFIG_TEST_UDELAY)                      += test_udelay.o
>
>  $(obj)/time.o: $(obj)/timeconst.h
>
> diff --git a/kernel/time/test_udelay.c b/kernel/time/test_udelay.c
> new file mode 100644
> index 0000000..e622ba3
> --- /dev/null
> +++ b/kernel/time/test_udelay.c
> @@ -0,0 +1,168 @@
> +/*
> + * udelay() test kernel module
> + *
> + * Test is executed by writing and reading to /sys/kernel/debug/udelay_test
> + * Tests are configured by writing: USECS ITERATIONS
> + * Tests are executed by reading from the same file.
> + * Specifying usecs of 0 or negative values will run multiples tests.
> + *
> + * Copyright (C) 2014 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/ktime.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +
> +#define DEFAULT_ITERATIONS 100
> +
> +#define DEBUGFS_FILENAME "udelay_test"
> +
> +static DEFINE_MUTEX(udelay_test_lock);
> +static struct dentry *udelay_test_debugfs_file;
> +static int udelay_test_usecs;
> +static int udelay_test_iterations = DEFAULT_ITERATIONS;
> +
> +static int udelay_test_single(struct seq_file *s, int usecs, uint32_t iters)
> +{
> +       int min = 0, max = 0, fail_count = 0;
> +       uint64_t sum = 0;
> +       uint64_t avg;
> +       int i;
> +       /* Allow udelay to be up to 0.5% fast */
> +       int allowed_error_ns = usecs * 5;
> +
> +       for (i = 0; i < iters; ++i) {
> +               struct timespec ts1, ts2;
> +               int time_passed;
> +
> +               ktime_get_ts(&ts1);
> +               udelay(usecs);
> +               ktime_get_ts(&ts2);
> +               time_passed = timespec_to_ns(&ts2) - timespec_to_ns(&ts1);
> +
> +               if (i == 0 || time_passed < min)
> +                       min = time_passed;
> +               if (i == 0 || time_passed > max)
> +                       max = time_passed;
> +               if ((time_passed + allowed_error_ns) / 1000 < usecs)
> +                       ++fail_count;
> +               WARN_ON(time_passed < 0);
> +               sum += time_passed;
> +       }
> +
> +       avg = sum;
> +       do_div(avg, iters);
> +       seq_printf(s, "%d usecs x %d: exp=%d allowed=%d min=%d avg=%lld max=%d",
> +                       usecs, iters, usecs * 1000,
> +                       (usecs * 1000) - allowed_error_ns, min, avg, max);
> +       if (fail_count)
> +               seq_printf(s, " FAIL=%d", fail_count);
> +       seq_puts(s, "\n");
> +
> +       return 0;
> +}
> +
> +static int udelay_test_show(struct seq_file *s, void *v)
> +{
> +       int usecs;
> +       int iters;
> +       int ret = 0;
> +
> +       mutex_lock(&udelay_test_lock);
> +       usecs = udelay_test_usecs;
> +       iters = udelay_test_iterations;
> +       mutex_unlock(&udelay_test_lock);
> +
> +       if (usecs > 0 && iters > 0) {
> +               return udelay_test_single(s, usecs, iters);
> +       } else if (usecs == 0) {
> +               struct timespec ts;
> +
> +               ktime_get_ts(&ts);
> +               seq_printf(s, "udelay() test (lpj=%ld kt=%ld.%09ld)\n",
> +                               loops_per_jiffy, ts.tv_sec, ts.tv_nsec);
> +               seq_puts(s, "usage:\n");
> +               seq_puts(s, "echo USECS [ITERS] > " DEBUGFS_FILENAME "\n");
> +               seq_puts(s, "cat " DEBUGFS_FILENAME "\n");
> +       }
> +
> +       return ret;
> +}
> +
> +static int udelay_test_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, udelay_test_show, inode->i_private);
> +}
> +
> +static ssize_t udelay_test_write(struct file *file, const char __user *buf,
> +               size_t count, loff_t *pos)
> +{
> +       char lbuf[32];
> +       int ret;
> +       int usecs;
> +       int iters;
> +
> +       if (count >= sizeof(lbuf))
> +               return -EINVAL;
> +
> +       if (copy_from_user(lbuf, buf, count))
> +               return -EFAULT;
> +       lbuf[count] = '\0';
> +
> +       ret = sscanf(lbuf, "%d %d", &usecs, &iters);
> +       if (ret < 1)
> +               return -EINVAL;
> +       else if (ret < 2)
> +               iters = DEFAULT_ITERATIONS;
> +
> +       mutex_lock(&udelay_test_lock);
> +       udelay_test_usecs = usecs;
> +       udelay_test_iterations = iters;
> +       mutex_unlock(&udelay_test_lock);
> +
> +       return count;
> +}
> +
> +static const struct file_operations udelay_test_debugfs_ops = {
> +       .owner = THIS_MODULE,
> +       .open = udelay_test_open,
> +       .read = seq_read,
> +       .write = udelay_test_write,
> +       .llseek = seq_lseek,
> +       .release = single_release,
> +};
> +
> +static int __init udelay_test_init(void)
> +{
> +       mutex_lock(&udelay_test_lock);
> +       udelay_test_debugfs_file = debugfs_create_file(DEBUGFS_FILENAME,
> +                       S_IRUSR, NULL, NULL, &udelay_test_debugfs_ops);
> +       mutex_unlock(&udelay_test_lock);
> +
> +       return 0;
> +}
> +
> +module_init(udelay_test_init);
> +
> +static void __exit udelay_test_exit(void)
> +{
> +       mutex_lock(&udelay_test_lock);
> +       debugfs_remove(udelay_test_debugfs_file);
> +       mutex_unlock(&udelay_test_lock);
> +}
> +
> +module_exit(udelay_test_exit);
> +
> +MODULE_AUTHOR("David Riley <davidriley@chromium.org>");
> +MODULE_LICENSE("GPL");
> diff --git a/kernel/time/udelay_test.c b/kernel/time/udelay_test.c
> deleted file mode 100644
> index e622ba3..0000000
> --- a/kernel/time/udelay_test.c
> +++ /dev/null
> @@ -1,168 +0,0 @@
> -/*
> - * udelay() test kernel module
> - *
> - * Test is executed by writing and reading to /sys/kernel/debug/udelay_test
> - * Tests are configured by writing: USECS ITERATIONS
> - * Tests are executed by reading from the same file.
> - * Specifying usecs of 0 or negative values will run multiples tests.
> - *
> - * Copyright (C) 2014 Google, Inc.
> - *
> - * This software is licensed under the terms of the GNU General Public
> - * License version 2, as published by the Free Software Foundation, and
> - * may be copied, distributed, and modified under those terms.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <linux/debugfs.h>
> -#include <linux/delay.h>
> -#include <linux/ktime.h>
> -#include <linux/module.h>
> -#include <linux/uaccess.h>
> -
> -#define DEFAULT_ITERATIONS 100
> -
> -#define DEBUGFS_FILENAME "udelay_test"
> -
> -static DEFINE_MUTEX(udelay_test_lock);
> -static struct dentry *udelay_test_debugfs_file;
> -static int udelay_test_usecs;
> -static int udelay_test_iterations = DEFAULT_ITERATIONS;
> -
> -static int udelay_test_single(struct seq_file *s, int usecs, uint32_t iters)
> -{
> -       int min = 0, max = 0, fail_count = 0;
> -       uint64_t sum = 0;
> -       uint64_t avg;
> -       int i;
> -       /* Allow udelay to be up to 0.5% fast */
> -       int allowed_error_ns = usecs * 5;
> -
> -       for (i = 0; i < iters; ++i) {
> -               struct timespec ts1, ts2;
> -               int time_passed;
> -
> -               ktime_get_ts(&ts1);
> -               udelay(usecs);
> -               ktime_get_ts(&ts2);
> -               time_passed = timespec_to_ns(&ts2) - timespec_to_ns(&ts1);
> -
> -               if (i == 0 || time_passed < min)
> -                       min = time_passed;
> -               if (i == 0 || time_passed > max)
> -                       max = time_passed;
> -               if ((time_passed + allowed_error_ns) / 1000 < usecs)
> -                       ++fail_count;
> -               WARN_ON(time_passed < 0);
> -               sum += time_passed;
> -       }
> -
> -       avg = sum;
> -       do_div(avg, iters);
> -       seq_printf(s, "%d usecs x %d: exp=%d allowed=%d min=%d avg=%lld max=%d",
> -                       usecs, iters, usecs * 1000,
> -                       (usecs * 1000) - allowed_error_ns, min, avg, max);
> -       if (fail_count)
> -               seq_printf(s, " FAIL=%d", fail_count);
> -       seq_puts(s, "\n");
> -
> -       return 0;
> -}
> -
> -static int udelay_test_show(struct seq_file *s, void *v)
> -{
> -       int usecs;
> -       int iters;
> -       int ret = 0;
> -
> -       mutex_lock(&udelay_test_lock);
> -       usecs = udelay_test_usecs;
> -       iters = udelay_test_iterations;
> -       mutex_unlock(&udelay_test_lock);
> -
> -       if (usecs > 0 && iters > 0) {
> -               return udelay_test_single(s, usecs, iters);
> -       } else if (usecs == 0) {
> -               struct timespec ts;
> -
> -               ktime_get_ts(&ts);
> -               seq_printf(s, "udelay() test (lpj=%ld kt=%ld.%09ld)\n",
> -                               loops_per_jiffy, ts.tv_sec, ts.tv_nsec);
> -               seq_puts(s, "usage:\n");
> -               seq_puts(s, "echo USECS [ITERS] > " DEBUGFS_FILENAME "\n");
> -               seq_puts(s, "cat " DEBUGFS_FILENAME "\n");
> -       }
> -
> -       return ret;
> -}
> -
> -static int udelay_test_open(struct inode *inode, struct file *file)
> -{
> -       return single_open(file, udelay_test_show, inode->i_private);
> -}
> -
> -static ssize_t udelay_test_write(struct file *file, const char __user *buf,
> -               size_t count, loff_t *pos)
> -{
> -       char lbuf[32];
> -       int ret;
> -       int usecs;
> -       int iters;
> -
> -       if (count >= sizeof(lbuf))
> -               return -EINVAL;
> -
> -       if (copy_from_user(lbuf, buf, count))
> -               return -EFAULT;
> -       lbuf[count] = '\0';
> -
> -       ret = sscanf(lbuf, "%d %d", &usecs, &iters);
> -       if (ret < 1)
> -               return -EINVAL;
> -       else if (ret < 2)
> -               iters = DEFAULT_ITERATIONS;
> -
> -       mutex_lock(&udelay_test_lock);
> -       udelay_test_usecs = usecs;
> -       udelay_test_iterations = iters;
> -       mutex_unlock(&udelay_test_lock);
> -
> -       return count;
> -}
> -
> -static const struct file_operations udelay_test_debugfs_ops = {
> -       .owner = THIS_MODULE,
> -       .open = udelay_test_open,
> -       .read = seq_read,
> -       .write = udelay_test_write,
> -       .llseek = seq_lseek,
> -       .release = single_release,
> -};
> -
> -static int __init udelay_test_init(void)
> -{
> -       mutex_lock(&udelay_test_lock);
> -       udelay_test_debugfs_file = debugfs_create_file(DEBUGFS_FILENAME,
> -                       S_IRUSR, NULL, NULL, &udelay_test_debugfs_ops);
> -       mutex_unlock(&udelay_test_lock);
> -
> -       return 0;
> -}
> -
> -module_init(udelay_test_init);
> -
> -static void __exit udelay_test_exit(void)
> -{
> -       mutex_lock(&udelay_test_lock);
> -       debugfs_remove(udelay_test_debugfs_file);
> -       mutex_unlock(&udelay_test_lock);
> -}
> -
> -module_exit(udelay_test_exit);
> -
> -MODULE_AUTHOR("David Riley <davidriley@chromium.org>");
> -MODULE_LICENSE("GPL");
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security
