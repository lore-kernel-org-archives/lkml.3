Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbaCTVnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:43:52 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:53512 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbaCTVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <1395351344-2054-1-git-send-email-holler@ahsoftware.de>
References: <1395351344-2054-1-git-send-email-holler@ahsoftware.de>
Date: Thu, 20 Mar 2014 22:43:50 +0100
X-Google-Sender-Auth: LKgbO_dxRMLh2sbQran7Q4c0Wc8
Message-ID: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>
Subject: Re: [PATCH] initramfs: print error and shell out for unsupported content
From: Levente Kurusa <levex@linux.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-20 22:35 GMT+01:00 Alexander Holler <holler@ahsoftware.de>:
> The initramfs generation is broken for file and directory names which contain
> colons or spaces. Print an error and don't try to continue.
>
> Tests:
>
> cd linux
> make defconfig
> echo 'CONFIG_BLK_DEV_INITRD=y' >> .config
> echo 'CONFIG_INITRAMFS_ROOT_UID=0' >>.config
> echo 'CONFIG_INITRAMFS_ROOT_GID=0' >>.config
> echo 'CONFIG_INITRAMFS_COMPRESSION_NONE=y' >>.config
> echo 'CONFIG_INITRAMFS_SOURCE="/tmp/bugroot"' >>.config
>
> Problem with colons:
>
> mkdir -p /tmp/bugroot/a:b
> make -j4 bzImage # no error
> make bzImage # try again, oops
>
> Problem with spaces:
>
> mkdir -p /tmp/bugroot/a\ b
> make -j4 bzImage # no error
> zcat usr/initramfs_data.cpio.gz | cpio --extract --list # oops, no content
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  scripts/gen_initramfs_list.sh | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
> index 17fa901..aacf366 100644
> --- a/scripts/gen_initramfs_list.sh
> +++ b/scripts/gen_initramfs_list.sh
> @@ -171,6 +171,17 @@ dir_filelist() {
>         ${dep_list}header "$1"
>
>         srcdir=$(echo "$1" | sed -e 's://*:/:g')
> +
> +       # Files and directories with spaces and colons are unsupported.
> +       local unsupported=$(find "${srcdir}" -regex '.*\(:\| \).*')
> +       if [ ! -z "${unsupported}" ]; then
> +               printf "ERROR: Unable to handle files/directories with " >&2
> +               printf "unsupported characters.\nPlease use other ways " >&2

'Please use other ways to...'
(i.e. missing "to")

> +               printf "generate a cpio-archive.\nUnsupported files and " >&2
> +               printf "directories are:\n$unsupported\n" >&2
> +               exit 1
> +       fi
> +

I think it would be worthy to tell the user what kind of characters
are unsupported. For instance, tell them that 'spaces' are unsupported.


>         dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n")
>
>         # If $dirlist is only one line, then the directory is empty
> [...]

--
Regards,
Levente Kurusa
