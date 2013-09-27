Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3I0PvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:51:05 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54999 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3I0PvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:51:03 -0400
MIME-Version: 1.0
In-Reply-To: <000401ce86b7$0463f580$0d2be080$@samsung.com>
References: <000401ce86b7$0463f580$0d2be080$@samsung.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 27 Sep 2013 09:50:39 -0600
Message-ID: <CAErSpo51GFB+yCuaHrwBqWjHxd0GboHgvWGov5pj4V6aGPfQHg@mail.gmail.com>
Subject: Re: [PATCH] kernel: replace strict_strto*() with kstrto*()
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Jean]

On Mon, Jul 22, 2013 at 2:39 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strto*() is not preferred, because
> strict_strto*() is obsolete. Thus, kstrto*() should be
> used.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  kernel/gcov/fs.c |    2 +-
>  kernel/ksysfs.c  |    2 +-
>  kernel/params.c  |   14 +++++++-------
>  3 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
> index 9bd0934..7a7d2ee 100644
> --- a/kernel/gcov/fs.c
> +++ b/kernel/gcov/fs.c
> @@ -74,7 +74,7 @@ static int __init gcov_persist_setup(char *str)
>  {
>         unsigned long val;
>
> -       if (strict_strtoul(str, 0, &val)) {
> +       if (kstrtoul(str, 0, &val)) {
>                 pr_warning("invalid gcov_persist parameter '%s'\n", str);
>                 return 0;
>         }
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 6ada93c..9659d38 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -113,7 +113,7 @@ static ssize_t kexec_crash_size_store(struct kobject *kobj,
>         unsigned long cnt;
>         int ret;
>
> -       if (strict_strtoul(buf, 0, &cnt))
> +       if (kstrtoul(buf, 0, &cnt))
>                 return -EINVAL;
>
>         ret = crash_shrink_memory(cnt);
> diff --git a/kernel/params.c b/kernel/params.c
> index 440e65d..1f228a3 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -252,13 +252,13 @@ int parse_args(const char *doing,
>         EXPORT_SYMBOL(param_ops_##name)
>
>
> -STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
> -STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
> -STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
> -STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
> -STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
> -STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
> -STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
> +STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, kstrtoul);
> +STANDARD_PARAM_DEF(short, short, "%hi", long, kstrtol);
> +STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, kstrtoul);
> +STANDARD_PARAM_DEF(int, int, "%i", long, kstrtol);
> +STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, kstrtoul);
> +STANDARD_PARAM_DEF(long, long, "%li", long, kstrtol);
> +STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, kstrtoul);
>
>  int param_set_charp(const char *val, const struct kernel_param *kp)
>  {
> --

Hi Jingoo,

There's some indication that this change might have broken handling of
signed types.  See
https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-September/111758.html
and https://bugzilla.kernel.org/show_bug.cgi?id=61811.

Actually, your patch above looks like it handles byte, short, and long
the same way as in Jean's fix (using kstrtol, not kstrtoul).  So maybe
an earlier, buggy, version got merged as 6072ddc852?

Can you check it out?

Bjorn
