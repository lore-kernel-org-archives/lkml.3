Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3IQEdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 00:33:20 -0400
Received: from nbd.name ([46.4.11.11]:57318 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3IQEcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 00:32:53 -0400
Message-ID: <5237DB64.1020805@phrozen.org>
Date: Tue, 17 Sep 2013 06:32:36 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 15/28] mips: use early_init_dt_scan
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-16-git-send-email-robherring2@gmail.com>
In-Reply-To: <1379372965-22359-16-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/13 01:09, Rob Herring wrote:
> From: Rob Herring<rob.herring@calxeda.com>
>
> Convert mips to use new early_init_dt_scan function.
>
> Remove early_init_dt_scan_memory_arch
>
> Signed-off-by: Rob Herring<rob.herring@calxeda.com>
> Cc: Ralf Baechle<ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org
> ---

Acked-by: John Crispin <blogic@openwrt.org>


Thanks for this series ...







>   arch/mips/include/asm/prom.h |  3 ---
>   arch/mips/kernel/prom.c      | 39 +++------------------------------------
>   2 files changed, 3 insertions(+), 39 deletions(-)
>
> diff --git a/arch/mips/include/asm/prom.h b/arch/mips/include/asm/prom.h
> index 1e7e096..e3dbd0e 100644
> --- a/arch/mips/include/asm/prom.h
> +++ b/arch/mips/include/asm/prom.h
> @@ -17,9 +17,6 @@
>   #include<linux/types.h>
>   #include<asm/bootinfo.h>
>
> -extern int early_init_dt_scan_memory_arch(unsigned long node,
> -	const char *uname, int depth, void *data);
> -
>   extern void device_tree_init(void);
>
>   static inline unsigned long pci_address_to_pio(phys_addr_t address)
> diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
> index 0fa0b69..67a4c53 100644
> --- a/arch/mips/kernel/prom.c
> +++ b/arch/mips/kernel/prom.c
> @@ -17,8 +17,6 @@
>   #include<linux/debugfs.h>
>   #include<linux/of.h>
>   #include<linux/of_fdt.h>
> -#include<linux/of_irq.h>
> -#include<linux/of_platform.h>
>
>   #include<asm/page.h>
>   #include<asm/prom.h>
> @@ -40,13 +38,6 @@ char *mips_get_machine_name(void)
>   }
>
>   #ifdef CONFIG_OF
> -int __init early_init_dt_scan_memory_arch(unsigned long node,
> -					  const char *uname, int depth,
> -					  void *data)
> -{
> -	return early_init_dt_scan_memory(node, uname, depth, data);
> -}
> -
>   void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>   {
>   	return add_memory_region(base, size, BOOT_MEM_RAM);
> @@ -78,36 +69,12 @@ int __init early_init_dt_scan_model(unsigned long node,	const char *uname,
>   	return 0;
>   }
>
> -void __init early_init_devtree(void *params)
> -{
> -	/* Setup flat device-tree pointer */
> -	initial_boot_params = params;
> -
> -	/* Retrieve various informations from the /chosen node of the
> -	 * device-tree, including the platform type, initrd location and
> -	 * size, and more ...
> -	 */
> -	of_scan_flat_dt(early_init_dt_scan_chosen, arcs_cmdline);
> -
> -
> -	/* Scan memory nodes */
> -	of_scan_flat_dt(early_init_dt_scan_root, NULL);
> -	of_scan_flat_dt(early_init_dt_scan_memory_arch, NULL);
> -
> -	/* try to load the mips machine name */
> -	of_scan_flat_dt(early_init_dt_scan_model, NULL);
> -}
> -
>   void __init __dt_setup_arch(struct boot_param_header *bph)
>   {
> -	if (be32_to_cpu(bph->magic) != OF_DT_HEADER) {
> -		pr_err("DTB has bad magic, ignoring builtin OF DTB\n");
> -
> +	if (!early_init_dt_scan(bph))
>   		return;
> -	}
> -
> -	initial_boot_params = bph;
>
> -	early_init_devtree(initial_boot_params);
> +	/* try to load the mips machine name */
> +	of_scan_flat_dt(early_init_dt_scan_model, NULL);
>   }
>   #endif

