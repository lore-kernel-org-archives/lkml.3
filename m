Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaCFVPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:15:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:20915 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbaCFVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:15:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,603,1389772800"; 
   d="scan'208";a="467966691"
Date: Thu, 6 Mar 2014 13:15:24 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv3 1/4] xhci: Use command structures when queuing commands
 on the command ring
Message-ID: <20140306211524.GA14522@xanatos>
References: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
 <1393443530-9216-2-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393443530-9216-2-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 09:38:47PM +0200, Mathias Nyman wrote:
> To create a global command queue we require that each command put on the
> command ring is submitted with a command structure.
> 
> Functions that queue commands and wait for completion need to allocate a command
> before submitting it, and free it once completed. The following command queuing
> functions need to be modified.
> 
> xhci_configure_endpoint()
> xhci_address_device()
> xhci_queue_slot_control()
> xhci_queue_stop_endpoint()
> xhci_queue_new_dequeue_state()
> xhci_queue_reset_ep()
> xhci_configure_endpoint()
> 
> xhci_configure_endpoint() could already be called with a command structure,
> and only xhci_check_maxpacket and xhci_check_bandwidth did not do so. These
> are changed and a command structure is now required. This change also simplifies
> the configure endpoint command completion handling and the "goto bandwidth_change"
> handling code can be removed.
> 
> In some cases the command queuing function is called in interrupt context.
> These commands needs to be allocated atomically, and they can't wait for
> completion. These commands will in this patch be freed directly after queuing,
> but freeing will be moved to the command completion event handler in a later
> patch once we get the global command queue up.(Just so that we won't leak
> memory in the middle of the patch set)

Mathias, I got the following stack trace while testing this code (along
with Hans' streams changes, although I suspect your code is the issue):

Mar  6 12:03:21 xanatos kernel: [ 1450.106055] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
Mar  6 12:03:22 xanatos kernel: [ 1450.799410] usb 2-2: New USB device found, idVendor=2109, idProduct=0810
Mar  6 12:03:22 xanatos kernel: [ 1450.799419] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Mar  6 12:03:22 xanatos kernel: [ 1450.799423] usb 2-2: Product: 4-Port USB 3.0 Hub
Mar  6 12:03:22 xanatos kernel: [ 1450.799427] usb 2-2: Manufacturer: VIA Labs, Inc.
Mar  6 12:03:22 xanatos kernel: [ 1450.803206] hub 2-2:1.0: USB hub found
Mar  6 12:03:22 xanatos kernel: [ 1450.855282] hub 2-2:1.0: 4 ports detected
Mar  6 12:03:22 xanatos kernel: [ 1450.881379] BUG: sleeping function called from invalid context at mm/slub.c:965
Mar  6 12:03:22 xanatos kernel: [ 1450.881388] in_atomic(): 1, irqs_disabled(): 1, pid: 12761, name: kworker/0:0
Mar  6 12:03:22 xanatos kernel: [ 1450.881392] INFO: lockdep is turned off.
Mar  6 12:03:22 xanatos kernel: [ 1450.881396] irq event stamp: 0
Mar  6 12:03:22 xanatos kernel: [ 1450.881400] hardirqs last  enabled at (0): [<          (null)>]           (null)
Mar  6 12:03:22 xanatos kernel: [ 1450.881404] hardirqs last disabled at (0): [<ffffffff8104885c>] copy_process.part.24+0x60c/0x1be0
Mar  6 12:03:22 xanatos kernel: [ 1450.881416] softirqs last  enabled at (0): [<ffffffff8104885c>] copy_process.part.24+0x60c/0x1be0
Mar  6 12:03:22 xanatos kernel: [ 1450.881425] softirqs last disabled at (0): [<          (null)>]           (null)
Mar  6 12:03:22 xanatos kernel: [ 1450.881433] CPU: 0 PID: 12761 Comm: kworker/0:0 Not tainted 3.14.0-rc5+ #200
Mar  6 12:03:22 xanatos kernel: [ 1450.881436] Hardware name: LENOVO 2325AP7/2325AP7, BIOS G2ET82WW (2.02 ) 09/11/2012
Mar  6 12:03:22 xanatos kernel: [ 1450.881444] Workqueue: pm pm_runtime_work
Mar  6 12:03:22 xanatos kernel: [ 1450.881449]  0000000000000000 ffff880017933770 ffffffff81655c0d 0000000000000010
Mar  6 12:03:22 xanatos kernel: [ 1450.881457]  ffff880017933780 ffffffff81079e0f ffff8800179337c0 ffffffff81195f9e
Mar  6 12:03:22 xanatos kernel: [ 1450.881465]  ffffffffa05aa044 0000000000008010 0000000000000000 0000000000000000
Mar  6 12:03:22 xanatos kernel: [ 1450.881474] Call Trace:
Mar  6 12:03:22 xanatos kernel: [ 1450.881485]  [<ffffffff81655c0d>] dump_stack+0x4d/0x66
Mar  6 12:03:22 xanatos kernel: [ 1450.881493]  [<ffffffff81079e0f>] __might_sleep+0xdf/0x110
Mar  6 12:03:22 xanatos kernel: [ 1450.881502]  [<ffffffff81195f9e>] kmem_cache_alloc_trace+0x4e/0x190
Mar  6 12:03:22 xanatos kernel: [ 1450.881518]  [<ffffffffa05aa044>] ? xhci_alloc_command+0x44/0x150 [xhci_hcd]
Mar  6 12:03:22 xanatos kernel: [ 1450.881530]  [<ffffffffa05aa044>] xhci_alloc_command+0x44/0x150 [xhci_hcd]
Mar  6 12:03:22 xanatos kernel: [ 1450.881543]  [<ffffffffa05b1e48>] xhci_stop_device.constprop.9+0x88/0x1b0 [xhci_hcd]
Mar  6 12:03:22 xanatos kernel: [ 1450.881556]  [<ffffffffa05b2b46>] xhci_hub_control+0xa76/0x1420 [xhci_hcd]
Mar  6 12:03:22 xanatos kernel: [ 1450.881585]  [<ffffffffa003400e>] ? usb_hcd_link_urb_to_ep+0x1e/0xa0 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881596]  [<ffffffff811967cd>] ? __kmalloc+0xfd/0x1e0
Mar  6 12:03:22 xanatos kernel: [ 1450.881622]  [<ffffffffa00363cd>] usb_hcd_submit_urb+0x38d/0xaf0 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881632]  [<ffffffff8116554b>] ? is_kernel_percpu_address+0x4b/0x90
Mar  6 12:03:22 xanatos kernel: [ 1450.881645]  [<ffffffff810d47c6>] ? is_module_address+0x16/0x30
Mar  6 12:03:22 xanatos kernel: [ 1450.881668]  [<ffffffffa0037d8c>] usb_submit_urb+0x31c/0x5c0 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881695]  [<ffffffffa00387c4>] usb_start_wait_urb+0x74/0x190 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881722]  [<ffffffffa00389a5>] usb_control_msg+0xc5/0x110 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881744]  [<ffffffffa002bac8>] set_port_feature+0x48/0x50 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881764]  [<ffffffffa002f28b>] usb_port_suspend+0x15b/0x440 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881790]  [<ffffffffa00456ca>] generic_suspend+0x2a/0x40 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881815]  [<ffffffffa003bd3f>] usb_suspend_both+0x1bf/0x1e0 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881838]  [<ffffffffa003d103>] usb_runtime_suspend+0x33/0x70 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881859]  [<ffffffffa003d0d0>] ? usb_probe_interface+0x300/0x300 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881867]  [<ffffffff81448b52>] __rpm_callback+0x32/0x70
Mar  6 12:03:22 xanatos kernel: [ 1450.881872]  [<ffffffff81448bb4>] rpm_callback+0x24/0x80
Mar  6 12:03:22 xanatos kernel: [ 1450.881878]  [<ffffffff814490c6>] rpm_suspend+0x126/0x6e0
Mar  6 12:03:22 xanatos kernel: [ 1450.881885]  [<ffffffff8144a8dd>] __pm_runtime_suspend+0x5d/0xa0
Mar  6 12:03:22 xanatos kernel: [ 1450.881906]  [<ffffffffa003d160>] ? usb_runtime_resume+0x20/0x20 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881928]  [<ffffffffa003d18a>] usb_runtime_idle+0x2a/0x40 [usbcore]
Mar  6 12:03:22 xanatos kernel: [ 1450.881935]  [<ffffffff81448b52>] __rpm_callback+0x32/0x70
Mar  6 12:03:22 xanatos kernel: [ 1450.881942]  [<ffffffff8144995d>] rpm_idle+0x1ed/0x300
Mar  6 12:03:22 xanatos kernel: [ 1450.881948]  [<ffffffff8144aa5f>] pm_runtime_work+0xbf/0xd0
Mar  6 12:03:22 xanatos kernel: [ 1450.881956]  [<ffffffff81069184>] process_one_work+0x1f4/0x550
Mar  6 12:03:22 xanatos kernel: [ 1450.881962]  [<ffffffff81069122>] ? process_one_work+0x192/0x550
Mar  6 12:03:22 xanatos kernel: [ 1450.881968]  [<ffffffff81069ec1>] worker_thread+0x121/0x3a0
Mar  6 12:03:22 xanatos kernel: [ 1450.881975]  [<ffffffff81069da0>] ? manage_workers.isra.22+0x2a0/0x2a0
Mar  6 12:03:22 xanatos kernel: [ 1450.881982]  [<ffffffff8107084c>] kthread+0xfc/0x120
Mar  6 12:03:22 xanatos kernel: [ 1450.881990]  [<ffffffff81070750>] ? kthread_create_on_node+0x230/0x230
Mar  6 12:03:22 xanatos kernel: [ 1450.881999]  [<ffffffff816677ec>] ret_from_fork+0x7c/0xb0
Mar  6 12:03:22 xanatos kernel: [ 1450.882005]  [<ffffffff81070750>] ? kthread_create_on_node+0x230/0x230

Can you fix this in a second revision?  (Note, this does not take
priority over reverting those two patches that are causing regressions.
Let me know if you need any help with that.)

Sarah Sharp


> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-hub.c  |  21 +++--
>  drivers/usb/host/xhci-ring.c | 105 ++++++++++++-----------
>  drivers/usb/host/xhci.c      | 194 ++++++++++++++++++++++++++++---------------
>  drivers/usb/host/xhci.h      |  31 +++----
>  4 files changed, 214 insertions(+), 137 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
> index 9992fbf..fb0f936 100644
> --- a/drivers/usb/host/xhci-hub.c
> +++ b/drivers/usb/host/xhci-hub.c
> @@ -20,7 +20,8 @@
>   * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> -#include <linux/gfp.h>
> +
> +#include <linux/slab.h>
>  #include <asm/unaligned.h>
>  
>  #include "xhci.h"
> @@ -284,12 +285,22 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
>  
>  	spin_lock_irqsave(&xhci->lock, flags);
>  	for (i = LAST_EP_INDEX; i > 0; i--) {
> -		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue)
> -			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
> +		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue) {
> +			struct xhci_command *command;
> +			command = xhci_alloc_command(xhci, false, false,
> +						     GFP_NOIO);

This GFP_NOIO should be GFP_ATOMIC, since you're holding the spinlock.
I'll fix that in your patch, since the code seems to be working fine
otherwise.

(Note, fixing this does not take priority over sending those two reverts
to Greg.  Let me know if you need help figuring out how to send a revert
patch.)

Sarah Sharp

> +			if (!command) {
> +				spin_unlock_irqrestore(&xhci->lock, flags);
> +				xhci_free_command(xhci, cmd);
> +				return -ENOMEM;
> +
> +			}
> +			xhci_queue_stop_endpoint(xhci, command, slot_id, i,
> +						 suspend);
> +		}
>  	}
> -	cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
>  	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
> -	xhci_queue_stop_endpoint(xhci, slot_id, 0, suspend);
> +	xhci_queue_stop_endpoint(xhci, cmd, slot_id, 0, suspend);
>  	xhci_ring_cmd_db(xhci);
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 0ed64eb..fa34c9b 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -123,16 +123,6 @@ static int enqueue_is_link_trb(struct xhci_ring *ring)
>  	return TRB_TYPE_LINK_LE32(link->control);
>  }
>  
> -union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring)
> -{
> -	/* Enqueue pointer can be left pointing to the link TRB,
> -	 * we must handle that
> -	 */
> -	if (TRB_TYPE_LINK_LE32(ring->enqueue->link.control))
> -		return ring->enq_seg->next->trbs;
> -	return ring->enqueue;
> -}
> -
>  /* Updates trb to point to the next TRB in the ring, and updates seg if the next
>   * TRB is in a new segment.  This does not skip over link TRBs, and it does not
>   * effect the ring dequeue or enqueue pointers.
> @@ -674,12 +664,14 @@ static void td_to_noop(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
>  	}
>  }
>  
> -static int queue_set_tr_deq(struct xhci_hcd *xhci, int slot_id,
> +static int queue_set_tr_deq(struct xhci_hcd *xhci,
> +		struct xhci_command *cmd, int slot_id,
>  		unsigned int ep_index, unsigned int stream_id,
>  		struct xhci_segment *deq_seg,
>  		union xhci_trb *deq_ptr, u32 cycle_state);
>  
>  void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
> +		struct xhci_command *cmd,
>  		unsigned int slot_id, unsigned int ep_index,
>  		unsigned int stream_id,
>  		struct xhci_dequeue_state *deq_state)
> @@ -694,7 +686,7 @@ void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
>  			deq_state->new_deq_ptr,
>  			(unsigned long long)xhci_trb_virt_to_dma(deq_state->new_deq_seg, deq_state->new_deq_ptr),
>  			deq_state->new_cycle_state);
> -	queue_set_tr_deq(xhci, slot_id, ep_index, stream_id,
> +	queue_set_tr_deq(xhci, cmd, slot_id, ep_index, stream_id,
>  			deq_state->new_deq_seg,
>  			deq_state->new_deq_ptr,
>  			(u32) deq_state->new_cycle_state);
> @@ -849,7 +841,9 @@ remove_finished_td:
>  
>  	/* If necessary, queue a Set Transfer Ring Dequeue Pointer command */
>  	if (deq_state.new_deq_ptr && deq_state.new_deq_seg) {
> -		xhci_queue_new_dequeue_state(xhci,
> +		struct xhci_command *command;
> +		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
> +		xhci_queue_new_dequeue_state(xhci, command,
>  				slot_id, ep_index,
>  				ep->stopped_td->urb->stream_id,
>  				&deq_state);
> @@ -1174,9 +1168,11 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
>  	 * because the HW can't handle two commands being queued in a row.
>  	 */
>  	if (xhci->quirks & XHCI_RESET_EP_QUIRK) {
> +		struct xhci_command *command;
> +		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
>  		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
>  				"Queueing configure endpoint command");
> -		xhci_queue_configure_endpoint(xhci,
> +		xhci_queue_configure_endpoint(xhci, command,
>  				xhci->devs[slot_id]->in_ctx->dma, slot_id,
>  				false);
>  		xhci_ring_cmd_db(xhci);
> @@ -1433,7 +1429,7 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
>  			add_flags - SLOT_FLAG == drop_flags) {
>  		ep_state = virt_dev->eps[ep_index].ep_state;
>  		if (!(ep_state & EP_HALTED))
> -			goto bandwidth_change;
> +			return;
>  		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
>  				"Completed config ep cmd - "
>  				"last ep index = %d, state = %d",
> @@ -1443,11 +1439,6 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
>  		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
>  		return;
>  	}
> -bandwidth_change:
> -	xhci_dbg_trace(xhci,  trace_xhci_dbg_context_change,
> -			"Completed config ep cmd");
> -	virt_dev->cmd_status = cmd_comp_code;
> -	complete(&virt_dev->cmd_completion);
>  	return;
>  }
>  
> @@ -1906,12 +1897,16 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
>  		struct xhci_td *td, union xhci_trb *event_trb)
>  {
>  	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
> +	struct xhci_command *command;
> +	command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
> +	if (!command)
> +		return;
>  	ep->ep_state |= EP_HALTED;
>  	ep->stopped_td = td;
>  	ep->stopped_trb = event_trb;
>  	ep->stopped_stream = stream_id;
>  
> -	xhci_queue_reset_ep(xhci, slot_id, ep_index);
> +	xhci_queue_reset_ep(xhci, command, slot_id, ep_index);
>  	xhci_cleanup_stalled_ring(xhci, td->urb->dev, ep_index);
>  
>  	ep->stopped_td = NULL;
> @@ -2626,7 +2621,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
>  				 * successful event after a short transfer.
>  				 * Ignore it.
>  				 */
> -				if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) && 
> +				if ((xhci->quirks & XHCI_SPURIOUS_SUCCESS) &&
>  						ep_ring->last_td_was_short) {
>  					ep_ring->last_td_was_short = false;
>  					ret = 0;
> @@ -3968,8 +3963,9 @@ int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
>   * Don't decrement xhci->cmd_ring_reserved_trbs after we've queued the TRB
>   * because the command event handler may want to resubmit a failed command.
>   */
> -static int queue_command(struct xhci_hcd *xhci, u32 field1, u32 field2,
> -		u32 field3, u32 field4, bool command_must_succeed)
> +static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +			 u32 field1, u32 field2,
> +			 u32 field3, u32 field4, bool command_must_succeed)
>  {
>  	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
>  	int ret;
> @@ -3986,57 +3982,65 @@ static int queue_command(struct xhci_hcd *xhci, u32 field1, u32 field2,
>  					"unfailable commands failed.\n");
>  		return ret;
>  	}
> +	if (cmd->completion)
> +		cmd->command_trb = xhci->cmd_ring->enqueue;
> +	else
> +		kfree(cmd);
> +
>  	queue_trb(xhci, xhci->cmd_ring, false, field1, field2, field3,
>  			field4 | xhci->cmd_ring->cycle_state);
>  	return 0;
>  }
>  
>  /* Queue a slot enable or disable request on the command ring */
> -int xhci_queue_slot_control(struct xhci_hcd *xhci, u32 trb_type, u32 slot_id)
> +int xhci_queue_slot_control(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		u32 trb_type, u32 slot_id)
>  {
> -	return queue_command(xhci, 0, 0, 0,
> +	return queue_command(xhci, cmd, 0, 0, 0,
>  			TRB_TYPE(trb_type) | SLOT_ID_FOR_TRB(slot_id), false);
>  }
>  
>  /* Queue an address device command TRB */
> -int xhci_queue_address_device(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
> -			      u32 slot_id, enum xhci_setup_dev setup)
> +int xhci_queue_address_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		dma_addr_t in_ctx_ptr, u32 slot_id, enum xhci_setup_dev setup)
>  {
> -	return queue_command(xhci, lower_32_bits(in_ctx_ptr),
> +	return queue_command(xhci, cmd, lower_32_bits(in_ctx_ptr),
>  			upper_32_bits(in_ctx_ptr), 0,
>  			TRB_TYPE(TRB_ADDR_DEV) | SLOT_ID_FOR_TRB(slot_id)
>  			| (setup == SETUP_CONTEXT_ONLY ? TRB_BSR : 0), false);
>  }
>  
> -int xhci_queue_vendor_command(struct xhci_hcd *xhci,
> +int xhci_queue_vendor_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
>  		u32 field1, u32 field2, u32 field3, u32 field4)
>  {
> -	return queue_command(xhci, field1, field2, field3, field4, false);
> +	return queue_command(xhci, cmd, field1, field2, field3, field4, false);
>  }
>  
>  /* Queue a reset device command TRB */
> -int xhci_queue_reset_device(struct xhci_hcd *xhci, u32 slot_id)
> +int xhci_queue_reset_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		u32 slot_id)
>  {
> -	return queue_command(xhci, 0, 0, 0,
> +	return queue_command(xhci, cmd, 0, 0, 0,
>  			TRB_TYPE(TRB_RESET_DEV) | SLOT_ID_FOR_TRB(slot_id),
>  			false);
>  }
>  
>  /* Queue a configure endpoint command TRB */
> -int xhci_queue_configure_endpoint(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
> +int xhci_queue_configure_endpoint(struct xhci_hcd *xhci,
> +		struct xhci_command *cmd, dma_addr_t in_ctx_ptr,
>  		u32 slot_id, bool command_must_succeed)
>  {
> -	return queue_command(xhci, lower_32_bits(in_ctx_ptr),
> +	return queue_command(xhci, cmd, lower_32_bits(in_ctx_ptr),
>  			upper_32_bits(in_ctx_ptr), 0,
>  			TRB_TYPE(TRB_CONFIG_EP) | SLOT_ID_FOR_TRB(slot_id),
>  			command_must_succeed);
>  }
>  
>  /* Queue an evaluate context command TRB */
> -int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
> -		u32 slot_id, bool command_must_succeed)
> +int xhci_queue_evaluate_context(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		dma_addr_t in_ctx_ptr, u32 slot_id, bool command_must_succeed)
>  {
> -	return queue_command(xhci, lower_32_bits(in_ctx_ptr),
> +	return queue_command(xhci, cmd, lower_32_bits(in_ctx_ptr),
>  			upper_32_bits(in_ctx_ptr), 0,
>  			TRB_TYPE(TRB_EVAL_CONTEXT) | SLOT_ID_FOR_TRB(slot_id),
>  			command_must_succeed);
> @@ -4046,25 +4050,26 @@ int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
>   * Suspend is set to indicate "Stop Endpoint Command" is being issued to stop
>   * activity on an endpoint that is about to be suspended.
>   */
> -int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, int slot_id,
> -		unsigned int ep_index, int suspend)
> +int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +			     int slot_id, unsigned int ep_index, int suspend)
>  {
>  	u32 trb_slot_id = SLOT_ID_FOR_TRB(slot_id);
>  	u32 trb_ep_index = EP_ID_FOR_TRB(ep_index);
>  	u32 type = TRB_TYPE(TRB_STOP_RING);
>  	u32 trb_suspend = SUSPEND_PORT_FOR_TRB(suspend);
>  
> -	return queue_command(xhci, 0, 0, 0,
> +	return queue_command(xhci, cmd, 0, 0, 0,
>  			trb_slot_id | trb_ep_index | type | trb_suspend, false);
>  }
>  
>  /* Set Transfer Ring Dequeue Pointer command.
>   * This should not be used for endpoints that have streams enabled.
>   */
> -static int queue_set_tr_deq(struct xhci_hcd *xhci, int slot_id,
> -		unsigned int ep_index, unsigned int stream_id,
> -		struct xhci_segment *deq_seg,
> -		union xhci_trb *deq_ptr, u32 cycle_state)
> +static int queue_set_tr_deq(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +			int slot_id,
> +			unsigned int ep_index, unsigned int stream_id,
> +			struct xhci_segment *deq_seg,
> +			union xhci_trb *deq_ptr, u32 cycle_state)
>  {
>  	dma_addr_t addr;
>  	u32 trb_slot_id = SLOT_ID_FOR_TRB(slot_id);
> @@ -4088,18 +4093,18 @@ static int queue_set_tr_deq(struct xhci_hcd *xhci, int slot_id,
>  	}
>  	ep->queued_deq_seg = deq_seg;
>  	ep->queued_deq_ptr = deq_ptr;
> -	return queue_command(xhci, lower_32_bits(addr) | cycle_state,
> +	return queue_command(xhci, cmd, lower_32_bits(addr) | cycle_state,
>  			upper_32_bits(addr), trb_stream_id,
>  			trb_slot_id | trb_ep_index | type, false);
>  }
>  
> -int xhci_queue_reset_ep(struct xhci_hcd *xhci, int slot_id,
> -		unsigned int ep_index)
> +int xhci_queue_reset_ep(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +			int slot_id, unsigned int ep_index)
>  {
>  	u32 trb_slot_id = SLOT_ID_FOR_TRB(slot_id);
>  	u32 trb_ep_index = EP_ID_FOR_TRB(ep_index);
>  	u32 type = TRB_TYPE(TRB_RESET_EP);
>  
> -	return queue_command(xhci, 0, 0, 0, trb_slot_id | trb_ep_index | type,
> -			false);
> +	return queue_command(xhci, cmd, 0, 0, 0,
> +			     trb_slot_id | trb_ep_index | type, false);
>  }
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 6fe577d..8bf2aa3 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -637,10 +637,14 @@ int xhci_run(struct usb_hcd *hcd)
>  	writel(ER_IRQ_ENABLE(temp), &xhci->ir_set->irq_pending);
>  	xhci_print_ir_set(xhci, 0);
>  
> -	if (xhci->quirks & XHCI_NEC_HOST)
> -		xhci_queue_vendor_command(xhci, 0, 0, 0,
> +	if (xhci->quirks & XHCI_NEC_HOST) {
> +		struct xhci_command *command;
> +		command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
> +		if (!command)
> +			return -ENOMEM;
> +		xhci_queue_vendor_command(xhci, command, 0, 0, 0,
>  				TRB_TYPE(TRB_NEC_GET_FW));
> -
> +	}
>  	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
>  			"Finished xhci_run for USB2 roothub");
>  	return 0;
> @@ -1183,10 +1187,10 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
>  		unsigned int ep_index, struct urb *urb)
>  {
> -	struct xhci_container_ctx *in_ctx;
>  	struct xhci_container_ctx *out_ctx;
>  	struct xhci_input_control_ctx *ctrl_ctx;
>  	struct xhci_ep_ctx *ep_ctx;
> +	struct xhci_command *command;
>  	int max_packet_size;
>  	int hw_max_packet_size;
>  	int ret = 0;
> @@ -1211,18 +1215,24 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
>  		/* FIXME: This won't work if a non-default control endpoint
>  		 * changes max packet sizes.
>  		 */
> -		in_ctx = xhci->devs[slot_id]->in_ctx;
> -		ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
> +
> +		command = xhci_alloc_command(xhci, false, true, GFP_KERNEL);
> +		if (!command)
> +			return -ENOMEM;
> +
> +		command->in_ctx = xhci->devs[slot_id]->in_ctx;
> +		ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
>  		if (!ctrl_ctx) {
>  			xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
>  					__func__);
> -			return -ENOMEM;
> +			ret = -ENOMEM;
> +			goto command_cleanup;
>  		}
>  		/* Set up the modified control endpoint 0 */
>  		xhci_endpoint_copy(xhci, xhci->devs[slot_id]->in_ctx,
>  				xhci->devs[slot_id]->out_ctx, ep_index);
>  
> -		ep_ctx = xhci_get_ep_ctx(xhci, in_ctx, ep_index);
> +		ep_ctx = xhci_get_ep_ctx(xhci, command->in_ctx, ep_index);
>  		ep_ctx->ep_info2 &= cpu_to_le32(~MAX_PACKET_MASK);
>  		ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet_size));
>  
> @@ -1230,17 +1240,20 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
>  		ctrl_ctx->drop_flags = 0;
>  
>  		xhci_dbg(xhci, "Slot %d input context\n", slot_id);
> -		xhci_dbg_ctx(xhci, in_ctx, ep_index);
> +		xhci_dbg_ctx(xhci, command->in_ctx, ep_index);
>  		xhci_dbg(xhci, "Slot %d output context\n", slot_id);
>  		xhci_dbg_ctx(xhci, out_ctx, ep_index);
>  
> -		ret = xhci_configure_endpoint(xhci, urb->dev, NULL,
> +		ret = xhci_configure_endpoint(xhci, urb->dev, command,
>  				true, false);
>  
>  		/* Clean up the input context for later use by bandwidth
>  		 * functions.
>  		 */
>  		ctrl_ctx->add_flags = cpu_to_le32(SLOT_FLAG);
> +command_cleanup:
> +		kfree(command->completion);
> +		kfree(command);
>  	}
>  	return ret;
>  }
> @@ -1461,6 +1474,7 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
>  	unsigned int ep_index;
>  	struct xhci_ring *ep_ring;
>  	struct xhci_virt_ep *ep;
> +	struct xhci_command *command;
>  
>  	xhci = hcd_to_xhci(hcd);
>  	spin_lock_irqsave(&xhci->lock, flags);
> @@ -1530,12 +1544,14 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
>  	 * the first cancellation to be handled.
>  	 */
>  	if (!(ep->ep_state & EP_HALT_PENDING)) {
> +		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
>  		ep->ep_state |= EP_HALT_PENDING;
>  		ep->stop_cmds_pending++;
>  		ep->stop_cmd_timer.expires = jiffies +
>  			XHCI_STOP_EP_CMD_TIMEOUT * HZ;
>  		add_timer(&ep->stop_cmd_timer);
> -		xhci_queue_stop_endpoint(xhci, urb->dev->slot_id, ep_index, 0);
> +		xhci_queue_stop_endpoint(xhci, command, urb->dev->slot_id,
> +					 ep_index, 0);
>  		xhci_ring_cmd_db(xhci);
>  	}
>  done:
> @@ -2572,21 +2588,16 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  	int ret;
>  	int timeleft;
>  	unsigned long flags;
> -	struct xhci_container_ctx *in_ctx;
>  	struct xhci_input_control_ctx *ctrl_ctx;
> -	struct completion *cmd_completion;
> -	u32 *cmd_status;
>  	struct xhci_virt_device *virt_dev;
> -	union xhci_trb *cmd_trb;
> +
> +	if (!command)
> +		return -EINVAL;
>  
>  	spin_lock_irqsave(&xhci->lock, flags);
>  	virt_dev = xhci->devs[udev->slot_id];
>  
> -	if (command)
> -		in_ctx = command->in_ctx;
> -	else
> -		in_ctx = virt_dev->in_ctx;
> -	ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
> +	ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
>  	if (!ctrl_ctx) {
>  		spin_unlock_irqrestore(&xhci->lock, flags);
>  		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
> @@ -2603,7 +2614,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  		return -ENOMEM;
>  	}
>  	if ((xhci->quirks & XHCI_SW_BW_CHECKING) &&
> -			xhci_reserve_bandwidth(xhci, virt_dev, in_ctx)) {
> +	    xhci_reserve_bandwidth(xhci, virt_dev, command->in_ctx)) {
>  		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
>  			xhci_free_host_resources(xhci, ctrl_ctx);
>  		spin_unlock_irqrestore(&xhci->lock, flags);
> @@ -2611,27 +2622,18 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  		return -ENOMEM;
>  	}
>  
> -	if (command) {
> -		cmd_completion = command->completion;
> -		cmd_status = &command->status;
> -		command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
> -		list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
> -	} else {
> -		cmd_completion = &virt_dev->cmd_completion;
> -		cmd_status = &virt_dev->cmd_status;
> -	}
> -	init_completion(cmd_completion);
> +	list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
>  
> -	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
>  	if (!ctx_change)
> -		ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,
> +		ret = xhci_queue_configure_endpoint(xhci, command,
> +				command->in_ctx->dma,
>  				udev->slot_id, must_succeed);
>  	else
> -		ret = xhci_queue_evaluate_context(xhci, in_ctx->dma,
> +		ret = xhci_queue_evaluate_context(xhci, command,
> +				command->in_ctx->dma,
>  				udev->slot_id, must_succeed);
>  	if (ret < 0) {
> -		if (command)
> -			list_del(&command->cmd_list);
> +		list_del(&command->cmd_list);
>  		if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
>  			xhci_free_host_resources(xhci, ctrl_ctx);
>  		spin_unlock_irqrestore(&xhci->lock, flags);
> @@ -2644,7 +2646,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  
>  	/* Wait for the configure endpoint command to complete */
>  	timeleft = wait_for_completion_interruptible_timeout(
> -			cmd_completion,
> +			command->completion,
>  			XHCI_CMD_DEFAULT_TIMEOUT);
>  	if (timeleft <= 0) {
>  		xhci_warn(xhci, "%s while waiting for %s command\n",
> @@ -2653,16 +2655,18 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  					"configure endpoint" :
>  					"evaluate context");
>  		/* cancel the configure endpoint command */
> -		ret = xhci_cancel_cmd(xhci, command, cmd_trb);
> +		ret = xhci_cancel_cmd(xhci, command, command->command_trb);
>  		if (ret < 0)
>  			return ret;
>  		return -ETIME;
>  	}
>  
>  	if (!ctx_change)
> -		ret = xhci_configure_endpoint_result(xhci, udev, cmd_status);
> +		ret = xhci_configure_endpoint_result(xhci, udev,
> +						     &command->status);
>  	else
> -		ret = xhci_evaluate_context_result(xhci, udev, cmd_status);
> +		ret = xhci_evaluate_context_result(xhci, udev,
> +						   &command->status);
>  
>  	if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK)) {
>  		spin_lock_irqsave(&xhci->lock, flags);
> @@ -2696,6 +2700,7 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>  	struct xhci_virt_device	*virt_dev;
>  	struct xhci_input_control_ctx *ctrl_ctx;
>  	struct xhci_slot_ctx *slot_ctx;
> +	struct xhci_command *command;
>  
>  	ret = xhci_check_args(hcd, udev, NULL, 0, true, __func__);
>  	if (ret <= 0)
> @@ -2707,12 +2712,19 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>  	xhci_dbg(xhci, "%s called for udev %p\n", __func__, udev);
>  	virt_dev = xhci->devs[udev->slot_id];
>  
> +	command = xhci_alloc_command(xhci, false, true, GFP_KERNEL);
> +	if (!command)
> +		return -ENOMEM;
> +
> +	command->in_ctx = virt_dev->in_ctx;
> +
>  	/* See section 4.6.6 - A0 = 1; A1 = D0 = D1 = 0 */
> -	ctrl_ctx = xhci_get_input_control_ctx(xhci, virt_dev->in_ctx);
> +	ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
>  	if (!ctrl_ctx) {
>  		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
>  				__func__);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto command_cleanup;
>  	}
>  	ctrl_ctx->add_flags |= cpu_to_le32(SLOT_FLAG);
>  	ctrl_ctx->add_flags &= cpu_to_le32(~EP0_FLAG);
> @@ -2720,20 +2732,20 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>  
>  	/* Don't issue the command if there's no endpoints to update. */
>  	if (ctrl_ctx->add_flags == cpu_to_le32(SLOT_FLAG) &&
> -			ctrl_ctx->drop_flags == 0)
> -		return 0;
> -
> +	    ctrl_ctx->drop_flags == 0) {
> +		ret = 0;
> +		goto command_cleanup;
> +	}
>  	xhci_dbg(xhci, "New Input Control Context:\n");
>  	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
>  	xhci_dbg_ctx(xhci, virt_dev->in_ctx,
>  		     LAST_CTX_TO_EP_NUM(le32_to_cpu(slot_ctx->dev_info)));
>  
> -	ret = xhci_configure_endpoint(xhci, udev, NULL,
> +	ret = xhci_configure_endpoint(xhci, udev, command,
>  			false, false);
> -	if (ret) {
> +	if (ret)
>  		/* Callee should call reset_bandwidth() */
> -		return ret;
> -	}
> +		goto command_cleanup;
>  
>  	xhci_dbg(xhci, "Output context after successful config ep cmd:\n");
>  	xhci_dbg_ctx(xhci, virt_dev->out_ctx,
> @@ -2762,6 +2774,9 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
>  		virt_dev->eps[i].ring = virt_dev->eps[i].new_ring;
>  		virt_dev->eps[i].new_ring = NULL;
>  	}
> +command_cleanup:
> +	kfree(command->completion);
> +	kfree(command);
>  
>  	return ret;
>  }
> @@ -2863,9 +2878,14 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
>  	 * issue a configure endpoint command later.
>  	 */
>  	if (!(xhci->quirks & XHCI_RESET_EP_QUIRK)) {
> +		struct xhci_command *command;
> +		/* Can't sleep if we're called from cleanup_halted_endpoint() */
> +		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
> +		if (!command)
> +			return;
>  		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
>  				"Queueing new dequeue state");
> -		xhci_queue_new_dequeue_state(xhci, udev->slot_id,
> +		xhci_queue_new_dequeue_state(xhci, command, udev->slot_id,
>  				ep_index, ep->stopped_stream, &deq_state);
>  	} else {
>  		/* Better hope no one uses the input context between now and the
> @@ -2896,6 +2916,7 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
>  	unsigned long flags;
>  	int ret;
>  	struct xhci_virt_ep *virt_ep;
> +	struct xhci_command *command;
>  
>  	xhci = hcd_to_xhci(hcd);
>  	udev = (struct usb_device *) ep->hcpriv;
> @@ -2918,10 +2939,14 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
>  		return;
>  	}
>  
> +	command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
> +	if (!command)
> +		return;
> +
>  	xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
>  			"Queueing reset endpoint command");
>  	spin_lock_irqsave(&xhci->lock, flags);
> -	ret = xhci_queue_reset_ep(xhci, udev->slot_id, ep_index);
> +	ret = xhci_queue_reset_ep(xhci, command, udev->slot_id, ep_index);
>  	/*
>  	 * Can't change the ring dequeue pointer until it's transitioned to the
>  	 * stopped state, which is only upon a successful reset endpoint
> @@ -3447,10 +3472,9 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>  
>  	/* Attempt to submit the Reset Device command to the command ring */
>  	spin_lock_irqsave(&xhci->lock, flags);
> -	reset_device_cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
>  
>  	list_add_tail(&reset_device_cmd->cmd_list, &virt_dev->cmd_list);
> -	ret = xhci_queue_reset_device(xhci, slot_id);
> +	ret = xhci_queue_reset_device(xhci, reset_device_cmd, slot_id);
>  	if (ret) {
>  		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
>  		list_del(&reset_device_cmd->cmd_list);
> @@ -3561,6 +3585,11 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  	unsigned long flags;
>  	u32 state;
>  	int i, ret;
> +	struct xhci_command *command;
> +
> +	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
> +	if (!command)
> +		return;
>  
>  #ifndef CONFIG_USB_DEFAULT_PERSIST
>  	/*
> @@ -3576,8 +3605,10 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  	/* If the host is halted due to driver unload, we still need to free the
>  	 * device.
>  	 */
> -	if (ret <= 0 && ret != -ENODEV)
> +	if (ret <= 0 && ret != -ENODEV) {
> +		kfree(command);
>  		return;
> +	}
>  
>  	virt_dev = xhci->devs[udev->slot_id];
>  
> @@ -3594,16 +3625,19 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  			(xhci->xhc_state & XHCI_STATE_HALTED)) {
>  		xhci_free_virt_device(xhci, udev->slot_id);
>  		spin_unlock_irqrestore(&xhci->lock, flags);
> +		kfree(command);
>  		return;
>  	}
>  
> -	if (xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id)) {
> +	if (xhci_queue_slot_control(xhci, command, TRB_DISABLE_SLOT,
> +				    udev->slot_id)) {
>  		spin_unlock_irqrestore(&xhci->lock, flags);
>  		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
>  		return;
>  	}
>  	xhci_ring_cmd_db(xhci);
>  	spin_unlock_irqrestore(&xhci->lock, flags);
> +
>  	/*
>  	 * Event command completion handler will free any data structures
>  	 * associated with the slot.  XXX Can free sleep?
> @@ -3643,31 +3677,40 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  	unsigned long flags;
>  	int timeleft;
>  	int ret;
> -	union xhci_trb *cmd_trb;
> +	struct xhci_command *command;
> +
> +	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
> +	if (!command)
> +		return 0;
>  
>  	spin_lock_irqsave(&xhci->lock, flags);
> -	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
> -	ret = xhci_queue_slot_control(xhci, TRB_ENABLE_SLOT, 0);
> +	command->completion = &xhci->addr_dev;
> +	ret = xhci_queue_slot_control(xhci, command, TRB_ENABLE_SLOT, 0);
>  	if (ret) {
>  		spin_unlock_irqrestore(&xhci->lock, flags);
>  		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
> +		kfree(command);
>  		return 0;
>  	}
>  	xhci_ring_cmd_db(xhci);
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
>  	/* XXX: how much time for xHC slot assignment? */
> -	timeleft = wait_for_completion_interruptible_timeout(&xhci->addr_dev,
> +	timeleft = wait_for_completion_interruptible_timeout(
> +			command->completion,
>  			XHCI_CMD_DEFAULT_TIMEOUT);
>  	if (timeleft <= 0) {
>  		xhci_warn(xhci, "%s while waiting for a slot\n",
>  				timeleft == 0 ? "Timeout" : "Signal");
>  		/* cancel the enable slot request */
> -		return xhci_cancel_cmd(xhci, NULL, cmd_trb);
> +		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
> +		kfree(command);
> +		return ret;
>  	}
>  
>  	if (!xhci->slot_id) {
>  		xhci_err(xhci, "Error while assigning device slot ID\n");
> +		kfree(command);
>  		return 0;
>  	}
>  
> @@ -3702,6 +3745,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  		pm_runtime_get_noresume(hcd->self.controller);
>  #endif
>  
> +
> +	kfree(command);
>  	/* Is this a LS or FS device under a HS hub? */
>  	/* Hub or peripherial? */
>  	return 1;
> @@ -3709,7 +3754,10 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
>  disable_slot:
>  	/* Disable slot, if we can do it without mem alloc */
>  	spin_lock_irqsave(&xhci->lock, flags);
> -	if (!xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id))
> +	command->completion = NULL;
> +	command->status = 0;
> +	if (!xhci_queue_slot_control(xhci, command, TRB_DISABLE_SLOT,
> +				     udev->slot_id))
>  		xhci_ring_cmd_db(xhci);
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  	return 0;
> @@ -3733,7 +3781,7 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  	struct xhci_slot_ctx *slot_ctx;
>  	struct xhci_input_control_ctx *ctrl_ctx;
>  	u64 temp_64;
> -	union xhci_trb *cmd_trb;
> +	struct xhci_command *command;
>  
>  	if (!udev->slot_id) {
>  		xhci_dbg_trace(xhci, trace_xhci_dbg_address,
> @@ -3754,11 +3802,19 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  		return -EINVAL;
>  	}
>  
> +	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
> +	if (!command)
> +		return -ENOMEM;
> +
> +	command->in_ctx = virt_dev->in_ctx;
> +	command->completion = &xhci->addr_dev;
> +
>  	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
>  	ctrl_ctx = xhci_get_input_control_ctx(xhci, virt_dev->in_ctx);
>  	if (!ctrl_ctx) {
>  		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
>  				__func__);
> +		kfree(command);
>  		return -EINVAL;
>  	}
>  	/*
> @@ -3780,21 +3836,21 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  				le32_to_cpu(slot_ctx->dev_info) >> 27);
>  
>  	spin_lock_irqsave(&xhci->lock, flags);
> -	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
> -	ret = xhci_queue_address_device(xhci, virt_dev->in_ctx->dma,
> +	ret = xhci_queue_address_device(xhci, command, virt_dev->in_ctx->dma,
>  					udev->slot_id, setup);
>  	if (ret) {
>  		spin_unlock_irqrestore(&xhci->lock, flags);
>  		xhci_dbg_trace(xhci, trace_xhci_dbg_address,
>  				"FIXME: allocate a command ring segment");
> +		kfree(command);
>  		return ret;
>  	}
>  	xhci_ring_cmd_db(xhci);
>  	spin_unlock_irqrestore(&xhci->lock, flags);
>  
>  	/* ctrl tx can take up to 5 sec; XXX: need more time for xHC? */
> -	timeleft = wait_for_completion_interruptible_timeout(&xhci->addr_dev,
> -			XHCI_CMD_DEFAULT_TIMEOUT);
> +	timeleft = wait_for_completion_interruptible_timeout(
> +			command->completion, XHCI_CMD_DEFAULT_TIMEOUT);
>  	/* FIXME: From section 4.3.4: "Software shall be responsible for timing
>  	 * the SetAddress() "recovery interval" required by USB and aborting the
>  	 * command on a timeout.
> @@ -3803,7 +3859,8 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  		xhci_warn(xhci, "%s while waiting for setup %s command\n",
>  			  timeleft == 0 ? "Timeout" : "Signal", act);
>  		/* cancel the address device command */
> -		ret = xhci_cancel_cmd(xhci, NULL, cmd_trb);
> +		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
> +		kfree(command);
>  		if (ret < 0)
>  			return ret;
>  		return -ETIME;
> @@ -3840,6 +3897,7 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  		break;
>  	}
>  	if (ret) {
> +		kfree(command);
>  		return ret;
>  	}
>  	temp_64 = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
> @@ -3874,7 +3932,7 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
>  	xhci_dbg_trace(xhci, trace_xhci_dbg_address,
>  		       "Internal device address = %d",
>  		       le32_to_cpu(slot_ctx->dev_state) & DEV_ADDR_MASK);
> -
> +	kfree(command);
>  	return 0;
>  }
>  
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index 58ed9d0..083ff11 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1807,13 +1807,14 @@ struct xhci_segment *trb_in_td(struct xhci_segment *start_seg,
>  		dma_addr_t suspect_dma);
>  int xhci_is_vendor_info_code(struct xhci_hcd *xhci, unsigned int trb_comp_code);
>  void xhci_ring_cmd_db(struct xhci_hcd *xhci);
> -int xhci_queue_slot_control(struct xhci_hcd *xhci, u32 trb_type, u32 slot_id);
> -int xhci_queue_address_device(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
> -		u32 slot_id, enum xhci_setup_dev);
> -int xhci_queue_vendor_command(struct xhci_hcd *xhci,
> +int xhci_queue_slot_control(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		u32 trb_type, u32 slot_id);
> +int xhci_queue_address_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		dma_addr_t in_ctx_ptr, u32 slot_id, enum xhci_setup_dev);
> +int xhci_queue_vendor_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
>  		u32 field1, u32 field2, u32 field3, u32 field4);
> -int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, int slot_id,
> -		unsigned int ep_index, int suspend);
> +int xhci_queue_stop_endpoint(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		int slot_id, unsigned int ep_index, int suspend);
>  int xhci_queue_ctrl_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
>  		int slot_id, unsigned int ep_index);
>  int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
> @@ -1822,18 +1823,21 @@ int xhci_queue_intr_tx(struct xhci_hcd *xhci, gfp_t mem_flags, struct urb *urb,
>  		int slot_id, unsigned int ep_index);
>  int xhci_queue_isoc_tx_prepare(struct xhci_hcd *xhci, gfp_t mem_flags,
>  		struct urb *urb, int slot_id, unsigned int ep_index);
> -int xhci_queue_configure_endpoint(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
> -		u32 slot_id, bool command_must_succeed);
> -int xhci_queue_evaluate_context(struct xhci_hcd *xhci, dma_addr_t in_ctx_ptr,
> -		u32 slot_id, bool command_must_succeed);
> -int xhci_queue_reset_ep(struct xhci_hcd *xhci, int slot_id,
> -		unsigned int ep_index);
> -int xhci_queue_reset_device(struct xhci_hcd *xhci, u32 slot_id);
> +int xhci_queue_configure_endpoint(struct xhci_hcd *xhci,
> +		struct xhci_command *cmd, dma_addr_t in_ctx_ptr, u32 slot_id,
> +		bool command_must_succeed);
> +int xhci_queue_evaluate_context(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		dma_addr_t in_ctx_ptr, u32 slot_id, bool command_must_succeed);
> +int xhci_queue_reset_ep(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		int slot_id, unsigned int ep_index);
> +int xhci_queue_reset_device(struct xhci_hcd *xhci, struct xhci_command *cmd,
> +		u32 slot_id);
>  void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
>  		unsigned int slot_id, unsigned int ep_index,
>  		unsigned int stream_id, struct xhci_td *cur_td,
>  		struct xhci_dequeue_state *state);
>  void xhci_queue_new_dequeue_state(struct xhci_hcd *xhci,
> +		struct xhci_command *cmd,
>  		unsigned int slot_id, unsigned int ep_index,
>  		unsigned int stream_id,
>  		struct xhci_dequeue_state *deq_state);
> @@ -1847,7 +1851,6 @@ int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
>  		union xhci_trb *cmd_trb);
>  void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
>  		unsigned int ep_index, unsigned int stream_id);
> -union xhci_trb *xhci_find_next_enqueue(struct xhci_ring *ring);
>  
>  /* xHCI roothub code */
>  void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
> -- 
> 1.8.1.2
> 
