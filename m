Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaFVSgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:36:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48560 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbaFVSgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:36:54 -0400
Message-ID: <53A7222A.6050104@zytor.com>
Date: Sun, 22 Jun 2014 11:36:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Daniel M. Weeks" <dan@danweeks.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] initramfs: Support initrd that is bigger than 2GiB
References: <1403317797-3977-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1403317797-3977-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 07:29 PM, Yinghai Lu wrote:
> When initrd (compressed or not) is used, kernel report data corrupted
> with /dev/ram0.
> 
> The root cause:
> During initramfs checking, if it is initrd, it will be transferred to
> /initrd.image with sys_write.
> sys_write only support 2G-4K write, so if the initrd ram is more than
> that, /initrd.image will not complete at all.
> 
> Add local xwrite to loop calling sys_write to workaround the
> problem.
> 
> Also need to use xwrite in write_buffer() to handle:
> image is uncompressed cpio and there is one big file (>2G) in it.
>    unpack_to_rootfs ===> write_buffer ===> actions[]/do_copy
> 
> At the same time, we don't need to worry about sys_read/sys_write in
> do_mounts_rd.c::crd_load. As decompressor will have fill/flush and
> local buffer that is smaller than 2G.
> 
> Test with uncompressed initrd, and compressed ones with gz, bz2, lzma,xz,
> lzop.
> 
> -v2: according to HPA, change name to xwrite.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ---
>  init/initramfs.c |   33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/init/initramfs.c
> ===================================================================
> --- linux-2.6.orig/init/initramfs.c
> +++ linux-2.6/init/initramfs.c
> @@ -19,6 +19,26 @@
>  #include <linux/syscalls.h>
>  #include <linux/utime.h>
>  
> +static long __init xwrite(unsigned int fd, char *p,
> +				   size_t count)
> +{
> +	ssize_t left = count;
> +	long written;
> +
> +	/* sys_write only can write MAX_RW_COUNT aka 2G-4K bytes at most */
> +	while (left > 0) {
> +		written = sys_write(fd, p, left);
> +
> +		if (written <= 0)
> +			break;
> +
> +		left -= written;
> +		p += written;
> +	}
> +
> +	return (written < 0) ? written : count;

The return value is bogus here, although it is probably theoretical (and
since you only care about a full write), but a written of 0 would return
in count being returned no matter the actual written value.

The normal behavior of xwrite(), like fwrite() and write(), is to return
the total number of bytes written if any bytes are written at all.

Here is my personal implementation of xwrite() (designed for userspace):

http://git.zytor.com/?p=lib/lib.git;a=blob;f=xwrite.c;hb=HEAD

Otherwise, the patch looks good.

	-hpa

