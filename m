Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3H3Ni7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:38:59 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42851 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3H3Ni5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:38:57 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 12/16] Fix types in EFI calls to match EFI function definitions.
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1376090777-20090-13-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-13-git-send-email-roy.franz@linaro.org>
Date: Fri, 30 Aug 2013 14:39:02 +0100
Message-Id: <20130830133902.AEA7A3E102A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 16:26:13 -0700, Roy Franz <roy.franz@linaro.org> wrote:
> EFI calls can made directly on ARM, so the function pointers
> are directly invoked.  This allows types to be checked at
> compile time, so here we ensure that the parameters match
> the function signature.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index b707a9f..4bb542f 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -321,7 +321,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
>  				EFI_LOADER_DATA,
>  				nr_files * sizeof(*files),
> -				&files);
> +				(void **)&files);
>  	if (status != EFI_SUCCESS) {
>  		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
>  		goto fail;
> @@ -372,7 +372,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  			boottime = sys_table_arg->boottime;
>  
>  			status = efi_call_phys3(boottime->handle_protocol,
> -					image->device_handle, &fs_proto, &io);
> +					image->device_handle, &fs_proto,
> +						(void **)&io);
>  			if (status != EFI_SUCCESS) {
>  				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
>  				goto free_files;
> @@ -406,7 +407,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  
>  grow:
>  		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
> -					EFI_LOADER_DATA, info_sz, &info);
> +					EFI_LOADER_DATA, info_sz,
> +					(void **)&info);
>  		if (status != EFI_SUCCESS) {
>  			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
>  			goto close_handles;
> @@ -456,18 +458,19 @@ grow:
>  
>  		addr = file_addr;
>  		for (j = 0; j < nr_files; j++) {
> -			u64 size;
> +			unsigned long size;
>  
>  			size = files[j].size;
>  			while (size) {
> -				u64 chunksize;
> +				unsigned long chunksize;
>  				if (size > EFI_READ_CHUNK_SIZE)
>  					chunksize = EFI_READ_CHUNK_SIZE;
>  				else
>  					chunksize = size;
>  				status = efi_call_phys3(fh->read,
>  							files[j].handle,
> -							&chunksize, addr);
> +							&chunksize,
> +							(void *)addr);

I think you need some description in the commit text about why the type
of chunksize is changing. It's not clear why you're making this change.
It is a bug fix?

g.
