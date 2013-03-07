Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3CGLjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:39:16 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43028 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932358Ab3CGLjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:39:14 -0500
Message-ID: <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: Matt Fleming <matt@console-pimps.org>
To: joeyli <jlee@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
Date: Thu, 07 Mar 2013 11:39:08 +0000
In-Reply-To: <1362652440.28562.26.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 18:34 +0800, joeyli wrote:
> The VariableNameSize is not reliable when EFI_SUCCESS is returned
> because UEFI 2.3.1 spec only mention VariableNameSize should updated
> when EFI_BUFFER_TOO_SMALL is returned. And, the 1024 bytes of buffer is
> from old UEFI spec. There doesn't have any size condition of variable
> data or variable name in 2.3.1 spec.

The spec may only mention what happens in the EFI_BUFFER_TOO_SMALL case,
but for EFI_SUCCESS, any behaviour other than leaving VariableNameSize
alone or updating it with the required size of the buffer is just
completely insane.

> I modified the patch to grab VariableNameSize when EFI_BUFFER_TOO_SMALL,
> the behavior like what we do in efivarfs_file_read().

Thanks, this does seem like the most robust solution.

> This patch works on a normal UEFI machine, we will test it on HP z220. I
> will send out it formally after test success.

Has anyone tried contacting HP to tell them their firmware is doing
bizarre things?

[...]

> @@ -1722,17 +1723,35 @@ int register_efivars(struct efivars *efivars,
>  	 */
>  
>  	do {
> -		variable_name_size = 1024;
> +		variable_name_size = 0;
>  
>  		status = ops->get_next_variable(&variable_name_size,
>  						variable_name,
>  						&vendor_guid);
>  		switch (status) {
> -		case EFI_SUCCESS:
> -			efivar_create_sysfs_entry(efivars,
> -						  variable_name_size,
> -						  variable_name,
> -						  &vendor_guid);
> +		case EFI_BUFFER_TOO_SMALL:
> +			if (variable_name_size < 2) {
> +				/* set variable_name_size to buffer size when it's too small */

This hunk would be better written like,

			if (variable_name_size < sizeof(efi_char16_t) * 2) {
				/* Bogus size - expect at least one char + NULL */
				variable_name_size = variable_name_buff_size;
			}

A variable name containing only '\0' is bogus. We need at least one
unicode character + '\0' for a valid variable name.

> +				variable_name_size = variable_name_buff_size;
> +			} else if (variable_name_size > variable_name_buff_size) {
> +				/* re-allocate more buffer when size doesn't enough */

This comment is redundant. Just delete it.

> +				kfree(variable_name);
> +				variable_name = kzalloc(variable_name_size, GFP_KERNEL);
> +				if (!variable_name) {
> +					printk(KERN_ERR "efivars: Memory allocation failed.\n");
> +					return -ENOMEM;
> +				}
> +				variable_name_buff_size = variable_name_size;
> +			}
> +			status = ops->get_next_variable(&variable_name_size,
> +							variable_name,
> +							&vendor_guid);
> +			variable_name_size = utf16_strsize(variable_name, variable_name_buff_size)+2;

Please document what this +2 represents and why we need it. Better yet,
use sizeof(efi_char16_t), and still document why it's needed, e.g. "Add
terminating NULL".

> +			if (status == EFI_SUCCESS)
> +				efivar_create_sysfs_entry(efivars,
> +							  variable_name_size,
> +							  variable_name,
> +							  &vendor_guid);
>  			break;
>  		case EFI_NOT_FOUND:
>  			break;


-- 
Matt Fleming, Intel Open Source Technology Center

