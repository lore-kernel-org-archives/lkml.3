Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3AaAOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:14:22 -0500
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:38292 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab3AaAOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:14:21 -0500
Date: Thu, 31 Jan 2013 00:18:06 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH v3 1/2] ARM: kernel: update cpuinfo to print SoC
 model name
Message-ID: <20130130231806.GO7360@game.jcrosoft.org>
References: <1359558091-29251-1-git-send-email-ruslan.bilovol@ti.com>
 <1359558091-29251-2-git-send-email-ruslan.bilovol@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359558091-29251-2-git-send-email-ruslan.bilovol@ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12283567985525828421
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrledtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehledrledtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:01 Wed 30 Jan     , Ruslan Bilovol wrote:
> Currently, reading /proc/cpuinfo provides userspace with CPU ID of
> the CPU carrying out the read from the file.
> Userspace using this information may decide what module
> to load or how to configure some specific (and processor-depended)
> settings or so.
> However, since really different SoCs can share same ARM core,
> this information currently is not so useful.
> For example, TI OMAP4460 and OMAP4470 SoCs show the same
> information in the /proc/cpuinfo whereas they are different.
> Since in most cases ARM CPU is a part of some system on a chip (SoC),
> the "cpuinfo" file looks like exactly that place, where this
> information have to be displayed.
> 
> So added new line "SoC name" in the "cpuinfo" output for system
> on a chip name. It is placed between CPU information and machine
> information, so the file structure looks gracefully (CPU-SoC-Hardware)
Nack

this break the kernel ABI

and we have now socinfo via sysfs

Best Regards,
J.
> 
> Example:
> 
> / # cat proc/cpuinfo
> [...]
> CPU variant     : 0x2
> CPU part        : 0xc09
> CPU revision    : 10
> 
> SoC name        : OMAP4470
> 
> Hardware        : OMAP4 Blaze Tablet
> Revision        : 20edb4
> [...]
> 
> Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
> ---
>  arch/arm/include/asm/setup.h |    1 +
>  arch/arm/kernel/setup.c      |    9 +++++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
> index c50f056..621df40 100644
> --- a/arch/arm/include/asm/setup.h
> +++ b/arch/arm/include/asm/setup.h
> @@ -52,5 +52,6 @@ extern struct meminfo meminfo;
>  extern int arm_add_memory(phys_addr_t start, phys_addr_t size);
>  extern void early_print(const char *str, ...);
>  extern void dump_machine_table(void);
> +extern void set_soc_model_name(char *name);
>  
>  #endif
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 3f6cbb2..bb3805f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -134,6 +134,7 @@ char elf_platform[ELF_PLATFORM_SIZE];
>  EXPORT_SYMBOL(elf_platform);
>  
>  static const char *cpu_name;
> +static const char *soc_name;
>  static const char *machine_name;
>  static char __initdata cmd_line[COMMAND_LINE_SIZE];
>  struct machine_desc *machine_desc __initdata;
> @@ -493,6 +494,11 @@ static void __init setup_processor(void)
>  	cpu_init();
>  }
>  
> +void set_soc_model_name(char *name)
> +{
> +	soc_name = name;
> +}
> +
>  void __init dump_machine_table(void)
>  {
>  	struct machine_desc *p;
> @@ -902,6 +908,9 @@ static int c_show(struct seq_file *m, void *v)
>  		seq_printf(m, "CPU revision\t: %d\n\n", cpuid & 15);
>  	}
>  
> +	if (soc_name)
> +		seq_printf(m, "SoC name\t: %s\n\n", soc_name);
> +
>  	seq_printf(m, "Hardware\t: %s\n", machine_name);
>  	seq_printf(m, "Revision\t: %04x\n", system_rev);
>  	seq_printf(m, "Serial\t\t: %08x%08x\n",
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
