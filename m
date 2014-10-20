Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaJTNxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:53:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52416 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaJTNxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:53:15 -0400
Date: Mon, 20 Oct 2014 15:52:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 3/8] x86, microcode, intel: clarify log messages
Message-ID: <20141020135250.GD3524@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-4-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410197875-19252-4-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:37:49PM -0300, Henrique de Moraes Holschuh wrote:
> The Intel microcode update driver will skip the second hardware thread
> on hyper-threaded cores during an update run, as the first hardware
> thread will have updated the entire core.  This can confuse users,
> because it will look like some CPUs were not updated in the system log.
> Attempt to clarify the log messages to hint that we might be updating
> more than one CPU (hardware thread) at a time.
> 
> Make sure all driver log messages conform to this template: "microcode:
> CPU#: <message>".  The <message> might refer to the core, and not to the
> hardware thread/CPU.
> 
> Reword error and debug messages for clarity or style.  Tag most error
> messages as "error:", and warnings as "warning:".  Report conditions
> which will stop a microcode update as errors, and conditions which will
> not stop a microcode update as warnings.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/kernel/cpu/microcode/intel.c       |   10 +++++-----
>  arch/x86/kernel/cpu/microcode/intel_early.c |   11 +++++++----
>  arch/x86/kernel/cpu/microcode/intel_lib.c   |   12 ++++++------
>  3 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> index 2c629d1..e99cdd8 100644
> --- a/arch/x86/kernel/cpu/microcode/intel.c
> +++ b/arch/x86/kernel/cpu/microcode/intel.c
> @@ -115,7 +115,7 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
>  {
>  	__collect_cpu_info(cpu_num, csig);
>  
> -	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
> +	pr_info("CPU%d: sig=0x%x, pf=0x%x, revision=0x%x\n",
>  		cpu_num, csig->sig, csig->pf, csig->rev);
>  
>  	return 0;
> @@ -178,11 +178,11 @@ static int apply_microcode_intel(int cpu)
>  	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
>  
>  	if (val[1] != mc_intel->hdr.rev) {
> -		pr_err("CPU%d update to revision 0x%x failed\n",
> +		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n",
>  		       cpu_num, mc_intel->hdr.rev);
>  		return -1;
>  	}
> -	pr_info("CPU%d updated to revision 0x%x, date = %04x-%02x-%02x\n",
> +	pr_info("CPU%d: entire core updated to revision 0x%x, date %04x-%02x-%02x\n",

Those two above are not really needed IMO.

>  		cpu_num, val[1],
>  		mc_intel->hdr.date & 0xffff,
>  		mc_intel->hdr.date >> 24,
> @@ -214,7 +214,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
>  
>  		mc_size = get_totalsize(&mc_header);
>  		if (!mc_size || mc_size > leftover) {
> -			pr_err("error! Bad data in microcode data file\n");
> +			pr_err("error: invalid microcode update data\n");

What's wrong with the original message?

>  			break;
>  		}
>  
> @@ -268,7 +268,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
>  	 */
>  	save_mc_for_early(new_mc);
>  
> -	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
> +	pr_debug("CPU%d: found a matching microcode update with version 0x%x (current=0x%x)\n",
>  		 cpu, new_rev, uci->cpu_sig.rev);
>  out:
>  	return state;
> diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> index b88343f..f73fc0a 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> @@ -16,6 +16,9 @@
>   *	as published by the Free Software Foundation; either version
>   *	2 of the License, or (at your option) any later version.
>   */
> +
> +#define pr_fmt(fmt) "microcode: " fmt
> +
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/slab.h>
> @@ -418,7 +421,7 @@ static void __ref show_saved_mc(void)
>  		pr_debug("no microcode data saved.\n");
>  		return;
>  	}
> -	pr_debug("Total microcode saved: %d\n", mc_saved_data.mc_saved_count);
> +	pr_debug("total microcode entries saved: %d\n", mc_saved_data.mc_saved_count);

That should be "Total microcode patches saved" - "entries" doesn't say a whole
lot.

>  
>  	collect_cpu_info_early(&uci);
>  
> @@ -519,7 +522,7 @@ int save_mc_for_early(u8 *mc)
>  	 */
>  	ret = save_microcode(&mc_saved_data, mc_saved_tmp, mc_saved_count);
>  	if (ret) {
> -		pr_err("Cannot save microcode patch.\n");
> +		pr_warn("warning: could not store microcode update data for later use.\n");

Capitalize: "Warning: could... "

otherwise that message clarification makes sense.

>  		goto out;
>  	}
>  
> @@ -579,7 +582,7 @@ print_ucode_info(struct ucode_cpu_info *uci, unsigned int date)
>  {
>  	int cpu = smp_processor_id();
>  
> -	pr_info("CPU%d microcode updated early to revision 0x%x, date = %04x-%02x-%02x\n",
> +	pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",

No, please no "entire core" mentions - that'll only confuse people.
Simply think of logical cores as separate cores which share the
microcode hw. No need for more confusion.

>  		cpu,
>  		uci->cpu_sig.rev,
>  		date & 0xffff,
> @@ -701,7 +704,7 @@ int __init save_microcode_in_initrd_intel(void)
>  	microcode_pointer(mc_saved, mc_saved_in_initrd, initrd_start, count);
>  	ret = save_microcode(&mc_saved_data, mc_saved, count);
>  	if (ret)
> -		pr_err("Cannot save microcode patches from initrd.\n");
> +		pr_warn("warning: failed to save early microcode update data for future use\n");

This one actually loses info - the "initrd" part.

>  
>  	show_saved_mc();
>  
> diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
> index 25915e3..1cc6494 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_lib.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
> @@ -64,7 +64,7 @@ int microcode_sanity_check(void *mc, int print_err)
>  
>  	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
>  		if (print_err)
> -			pr_err("error! Unknown microcode update format\n");
> +			pr_err("error: unknown microcode update format\n");

Actually it should be like a real sentence:

	"Error: unknown ... format.\n"

>  		return -EINVAL;
>  	}
>  	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
> @@ -72,13 +72,13 @@ int microcode_sanity_check(void *mc, int print_err)
>  		if ((ext_table_size < EXT_HEADER_SIZE)
>  		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
>  			if (print_err)
> -				pr_err("error! Small exttable size in microcode data file\n");
> +				pr_err("error: small exttable size in microcode data file\n");

That doesn't tell me a whole lot - maybe "... truncated exttable in microcode data file" ?

>  			return -EINVAL;
>  		}
>  		ext_header = mc + MC_HEADER_SIZE + data_size;
>  		if (ext_table_size != exttable_size(ext_header)) {
>  			if (print_err)
> -				pr_err("error! Bad exttable size in microcode data file\n");
> +				pr_err("error: bad exttable size in microcode data file\n");

Ditto.

>  			return -EFAULT;
>  		}
>  		ext_sigcount = ext_header->count;
> @@ -114,7 +114,7 @@ int microcode_sanity_check(void *mc, int print_err)
>  			ext_table_sum += ext_tablep[i];
>  		if (ext_table_sum) {
>  			if (print_err)
> -				pr_warn("aborting, bad extended signature table checksum\n");
> +				pr_err("error: bad extended signature table checksum\n");

Capitalize.

>  			return -EINVAL;
>  		}
>  	}
> @@ -126,7 +126,7 @@ int microcode_sanity_check(void *mc, int print_err)
>  		orig_sum += ((int *)mc)[i];
>  	if (orig_sum) {
>  		if (print_err)
> -			pr_err("aborting, bad checksum\n");
> +			pr_err("error: bad microcode update checksum\n");

Ditto.

>  		return -EINVAL;
>  	}
>  	if (!ext_table_size)
> @@ -140,7 +140,7 @@ int microcode_sanity_check(void *mc, int print_err)
>  			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
>  		if (sum) {
>  			if (print_err)
> -				pr_err("aborting, bad checksum\n");
> +				pr_err("error: bad extended signature checksum\n");

"Aborting ..." was better.

>  			return -EINVAL;
>  		}
>  	}
> -- 
> 1.7.10.4
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
