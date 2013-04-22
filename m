Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab3DVPDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:03:31 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:52631 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510Ab3DVPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:03:29 -0400
Message-ID: <1366643006.3251.14.camel@x61.thuisdomein>
Subject: Re: [PATCH V6 2/3] efi: Pass boot services variable info to runtime
 code
From: Paul Bolle <pebolle@tiscali.nl>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Apr 2013 17:03:26 +0200
In-Reply-To: <1366056587-24414-3-git-send-email-matthew.garrett@nebula.com>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-1-git-send-email-matthew.garrett@nebula.com>
	 <1366056587-24414-3-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Apr 2013 15:03:26.0560 (UTC) FILETIME=[8AA6E600:01CE3F6A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 13:09 -0700, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot services.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the results
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfully,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stub
> up to the efi platform code.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

This seems to be the patch that has become commit
cc5a080c5d40c36089bb08a8a16fa3fc7047fe0f ("efi: Pass boot services
variable info to runtime code"), which is part of v3.9-rc8.

It triggers this GCC warning (on Fedora 17, 32 bit):
    arch/x86/boot/compressed/eboot.c: In function ‘setup_efi_vars’:
    arch/x86/boot/compressed/eboot.c:269:2: warning: passing argument 1 of ‘efi_call_phys’ makes pointer from integer without a cast [enabled by default]
    In file included from arch/x86/boot/compressed/eboot.c:12:0:
    [...]/arch/x86/include/asm/efi.h:8:33: note: expected ‘void *’ but argument is of type ‘long unsigned int’

> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -251,6 +251,51 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
>  	*size = len;
>  }
>  
> +static efi_status_t setup_efi_vars(struct boot_params *params)
> +{
> +	struct setup_data *data;
> +	struct efi_var_bootdata *efidata;
> +	u64 store_size, remaining_size, var_size;
> +	efi_status_t status;
> +
> +	if (!sys_table->runtime->query_variable_info)
> +		return EFI_UNSUPPORTED;
> +
> +	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
> +
> +	while (data && data->next)
> +		data = (struct setup_data *)(unsigned long)data->next;
> +
> +	status = efi_call_phys4(sys_table->runtime->query_variable_info,

Casting to void * here makes the warning go away. But the code is
sufficiently complicated (for me) to make it unobvious whether that is
the right thing to do. Besides, I don't think I have hardware to test
this.

> +				EFI_VARIABLE_NON_VOLATILE |
> +				EFI_VARIABLE_BOOTSERVICE_ACCESS |
> +				EFI_VARIABLE_RUNTIME_ACCESS, &store_size,
> +				&remaining_size, &var_size);
> +
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> +				EFI_LOADER_DATA, sizeof(*efidata), &efidata);
> +
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	efidata->data.type = SETUP_EFI_VARS;
> +	efidata->data.len = sizeof(struct efi_var_bootdata) -
> +		sizeof(struct setup_data);
> +	efidata->data.next = 0;
> +	efidata->store_size = store_size;
> +	efidata->remaining_size = remaining_size;
> +	efidata->max_var_size = var_size;
> +
> +	if (data)
> +		data->next = (unsigned long)efidata;
> +	else
> +		params->hdr.setup_data = (unsigned long)efidata;
> +
> +}
> +
>  static efi_status_t setup_efi_pci(struct boot_params *params)
>  {
>  	efi_pci_io_protocol *pci;


Paul Bolle

