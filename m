Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3LPGCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:02:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3LPGCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:02:52 -0500
Date: Mon, 16 Dec 2013 14:02:02 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v5 08/14] efi: export efi runtime memory mapping to sysfs
Message-ID: <20131216060202.GA10271@dhcp-16-126.nay.redhat.com>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-9-git-send-email-dyoung@redhat.com>
 <20131211185520.GG23793@pd.tnic>
 <20131212023617.GF3751@dhcp-16-126.nay.redhat.com>
 <20131212205346.GA30162@pd.tnic>
 <20131213072600.GB11164@dhcp-16-126.nay.redhat.com>
 <20131213123028.GB18640@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213123028.GB18640@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/13 at 12:30pm, Matt Fleming wrote:
> I agree with Borislav that this should be invoked from efisubsys_init().
> Also Dave, there's nothing inherently x86-specific about runtime-map.c -
> we've been trying not to dump arch-specific code in
> drivers/firmware/efi/.
> 
> How about something like this, just to give you an idea? This would
> allow the ARM/ia64 folks to enable this code if they want at some later
> date. But more than that, it makes the code more self-contained and uses
> some real interfaces instead of relying on global variables,
> 
> (not compile tested)
> 
> ---
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 94a1cbcf6e2e..f45ea41deae0 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -76,8 +76,8 @@ static __initdata efi_config_table_type_t arch_tables[] = {
>  	{NULL_GUID, NULL, NULL},
>  };
>  
> -void *efi_runtime_map;
> -int nr_efi_runtime_map;
> +static void *efi_runtime_map;
> +static int nr_efi_runtime_map;
>  static u64 efi_setup; /* efi setup_data physical address */
>  
>  /*
> @@ -1084,6 +1084,9 @@ void __init efi_enter_virtual_mode(void)
>  		}
>  	}
>  
> +	efi_runtime_map_setup(efi_runtime_map, nr_efi_runtime_map,
> +			      boot_params.efi_info.efi_memdesc_size);
> +
>  	BUG_ON(!efi.systab);

After this change, nr_efi_runtime_map become static, but since I'm moving
the parse_efi_setup to efi_64.c and nr_efi_runtime_map is set there for
kexec kernel use..

So I will just save the setup_data paddr as efi_setup in efi_64.c, and
move other code from parse_efi_setup() to below function which is called
in efi_init();

+static void __init efi_setup_init(void)
+{
+	struct setup_data *sd;
+
+	if (!efi_setup)
+		return;
+
+	sd = early_memremap(efi_setup, sizeof(struct setup_data));
+	if (!sd) {
+		pr_warn("early_memremap setup_data failed\n");
+		efi_setup = 0;
+		return;
+	}
+	efi_setup += sizeof(struct setup_data);
+	nr_efi_runtime_map = (sd->len - sizeof(struct efi_setup_data)) /
+			     sizeof(efi_memory_desc_t);
+	early_memunmap(sd, sizeof(struct setup_data));
+}
