Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3JXC5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 22:57:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63695 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3JXC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 22:57:07 -0400
X-Spam-Score: -100.8
Message-ID: <52688C42.3030907@asianux.com>
Date: Thu, 24 Oct 2013 10:56:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
References: <5267AE7D.4080600@asianux.com> <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 09:47 PM, Vineet Gupta wrote:
> Apologies for top posting !
> 

Not at all.

> NAK.
> 

OK, thanks. At least this patch is incorrect.


> ARC will never have VGA console. You need to add !ARC to relevant Kconfig. However that approach is frowned upon in general. The current way to doing such things is to define a new Kconfig item which relevant arches can select.

Hmm... it seems necessary to discuss about the 2 fixing ways (which
already had a long discussion in ARM64):

 - add !ARC in related place, just like another (almost 30-40%) architectures done.

 - add a new Kconfig item (e.g. HAVE_VGA_CONSOLE), and let the left (almost 50%) architectures which use VGA_CONSOLE to set it.

Catalin, Will, Geert (it seems also include you) prefer 2nd way, but I
prefer 1st, my reasons are below, please help check:

 - 1st way need add some (10-20%) of architectures in one place, which belongs to local wide.
   2nd way will let the left (almost 50%) architectures need add HAVE_VGA_CONSOLE in various place, which belongs to arch global wide.

 - 1st way will let most (80-90%) of architectures don't care about VGA_CONSOLE (50% need it, 30-40% already mark it in the same place).
   2nd way will let 50% architectures care about VGA_CONSOLE (although can let the left 10-20% architectures do nothing -- not care about it).

 - 1st way is still easy, sustainable, and clear enough in local wide fixing (although maybe it is not the best, or clearest way).
   2nd way is also easy, sustainable and clear enough (maybe the best, or clearest for 10-20% architectures), but it will let the fix in global wide

All together, if we can bear and sustainable, I always prefer to fix it
in local wide, not lead to arch global (especially 80-90% architectures
already followed 1st way).


BTW: for me, if less than 20% architectures need XXX, we can trigger
defining a new Kconfig item (e.g. HAVE_XXX), or just follow original
implementation.


Thanks.

> 
> -Vineet
> ________________________________________
> From: Chen Gang [gang.chen@asianux.com]
> Sent: Wednesday, October 23, 2013 4:39 PM
> To: vgupta@synopsys.com; Arnd Bergmann; sachin.kamat@linaro.org; Paul Gortmaker; James Hogan
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] arc: kernel: add default extern variable 'screen_info' in "setup.c"
> 
> Add default 'screen_info' just like some of other architectures (e.g.
> cris, score, sh, tile), or can not pass compiling.
> 
> The related error (with allmodconfig):
> 
>   drivers/built-in.o: In function `vgacon_save_screen':
>   drivers/video/console/vgacon.c:1347: undefined reference to `screen_info'
>   drivers/video/console/vgacon.c:1348: undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_resize':
>   drivers/video/console/vgacon.c:1314: undefined reference to `screen_info'
>   drivers/video/console/vgacon.c:1315: undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_switch':
>   drivers/video/console/vgacon.c:820: undefined reference to `screen_info'
>   drivers/built-in.o:drivers/video/console/vgacon.c:840: more undefined references to `screen_info' follow
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arc/kernel/setup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
> index 2c68bc7e..07130f3 100644
> --- a/arch/arc/kernel/setup.c
> +++ b/arch/arc/kernel/setup.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/of_fdt.h>
>  #include <linux/cache.h>
> +#include <linux/screen_info.h>
>  #include <asm/sections.h>
>  #include <asm/arcregs.h>
>  #include <asm/tlb.h>
> @@ -37,6 +38,8 @@ struct task_struct *_current_task[NR_CPUS];   /* For stack switching */
> 
>  struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];
> 
> +struct screen_info screen_info;
> +
> 
>  void read_arc_build_cfg_regs(void)
>  {
> --
> 1.7.7.6
> 
> 


-- 
Chen Gang
