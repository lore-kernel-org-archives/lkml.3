Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3JHFnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:43:04 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:36213 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3JHFnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:43:02 -0400
Message-ID: <52539B4C.9040400@synopsys.com>
Date: Tue, 8 Oct 2013 11:12:36 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v2 25/29] arc: use common of_flat_dt_match_machine
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com> <1381163377-21044-26-git-send-email-robherring2@gmail.com>
In-Reply-To: <1381163377-21044-26-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.243]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 10/07/2013 09:59 PM, Rob Herring wrote:
> From: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
> 
> Convert arc to use the common of_flat_dt_match_machine function.
> 
> Signed-off-by: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>
> Acked-by: Vineet Gupta <vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
> ---
>  arch/arc/kernel/devtree.c | 65 +++++++++++++----------------------------------
>  1 file changed, 18 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
> index 1ab6f35..12de555 100644
> --- a/arch/arc/kernel/devtree.c
> +++ b/arch/arc/kernel/devtree.c
> @@ -18,6 +18,19 @@
>  #include <asm/clk.h>
>  #include <asm/mach_desc.h>
>  
> +static const void * __init arch_get_next_mach(const char *const **match)
> +{
> +	static const struct machine_desc *mdesc = __arch_info_begin;
> +	const struct machine_desc *m = mdesc;
> +
> +	if (m >= __arch_info_end)
> +		return NULL;
> +
> +	mdesc++;
> +	*match = m->dt_compat;
> +	return m;
> +}
> +
>  /**
>   * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
>   * @dt:		virtual address pointer to dt blob
> @@ -27,64 +40,22 @@
>   */
>  struct machine_desc * __init setup_machine_fdt(void *dt)
>  {
> -	struct machine_desc *mdesc = NULL, *mdesc_best = NULL;
> -	unsigned int score, mdesc_score = ~1;
> +	struct machine_desc *mdesc;
>  	unsigned long dt_root;
> -	const char *model, *compat;
>  	void *clk;
> -	char manufacturer[16];
>  	unsigned long len;
>  
>  	if (!early_init_dt_scan(dt))
>  		return NULL;
>  
> -	dt_root = of_get_flat_dt_root();
> -
> -	/*
> -	 * The kernel could be multi-platform enabled, thus could have many
> -	 * "baked-in" machine descriptors. Search thru all for the best
> -	 * "compatible" string match.
> -	 */
> -	for_each_machine_desc(mdesc) {
> -		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
> -		if (score > 0 && score < mdesc_score) {
> -			mdesc_best = mdesc;
> -			mdesc_score = score;
> -		}
> -	}
> -	if (!mdesc_best) {
> -		const char *prop;
> -		long size;
> -
> -		pr_err("\n unrecognized device tree list:\n[ ");
> -
> -		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
> -		if (prop) {
> -			while (size > 0) {
> -				printk("'%s' ", prop);
> -				size -= strlen(prop) + 1;
> -				prop += strlen(prop) + 1;
> -			}
> -		}
> -		printk("]\n\n");
> -
> +	mdesc = of_flat_dt_match_machine(NULL, arch_get_next_mach);
> +	if (!mdesc)
>  		machine_halt();
> -	}
> -
> -	/* compat = "<manufacturer>,<model>" */
> -	compat =  mdesc_best->dt_compat[0];
> -
> -	model = strchr(compat, ',');
> -	if (model)
> -		model++;
> -
> -	strlcpy(manufacturer, compat, model ? model - compat : strlen(compat));
> -
> -	pr_info("Board \"%s\" from %s (Manufacturer)\n", model, manufacturer);
>  
> +	dt_root = of_get_flat_dt_root();
>  	clk = of_get_flat_dt_prop(dt_root, "clock-frequency", &len);
>  	if (clk)
>  		arc_set_core_freq(of_read_ulong(clk, len/4));
>  
> -	return mdesc_best;
> +	return mdesc;
>  }
> 

Can you please fold the following into this patch. This removes the const warning
and also gets rid of some dead code.

Thx,
-Vineet

------------------->
>From 3cd48b4955e9763248e306fff7ddf420b126ebab Mon Sep 17 00:00:00 2001
From: Vineet Gupta <vgupta@synopsys.com>
Date: Tue, 8 Oct 2013 09:53:17 +0530
Subject: [PATCH] ARC: Addendum to "use common of_flat_dt_match_machine"

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/mach_desc.h | 14 ++------------
 arch/arc/kernel/devtree.c        |  4 ++--
 arch/arc/kernel/setup.c          |  2 +-
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/arch/arc/include/asm/mach_desc.h b/arch/arc/include/asm/mach_desc.h
index d3e9c0a05be8..c88c59c4183c 100644
--- a/arch/arc/include/asm/mach_desc.h
+++ b/arch/arc/include/asm/mach_desc.h
@@ -51,22 +51,12 @@ struct machine_desc {
 /*
  * Current machine - only accessible during boot.
  */
-extern struct machine_desc *machine_desc;
+extern const struct machine_desc *machine_desc;

 /*
  * Machine type table - also only accessible during boot
  */
 extern struct machine_desc __arch_info_begin[], __arch_info_end[];
-#define for_each_machine_desc(p)            \
-    for (p = __arch_info_begin; p < __arch_info_end; p++)
-
-static inline struct machine_desc *default_machine_desc(void)
-{
-    /* the default machine is the last one linked in */
-    if (__arch_info_end - 1 < __arch_info_begin)
-        return NULL;
-    return __arch_info_end - 1;
-}

 /*
  * Set of macros to define architecture features.
@@ -81,6 +71,6 @@ __attribute__((__section__(".arch.info.init"))) = {    \
 #define MACHINE_END                \
 };

-extern struct machine_desc *setup_machine_fdt(void *dt);
+extern const struct machine_desc *setup_machine_fdt(void *dt);

 #endif
diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index 336396300e53..b6dc4e21fd32 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -37,9 +37,9 @@ static const void * __init arch_get_next_mach(const char *const
**match)
  * If a dtb was passed to the kernel, then use it to choose the correct
  * machine_desc and to setup the system.
  */
-struct machine_desc * __init setup_machine_fdt(void *dt)
+const struct machine_desc * __init setup_machine_fdt(void *dt)
 {
-    struct machine_desc *mdesc;
+    const struct machine_desc *mdesc;
     unsigned long dt_root;
     void *clk;
     unsigned long len;
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 5ae542454bed..f7d4a41d0629 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -30,7 +30,7 @@
 int running_on_hw = 1;    /* vs. on ISS */

 char __initdata command_line[COMMAND_LINE_SIZE];
-struct machine_desc *machine_desc;
+const struct machine_desc *machine_desc;

 struct task_struct *_current_task[NR_CPUS];    /* For stack switching */

-- 1.8.1.2
