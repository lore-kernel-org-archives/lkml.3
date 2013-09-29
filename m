Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3I2EZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 00:25:27 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48726 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3I2EZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 00:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <tip-646e29a1789a3a936871008c15199c50367bf291@git.kernel.org>
References: <20130927143554.GF4422@pd.tnic>
	<tip-646e29a1789a3a936871008c15199c50367bf291@git.kernel.org>
Date: Sat, 28 Sep 2013 21:25:24 -0700
X-Google-Sender-Auth: YSg6JccaqKgxaTDrRn6Pek1J4wI
Message-ID: <CAE9FiQUzi42A1hefvVj_NbShk8A62WNPf53U3A=OydgKbyRjsA@mail.gmail.com>
Subject: Re: [tip:x86/boot] x86: Improve the printout of the SMP bootup CPU table
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        huawei.libin@huawei.com, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 1:28 AM, tip-bot for Borislav Petkov
<tipbot@zytor.com> wrote:
> Commit-ID:  646e29a1789a3a936871008c15199c50367bf291
> Gitweb:     http://git.kernel.org/tip/646e29a1789a3a936871008c15199c50367bf291
> Author:     Borislav Petkov <bp@suse.de>
> AuthorDate: Fri, 27 Sep 2013 16:35:54 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 28 Sep 2013 10:10:26 +0200
>
> x86: Improve the printout of the SMP bootup CPU table
>
> As the new x86 CPU bootup printout format code maintainer, I am
> taking immediate action to improve and clean (and thus indulge
> my OCD) the reporting of the cores when coming up online.
>
> Fix padding to a right-hand alignment, cleanup code and bind
> reporting width to the max number of supported CPUs on the
> system, like this:
>
>  [    0.074509] smpboot: Booting Node   0, Processors:      #1  #2  #3  #4  #5  #6  #7 OK
>  [    0.644008] smpboot: Booting Node   1, Processors:  #8  #9 #10 #11 #12 #13 #14 #15 OK
>  [    1.245006] smpboot: Booting Node   2, Processors: #16 #17 #18 #19 #20 #21 #22 #23 OK
>  [    1.864005] smpboot: Booting Node   3, Processors: #24 #25 #26 #27 #28 #29 #30 #31 OK
>  [    2.489005] smpboot: Booting Node   4, Processors: #32 #33 #34 #35 #36 #37 #38 #39 OK
>  [    3.093005] smpboot: Booting Node   5, Processors: #40 #41 #42 #43 #44 #45 #46 #47 OK
>  [    3.698005] smpboot: Booting Node   6, Processors: #48 #49 #50 #51 #52 #53 #54 #55 OK
>  [    4.304005] smpboot: Booting Node   7, Processors: #56 #57 #58 #59 #60 #61 #62 #63 OK
>  [    4.961413] Brought up 64 CPUs
>
> and this:
>
>  [    0.072367] smpboot: Booting Node   0, Processors:    #1 #2 #3 #4 #5 #6 #7 OK
>  [    0.686329] Brought up 8 CPUs
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: Libin <huawei.libin@huawei.com>
> Cc: wangyijing@huawei.com
> Cc: fenghua.yu@intel.com
> Cc: guohanjun@huawei.com
> Cc: paul.gortmaker@windriver.com
> Link: http://lkml.kernel.org/r/20130927143554.GF4422@pd.tnic
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/include/asm/misc.h |  6 ++++++
>  arch/x86/kernel/smpboot.c   | 21 +++++++++++++++------
>  arch/x86/lib/Makefile       |  2 +-
>  arch/x86/lib/misc.c         | 11 +++++++++++
>  4 files changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/misc.h b/arch/x86/include/asm/misc.h
> new file mode 100644
> index 0000000..475f5bb
> --- /dev/null
> +++ b/arch/x86/include/asm/misc.h
> @@ -0,0 +1,6 @@
> +#ifndef _ASM_X86_MISC_H
> +#define _ASM_X86_MISC_H
> +
> +int num_digits(int val);
> +
> +#endif /* _ASM_X86_MISC_H */
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 6cacab6..d41f3ba 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -73,11 +73,10 @@
>  #include <asm/setup.h>
>  #include <asm/uv/uv.h>
>  #include <linux/mc146818rtc.h>
> -
>  #include <asm/smpboot_hooks.h>
>  #include <asm/i8259.h>
> -
>  #include <asm/realmode.h>
> +#include <asm/misc.h>
>
>  /* State of each CPU */
>  DEFINE_PER_CPU(int, cpu_state) = { 0 };
> @@ -653,17 +652,27 @@ static void announce_cpu(int cpu, int apicid)
>  {
>         static int current_node = -1;
>         int node = early_cpu_to_node(cpu);
> -       int max_cpu_present = find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
> +       static int width;
> +
> +       if (!width)
> +               width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
>
>         if (system_state == SYSTEM_BOOTING) {
>                 if (node != current_node) {
>                         if (current_node > (-1))
>                                 pr_cont(" OK\n");
>                         current_node = node;
> -                       pr_info("Booting Node %3d, Processors ", node);
> +                       pr_info("Booting Node %3d, Processors:", node);
>                 }
> -               pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
> -               return;
> +
> +               /* Add padding for the BSP */
> +               if (cpu == 1)
> +                       pr_cont("%*s", width + 1, " ");

what's point to add the pad?

How do you know BIOS MADT or kernel MADT parsing code would have cpu1
the same node cpu0?

Yinghai
