Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaCUVDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 17:03:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCUVDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 17:03:06 -0400
Date: Fri, 21 Mar 2014 14:03:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] initramfs: print error and shell out for unsupported
 content
Message-Id: <20140321140305.a3679620aa25132a3b75a404@linux-foundation.org>
In-Reply-To: <1395352845-7435-1-git-send-email-holler@ahsoftware.de>
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>
	<1395352845-7435-1-git-send-email-holler@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 23:00:45 +0100 Alexander Holler <holler@ahsoftware.de> wrote:

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
> ...
>
> --- a/scripts/gen_initramfs_list.sh
> +++ b/scripts/gen_initramfs_list.sh
> @@ -171,6 +171,18 @@ dir_filelist() {
>  	${dep_list}header "$1"
>  
>  	srcdir=$(echo "$1" | sed -e 's://*:/:g')
> +
> +	# Files and directories with spaces and colons are unsupported.
> +	local unsupported=$(find "${srcdir}" -regex '.*\(:\| \).*')
> +	if [ ! -z "${unsupported}" ]; then
> +		printf "ERROR: Unable to handle files/directories with " >&2
> +		printf "unsupported characters (spaces and colons).\n" >&2
> +		printf "Please use other ways to generate a cpio-archive. " >&2
> +		printf "Unsupported files and directories are:\n" >&2
> +		printf "$unsupported\n" >&2
> +		exit 1
> +	fi
> +

It would be better to fix the it-doesnt-work-with-all-filenames bug. 
Any details on that?

