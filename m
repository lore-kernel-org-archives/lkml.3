Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaF0FF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:05:29 -0400
Received: from 174.37.253.146-static.reverse.softlayer.com ([174.37.253.146]:34053
	"EHLO primary.scalemp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaF0FF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:05:28 -0400
Message-ID: <53ACFB90.7030608@scalemp.com>
Date: Fri, 27 Jun 2014 08:05:20 +0300
From: Oren Twaig <oren@scalemp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Andi Kleen <ak@linux.intel.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Richard Weinberger <richard@nod.at>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH] x86, vsmp: Remove is_vsmp_box() from apic_is_clustered_box()
References: <53A7BC92.3080307@scalemp.com>
In-Reply-To: <53A7BC92.3080307@scalemp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - primary.scalemp.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
X-Get-Message-Sender-Via: primary.scalemp.com: authenticated_id: oren+scalemp.com/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping
On 06/23/2014 08:35 AM, Oren Twaig wrote:
> Remove invalid code which caused TSC to be declared as "unstable" on vSMP
> Foundation box even if it was stable and let the kernel decide for itself.
>
> When a vSMP Foundation box is detected, the function apic_cluster_num() counts
> the number of APIC clusters found. If more than one found, a multi board
> configuration is assumed, and TSC marked as unstable. This behavior is
> incorrect as vSMP Foundation may use processors from single node only, attached
> to memory of other nodes - and such node may have more than one APIC cluster
> (typically any recent intel box has more than single APIC_CLUSTERID(x)).
>
> To fix this, we simply remove the code which detects a vSMP Foundation box and
> affects apic_is_clusted_box() return value. This can be done because later the
> kernel checks by itself if the TSC is stable using the
> check_tsc_sync_[source|target]() functions and marks TSC as unstable if needed.
>
> Signed-off-by: Oren Twaig <oren@scalemp.com>
> Acked-by: Shai Fultheim <shai@scalemp.com>
> ---
>  arch/x86/include/asm/apic.h |    8 ------
>  arch/x86/kernel/apic/apic.c |   60 +------------------------------------------
>  2 files changed, 1 insertion(+), 67 deletions(-)
>
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 19b0eba..c100694 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -85,14 +85,6 @@ static inline bool apic_from_smp_config(void)
>  #include <asm/paravirt.h>
>  #endif
> 
> -#ifdef CONFIG_X86_64
> -extern int is_vsmp_box(void);
> -#else
> -static inline int is_vsmp_box(void)
> -{
> -    return 0;
> -}
> -#endif
>  extern int setup_profiling_timer(unsigned int);
> 
>  static inline void native_apic_mem_write(u32 reg, u32 v)
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index ad28db7..2b85bb9 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2451,51 +2451,6 @@ static void apic_pm_activate(void) { }
> 
>  #ifdef CONFIG_X86_64
> 
> -static int apic_cluster_num(void)
> -{
> -    int i, clusters, zeros;
> -    unsigned id;
> -    u16 *bios_cpu_apicid;
> -    DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
> -
> -    bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
> -    bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
> -
> -    for (i = 0; i < nr_cpu_ids; i++) {
> -        /* are we being called early in kernel startup? */
> -        if (bios_cpu_apicid) {
> -            id = bios_cpu_apicid[i];
> -        } else if (i < nr_cpu_ids) {
> -            if (cpu_present(i))
> -                id = per_cpu(x86_bios_cpu_apicid, i);
> -            else
> -                continue;
> -        } else
> -            break;
> -
> -        if (id != BAD_APICID)
> -            __set_bit(APIC_CLUSTERID(id), clustermap);
> -    }
> -
> -    /* Problem:  Partially populated chassis may not have CPUs in some of
> -     * the APIC clusters they have been allocated.  Only present CPUs have
> -     * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
> -     * Since clusters are allocated sequentially, count zeros only if
> -     * they are bounded by ones.
> -     */
> -    clusters = 0;
> -    zeros = 0;
> -    for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
> -        if (test_bit(i, clustermap)) {
> -            clusters += 1 + zeros;
> -            zeros = 0;
> -        } else
> -            ++zeros;
> -    }
> -
> -    return clusters;
> -}
> -
>  static int multi_checked;
>  static int multi;
> 
> @@ -2540,20 +2495,7 @@ static void dmi_check_multi(void)
>  int apic_is_clustered_box(void)
>  {
>      dmi_check_multi();
> -    if (multi)
> -        return 1;
> -
> -    if (!is_vsmp_box())
> -        return 0;
> -
> -    /*
> -     * ScaleMP vSMPowered boxes have one cluster per board and TSCs are
> -     * not guaranteed to be synced between boards
> -     */
> -    if (apic_cluster_num() > 1)
> -        return 1;
> -
> -    return 0;
> +    return multi;
>  }
>  #endif
> 
>
>


