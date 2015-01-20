Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbbATAHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:07:22 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50273 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbATAHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:07:21 -0500
Date: Mon, 19 Jan 2015 19:07:18 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel <kernel@savoirfairelinux.com>
Message-ID: <643183939.413796.1421712438502.JavaMail.root@mail>
In-Reply-To: <1421703806-29791-3-git-send-email-linux@roeck-us.net>
Subject: Re: [PATCH 2/3] sysfs: Only accept read/write permissions for file
 attributes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> For sysfs file attributes, only read and write permisssions make sense.

Minor typo, there's an extra 's' to permissions.

> Mask provided attribute permissions accordingly and send a warning
> to the console if invalid permission bits are set.
> 
> Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  fs/sysfs/group.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index 305eccb..0de6473 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -55,6 +55,12 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
>                                  if (!mode)
>                                          continue;
>                          }
> +
> +                        WARN(mode & ~(S_IRUGO | S_IWUGO | SYSFS_PREALLOC),
> +                             "Attribute %s: Invalid permission 0x%x\n",
> +                             (*attr)->name, mode);

To print permissions, I would suggest unsigned octal ("0%o").

> +
> +                        mode &= S_IRUGO | S_IWUGO | SYSFS_PREALLOC;

As readable attributes are created with S_IRUGO and writable attributes are
created with S_IWUSR, I would limit the scope of is_visible to only:
S_IRUGO | S_IWUSR. Write permission for group and others feels wrong.

Then, I think we may want to keep the extra bits (all mode bits > 0777) from
the default attribute mode. Can they be used for sysfs attributes?

My suggestion is something like this:

        /* Limit the scope to S_IRUGO | S_IWUSR */
        if (mode & ~(S_IRUGO | S_IWUSR))
                pr_warn("Attribute %s: Invalid permissions 0%o\n",
                        (*attr)->name, mode);

        mode &= S_IRUGO | S_IWUSR;

        /* Use only returned bits and defaults > 0777 */
        mode |= (*attr)->mode & ~S_IRWXUGO;

>                          error = sysfs_add_file_mode_ns(parent, *attr, false,
>                                                         mode, NULL);
>                          if (unlikely(error))

The code hitting this warning actually is drivers/pci/pci-sysfs.c, which
declares write-only attributes with S_IWUSR|S_IWGRP (0220). Is that correct to
have write access for group for these attributes?

Thanks,
-v
