Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab3ICKtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:49:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53343 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759914Ab3ICKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:49:49 -0400
Date: Tue, 3 Sep 2013 11:49:41 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        Matthew Garrett <mjg@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 10/18] efi: Enable secure boot lockdown automatically
 when enabled in firmware
Message-ID: <20130903104941.GG28598@console-pimps.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-11-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-11-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Aug, at 07:01:49PM, Lee, Chun-Yi wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> The firmware has a set of flags that indicate whether secure boot is enabled
> and enforcing. Use them to indicate whether the kernel should lock itself
> down.  We also indicate the machine is in secure boot mode by adding the
> EFI_SECURE_BOOT bit for use with efi_enabled.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> Acked-by: Lee, Chun-Yi <jlee@suse.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  Documentation/x86/zero-page.txt        |    2 ++
>  arch/x86/boot/compressed/eboot.c       |   32 ++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/bootparam_utils.h |    8 ++++++--
>  arch/x86/include/uapi/asm/bootparam.h  |    3 ++-
>  arch/x86/kernel/setup.c                |    7 +++++++
>  include/linux/cred.h                   |    2 ++
>  include/linux/efi.h                    |    1 +
>  7 files changed, 52 insertions(+), 3 deletions(-)

[...]

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

The _table argument isn't needed because it's never used.

[...]

>  	io_delay_init();
>  
> +	if (boot_params.secure_boot) {
> +#ifdef CONFIG_EFI
> +		set_bit(EFI_SECURE_BOOT, &x86_efi_facility);
> +#endif
> +		secureboot_enable();
> +	}
> +

efi_enabled(EFI_BOOT) should be checked also, instead of assuming that
secure_boot contains a sensible value.

-- 
Matt Fleming, Intel Open Source Technology Center
