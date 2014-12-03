Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaLCKfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:35:34 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54670 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaLCKfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:35:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Ward <robert.ward114@googlemail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: char: mem: Make /dev/mem an optional device
Date: Wed, 03 Dec 2014 11:35:27 +0100
Message-ID: <89216621.RaKMSXnzQp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1412030818030.7838@rob-thinkpad>
References: <alpine.DEB.2.10.1412030818030.7838@rob-thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:R7F5lqNjb9nkKp0ADKNiRnMztq6PtMXo0yIC5SqXfJ0
 AFRT3sC05t2kW1FfOsJilNk6XqAayqlgwbLhtJ6YoiLRiHYqak
 qHmjVSRyetzHS5+w3+3fw3fx+OFUdVqrxVfgJyv2XWl9n7kYcF
 gP646G4Vz/q4C44xOTtG5pYl4qZnIINFReLHgxgPFGC9vlH3xn
 VMW2s5mNO0q3x1gaR1PLMpCZ2gfW0feoVKd+dUMhrSvcR+Jcpj
 pjBFbvnKdxwjNgbJLAy0/ncJV1pgkbRjCHTtzNtGxnowhNucyM
 6I2Ufe6/DyL85GFFR2o5fq0lP527B9hKBcygcaXZ5Ng65ipJdC
 hg+WXQQoOcDj44nVAc2U=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 08:21:04 Rob Ward wrote:
> From ecd3ac31f6be2372d2beac0cc4831e74aeae75d2 Mon Sep 17 00:00:00 2001
> From: Rob Ward <robert.ward114@googlemail.com>
> Date: Wed, 5 Nov 2014 19:13:53 +0000
> Subject: [PATCH] drivers: char: mem: Make /dev/mem an optional device

Please leave out these headers from the email. If you use git-send-email,
it will work the right way, but for regular email clients you need to
remove them manually.

> Adds Kconfig option CONFIG_DEVMEM that allows the
> /dev/mem device to be disabled.
> 
> Option defaults to /dev/mem enabled.

Please explain the purpose of this. Are you doing this for security
considerations, for space savings, or something else.

If you are worried about security, please explain the possible attack
vector you are closing, if you want to save kernel text size, show
how much you save. It also helps to show a guess of what might break
if you turn it off.

> Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
> ---
>  drivers/char/Kconfig |  9 +++++++++
>  drivers/char/mem.c   | 19 ++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index efefd12..a4af822 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -6,6 +6,15 @@ menu "Character devices"
>  
>  source "drivers/tty/Kconfig"
>  
> +config DEVMEM
> +	bool "/dev/mem virtual device support"
> +	default y

Should this be

	bool "/dev/mem virtual device support" if EXPERT

so normal users don't accidentally disable it?

> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 524b707..feadc87 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -92,6 +92,7 @@ void __weak unxlate_dev_mem_ptr(unsigned long phys, void *addr)
>   * This funcion reads the *physical* memory. The f_pos points directly to the
>   * memory location.
>   */
> +#ifdef CONFIG_DEVMEM
>  static ssize_t read_mem(struct file *file, char __user *buf,
>  			size_t count, loff_t *ppos)
>  {
> @@ -216,6 +217,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
>  	*ppos += written;
>  	return written;
>  }
> +#endif

Adding a lot of #ifdef isn't nice, there are better ways to achieve the
same.

> +#ifdef CONFIG_DEVMEM
>  static const struct file_operations mem_fops = {
>  	.llseek		= memory_lseek,
>  	.read		= read_mem,
> @@ -720,6 +734,7 @@ static const struct file_operations mem_fops = {
>  	.open		= open_mem,
>  	.get_unmapped_area = get_unmapped_area_mem,
>  };
> +#endif

I would probably do it here an leave the mem_fops visible to the compiler
but mark it as '__maybe_unused' to avoid the warning when the reference below
is not there.

>  #ifdef CONFIG_DEVKMEM
>  static const struct file_operations kmem_fops = {
> @@ -782,7 +797,9 @@ static const struct memdev {
>  	const struct file_operations *fops;
>  	struct backing_dev_info *dev_info;
>  } devlist[] = {
> +#ifdef CONFIG_DEVMEM
>  	 [1] = { "mem", 0, &mem_fops, &directly_mappable_cdev_bdi },
> +#endif
>  #ifdef CONFIG_DEVKMEM
>  	 [2] = { "kmem", 0, &kmem_fops, &directly_mappable_cdev_bdi },
>  #endif

To keep it in sync with kmem, I would then submit a cleanup patch to
do the same for kmem_fops and replace the other #ifdef lines with
__maybe_unused statement for kmem_fops.

	Arnd
