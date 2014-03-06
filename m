Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCFVoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:44:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:11645 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaCFVoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:44:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,603,1389772800"; 
   d="scan'208";a="495435188"
Date: Thu, 6 Mar 2014 13:44:10 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv3 4/4] xhci: rework command timeout and cancellation,
Message-ID: <20140306214410.GB14522@xanatos>
References: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
 <1393443530-9216-5-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393443530-9216-5-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 09:38:50PM +0200, Mathias Nyman wrote:
> Use one timer to control command timeout.
> 
> start/kick the timer every time a command is completed and a
> new command is waiting, or a new command is added to a empty list.
> 
> If the timer runs out, then tag the current command as "aborted", and
> start the xhci command abortion process.
> 
> Previously each function that submitted a command had its own timer.
> If that command timed out, a new command structure for
> the command was created and it was put on a cancel_cmd_list list,
> then a pci write to abort the command ring was issued.
> 
> when the ring was aborted, it checked if the current command
> was the one to be canceled, later when the ring was stopped the
> driver got ownership of the TRBs in the command ring,
> compared then to the TRBs in the cancel_cmd_list,
> and turned them into No-ops.
> 
> Now, instead, at timeout we tag the status of the command in the
> command queue to be aborted, and start the ring abortion.
> Ring abortion stops the command ring and gives control of the commands to us.
> All the aborted commands are now turned into No-ops.
> 
> This allows us to remove the entire cancel_cmd_list code.
> 
> The functions waiting for a command to finish no longer have their own timeouts.
> They will wait either until the command completes normally,
> or until the whole command abortion is done.

Hmm, I thought this patchset was pretty much done, but I seem to have run
into a nasty corner case.

I thought it would be good to test these patches by adding a bit of code
to stall all commands when the fifth USB device was addressed:

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 4522c3218005..55f45cfc2830 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2328,6 +2328,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 	INIT_LIST_HEAD(&xhci->cmd_list);
 
+	xhci->stall_commands = false;
 	page_size = readl(&xhci->op_regs->page_size);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Supported page size register = 0x%x", page_size);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1ffed0ad5f96..a04f39dde22f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -271,7 +271,8 @@ static inline int room_on_ring(struct xhci_hcd *xhci, struct xhci_ring *ring,
 /* Ring the host controller doorbell after placing a command on the ring */
 void xhci_ring_cmd_db(struct xhci_hcd *xhci)
 {
-	if (!(xhci->cmd_ring_state & CMD_RING_STATE_RUNNING))
+	if (!(xhci->cmd_ring_state & CMD_RING_STATE_RUNNING) ||
+			xhci->stall_commands)
 		return;
 
 	xhci_dbg(xhci, "// Ding dong!\n");
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9c522df277e1..ffe9a4ba2c3c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3840,6 +3840,10 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 		kfree(command);
 		return ret;
 	}
+	if ((++xhci->num_addressed_devices % 5) == 0) {
+		xhci->stall_commands = true;
+		xhci_warn(xhci, "Stall all new commands.\n");
+	}
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
@@ -3889,6 +3893,10 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 		kfree(command);
 		return ret;
 	}
+	if (xhci->stall_commands) {
+		xhci_dbg(xhci, "Stop stalling commands. Command doorbell can now be rung.\n");
+		xhci->stall_commands = false;
+	}
 	temp_64 = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_address,
 			"Op regs DCBAA ptr = %#016llx", temp_64);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 68f0e6893dc2..3be5126ab01f 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1582,6 +1582,8 @@ struct xhci_hcd {
 	u32			port_status_u0;
 /* Compliance Mode Timer Triggered every 2 seconds */
 #define COMP_MODE_RCVRY_MSECS 2000
+	int			num_addressed_devices;
+	bool			stall_commands;
 };
 
 /* convert between an HCD pointer and the corresponding EHCI_HCD */


My goal was to have an address command stall while I submitted other
commands (like a Configure Endpoint command by changing the video
resolution on a webcam).  However, the effect that patch had was to
cause the USB core to mark the host as dying:

Mar  6 13:06:19 xanatos kernel: [ 5230.420138] usb 1-1.2: new high-speed USB device number 4 using xhci_hcd
Mar  6 13:06:19 xanatos kernel: [ 5230.420146] xhci_hcd 0000:00:14.0: Slot ID 3 Input Context:
Mar  6 13:06:19 xanatos kernel: [ 5230.420151] xhci_hcd 0000:00:14.0: Stall all new commands.
Mar  6 13:06:24 xanatos kernel: [ 5235.435382] xhci_hcd 0000:00:14.0: Abort command ring
Mar  6 13:06:29 xanatos kernel: [ 5240.430719] xhci_hcd 0000:00:14.0: xHCI host not responding to stop endpoint command.
Mar  6 13:06:29 xanatos kernel: [ 5240.430730] xhci_hcd 0000:00:14.0: Assuming host is dying, halting host.
Mar  6 13:06:29 xanatos kernel: [ 5240.430783] xhci_hcd 0000:00:14.0: HC died; cleaning up
Mar  6 13:06:29 xanatos kernel: [ 5240.446698] xhci_hcd 0000:00:14.0: Abort command ring
Mar  6 13:06:29 xanatos kernel: [ 5240.446710] xhci_hcd 0000:00:14.0: The command ring isn't running, Have the command ring been stopped?
Mar  6 13:08:10 xanatos kernel: [ 5341.096873] waiting module removal not supported: please upgrade
Mar  6 13:08:10 xanatos kernel: [ 5341.096916] xhci_hcd 0000:00:14.0: remove, state 4
Mar  6 13:08:10 xanatos kernel: [ 5341.096926] usb usb2: USB disconnect, device number 1
Mar  6 13:09:14 xanatos kernel: [ 5405.363489] INFO: task khubd:127 blocked for more than 120 seconds.
Mar  6 13:09:14 xanatos kernel: [ 5405.363498]       Not tainted 3.14.0-rc5+ #200
Mar  6 13:09:14 xanatos kernel: [ 5405.363501] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  6 13:09:14 xanatos kernel: [ 5405.363504] khubd           D ffff88003202c300     0   127      2 0x00000000
Mar  6 13:09:14 xanatos kernel: [ 5405.363512]  ffff880115455b10 0000000000000046 ffff88003202c300 ffffffff81c114c0
Mar  6 13:09:14 xanatos kernel: [ 5405.363519]  ffff880115455fd8 0000000000013b80 0000000000013b80 ffff88003202c300
Mar  6 13:09:14 xanatos kernel: [ 5405.363525]  7fffffffffffffff ffff8800c7360198 ffff8800c7360190 ffff88003202c300
Mar  6 13:09:14 xanatos kernel: [ 5405.363531] Call Trace:
Mar  6 13:09:14 xanatos kernel: [ 5405.363544]  [<ffffffff81659519>] schedule+0x29/0x70
Mar  6 13:09:14 xanatos kernel: [ 5405.363550]  [<ffffffff81658711>] schedule_timeout+0x281/0x310
Mar  6 13:09:14 xanatos kernel: [ 5405.363557]  [<ffffffff8165a88b>] ? wait_for_completion+0x3b/0x120
Mar  6 13:09:14 xanatos kernel: [ 5405.363563]  [<ffffffff8165a904>] wait_for_completion+0xb4/0x120
Mar  6 13:09:14 xanatos kernel: [ 5405.363571]  [<ffffffff81082480>] ? wake_up_state+0x20/0x20
Mar  6 13:09:14 xanatos kernel: [ 5405.363583]  [<ffffffffa0158096>] xhci_setup_device+0x196/0x760 [xhci_hcd]
Mar  6 13:09:14 xanatos kernel: [ 5405.363593]  [<ffffffffa015d920>] xhci_enable_device+0x10/0x20 [xhci_hcd]
Mar  6 13:09:14 xanatos kernel: [ 5405.363625]  [<ffffffffa002fcbd>] hub_port_init+0x49d/0xbe0 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363644]  [<ffffffffa0031ac6>] hub_thread+0x7a6/0x1730 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363651]  [<ffffffff8109f31d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
Mar  6 13:09:14 xanatos kernel: [ 5405.363659]  [<ffffffff810954d0>] ? prepare_to_wait_event+0x100/0x100
Mar  6 13:09:14 xanatos kernel: [ 5405.363674]  [<ffffffffa0031320>] ? usb_reset_device+0x1d0/0x1d0 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363680]  [<ffffffff8107084c>] kthread+0xfc/0x120
Mar  6 13:09:14 xanatos kernel: [ 5405.363686]  [<ffffffff81070750>] ? kthread_create_on_node+0x230/0x230
Mar  6 13:09:14 xanatos kernel: [ 5405.363693]  [<ffffffff816677ec>] ret_from_fork+0x7c/0xb0
Mar  6 13:09:14 xanatos kernel: [ 5405.363698]  [<ffffffff81070750>] ? kthread_create_on_node+0x230/0x230
Mar  6 13:09:14 xanatos kernel: [ 5405.363701] INFO: lockdep is turned off.
Mar  6 13:09:14 xanatos kernel: [ 5405.363721] INFO: task upowerd:1356 blocked for more than 120 seconds.
Mar  6 13:09:14 xanatos kernel: [ 5405.363724]       Not tainted 3.14.0-rc5+ #200
Mar  6 13:09:14 xanatos kernel: [ 5405.363726] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  6 13:09:14 xanatos kernel: [ 5405.363728] upowerd         D ffff8800b986a180     0  1356      1 0x00000000
Mar  6 13:09:14 xanatos kernel: [ 5405.363734]  ffff8800b9861de0 0000000000000046 ffff8800b986a180 ffff8800c566c300
Mar  6 13:09:14 xanatos kernel: [ 5405.363740]  ffff8800b9861fd8 0000000000013b80 0000000000013b80 ffff8800b986a180
Mar  6 13:09:14 xanatos kernel: [ 5405.363745]  ffff8800b9ab38f0 ffff8800b9ab38f8 0000000000000246 ffff8800b986a180
Mar  6 13:09:14 xanatos kernel: [ 5405.363751] Call Trace:
Mar  6 13:09:14 xanatos kernel: [ 5405.363758]  [<ffffffff816599f1>] schedule_preempt_disabled+0x31/0x80
Mar  6 13:09:14 xanatos kernel: [ 5405.363763]  [<ffffffff8165aacc>] mutex_lock_nested+0x15c/0x390
Mar  6 13:09:14 xanatos kernel: [ 5405.363783]  [<ffffffffa004043b>] ? read_descriptors+0x3b/0x110 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363800]  [<ffffffffa004043b>] read_descriptors+0x3b/0x110 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363809]  [<ffffffff8122c1fd>] sysfs_kf_bin_read+0x4d/0x70
Mar  6 13:09:14 xanatos kernel: [ 5405.363814]  [<ffffffff81230363>] kernfs_fop_read+0xa3/0x170
Mar  6 13:09:14 xanatos kernel: [ 5405.363821]  [<ffffffff811b1d6b>] vfs_read+0x9b/0x160
Mar  6 13:09:14 xanatos kernel: [ 5405.363827]  [<ffffffff811b2829>] SyS_read+0x49/0xa0
Mar  6 13:09:14 xanatos kernel: [ 5405.363834]  [<ffffffff81667896>] system_call_fastpath+0x1a/0x1f
Mar  6 13:09:14 xanatos kernel: [ 5405.363836] INFO: lockdep is turned off.
Mar  6 13:09:14 xanatos kernel: [ 5405.363860] INFO: task alsa-sink-USB A:14271 blocked for more than 120 seconds.
Mar  6 13:09:14 xanatos kernel: [ 5405.363862]       Not tainted 3.14.0-rc5+ #200
Mar  6 13:09:14 xanatos kernel: [ 5405.363864] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  6 13:09:14 xanatos kernel: [ 5405.363866] alsa-sink-USB A D ffff8800c7168000     0 14271   1801 0x00000000
Mar  6 13:09:14 xanatos kernel: [ 5405.363871]  ffff8800c5657b90 0000000000000046 ffff8800c7168000 ffff880118672180
Mar  6 13:09:14 xanatos kernel: [ 5405.363877]  ffff8800c5657fd8 0000000000013b80 0000000000013b80 ffff8800c7168000
Mar  6 13:09:14 xanatos kernel: [ 5405.363882]  7fffffffffffffff ffff880032314f68 ffff880032314f60 ffff8800c7168000
Mar  6 13:09:14 xanatos kernel: [ 5405.363888] Call Trace:
Mar  6 13:09:14 xanatos kernel: [ 5405.363894]  [<ffffffff81659519>] schedule+0x29/0x70
Mar  6 13:09:14 xanatos kernel: [ 5405.363899]  [<ffffffff81658711>] schedule_timeout+0x281/0x310
Mar  6 13:09:14 xanatos kernel: [ 5405.363905]  [<ffffffff8165a88b>] ? wait_for_completion+0x3b/0x120
Mar  6 13:09:14 xanatos kernel: [ 5405.363911]  [<ffffffff8165a904>] wait_for_completion+0xb4/0x120
Mar  6 13:09:14 xanatos kernel: [ 5405.363917]  [<ffffffff81082480>] ? wake_up_state+0x20/0x20
Mar  6 13:09:14 xanatos kernel: [ 5405.363927]  [<ffffffffa015b0df>] xhci_configure_endpoint+0xcf/0x550 [xhci_hcd]
Mar  6 13:09:14 xanatos kernel: [ 5405.363936]  [<ffffffffa015bead>] xhci_check_bandwidth+0x10d/0x2e0 [xhci_hcd]
Mar  6 13:09:14 xanatos kernel: [ 5405.363954]  [<ffffffffa0037043>] usb_hcd_alloc_bandwidth+0x2a3/0x340 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363972]  [<ffffffffa003a33a>] usb_set_interface+0xca/0x390 [usbcore]
Mar  6 13:09:14 xanatos kernel: [ 5405.363986]  [<ffffffffa055f3e1>] snd_usb_pcm_close.isra.9+0x51/0x80 [snd_usb_audio]
Mar  6 13:09:14 xanatos kernel: [ 5405.363996]  [<ffffffffa055f444>] snd_usb_playback_close+0x14/0x20 [snd_usb_audio]
Mar  6 13:09:14 xanatos kernel: [ 5405.364008]  [<ffffffffa043654f>] snd_pcm_release_substream.part.29+0x3f/0x90 [snd_pcm]
Mar  6 13:09:14 xanatos kernel: [ 5405.364018]  [<ffffffffa0436680>] snd_pcm_release+0xb0/0xc0 [snd_pcm]
Mar  6 13:09:14 xanatos kernel: [ 5405.364025]  [<ffffffff811b3a3f>] __fput+0xef/0x240
Mar  6 13:09:14 xanatos kernel: [ 5405.364031]  [<ffffffff811b3bde>] ____fput+0xe/0x10
Mar  6 13:09:14 xanatos kernel: [ 5405.364037]  [<ffffffff8106d4fc>] task_work_run+0xac/0xe0
Mar  6 13:09:14 xanatos kernel: [ 5405.364045]  [<ffffffff81002d69>] do_notify_resume+0x59/0x90
Mar  6 13:09:14 xanatos kernel: [ 5405.364049]  [<ffffffff81667ba2>] int_signal+0x12/0x17

And now khubd is hung, I can't unload the xHCI module, and the sound
layer is probably hung as well.

I think the issue is that when the xHCI host was marked as dying, we
halted the host, and the command ring will be marked as not running.
But there are still processes waiting on pending commands.  When the
timer fires because the first command times out, xhci_abort_cmd_ring
notices the command ring is not running, and assumes we'll get a command
event with the completion code set to COMP_CMD_STOP.  However, the host
is dead, so we'll never see that event.

I think the easiest way to fix this would be to have a new function that
handles when the host dies, that's called from both
xhci_stop_endpoint_command_watchdog and xhci_abort_cmd_ring (when
stopping the command ring fails).  That function should call
xhci_quiesce, xhci_halt, and flush out the entire command queue.

Also, what will happen if the xhci-hcd module is unloaded when a command
is still pending?  I think the code in xhci_mem_cleanup will leave those
processes hanging, waiting for their commands to complete:

        list_for_each_entry_safe(cur_cmd, next_cmd,
                        &xhci->cmd_list, cmd_list) {
                list_del(&cur_cmd->cmd_list);
                kfree(cur_cmd);
        }

You should probably also audit all xHCI functions that submit commands,
and make them not submit if the host is dying.  I don't see anything
stopping the USB core from causing command submission to a dead xHCI
host.

This needs to get fixed before the code can be merged.  (And again,
reverting those patches that were causing xHCI regressions takes
priority to fixing this.)

Sarah Sharp

> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-hub.c  |  11 +-
>  drivers/usb/host/xhci-mem.c  |  15 +-
>  drivers/usb/host/xhci-ring.c | 335 +++++++++++++------------------------------
>  drivers/usb/host/xhci.c      |  78 ++++------
>  drivers/usb/host/xhci.h      |   8 +-
>  5 files changed, 138 insertions(+), 309 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 0a57d95..8350fd9 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -271,7 +271,6 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
>  	struct xhci_virt_device *virt_dev;
>  	struct xhci_command *cmd;
>  	unsigned long flags;
> -	int timeleft;
>  	int ret;
>  	int i;
>  
> @@ -304,12 +303,10 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
>  	/* Wait for last stop endpoint command to finish */
> -	timeleft = wait_for_completion_interruptible_timeout(
> -			cmd->completion,
> -			XHCI_CMD_DEFAULT_TIMEOUT);
> -	if (timeleft <= 0) {
> -		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
> -				timeleft == 0 ? "Timeout" : "Signal");
> +	wait_for_completion(cmd->completion);
> +
> +	if (cmd->status == COMP_CMD_ABORT || cmd->status == COMP_CMD_STOP) {
> +		xhci_warn(xhci, "Timeout while waiting for stop endpoint command\n");
>  		ret = -ETIME;
>  	}
>  	xhci_free_command(xhci, cmd);
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index 81c2469..6baaaf5 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -1692,7 +1692,6 @@ void xhci_free_command(struct xhci_hcd *xhci,
>  void xhci_mem_cleanup(struct xhci_hcd *xhci)
>  {
>  	struct device	*dev = xhci_to_hcd(xhci)->self.controller;
> -	struct xhci_cd  *cur_cd, *next_cd;
>  	struct xhci_command *cur_cmd, *next_cmd;
>  	int size;
>  	int i, j, num_ports;
> @@ -1712,15 +1711,13 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
>  	if (xhci->lpm_command)
>  		xhci_free_command(xhci, xhci->lpm_command);
>  	xhci->cmd_ring_reserved_trbs = 0;
> +
> +	del_timer_sync(&xhci->cmd_timer);
> +
>  	if (xhci->cmd_ring)
>  		xhci_ring_free(xhci, xhci->cmd_ring);
>  	xhci->cmd_ring = NULL;
>  	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Freed command ring");
> -	list_for_each_entry_safe(cur_cd, next_cd,
> -			&xhci->cancel_cmd_list, cancel_cmd_list) {
> -		list_del(&cur_cd->cancel_cmd_list);
> -		kfree(cur_cd);
> -	}
>  
>  	list_for_each_entry_safe(cur_cmd, next_cmd,
>  			&xhci->cmd_list, cmd_list) {
> @@ -2228,7 +2225,6 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
>  	u32 page_size, temp;
>  	int i;
>  
> -	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
>  	INIT_LIST_HEAD(&xhci->cmd_list);
>  
>  	page_size = readl(&xhci->op_regs->page_size);
> @@ -2414,6 +2410,11 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
>  			"Wrote ERST address to ir_set 0.");
>  	xhci_print_ir_set(xhci, 0);
>  
> +	/* init command timeout timer */
> +	init_timer(&xhci->cmd_timer);
> +	xhci->cmd_timer.data = (unsigned long) xhci;
> +	xhci->cmd_timer.function = xhci_handle_command_timeout;
> +
>  	/*
>  	 * XXX: Might need to set the Interrupter Moderation Register to
>  	 * something other than the default (~1ms minimum between interrupts).
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 12bf467..b664a42 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -323,71 +323,6 @@ static int xhci_abort_cmd_ring(struct xhci_hcd *xhci)
>  	return 0;
>  }
>  
> -static int xhci_queue_cd(struct xhci_hcd *xhci,
> -		struct xhci_command *command,
> -		union xhci_trb *cmd_trb)
> -{
> -	struct xhci_cd *cd;
> -	cd = kzalloc(sizeof(struct xhci_cd), GFP_ATOMIC);
> -	if (!cd)
> -		return -ENOMEM;
> -	INIT_LIST_HEAD(&cd->cancel_cmd_list);
> -
> -	cd->command = command;
> -	cd->cmd_trb = cmd_trb;
> -	list_add_tail(&cd->cancel_cmd_list, &xhci->cancel_cmd_list);
> -
> -	return 0;
> -}
> -
> -/*
> - * Cancel the command which has issue.
> - *
> - * Some commands may hang due to waiting for acknowledgement from
> - * usb device. It is outside of the xHC's ability to control and
> - * will cause the command ring is blocked. When it occurs software
> - * should intervene to recover the command ring.
> - * See Section 4.6.1.1 and 4.6.1.2
> - */
> -int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
> -		union xhci_trb *cmd_trb)
> -{
> -	int retval = 0;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&xhci->lock, flags);
> -
> -	if (xhci->xhc_state & XHCI_STATE_DYING) {
> -		xhci_warn(xhci, "Abort the command ring,"
> -				" but the xHCI is dead.\n");
> -		retval = -ESHUTDOWN;
> -		goto fail;
> -	}
> -
> -	/* queue the cmd desriptor to cancel_cmd_list */
> -	retval = xhci_queue_cd(xhci, command, cmd_trb);
> -	if (retval) {
> -		xhci_warn(xhci, "Queuing command descriptor failed.\n");
> -		goto fail;
> -	}
> -
> -	/* abort command ring */
> -	retval = xhci_abort_cmd_ring(xhci);
> -	if (retval) {
> -		xhci_err(xhci, "Abort command ring failed\n");
> -		if (unlikely(retval == -ESHUTDOWN)) {
> -			spin_unlock_irqrestore(&xhci->lock, flags);
> -			usb_hc_died(xhci_to_hcd(xhci)->primary_hcd);
> -			xhci_dbg(xhci, "xHCI host controller is dead.\n");
> -			return retval;
> -		}
> -	}
> -
> -fail:
> -	spin_unlock_irqrestore(&xhci->lock, flags);
> -	return retval;
> -}
> -
>  void xhci_ring_ep_doorbell(struct xhci_hcd *xhci,
>  		unsigned int slot_id,
>  		unsigned int ep_index,
> @@ -1174,164 +1109,6 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
>  	}
>  }
>  
> -/* Complete the command and detele it from the devcie's command queue.
> - */
> -static void xhci_complete_cmd_in_cmd_wait_list(struct xhci_hcd *xhci,
> -		struct xhci_command *command, u32 status)
> -{
> -	command->status = status;
> -	list_del(&command->cmd_list);
> -	if (command->completion)
> -		complete(command->completion);
> -	else
> -		xhci_free_command(xhci, command);
> -}
> -
> -
> -/*
> - * Finding the command trb need to be cancelled and modifying it to
> - * NO OP command. And if the command is in device's command wait
> - * list, finishing and freeing it.
> - *
> - * If we can't find the command trb, we think it had already been
> - * executed.
> - */
> -static void xhci_cmd_to_noop(struct xhci_hcd *xhci, struct xhci_cd *cur_cd)
> -{
> -	struct xhci_segment *cur_seg;
> -	union xhci_trb *cmd_trb;
> -	u32 cycle_state;
> -
> -	if (xhci->cmd_ring->dequeue == xhci->cmd_ring->enqueue)
> -		return;
> -
> -	/* find the current segment of command ring */
> -	cur_seg = find_trb_seg(xhci->cmd_ring->first_seg,
> -			xhci->cmd_ring->dequeue, &cycle_state);
> -
> -	if (!cur_seg) {
> -		xhci_warn(xhci, "Command ring mismatch, dequeue = %p %llx (dma)\n",
> -				xhci->cmd_ring->dequeue,
> -				(unsigned long long)
> -				xhci_trb_virt_to_dma(xhci->cmd_ring->deq_seg,
> -					xhci->cmd_ring->dequeue));
> -		xhci_debug_ring(xhci, xhci->cmd_ring);
> -		xhci_dbg_ring_ptrs(xhci, xhci->cmd_ring);
> -		return;
> -	}
> -
> -	/* find the command trb matched by cd from command ring */
> -	for (cmd_trb = xhci->cmd_ring->dequeue;
> -			cmd_trb != xhci->cmd_ring->enqueue;
> -			next_trb(xhci, xhci->cmd_ring, &cur_seg, &cmd_trb)) {
> -		/* If the trb is link trb, continue */
> -		if (TRB_TYPE_LINK_LE32(cmd_trb->generic.field[3]))
> -			continue;
> -
> -		if (cur_cd->cmd_trb == cmd_trb) {
> -
> -			/* If the command in device's command list, we should
> -			 * finish it and free the command structure.
> -			 */
> -			if (cur_cd->command)
> -				xhci_complete_cmd_in_cmd_wait_list(xhci,
> -					cur_cd->command, COMP_CMD_STOP);
> -
> -			/* get cycle state from the origin command trb */
> -			cycle_state = le32_to_cpu(cmd_trb->generic.field[3])
> -				& TRB_CYCLE;
> -
> -			/* modify the command trb to NO OP command */
> -			cmd_trb->generic.field[0] = 0;
> -			cmd_trb->generic.field[1] = 0;
> -			cmd_trb->generic.field[2] = 0;
> -			cmd_trb->generic.field[3] = cpu_to_le32(
> -					TRB_TYPE(TRB_CMD_NOOP) | cycle_state);
> -			break;
> -		}
> -	}
> -}
> -
> -static void xhci_cancel_cmd_in_cd_list(struct xhci_hcd *xhci)
> -{
> -	struct xhci_cd *cur_cd, *next_cd;
> -
> -	if (list_empty(&xhci->cancel_cmd_list))
> -		return;
> -
> -	list_for_each_entry_safe(cur_cd, next_cd,
> -			&xhci->cancel_cmd_list, cancel_cmd_list) {
> -		xhci_cmd_to_noop(xhci, cur_cd);
> -		list_del(&cur_cd->cancel_cmd_list);
> -		kfree(cur_cd);
> -	}
> -}
> -
> -/*
> - * traversing the cancel_cmd_list. If the command descriptor according
> - * to cmd_trb is found, the function free it and return 1, otherwise
> - * return 0.
> - */
> -static int xhci_search_cmd_trb_in_cd_list(struct xhci_hcd *xhci,
> -		union xhci_trb *cmd_trb)
> -{
> -	struct xhci_cd *cur_cd, *next_cd;
> -
> -	if (list_empty(&xhci->cancel_cmd_list))
> -		return 0;
> -
> -	list_for_each_entry_safe(cur_cd, next_cd,
> -			&xhci->cancel_cmd_list, cancel_cmd_list) {
> -		if (cur_cd->cmd_trb == cmd_trb) {
> -			if (cur_cd->command)
> -				xhci_complete_cmd_in_cmd_wait_list(xhci,
> -					cur_cd->command, COMP_CMD_STOP);
> -			list_del(&cur_cd->cancel_cmd_list);
> -			kfree(cur_cd);
> -			return 1;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -/*
> - * If the cmd_trb_comp_code is COMP_CMD_ABORT, we just check whether the
> - * trb pointed by the command ring dequeue pointer is the trb we want to
> - * cancel or not. And if the cmd_trb_comp_code is COMP_CMD_STOP, we will
> - * traverse the cancel_cmd_list to trun the all of the commands according
> - * to command descriptor to NO-OP trb.
> - */
> -static int handle_stopped_cmd_ring(struct xhci_hcd *xhci,
> -		int cmd_trb_comp_code)
> -{
> -	int cur_trb_is_good = 0;
> -
> -	/* Searching the cmd trb pointed by the command ring dequeue
> -	 * pointer in command descriptor list. If it is found, free it.
> -	 */
> -	cur_trb_is_good = xhci_search_cmd_trb_in_cd_list(xhci,
> -			xhci->cmd_ring->dequeue);
> -
> -	if (cmd_trb_comp_code == COMP_CMD_ABORT)
> -		xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
> -	else if (cmd_trb_comp_code == COMP_CMD_STOP) {
> -		/* traversing the cancel_cmd_list and canceling
> -		 * the command according to command descriptor
> -		 */
> -		xhci_cancel_cmd_in_cd_list(xhci);
> -
> -		xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
> -		/*
> -		 * ring command ring doorbell again to restart the
> -		 * command ring
> -		 */
> -		if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue)
> -			xhci_ring_cmd_db(xhci);
> -	}
> -	return cur_trb_is_good;
> -}
> -
>  static void xhci_handle_cmd_enable_slot(struct xhci_hcd *xhci, int slot_id,
>  		u32 cmd_comp_code)
>  {
> @@ -1429,6 +1206,30 @@ static void xhci_handle_cmd_nec_get_fw(struct xhci_hcd *xhci,
>  			NEC_FW_MINOR(le32_to_cpu(event->status)));
>  }
>  
> +void xhci_handle_command_timeout(unsigned long data)
> +{
> +	struct xhci_hcd *xhci;
> +	int ret;
> +	unsigned long flags;
> +	xhci = (struct xhci_hcd *) data;
> +	/* mark this command to be cancelled */
> +	spin_lock_irqsave(&xhci->lock, flags);
> +	if (xhci->current_cmd)
> +		xhci->current_cmd->status = COMP_CMD_ABORT;
> +	spin_unlock_irqrestore(&xhci->lock, flags);
> +
> +	ret = xhci_abort_cmd_ring(xhci);
> +
> +	if (ret) {
> +		xhci_err(xhci, "Abort command ring failed\n");
> +		if (unlikely(ret == -ESHUTDOWN)) {
> +			usb_hc_died(xhci_to_hcd(xhci)->primary_hcd);
> +			xhci_dbg(xhci, "xHCI host controller is dead.\n");
> +		}
> +	}
> +	return;
> +}
> +
>  static void handle_cmd_completion(struct xhci_hcd *xhci,
>  		struct xhci_event_cmd *event)
>  {
> @@ -1462,26 +1263,64 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>  			 "Command completion event does not match command\n");
>  		return;
>  	}
> +
> +	del_timer(&xhci->cmd_timer);
> +
>  	trace_xhci_cmd_completion(cmd_trb, (struct xhci_generic_trb *) event);
>  
>  	cmd_comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
> -	if (cmd_comp_code == COMP_CMD_ABORT || cmd_comp_code == COMP_CMD_STOP) {
> -		/* If the return value is 0, we think the trb pointed by
> -		 * command ring dequeue pointer is a good trb. The good
> -		 * trb means we don't want to cancel the trb, but it have
> -		 * been stopped by host. So we should handle it normally.
> -		 * Otherwise, driver should invoke inc_deq() and return.
> -		 */
> -		if (handle_stopped_cmd_ring(xhci, cmd_comp_code)) {
> -			inc_deq(xhci, xhci->cmd_ring);
> -			return;
> +
> +	/* If CMD ring stopped we own the trbs between enqueue and dequeue */
> +	if (cmd_comp_code == COMP_CMD_STOP) {
> +		struct xhci_command *cur_cmd, *tmp_cmd;
> +		u32 cycle_state;
> +
> +		/* Turn all aborted commands in list to no-ops, then restart */
> +		list_for_each_entry_safe(cur_cmd, tmp_cmd, &xhci->cmd_list,
> +					 cmd_list) {
> +
> +			if (cur_cmd->status != COMP_CMD_ABORT)
> +				continue;
> +
> +			cur_cmd->status = COMP_CMD_STOP;
> +
> +			/* get cycle state from the original cmd trb */
> +			cycle_state = le32_to_cpu(
> +				cur_cmd->command_trb->generic.field[3]) &
> +				TRB_CYCLE;
> +
> +			/* modify the command trb to NO OP command */
> +			cur_cmd->command_trb->generic.field[0] = 0;
> +			cur_cmd->command_trb->generic.field[1] = 0;
> +			cur_cmd->command_trb->generic.field[2] = 0;
> +			cur_cmd->command_trb->generic.field[3] = cpu_to_le32(
> +				TRB_TYPE(TRB_CMD_NOOP) | cycle_state);
> +
> +			/* completion is called when command completion
> +			 * event is received for these no-op commands
> +			 */
>  		}
> -		/* There is no command to handle if we get a stop event when the
> -		 * command ring is empty, event->cmd_trb points to the next
> -		 * unset command
> -		 */
> -		if (xhci->cmd_ring->dequeue == xhci->cmd_ring->enqueue)
> -			return;
> +		xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
> +
> +		/* ring command ring doorbell to restart the command ring */
> +		if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue) {
> +			xhci->current_cmd = cmd;
> +			mod_timer(&xhci->cmd_timer,
> +				  jiffies + XHCI_CMD_DEFAULT_TIMEOUT);
> +			xhci_ring_cmd_db(xhci);
> +		}
> +		return;
> +	}
> +	/*
> +	 * Host aborted the command ring, check if the current command was
> +	 * supposed to be aborted, otherwise continue normally.
> +	 * The command ring is stopped now, but the xHC will issue a Command
> +	 * Ring Stopped event which will cause us to restart it.
> +	 */
> +	if (cmd_comp_code == COMP_CMD_ABORT) {
> +		xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
> +		if (cmd->status == COMP_CMD_ABORT)
> +			goto event_handled;
>  	}
>  
>  	cmd_type = TRB_FIELD_TO_TYPE(le32_to_cpu(cmd_trb->generic.field[3]));
> @@ -1512,6 +1351,9 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>  		xhci_handle_cmd_set_deq(xhci, slot_id, cmd_trb, cmd_comp_code);
>  		break;
>  	case TRB_CMD_NOOP:
> +		/* Is this an aborted command turned to NO-OP? */
> +		if (cmd->status == COMP_CMD_STOP)
> +			cmd_comp_code = COMP_CMD_STOP;
>  		break;
>  	case TRB_RESET_EP:
>  		WARN_ON(slot_id != TRB_TO_SLOT_ID(
> @@ -1532,6 +1374,14 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>  		break;
>  	}
>  
> +	/* restart timer if this wasn't the last command */
> +	if (cmd->cmd_list.next != &xhci->cmd_list) {
> +		xhci->current_cmd = list_entry(cmd->cmd_list.next,
> +					       struct xhci_command, cmd_list);
> +		mod_timer(&xhci->cmd_timer, jiffies + XHCI_CMD_DEFAULT_TIMEOUT);
> +	}
> +
> +event_handled:
>  	list_del(&cmd->cmd_list);
>  
>  	if (cmd->completion) {
> @@ -3946,6 +3796,13 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
>  	cmd->command_trb = xhci->cmd_ring->enqueue;
>  	list_add_tail(&cmd->cmd_list, &xhci->cmd_list);
>  
> +	/* if there are no other commands queued we start the timeout timer */
> +	if (xhci->cmd_list.next == &cmd->cmd_list &&
> +	    !timer_pending(&xhci->cmd_timer)) {
> +		xhci->current_cmd = cmd;
> +		mod_timer(&xhci->cmd_timer, jiffies + XHCI_CMD_DEFAULT_TIMEOUT);
> +	}
> +
>  	queue_trb(xhci, xhci->cmd_ring, false, field1, field2, field3,
>  			field4 | xhci->cmd_ring->cycle_state);
>  	return 0;
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 4dc88ae..d44eee7 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1816,6 +1816,11 @@ static int xhci_configure_endpoint_result(struct xhci_hcd *xhci,
>  	int ret;
>  
>  	switch (*cmd_status) {
> +	case COMP_CMD_ABORT:
> +	case COMP_CMD_STOP:
> +		xhci_warn(xhci, "Timeout while waiting for configure endpoint command\n");
> +		ret = -ETIME;
> +		break;
>  	case COMP_ENOMEM:
>  		dev_warn(&udev->dev, "Not enough host controller resources "
>  				"for new device state.\n");
> @@ -1862,6 +1867,11 @@ static int xhci_evaluate_context_result(struct xhci_hcd *xhci,
>  	struct xhci_virt_device *virt_dev = xhci->devs[udev->slot_id];
>  
>  	switch (*cmd_status) {
> +	case COMP_CMD_ABORT:
> +	case COMP_CMD_STOP:
> +		xhci_warn(xhci, "Timeout while waiting for evaluate context command\n");
> +		ret = -ETIME;
> +		break;
>  	case COMP_EINVAL:
>  		dev_warn(&udev->dev, "WARN: xHCI driver setup invalid evaluate "
>  				"context command.\n");
> @@ -2586,7 +2596,6 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  		bool ctx_change, bool must_succeed)
>  {
>  	int ret;
> -	int timeleft;
>  	unsigned long flags;
>  	struct xhci_input_control_ctx *ctrl_ctx;
>  	struct xhci_virt_device *virt_dev;
> @@ -2642,21 +2651,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
>  	/* Wait for the configure endpoint command to complete */
> -	timeleft = wait_for_completion_interruptible_timeout(
> -			command->completion,
> -			XHCI_CMD_DEFAULT_TIMEOUT);
> -	if (timeleft <= 0) {
> -		xhci_warn(xhci, "%s while waiting for %s command\n",
> -				timeleft == 0 ? "Timeout" : "Signal",
> -				ctx_change == 0 ?
> -					"configure endpoint" :
> -					"evaluate context");
> -		/* cancel the configure endpoint command */
> -		ret = xhci_cancel_cmd(xhci, command, command->command_trb);
> -		if (ret < 0)
> -			return ret;
> -		return -ETIME;
> -	}
> +	wait_for_completion(command->completion);
>  
>  	if (!ctx_change)
>  		ret = xhci_configure_endpoint_result(xhci, udev,
> @@ -3412,7 +3407,6 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>  	unsigned int slot_id;
>  	struct xhci_virt_device *virt_dev;
>  	struct xhci_command *reset_device_cmd;
> -	int timeleft;
>  	int last_freed_endpoint;
>  	struct xhci_slot_ctx *slot_ctx;
>  	int old_active_eps = 0;
> @@ -3480,15 +3474,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
>  	/* Wait for the Reset Device command to finish */
> -	timeleft = wait_for_completion_interruptible_timeout(
> -			reset_device_cmd->completion,
> -			XHCI_CMD_DEFAULT_TIMEOUT);
> -	if (timeleft <= 0) {
> -		xhci_warn(xhci, "%s while waiting for reset device command\n",
> -				timeleft == 0 ? "Timeout" : "Signal");
> -		ret = -ETIME;
> -		goto command_cleanup;
> -	}
> +	wait_for_completion(reset_device_cmd->completion);
>  
>  	/* The Reset Device command can't fail, according to the 0.95/0.96 spec,
>  	 * unless we tried to reset a slot ID that wasn't enabled,
> @@ -3496,6 +3482,11 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>  	 */
>  	ret = reset_device_cmd->status;
>  	switch (ret) {
> +	case COMP_CMD_ABORT:
> +	case COMP_CMD_STOP:
> +		xhci_warn(xhci, "Timeout waiting for reset device command\n");
> +		ret = -ETIME;
> +		goto command_cleanup;
>  	case COMP_EBADSLT: /* 0.95 completion code for bad slot ID */
>  	case COMP_CTX_STATE: /* 0.96 completion code for same thing */
>  		xhci_dbg(xhci, "Can't reset device (slot ID %u) in %s state\n",
> @@ -3663,7 +3654,6 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  {
>  	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>  	unsigned long flags;
> -	int timeleft;
>  	int ret;
>  	struct xhci_command *command;
>  
> @@ -3683,19 +3673,9 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  	xhci_ring_cmd_db(xhci);
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
> -	/* XXX: how much time for xHC slot assignment? */
> -	timeleft = wait_for_completion_interruptible_timeout(
> -			command->completion,
> -			XHCI_CMD_DEFAULT_TIMEOUT);
> -	if (timeleft <= 0) {
> -		xhci_warn(xhci, "%s while waiting for a slot\n",
> -				timeleft == 0 ? "Timeout" : "Signal");
> -		/* cancel the enable slot request */
> -		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
> -		return ret;
> -	}
> +	wait_for_completion(command->completion);
>  
> -	if (!xhci->slot_id) {
> +	if (!xhci->slot_id || command->status != COMP_SUCCESS) {
>  		xhci_err(xhci, "Error while assigning device slot ID\n");
>  		kfree(command);
>  		return 0;
> @@ -3761,7 +3741,6 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  {
>  	const char *act = setup == SETUP_CONTEXT_ONLY ? "context" : "address";
>  	unsigned long flags;
> -	int timeleft;
>  	struct xhci_virt_device *virt_dev;
>  	int ret = 0;
>  	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> @@ -3836,23 +3815,18 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
>  	/* ctrl tx can take up to 5 sec; XXX: need more time for xHC? */
> -	timeleft = wait_for_completion_interruptible_timeout(
> -			command->completion, XHCI_CMD_DEFAULT_TIMEOUT);
> +	wait_for_completion(command->completion);
> +
>  	/* FIXME: From section 4.3.4: "Software shall be responsible for timing
>  	 * the SetAddress() "recovery interval" required by USB and aborting the
>  	 * command on a timeout.
>  	 */
> -	if (timeleft <= 0) {
> -		xhci_warn(xhci, "%s while waiting for setup %s command\n",
> -			  timeleft == 0 ? "Timeout" : "Signal", act);
> -		/* cancel the address device command */
> -		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
> -		if (ret < 0)
> -			return ret;
> -		return -ETIME;
> -	}
> -
>  	switch (command->status) {
> +	case COMP_CMD_ABORT:
> +	case COMP_CMD_STOP:
> +		xhci_warn(xhci, "Timeout while waiting for setup device command\n");
> +		ret = -ETIME;
> +		break;
>  	case COMP_CTX_STATE:
>  	case COMP_EBADSLT:
>  		xhci_err(xhci, "Setup ERROR: setup %s command for slot %d.\n",
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 217e5b0..f1a1906 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1295,7 +1295,6 @@ struct xhci_td {
>  
>  /* command descriptor */
>  struct xhci_cd {
> -	struct list_head	cancel_cmd_list;
>  	struct xhci_command	*command;
>  	union xhci_trb		*cmd_trb;
>  };
> @@ -1479,9 +1478,10 @@ struct xhci_hcd {
>  #define CMD_RING_STATE_RUNNING         (1 << 0)
>  #define CMD_RING_STATE_ABORTED         (1 << 1)
>  #define CMD_RING_STATE_STOPPED         (1 << 2)
> -	struct list_head        cancel_cmd_list;
>  	struct list_head        cmd_list;
>  	unsigned int		cmd_ring_reserved_trbs;
> +	struct timer_list	cmd_timer;
> +	struct xhci_command	*current_cmd;
>  	struct xhci_ring	*event_ring;
>  	struct xhci_erst	erst;
>  	/* Scratchpad */
> @@ -1845,8 +1845,8 @@ void xhci_queue_config_ep_quirk(struct xhci_hcd *xhci,
>  		unsigned int slot_id, unsigned int ep_index,
>  		struct xhci_dequeue_state *deq_state);
>  void xhci_stop_endpoint_command_watchdog(unsigned long arg);
> -int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
> -		union xhci_trb *cmd_trb);
> +void xhci_handle_command_timeout(unsigned long data);
> +
>  void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
>  		unsigned int ep_index, unsigned int stream_id);
>  
> -- 
> 1.8.1.2
> 
