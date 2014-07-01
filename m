Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbaGAUWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:22:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbaGAUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:22:35 -0400
Date: Tue, 1 Jul 2014 16:21:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, bp@alien8.de, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, linux-efi@vger.kernel.org
Subject: Re: [PATCH 15/15] kexec: Support kexec/kdump on EFI systems
Message-ID: <20140701202152.GB19352@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-16-git-send-email-vgoyal@redhat.com>
 <20140701194605.GJ7539@console-pimps.org>
 <20140701131419.454a3fc32fcc84a43b668c50@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701131419.454a3fc32fcc84a43b668c50@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 01:14:19PM -0700, Andrew Morton wrote:
> On Tue, 1 Jul 2014 20:46:05 +0100 Matt Fleming <matt@console-pimps.org> wrote:
> 
> > > +int get_efi_runtime_map_size(void)
> > > +{
> > > +	return nr_efi_runtime_map * efi_memdesc_size;
> > > +}
> > > +
> > > +int get_efi_runtime_map_desc_size(void)
> > > +{
> > > +	return efi_memdesc_size;
> > > +}
> > > +
> > > +int efi_runtime_map_copy(void *buf, size_t bufsz)
> > > +{
> > > +	size_t sz = get_efi_runtime_map_size();
> > > +
> > > +	if (sz > bufsz)
> > > +		sz = bufsz;
> > > +
> > > +	memcpy(buf, efi_runtime_map, sz);
> > > +	return 0;
> > > +}
> > 
> > Could we prefix these with efi_, e.g. efi_get_runtime_map_size() ?
> 
> This?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: kexec-support-kexec-kdump-on-efi-systems-fix
> 
> s/get_efi/efi_get/g, per Matt
> 
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Matt Fleming <matt@console-pimps.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Looks good to me. Thanks Andrew.

Vivek

> ---
> 
>  arch/x86/kernel/kexec-bzimage64.c  |    4 ++--
>  drivers/firmware/efi/runtime-map.c |    6 +++---
>  include/linux/efi.h                |    8 ++++----
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff -puN arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems-fix arch/x86/kernel/kexec-bzimage64.c
> --- a/arch/x86/kernel/kexec-bzimage64.c~kexec-support-kexec-kdump-on-efi-systems-fix
> +++ a/arch/x86/kernel/kexec-bzimage64.c
> @@ -181,7 +181,7 @@ setup_efi_state(struct boot_params *para
>  	ei->efi_systab_hi = current_ei->efi_systab_hi;
>  
>  	ei->efi_memdesc_version = current_ei->efi_memdesc_version;
> -	ei->efi_memdesc_size = get_efi_runtime_map_desc_size();
> +	ei->efi_memdesc_size = efi_get_runtime_map_desc_size();
>  
>  	setup_efi_info_memmap(params, params_load_addr, efi_map_offset,
>  			      efi_map_sz);
> @@ -397,7 +397,7 @@ void *bzImage64_load(struct kimage *imag
>  	 * have to create separate segment for each. Keeps things
>  	 * little bit simple
>  	 */
> -	efi_map_sz = get_efi_runtime_map_size();
> +	efi_map_sz = efi_get_runtime_map_size();
>  	efi_map_sz = ALIGN(efi_map_sz, 16);
>  	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
>  				MAX_ELFCOREHDR_STR_LEN;
> diff -puN drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems-fix drivers/firmware/efi/runtime-map.c
> --- a/drivers/firmware/efi/runtime-map.c~kexec-support-kexec-kdump-on-efi-systems-fix
> +++ a/drivers/firmware/efi/runtime-map.c
> @@ -138,19 +138,19 @@ add_sysfs_runtime_map_entry(struct kobje
>  	return entry;
>  }
>  
> -int get_efi_runtime_map_size(void)
> +int efi_get_runtime_map_size(void)
>  {
>  	return nr_efi_runtime_map * efi_memdesc_size;
>  }
>  
> -int get_efi_runtime_map_desc_size(void)
> +int efi_get_runtime_map_desc_size(void)
>  {
>  	return efi_memdesc_size;
>  }
>  
>  int efi_runtime_map_copy(void *buf, size_t bufsz)
>  {
> -	size_t sz = get_efi_runtime_map_size();
> +	size_t sz = efi_get_runtime_map_size();
>  
>  	if (sz > bufsz)
>  		sz = bufsz;
> diff -puN include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems-fix include/linux/efi.h
> --- a/include/linux/efi.h~kexec-support-kexec-kdump-on-efi-systems-fix
> +++ a/include/linux/efi.h
> @@ -1151,8 +1151,8 @@ int efivars_sysfs_init(void);
>  #ifdef CONFIG_EFI_RUNTIME_MAP
>  int efi_runtime_map_init(struct kobject *);
>  void efi_runtime_map_setup(void *, int, u32);
> -int get_efi_runtime_map_size(void);
> -int get_efi_runtime_map_desc_size(void);
> +int efi_get_runtime_map_size(void);
> +int efi_get_runtime_map_desc_size(void);
>  int efi_runtime_map_copy(void *buf, size_t bufsz);
>  #else
>  static inline int efi_runtime_map_init(struct kobject *kobj)
> @@ -1163,12 +1163,12 @@ static inline int efi_runtime_map_init(s
>  static inline void
>  efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
>  
> -static inline int get_efi_runtime_map_size(void)
> +static inline int efi_get_runtime_map_size(void)
>  {
>  	return 0;
>  }
>  
> -static inline int get_efi_runtime_map_desc_size(void)
> +static inline int efi_get_runtime_map_desc_size(void)
>  {
>  	return 0;
>  }
> _
