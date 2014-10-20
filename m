Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaJTPI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:08:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33365 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbaJTPIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:08:25 -0400
Date: Mon, 20 Oct 2014 17:08:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: add error logging to early
 update driver
Message-ID: <20141020150801.GE3524@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:37:50PM -0300, Henrique de Moraes Holschuh wrote:
> Enhance the logging in the Intel early microcode update driver to
> be able to report errors.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> ---
>  arch/x86/kernel/cpu/microcode/intel_early.c |   94 +++++++++++++++------------
>  1 file changed, 54 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> index f73fc0a..8ad50d6 100644
> --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> @@ -31,6 +31,12 @@
>  #include <asm/tlbflush.h>
>  #include <asm/setup.h>
>  
> +enum {
> +	INTEL_EARLYMCU_NONE = 0, /* did nothing */
> +	INTEL_EARLYMCU_UPDATEOK, /* microcode updated */
> +	INTEL_EARLYMCU_REJECTED, /* cpu rejected it */
> +};
> +
>  static unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
>  static struct mc_saved_data {
>  	unsigned int mc_saved_count;
> @@ -576,37 +582,50 @@ scan_microcode(unsigned long start, unsigned long end,
>  
>  /*
>   * Print ucode update info.
> + * for status == INTEL_EARLYMCU_UPDATEOK, data should be the mcu date
> + * for status == INTEL_EARLYMCU_REJECTED, data should be mcu revision
>   */
> -static void
> -print_ucode_info(struct ucode_cpu_info *uci, unsigned int date)
> +static void print_ucode_info(const unsigned int status,
> +			      const struct ucode_cpu_info *uci,
> +			      const unsigned int data)
>  {
>  	int cpu = smp_processor_id();
> -
> -	pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
> -		cpu,
> -		uci->cpu_sig.rev,
> -		date & 0xffff,
> -		date >> 24,
> -		(date >> 16) & 0xff);
> +	struct ucode_cpu_info ucil;
> +
> +	switch (status) {
> +	case INTEL_EARLYMCU_NONE:
> +		break;
> +	case INTEL_EARLYMCU_UPDATEOK:
> +		if (!uci) {
> +			collect_cpu_info_early(&ucil);
> +			uci = &ucil;
> +		}
> +		pr_info("CPU%d: entire core updated early to revision 0x%x, date %04x-%02x-%02x\n",
> +			cpu,
> +			uci->cpu_sig.rev,
> +			data & 0xffff,
> +			data >> 24,
> +			(data >> 16) & 0xff);
> +		break;
> +	case INTEL_EARLYMCU_REJECTED:
> +		pr_err("CPU%d: update to revision 0x%x rejected by the processor\n", cpu, data);
> +		break;
> +	}
>  }
>  
>  #ifdef CONFIG_X86_32
>  
> -static int delay_ucode_info;
> -static int current_mc_date;
> +static unsigned int delay_ucode_info;
> +static unsigned int delay_ucode_info_data;

First of all, this really is date and not data and prefixing it with
"delay" really doesn't make it cleaner.

Then, this whole scheme can be simplified a bit by dropping
delay_ucode_info and using current_mc_date to test whether to print the
message or not. After printing, you set it back to 0.

And then you can drop the _REJECTED case as it is not needed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
