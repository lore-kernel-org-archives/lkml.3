Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3G2ULB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:11:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46419 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab3G2ULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:11:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, xen-devel@lists.xen.org,
        tboot-devel@lists.sourceforge.net, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH v7 2/3] x86/tboot: Fail extended mode reduced hardware sleep
Date: Mon, 29 Jul 2013 22:21:08 +0200
Message-ID: <8791139.q8n07ejQ71@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1375118055-15942-3-git-send-email-benjamin.guthro@citrix.com>
References: <1375118055-15942-1-git-send-email-benjamin.guthro@citrix.com> <1375118055-15942-3-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 01:14:14 PM Ben Guthro wrote:
> Register for the extended sleep callback from acpi.
> As tboot currently does not support the reduced hardware sleep
> interface, fail this extended call.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Cc: tboot-devel@lists.sourceforge.net
> Cc: Gang Wei <gang.wei@intel.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/kernel/tboot.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index addf7b5..760f431 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -301,6 +301,17 @@ static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
>  	return 0;
>  }
>  
> +static int tboot_extended_sleep(u8 sleep_state, u32 val_a, u32 val_b)
> +{
> +	if (!tboot_enabled())
> +		return 0;
> +
> +	pr_warning("tboot is not able to suspend on platforms with"
> +		   " reduced hardware sleep (ACPIv5). Please contact"
> +		   " tboot-devel@lists.sourceforge.net mailing list.");
> +	return -1;

Please use a meaningful error code here.  For example -ENODEV.

> +}
> +
>  static atomic_t ap_wfs_count;
>  
>  static int tboot_wait_for_aps(int num_aps)
> @@ -422,6 +433,7 @@ static __init int tboot_late_init(void)
>  #endif
>  
>  	acpi_os_set_prepare_sleep(&tboot_sleep);
> +	acpi_os_set_prepare_extended_sleep(&tboot_extended_sleep);
>  	return 0;
>  }

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
