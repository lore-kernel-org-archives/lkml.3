Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3HYQ0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 12:26:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37866 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab3HYQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 12:25:58 -0400
Date: Sun, 25 Aug 2013 18:25:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Message-ID: <20130825162554.GH5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-12-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-08-22 19:01:50, Lee, Chun-Yi wrote:
> Introduced a hibernate_key.c file to query the key pair from EFI variables
> and maintain key pair for check signature of S4 snapshot image. We
> loaded the private key when snapshot image stored success.
> 
> This patch introduced 2 EFI variables for store the key to sign S4 image and
> verify signature when S4 wake up. The names and GUID are:
>   S4SignKey-fe141863-c070-478e-b8a3-878a5dc9ef21
>   S4WakeKey-fe141863-c070-478e-b8a3-878a5dc9ef21
> 
> S4SignKey is used by EFI bootloader to pass the RSA private key that packaged
> by PKCS#8 format, kernel will read and parser it when system boot and reload
> it when S4 resume. EFI bootloader need gnerate a new private key when every
> time system boot.
> 
> S4WakeKey is used to pass the RSA public key that packaged by X.509
> certificate, kernel will read and parser it for check the signature of
> S4 snapshot image when S4 resume.
> 
> The follow-up patch will remove S4SignKey and S4WakeKey after load them
> to kernel for avoid anyone can access it through efivarfs.
> 
> v3:
> - Load S4 sign key before ExitBootServices.
>   Load private key before ExitBootServices() then bootloader doesn't need
>   generate key-pair for each booting:
>    + Add setup_s4_keys() to eboot.c to load S4 sign key before ExitBootServices.
>    + Reserve the memory block of sign key data blob in efi.c
> - In Makefile, moved hibernate_keys.o before hibernate.o for load S4 sign
>   key before check hibernate image. It makes sure the new sign key will be
>   transfer to resume target kernel.
> - Set "depends on EFI_STUB" in Kconfig
> 
> v2:
> Add CONFIG_SNAPSHOT_VERIFICATION for build of hibernate_keys.c depend on
> Kconfig.
> 
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Takashi Iwai <tiwai@suse.de>
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>


> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -368,6 +368,91 @@ free_handle:
>  	return status;
>  }
>  
> +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> +static efi_status_t setup_s4_keys(struct boot_params *params)
> +{
> +	struct setup_data *data;
> +	unsigned long datasize;
> +	u32 attr;
> +	struct efi_s4_key *s4key;
> +	efi_status_t status;
> +
> +	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;

A bit too many casts.

> @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
>  
>  	setup_efi_pci(boot_params);
>  
> +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> +	setup_s4_keys(boot_params);
> +#endif
> +

Move ifdef inside the function?

> @@ -729,6 +792,11 @@ void __init efi_init(void)
>  
>  	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
>  
> +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> +	/* keep s4 key from setup_data */
> +	efi_reserve_s4_skey_data();
> +#endif
> +

Here too.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
