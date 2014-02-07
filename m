Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaBGLHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:07:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:21539 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaBGLHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:07:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,799,1384329600"; 
   d="scan'208";a="479554553"
From: Jani Nikula <jani.nikula@intel.com>
To: Jiri Kosina <jkosina@suse.cz>, Dave Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm next tree
In-Reply-To: <alpine.LNX.2.00.1402071052470.24838@pobox.suse.cz>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie> <alpine.LRH.2.00.1401301648050.15677@twin.jikos.cz> <alpine.LNX.2.00.1402071052470.24838@pobox.suse.cz>
User-Agent: Notmuch/0.17+61~gab0de040c7c1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Feb 2014 13:10:25 +0200
Message-ID: <87a9e318m6.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Feb 2014, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 30 Jan 2014, Jiri Kosina wrote:
>
>> >   git://people.freedesktop.org/~airlied/linux drm-next
>> [ ... snip ... ]
>> > Daniel Vetter (59):
>> [ ... snip ... ]
>> >       drm/i915: dp aux irq support for g4x/vlv
>> 
>> This commit causes all kinds of havoc on my ThinkPad x200s. It results in
> [ ... snip ... ]
>
> Not having received any response, I suggest the following for 3.14

Daniel, it's your commit this bisects to...

If we end up having to revert, I'd just touch the has_aux_irq part, for
example:

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 5ede4e8..464c047 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -404,7 +404,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
 	int i, ret, recv_bytes;
 	uint32_t status;
 	int try, precharge, clock = 0;
-	bool has_aux_irq = true;
+	bool has_aux_irq = INTEL_INFO(dev)->gen >= 5;
 	uint32_t timeout;

 	/* dp aux is extremely sensitive to irq latency, hence request the

or even INTEL_INFO(dev)->gen != 4.

But up to Daniel.


BR,
Jani.




>
>
>
>
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] Revert "drm/i915: dp aux irq support for g4x/vlv"
>
> This reverts commit 4aeebd7443e36b0a40032e518a9338f48bd27efc.
>
> Conflicts:
>
> 	drivers/gpu/drm/i915/i915_reg.h
>
> This commit causes all kinds of havoc on my ThinkPad x200s. It results in
>
>  irq 16: nobody cared (try booting with the "irqpoll" option)
>  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-00854-g4aeebd7 #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   ffff8800795186c0 ffff88007c203e08 ffffffff81582503 ffff88007c203e38
>   ffffffff810a6a98 ffff88007c203e88 ffff880079518600 0000000000000000
>   0000000000000010 ffff88007c203e78 ffffffff810a6d43 00000010ffc4af9d
>  Call Trace:
>   <IRQ>  [<ffffffff81582503>] dump_stack+0x7a/0x97
>   [<ffffffff810a6a98>] __report_bad_irq+0x38/0xf0
>   [<ffffffff810a6d43>] note_interrupt+0x1f3/0x240
>   [<ffffffff810a42d2>] handle_irq_event_percpu+0x142/0x220
>   [<ffffffff810a43f9>] handle_irq_event+0x49/0x70
>   [<ffffffff810a7561>] handle_fasteoi_irq+0x61/0x100
>   [<ffffffff81004a89>] handle_irq+0x59/0x150
>   [<ffffffff81052b6e>] ? _local_bh_enable+0xe/0x10
>   [<ffffffff81052bf1>] ? irq_enter+0x81/0x90
>   [<ffffffff8100403b>] do_IRQ+0x5b/0xe0
>   [<ffffffff81588aaf>] common_interrupt+0x6f/0x6f
>   <EOI>  [<ffffffff81588b5c>] ? retint_restore_args+0xe/0xe
>   [<ffffffff8146c767>] ? poll_idle+0x47/0x90
>   [<ffffffff8146c740>] ? poll_idle+0x20/0x90
>   [<ffffffff810acd96>] ? ktime_get+0x56/0xd0
>   [<ffffffff8146c7f0>] cpuidle_enter_state+0x40/0xd0
>   [<ffffffff8146cc0a>] cpuidle_idle_call+0x10a/0x160
>   [<ffffffff8100b7b9>] arch_cpu_idle+0x9/0x30
>   [<ffffffff810a370b>] cpu_idle_loop+0x8b/0x270
>   [<ffffffff810a390e>] cpu_startup_entry+0x1e/0x20
>   [<ffffffff8157a0c3>] rest_init+0xd3/0xe0
>   [<ffffffff81579ff0>] ? csum_partial_copy_generic+0x170/0x170
>   [<ffffffff81ad905c>] start_kernel+0x3b3/0x461
>   [<ffffffff81ad8a96>] ? repair_env_string+0x58/0x58
>   [<ffffffff81ad84d1>] x86_64_start_reservations+0x1b/0x32
>   [<ffffffff81ad8622>] x86_64_start_kernel+0x13a/0x141
>  handlers:
>  [<ffffffffa00acbc0>] usb_hcd_irq [usbcore]
>  Disabling IRQ #16
>
> and things go south afterwards (the machine hangs randomly, I/O is 
> horribly slow, etc).
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>
> ---
>  drivers/gpu/drm/i915/i915_irq.c |    7 -------
>  drivers/gpu/drm/i915/i915_reg.h |    5 -----
>  drivers/gpu/drm/i915/intel_dp.c |    2 +-
>  3 files changed, 1 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 17d8fcb..b7fae5b 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -1480,9 +1480,6 @@ static irqreturn_t valleyview_irq_handler(int irq, void *arg)
>  
>  			intel_hpd_irq_handler(dev, hotplug_trigger, hpd_status_i915);
>  
> -			if (hotplug_status & DP_AUX_CHANNEL_MASK_INT_STATUS_G4X)
> -				dp_aux_irq_handler(dev);
> -
>  			I915_WRITE(PORT_HOTPLUG_STAT, hotplug_status);
>  			I915_READ(PORT_HOTPLUG_STAT);
>  		}
> @@ -3670,10 +3667,6 @@ static irqreturn_t i965_irq_handler(int irq, void *arg)
>  			intel_hpd_irq_handler(dev, hotplug_trigger,
>  					      IS_G4X(dev) ? hpd_status_g4x : hpd_status_i915);
>  
> -			if (IS_G4X(dev) &&
> -			    (hotplug_status & DP_AUX_CHANNEL_MASK_INT_STATUS_G4X))
> -				dp_aux_irq_handler(dev);
> -
>  			I915_WRITE(PORT_HOTPLUG_STAT, hotplug_status);
>  			I915_READ(PORT_HOTPLUG_STAT);
>  		}
> diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
> index a48b7ca..94b4cd5 100644
> --- a/drivers/gpu/drm/i915/i915_reg.h
> +++ b/drivers/gpu/drm/i915/i915_reg.h
> @@ -2139,11 +2139,6 @@
>  #define   CRT_HOTPLUG_MONITOR_COLOR		(3 << 8)
>  #define   CRT_HOTPLUG_MONITOR_MONO		(2 << 8)
>  #define   CRT_HOTPLUG_MONITOR_NONE		(0 << 8)
> -#define   DP_AUX_CHANNEL_D_INT_STATUS_G4X	(1 << 6)
> -#define   DP_AUX_CHANNEL_C_INT_STATUS_G4X	(1 << 5)
> -#define   DP_AUX_CHANNEL_B_INT_STATUS_G4X	(1 << 4)
> -#define   DP_AUX_CHANNEL_MASK_INT_STATUS_G4X	(7 << 4)
> -
>  /* SDVO is different across gen3/4 */
>  #define   SDVOC_HOTPLUG_INT_STATUS_G4X		(1 << 3)
>  #define   SDVOB_HOTPLUG_INT_STATUS_G4X		(1 << 2)
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 5ede4e8..464c047 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -404,7 +404,7 @@ intel_dp_aux_ch(struct intel_dp *intel_dp,
>  	int i, ret, recv_bytes;
>  	uint32_t status;
>  	int try, precharge, clock = 0;
> -	bool has_aux_irq = true;
> +	bool has_aux_irq = INTEL_INFO(dev)->gen >= 5 && !IS_VALLEYVIEW(dev);
>  	uint32_t timeout;
>  
>  	/* dp aux is extremely sensitive to irq latency, hence request the
> -- 
> Jiri Kosina
> SUSE Labs
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Technology Center
