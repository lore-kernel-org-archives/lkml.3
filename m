Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaFPPbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:31:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbaFPPbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:31:15 -0400
Date: Mon, 16 Jun 2014 11:30:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: matt@console-pimps.org, peterz@infradead.org, acme@kernel.org,
        mingo@redhat.com, paulus@samba.org, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf/x86/intel: ignore CondChgd bit to avoid false
 NMI handling
Message-ID: <20140616153047.GJ177152@redhat.com>
References: <20140613084437.12424.62294.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140613084437.12424.62294.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 05:44:37PM +0900, HATAYAMA Daisuke wrote:
> Currently, a NMI handler for NMI watchdog may falsely handle any NMI
> signaled for different purpose if CondChgd bit in
> MSR_CORE_PERF_GLOBAL_STATUS MSR is set.
> 
> This commit deals with the issue simply by ignoring CondChgd bit.
> 
> Here is explanation in detail.
> 
> On x86 NMI watchdog uses performance monitoring feature to
> periodically signal NMI each time performance counter gets overflowed.
> 
> intel_pmu_handle_irq() is called as a NMI_LOCAL handler from a NMI
> handler of NMI watchdog, perf_event_nmi_handler(). It identifies an
> owner of a given NMI by looking at overflow status bits in
> MSR_CORE_PERF_GLOBAL_STATUS MSR. If some of the bits are set, then it
> handles the given NMI as its own NMI.
> 
> The problem is that the intel_pmu_handle_irq() doesn't distinguish
> CondChgd bit from other bits. Unlike the other status bits, CondChgd
> bit doesn't represent overflow status for performance counters. Thus,
> CondChgd bit cannot be thought of as a mark indicating a given NMI is
> NMI watchdog's. As a result, if CondChgd bit is set, any NMI is
> falsely handled by the NMI handler of NMI watchdog. Also, if type of
> the falsely handled NMI is either NMI_UNKNOWN, NMI_SERR or
> NMI_IO_CHECK, the corresponding action is never performed until
> CondChgd bit is cleared.
> 
> I noticed this behavior on systems with Ivy Bridge processors: Intel
> Xeon CPU E5-2630 v2 and Intel Xeon CPU E7-8890 v2. On both systems,
> CondChgd bit in MSR_CORE_PERF_GLOBAL_STATUS MSR has already been set
> in the beginning at boot. Then the CondChgd bit is immediately cleared
> by next wrmsr to MSR_CORE_PERF_GLOBAL_CTRL MSR and appears to remain
> 0.
> 
> On the other hand, on older processors such as Nehalem, Xeon E7540,
> CondChgd bit is not set in the beginning at boot.
> 
> I'm not sure about exact behavior of CondChgd bit, in particular when
> this bit is set. Although I read Intel System Programmer's Manual to
> figure out that, the descriptions I found are:
> 
>   In 18.9.1:
> 
>   "The MSR_PERF_GLOBAL_STATUS MSR also provides a ‘sticky bit’ to
>    indicate changes to the state of performancmonitoring hardware"
> 
>   In Table 35-2 IA-32 Architectural MSRs
> 
>   63 CondChg: status bits of this register has changed.
> 
> These are different from the bahviour I see on the actual system as I
> explained above.
> 
> At least, I think ignoring CondChgd bit should be enough for NMI
> watchdog perspective.

As I said in a previous email, I ran into a similar problem and was going
to solve it by zeroing out all the registers on init (which probably would
have upset Peter :-) ).  This is a smaller solution and seems ok.  The
only downside is it is called in the nmi handler.


I am working with our customer to try and talk with Intel why this bit is
set to begin with.  Our customer says their BIOS doesn't use the PMU
during boot so it wasn't clear why this is now set on IVBs (though I don't
see them on Intel whitebox IVBs).

I am for this patch as it solves our problem too.  But it makes me wonder
if this is just yet another workaround for something broken deeper.

Acked-by: Don Zickus <dzickus@redhat.com>


> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index adb02aa..07846d7 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1382,6 +1382,15 @@ again:
>  	intel_pmu_lbr_read();
>  
>  	/*
> +	 * CondChgd bit 63 doesn't mean any overflow status. Ignore
> +	 * and clear the bit.
> +	 */
> +	if (__test_and_clear_bit(63, (unsigned long *)&status)) {
> +		if (!status)
> +			goto done;
> +	}
> +
> +	/*
>  	 * PEBS overflow sets bit 62 in the global status register
>  	 */
>  	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
