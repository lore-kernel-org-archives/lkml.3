Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab3H2Sha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:37:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab3H2ShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:37:25 -0400
Date: Thu, 29 Aug 2013 14:37:13 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH V2 10/10] Add option to automatically enforce module
 signatures when in Secure Boot mode
Message-ID: <20130829183713.GT20828@hansolo.jdub.homelinux.org>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
 <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376933171-9854-11-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 01:26:11PM -0400, Matthew Garrett wrote:
> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
> only load signed bootloaders and kernels. Certain use cases may also
> require that all kernel modules also be signed. Add a configuration option
> that enforces this automatically when enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  Documentation/x86/zero-page.txt       |  2 ++
>  arch/x86/Kconfig                      | 10 ++++++++++
>  arch/x86/boot/compressed/eboot.c      | 33 +++++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/bootparam.h |  3 ++-
>  arch/x86/kernel/setup.c               |  6 ++++++
>  include/linux/module.h                |  6 ++++++
>  kernel/module.c                       |  7 +++++++
>  7 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
> index 199f453..ec38acf 100644
> --- a/Documentation/x86/zero-page.txt
> +++ b/Documentation/x86/zero-page.txt
> @@ -30,6 +30,8 @@ Offset	Proto	Name		Meaning
>  1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
>  1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
>  				(below)
> +1EB/001	ALL     kbd_status      Numlock is enabled
> +1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
>  1EF/001	ALL	sentinel	Used to detect broken bootloaders
>  290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
>  2D0/A00	ALL	e820_map	E820 memory map table
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index b32ebf9..6a6c19b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1581,6 +1581,16 @@ config EFI_STUB
>  
>  	  See Documentation/x86/efi-stub.txt for more information.
>  
> +config EFI_SECURE_BOOT_SIG_ENFORCE
> +        def_bool n
> +	prompt "Force module signing when UEFI Secure Boot is enabled"
> +	---help---
> +	  UEFI Secure Boot provides a mechanism for ensuring that the
> +	  firmware will only load signed bootloaders and kernels. Certain
> +	  use cases may also require that all kernel modules also be signed.
> +	  Say Y here to automatically enable module signature enforcement
> +	  when a system boots with UEFI Secure Boot enabled.
> +
>  config SECCOMP
>  	def_bool y
>  	prompt "Enable seccomp to safely compute untrusted bytecode"
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index b7388a4..145294d 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -861,6 +861,37 @@ fail:
>  	return status;
>  }
>  
> +static int get_secure_boot(efi_system_table_t *_table)
> +{
> +	u8 sb, setup;
> +	unsigned long datasize = sizeof(sb);
> +	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
> +	efi_status_t status;
> +
> +	status = efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> +
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (sb == 0)
> +		return 0;
> +
> +
> +	status = efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SetupMode", &var_guid, NULL, &datasize,
> +				&setup);
> +
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (setup == 1)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +
>  /*
>   * Because the x86 boot code expects to be passed a boot_params we
>   * need to create one ourselves (usually the bootloader would create
> @@ -1169,6 +1200,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
>  	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>  		goto fail;
>  
> +	boot_params->secure_boot = get_secure_boot(sys_table);
> +
>  	setup_graphics(boot_params);
>  
>  	setup_efi_pci(boot_params);
> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> index c15ddaf..d35da96 100644
> --- a/arch/x86/include/uapi/asm/bootparam.h
> +++ b/arch/x86/include/uapi/asm/bootparam.h
> @@ -131,7 +131,8 @@ struct boot_params {
>  	__u8  eddbuf_entries;				/* 0x1e9 */
>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
>  	__u8  kbd_status;				/* 0x1eb */
> -	__u8  _pad5[3];					/* 0x1ec */
> +	__u8  secure_boot;				/* 0x1ec */
> +	__u8  _pad5[2];					/* 0x1ec */
>  	/*
>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
>  	 *

You need to include the following chunk of code with this, otherwise the
secure_boot variable gets cleared.

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 4a8cb8d..25f9cf1 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -38,9 +38,13 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 		memset(&boot_params->ext_ramdisk_image, 0,
 		       (char *)&boot_params->efi_info -
 			(char *)&boot_params->ext_ramdisk_image);
-		memset(&boot_params->kbd_status, 0,
+		memset(&boot_params->kbd_status, 0, sizeof(boot_params->kbd_status));
+		/* don't clear boot_params->secure_boot.  we set that ourselves
+		 * earlier.
+		 */
+		memset(&boot_params->_pad5[0], 0,
 		       (char *)&boot_params->hdr -
-		       (char *)&boot_params->kbd_status);
+		       (char *)&boot_params->_pad5[0]);
 		memset(&boot_params->_pad7[0], 0,
 		       (char *)&boot_params->edd_mbr_sig_buffer[0] -
 			(char *)&boot_params->_pad7[0]);


josh
