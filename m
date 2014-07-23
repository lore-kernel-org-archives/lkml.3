Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbaGWSHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:07:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34867 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbaGWSHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:07:22 -0400
Date: Wed, 23 Jul 2014 20:07:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 12/70] x86, pci, amd_bus: _FROZEN Cleanup
Message-ID: <20140723180718.GH21707@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-13-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406080786-3938-13-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:58:48PM -0400, Chen, Gong wrote:
> Remove XXX_FROZEN state from x86/pci/amd_bus.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---
>  arch/x86/pci/amd_bus.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index c20d2cc..30f0fca9 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -341,9 +341,8 @@ static int amd_cpu_notify(struct notifier_block *self, unsigned long action,
>  			  void *hcpu)
>  {
>  	int cpu = (long)hcpu;
> -	switch (action) {
> +	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_ONLINE:
> -	case CPU_ONLINE_FROZEN:
>  		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
>  		break;
>  	default:

Or you can kill all the switch-case gunk and make it even more readable:

Index: b/arch/x86/pci/amd_bus.c
===================================================================
--- a/arch/x86/pci/amd_bus.c	2014-07-23 20:04:44.074436425 +0200
+++ b/arch/x86/pci/amd_bus.c	2014-07-23 20:05:14.282436087 +0200
@@ -340,15 +340,9 @@ static void enable_pci_io_ecs(void *unus
 static int amd_cpu_notify(struct notifier_block *self, unsigned long action,
 			  void *hcpu)
 {
-	int cpu = (long)hcpu;
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
-		break;
-	default:
-		break;
-	}
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_ONLINE)
+		smp_call_function_single((long)hcpu, enable_pci_io_ecs, NULL, 0);
+
 	return NOTIFY_OK;
 }

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
