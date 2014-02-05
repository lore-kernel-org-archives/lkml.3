Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBECVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:21:49 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55696 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaBECVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:21:47 -0500
MIME-Version: 1.0
In-Reply-To: <1391091027-31783-2-git-send-email-mathias.nyman@linux.intel.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<1391091027-31783-2-git-send-email-mathias.nyman@linux.intel.com>
Date: Tue, 4 Feb 2014 18:21:46 -0800
Message-ID: <CAPcyv4gqcf2b8Yv-rqg0OiEeOeN4P4g-um+oYzMDXW6Y7N8qeQ@mail.gmail.com>
Subject: Re: [RFCv2 01/10] xhci: Use command structures when calling xhci_configure_endpoint
From: Dan Williams <dan.j.williams@intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: USB list <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias, comments below:

On Thu, Jan 30, 2014 at 6:10 AM, Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
> To create a global command queue we need to fill a command structure
> for each entry on the command ring.
>
> We start by requiring xhci_configure_endpoint() to be called with
> a proper command structure. Functions xhci_check_maxpacket and xhci_check_bandwith

s/xhci_check_bandwith/xhci_check_bandwidth/

> that called xhci_configure_endpoint without a command strucure are fixed.

s/strucure/structure/

>
> A special case where an endpoint needs to be configured after reset, done in interrupt
> context is also changed to create a command strucure. (this command

s/strucure/structure/

> structure is not used yet, but will be later when we requre all queued commands

s/requre/require/

> to have a command strucure)

s/strucure/structure/

>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-ring.c | 10 ++---
>  drivers/usb/host/xhci.c      | 97 ++++++++++++++++++++++++--------------------
>  2 files changed, 56 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 1e2f3f4..da83a844 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1180,12 +1180,15 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
>          * because the HW can't handle two commands being queued in a row.
>          */
>         if (xhci->quirks & XHCI_RESET_EP_QUIRK) {
> +               struct xhci_command *command;
> +               command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);

One cleanup we may want to consider in this series is making
xhci_alloc_command() more readable.  My brain hurts when I see "false,
false" as I wonder what that means.  I took a look and of the 4
possible ways to call xhci_alloc_command, we only use 2:

$ git grep xhci_alloc_command\(.*\) | grep -o
xhci_alloc_command\(xhci,.*,.*, | sort -u
xhci_alloc_command(xhci, false, true,
xhci_alloc_command(xhci, true, true,

So a first take is to just have a xhci_alloc_command() for "true,
true" and a xhci_alloc_command_no_ctx() for "false, true".

...uh oh, this series adds a usage of:
xhci_alloc_command(xhci, false, false,

...any reason we can't just use something like
xhci_alloc_command_no_ctx() instead?

Actually just make xhci_alloc_command() take an option in_ctx
parameter, when it is NULL xhci_alloc_command will allocate one,
otherwise it will use the passed in one.

>                 xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
>                                 "Queueing configure endpoint command");
>                 xhci_queue_configure_endpoint(xhci,
>                                 xhci->devs[slot_id]->in_ctx->dma, slot_id,
>                                 false);
>                 xhci_ring_cmd_db(xhci);
> +               kfree(command);

It's not really acceptable to add dead code in a patch.  Consider the
case where some of the patches are reverted due to a regression.  If,
for example we revert patch 2, the unused infrastructure in patch1
does not get deleted.  Patch size minimization is good, but not when
it separates new infrastructure from its first user.

>         } else {
>                 /* Clear our internal halted state and restart the ring(s) */
>                 xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
> @@ -1439,7 +1442,7 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
>                         add_flags - SLOT_FLAG == drop_flags) {
>                 ep_state = virt_dev->eps[ep_index].ep_state;
>                 if (!(ep_state & EP_HALTED))
> -                       goto bandwidth_change;
> +                       return;
>                 xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
>                                 "Completed config ep cmd - "
>                                 "last ep index = %d, state = %d",
> @@ -1449,11 +1452,6 @@ static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
>                 ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
>                 return;
>         }
> -bandwidth_change:
> -       xhci_dbg_trace(xhci,  trace_xhci_dbg_context_change,
> -                       "Completed config ep cmd");
> -       virt_dev->cmd_status = cmd_comp_code;
> -       complete(&virt_dev->cmd_completion);
>         return;

This change has no description in the change log.  What's the reason
for deleting the goto?

>  }
>
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 4265b48..a40485e 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -1179,10 +1179,10 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>  static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
>                 unsigned int ep_index, struct urb *urb)
>  {
> -       struct xhci_container_ctx *in_ctx;
>         struct xhci_container_ctx *out_ctx;
>         struct xhci_input_control_ctx *ctrl_ctx;
>         struct xhci_ep_ctx *ep_ctx;
> +       struct xhci_command *command;
>         int max_packet_size;
>         int hw_max_packet_size;
>         int ret = 0;
> @@ -1207,18 +1207,24 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
>                 /* FIXME: This won't work if a non-default control endpoint
>                  * changes max packet sizes.
>                  */
> -               in_ctx = xhci->devs[slot_id]->in_ctx;
> -               ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
> +
> +               command = xhci_alloc_command(xhci, false, true, GFP_KERNEL);
> +               if (!command)
> +                       return -ENOMEM;
> +
> +               command->in_ctx = xhci->devs[slot_id]->in_ctx;
> +               ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);

If you change xhci_alloc_command() to take an in_ctx parameter then
you don't need to kill the 'in_ctx' variable or change any lines that
reference the old local in_ctx variable.

>                 if (!ctrl_ctx) {
>                         xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
>                                         __func__);
> -                       return -ENOMEM;
> +                       ret = -ENOMEM;
> +                       goto command_cleanup;
>                 }
>                 /* Set up the modified control endpoint 0 */
>                 xhci_endpoint_copy(xhci, xhci->devs[slot_id]->in_ctx,
>                                 xhci->devs[slot_id]->out_ctx, ep_index);
>
> -               ep_ctx = xhci_get_ep_ctx(xhci, in_ctx, ep_index);
> +               ep_ctx = xhci_get_ep_ctx(xhci, command->in_ctx, ep_index);
>                 ep_ctx->ep_info2 &= cpu_to_le32(~MAX_PACKET_MASK);
>                 ep_ctx->ep_info2 |= cpu_to_le32(MAX_PACKET(max_packet_size));
>
> @@ -1226,17 +1232,20 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
>                 ctrl_ctx->drop_flags = 0;
>
>                 xhci_dbg(xhci, "Slot %d input context\n", slot_id);
> -               xhci_dbg_ctx(xhci, in_ctx, ep_index);
> +               xhci_dbg_ctx(xhci, command->in_ctx, ep_index);
>                 xhci_dbg(xhci, "Slot %d output context\n", slot_id);
>                 xhci_dbg_ctx(xhci, out_ctx, ep_index);
>
> -               ret = xhci_configure_endpoint(xhci, urb->dev, NULL,
> +               ret = xhci_configure_endpoint(xhci, urb->dev, command,
>                                 true, false);
>
>                 /* Clean up the input context for later use by bandwidth
>                  * functions.
>                  */
>                 ctrl_ctx->add_flags = cpu_to_le32(SLOT_FLAG);
> +command_cleanup:
> +               kfree(command->completion);
> +               kfree(command);
>         }
>         return ret;
>  }
> @@ -2568,21 +2577,16 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>         int ret;
>         int timeleft;
>         unsigned long flags;
> -       struct xhci_container_ctx *in_ctx;
>         struct xhci_input_control_ctx *ctrl_ctx;
> -       struct completion *cmd_completion;
> -       u32 *cmd_status;
>         struct xhci_virt_device *virt_dev;
> -       union xhci_trb *cmd_trb;
> +
> +       if (!command)
> +               return -EINVAL;
>
>         spin_lock_irqsave(&xhci->lock, flags);
>         virt_dev = xhci->devs[udev->slot_id];
>
> -       if (command)
> -               in_ctx = command->in_ctx;
> -       else
> -               in_ctx = virt_dev->in_ctx;
> -       ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
> +       ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
>         if (!ctrl_ctx) {
>                 spin_unlock_irqrestore(&xhci->lock, flags);
>                 xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
> @@ -2599,7 +2603,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>                 return -ENOMEM;
>         }
>         if ((xhci->quirks & XHCI_SW_BW_CHECKING) &&
> -                       xhci_reserve_bandwidth(xhci, virt_dev, in_ctx)) {
> +           xhci_reserve_bandwidth(xhci, virt_dev, command->in_ctx)) {
>                 if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
>                         xhci_free_host_resources(xhci, ctrl_ctx);
>                 spin_unlock_irqrestore(&xhci->lock, flags);
> @@ -2607,27 +2611,17 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>                 return -ENOMEM;
>         }
>
> -       if (command) {
> -               cmd_completion = command->completion;
> -               cmd_status = &command->status;
> -               command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
> -               list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
> -       } else {
> -               cmd_completion = &virt_dev->cmd_completion;
> -               cmd_status = &virt_dev->cmd_status;
> -       }
> -       init_completion(cmd_completion);
> +       command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
> +       list_add_tail(&command->cmd_list, &virt_dev->cmd_list);
>
> -       cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
>         if (!ctx_change)
> -               ret = xhci_queue_configure_endpoint(xhci, in_ctx->dma,
> +               ret = xhci_queue_configure_endpoint(xhci, command->in_ctx->dma,
>                                 udev->slot_id, must_succeed);
>         else
> -               ret = xhci_queue_evaluate_context(xhci, in_ctx->dma,
> +               ret = xhci_queue_evaluate_context(xhci, command->in_ctx->dma,
>                                 udev->slot_id, must_succeed);
>         if (ret < 0) {
> -               if (command)
> -                       list_del(&command->cmd_list);
> +               list_del(&command->cmd_list);
>                 if ((xhci->quirks & XHCI_EP_LIMIT_QUIRK))
>                         xhci_free_host_resources(xhci, ctrl_ctx);
>                 spin_unlock_irqrestore(&xhci->lock, flags);
> @@ -2640,7 +2634,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
>
>         /* Wait for the configure endpoint command to complete */
>         timeleft = wait_for_completion_interruptible_timeout(
> -                       cmd_completion,
> +                       command->completion,
>                         XHCI_CMD_DEFAULT_TIMEOUT);
>         if (timeleft <= 0) {
>                 xhci_warn(xhci, "%s while waiting for %s command\n",

Given that we are waiting for the command to finish within
xhci_configure_endpoint() shouldn't we free the completion in
xhci_configure_endpoint as well?  In other words in what cases do we
need an xhci_command to have a longer lifetime than the scope of the
execution routine (xhci_stop_device, xhci_configure_endpoint,
xhci_discover_or_reset_device, xhci_alloc_dev, xhci_setup_device).

Taking things a step further it seems that all the locations where we
asynchronously queue commands are in the completion handlers for other
commands.  I'm wondering if this would be cleaner if we simply queued
all command submissions and completion events to a single threaded
workqueue.  I'll go through the rest of the series to see if that
impression makes sense, but something to consider...
