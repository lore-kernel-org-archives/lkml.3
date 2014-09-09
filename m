Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaIIPez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaIIPey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:34:54 -0400
Message-ID: <540F1DFD.10301@redhat.com>
Date: Tue, 09 Sep 2014 17:34:21 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        calvin.walton@kepstin.ca, yinghai@kernel.org, grawity@gmail.com,
        anders@chargestorm.se, matt.fleming@intel.com, harald@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/efi: Only load initrd above 4g on second
 try
References: <tip-47226ad4f4cfd1e91ded7f2ec42f83ff1c624663@git.kernel.org>
In-Reply-To: <tip-47226ad4f4cfd1e91ded7f2ec42f83ff1c624663@git.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 17:18, tip-bot for Yinghai Lu wrote:
> Commit-ID:  47226ad4f4cfd1e91ded7f2ec42f83ff1c624663
> Gitweb:     http://git.kernel.org/tip/47226ad4f4cfd1e91ded7f2ec42f83ff1c624663
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Wed, 3 Sep 2014 21:50:07 -0700
> Committer:  Matt Fleming <matt.fleming@intel.com>
> CommitDate: Mon, 8 Sep 2014 20:52:02 +0100
> 
> x86/efi: Only load initrd above 4g on second try
> 
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
> 
> Revert to old way to load initrd under 4G on first try, second try will
> use above 4G buffer when initrd is too big and does not fit under 4G.
> 
> [ The cause of the freeze appears to be a firmware bug when reading
>   file data into buffers above 4GB, though the exact reason is unknown.
>   Mantas reports that the hang can be avoid if the file size is a
>   multiple of 512 bytes, but I've seen some ASUS firmware simply
>   corrupting the file data rather than freezing.
> 
>   Laszlo fixed an issue in the upstream EDK2 DiskIO code in Aug 2013
>   which may possibly be related, commit 4e39b75e ("MdeModulePkg/DiskIoDxe:
>   fix source/destination pointer of overrun transfer").
> 
>   Whatever the cause, it's unlikely that a fix will be forthcoming
>   from the vendor, hence the workaround - Matt ]
> 
> Cc: Laszlo Ersek <lersek@redhat.com>
> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
> Reported-by: Harald Hoyer <harald@redhat.com>
> Tested-by: Anders Darander <anders@chargestorm.se>
> Tested-by: Calvin Walton <calvin.walton@kepstin.ca>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/boot/compressed/eboot.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index f277184..dca9842 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1032,7 +1032,6 @@ struct boot_params *make_boot_params(struct efi_config *c)
>  	int i;
>  	unsigned long ramdisk_addr;
>  	unsigned long ramdisk_size;
> -	unsigned long initrd_addr_max;
>  
>  	efi_early = c;
>  	sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
> @@ -1095,15 +1094,20 @@ struct boot_params *make_boot_params(struct efi_config *c)
>  
>  	memset(sdt, 0, sizeof(*sdt));
>  
> -	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
> -		initrd_addr_max = -1UL;
> -	else
> -		initrd_addr_max = hdr->initrd_addr_max;
> -
>  	status = handle_cmdline_files(sys_table, image,
>  				      (char *)(unsigned long)hdr->cmd_line_ptr,
> -				      "initrd=", initrd_addr_max,
> +				      "initrd=", hdr->initrd_addr_max,
>  				      &ramdisk_addr, &ramdisk_size);
> +
> +	if (status != EFI_SUCCESS &&
> +	    hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G) {
> +		efi_printk(sys_table, "Trying to load files to higher address\n");
> +		status = handle_cmdline_files(sys_table, image,
> +				      (char *)(unsigned long)hdr->cmd_line_ptr,
> +				      "initrd=", -1UL,
> +				      &ramdisk_addr, &ramdisk_size);
> +	}
> +
>  	if (status != EFI_SUCCESS)
>  		goto fail2;
>  	hdr->ramdisk_image = ramdisk_addr & 0xffffffff;
> 

Assuming that handle_cmdline_files() cleans up things internally on a
failed attempt (no memory leaked etc), this seems sane to me. (All I
know about this code is visible in the above context.)

Acked-by: Laszlo Ersek <lersek@redhat.com>

Thanks
Laszlo
