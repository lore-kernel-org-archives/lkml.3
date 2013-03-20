Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3CTL00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:26:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34885 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757714Ab3CTL0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:26:24 -0400
Message-ID: <51499CDB.7040606@console-pimps.org>
Date: Wed, 20 Mar 2013 11:26:19 +0000
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 08:40 AM, James Bottomley wrote:
> From: James Bottomley <JBottomley@Parallels.com>
> 
> The object here is to make the NV+BS variables accessible (at least read only)
> at runtime so we can get a full picture of the state of the EFI variables for
> debugging and secure boot purposes.

This should definitely be guarded with a debug config option and off by
default. It needs to be made really clear that this code is for
debugging purposes.

[...]

> +static efi_status_t setup_efi_bootvars(struct boot_params *params)
> +{
> +	const int len = 1024;
> +	efi_char16_t *str;
> +	efi_status_t status;
> +	struct setup_data **data = (struct setup_data **)&params->hdr.setup_data;
> +
> +	status = efi_call_phys3(sys_table->boottime->allocate_pool,
> +				EFI_LOADER_DATA, len, &str);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	/*
> +	 * Note: this trick only works on Little Endian if hdr.setup_data
> +	 * is u64 on both 64 and 32 bit
> +	 */
> +	while (*data)
> +		data = (struct setup_data **)&(*data)->next;
> +
> +	memset(str, 0, len);
> +
> +	for (;;) {
> +		unsigned long size = len, str_len;
> +		efi_guid_t guid;
> +		struct efi_setup_bootvars *bvs;
> +		unsigned int attributes;
> +
> +		status = efi_call_phys3(sys_table->runtime->get_next_variable,
> +					&size, str, &guid);
> +		if (status != EFI_SUCCESS)
> +			break;
> +
> +		str_len = size;

Beware of these recent debacles,

    http://article.gmane.org/gmane.linux.kernel.efi/905
    http://article.gmane.org/gmane.linux.kernel.efi/909

I'm not saying you need to handle them explicitly in this patch, at
least not if this is all under a config option with a big fat warning.

> +		size = 0;
> +		status = efi_call_phys5(sys_table->runtime->get_variable,
> +					str, &guid, &attributes, &size, NULL);
> +		if (status != EFI_SUCCESS && status != EFI_BUFFER_TOO_SMALL)
> +			break;
> +
> +
> +		/*
> +		 * Please don't be tempted to optimise here: some
> +		 * UEFI implementations fail to set attributes if
> +		 * they return any error (including EFI_BUFFER_TOO_SMALL)
> +		 */
> +		status = efi_call_phys3(sys_table->boottime->allocate_pool,
> +					EFI_LOADER_DATA,
> +					size + sizeof(*bvs) + str_len,
> +					&bvs);
> +		if (status != EFI_SUCCESS)
> +			continue;

Allocating things as EFI_LOADER_DATA is fine but you need to be sure to
reserve these memory regions so that they don't get used by any of the
memory allocators. See

    http://article.gmane.org/gmane.linux.kernel.efi/580

(yes, setup_efi_pci() suffers from the same problem)

> +		memset(bvs, 0 , sizeof(bvs));
> +		status = efi_call_phys5(sys_table->runtime->get_variable,
> +					str, &guid, &attributes,
> +					&size, bvs->data);
> +
> +		if (status != EFI_SUCCESS
> +		    || (attributes & 0x07) != (EFI_VARIABLE_BOOTSERVICE_ACCESS |
> +					       EFI_VARIABLE_NON_VOLATILE)) {
> +			efi_call_phys1(sys_table->boottime->free_pool, bvs);
> +			continue;
> +		}

Please use the EFI_VARIABLE_* constants instead of the magic 0x07.

[...]

> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index fff986d..931060a 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -153,17 +153,103 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
>  					  unsigned long *data_size,
>  					  void *data)
>  {
> -	return efi_call_virt5(get_variable,
> -			      name, vendor, attr,
> -			      data_size, data);
> +	efi_status_t status = efi_call_virt5(get_variable,
> +					     name, vendor, attr,
> +					     data_size, data);
> +	u64 pa_data;
> +	struct setup_data *s_d;
> +
> +	if (status != EFI_NOT_FOUND)
> +		return status;
> +
> +
> +	for (pa_data = boot_params.hdr.setup_data; pa_data;
> +	     pa_data = s_d->next) {
> +		struct efi_setup_bootvars *bvs;
> +		efi_char16_t *bvs_name;
> +		int i = 0;
> +
> +		s_d = phys_to_virt(pa_data);
> +
> +		if (s_d->type != SETUP_EFIVAR)
> +			continue;
> +
> +		bvs = (struct efi_setup_bootvars *)s_d;
> +		bvs_name = (efi_char16_t *)(bvs->data + bvs->size);
> +
> +		for (i = 0; bvs_name[i] != 0 && name[i] != 0; i++)
> +			if (bvs_name[i] != name[i])
> +				break;
> +
> +		if (bvs_name[i] != 0 || name[i] != 0)
> +			continue;
> +

This would be cleaner if you pulled some of the utf16_str* functions out
of drivers/firmware/efivars.c and stuck them in include/linux/efi.h.
Then you could do something like,

		if (utf16_strncmp(bvs_name, name, utf16_strlen(name)) != 0)
			continue;

> +		if (memcmp(&bvs->guid, vendor, sizeof(*vendor)) != 0)
> +			continue;
> +
> +		if (attr)
> +			*attr = bvs->attributes;
> +
> +		if (*data_size < bvs->size) {
> +			*data_size = bvs->size;
> +			return EFI_BUFFER_TOO_SMALL;
> +		}
> +		*data_size = bvs->size;
> +		memcpy(data, bvs->data, bvs->size);
> +
> +		return EFI_SUCCESS;
> +	}
> +	return EFI_NOT_FOUND;
>  }
>  
>  static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>  					       efi_char16_t *name,
>  					       efi_guid_t *vendor)
>  {
> -	return efi_call_virt3(get_next_variable,
> -			      name_size, name, vendor);
> +	static int use_bootvars = 0;
> +	efi_status_t status;
> +	u64 pa_data = boot_params.hdr.setup_data;
> +	int found = 0;

Why not make found a boolean?

-- 
Matt Fleming, Intel Open Source Technology Center
