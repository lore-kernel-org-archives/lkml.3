Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3G3AkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:40:09 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:46726 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3G3AkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <1369445630-31018-1-git-send-email-jwerner@chromium.org>
References: <1369445630-31018-1-git-send-email-jwerner@chromium.org>
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 30 Jul 2013 08:39:45 +0800
Message-ID: <CAO_0yfPpYXaU-FFUvrV+=rqzUdHof0XZp93Z-59xQyGFv3FzBQ@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Fix Command Ring Stopped Event handling
To: Julius Werner <jwerner@chromium.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Elric Fu <elricfu1@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        haitao.zhang@canonical.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

We met a panic issue with a 3.5-based kernel, code at
git://kernel.ubuntu.com/ubuntu/ubuntu-quantal.git.

call trace as:
[   27.508480] BUG: unable to handle kernel NULL pointer dereference
at 00000000000003c8
[   27.544645] Call Trace:
[   27.545060]  <IRQ>
[   27.545353]  [<ffffffff814eb541>]
handle_set_deq_completion.isra.37+0x61/0x250
[   27.546610]  [<ffffffff814eb8d5>] ? handle_stopped_cmd_ring+0x175/0x190
[   27.547785]  [<ffffffff814ecd23>] handle_cmd_completion+0x1d3/0x440
[   27.548833]  [<ffffffff814ee26d>] xhci_handle_event+0x14d/0x1d0
[   27.549881]  [<ffffffff814ee398>] xhci_irq+0xa8/0x1d0
[   27.550800]  [<ffffffff814ee4d1>] xhci_msi_irq+0x11/0x20
[   27.551722]  [<ffffffff810e2835>] handle_irq_event_percpu+0x55/0x210
[   27.552899]  [<ffffffff81374ebf>] ? msi_set_mask_bit+0x6f/0x80
[   27.553959]  [<ffffffff810e2a3e>] handle_irq_event+0x4e/0x80
[   27.555007]  [<ffffffff810e5384>] handle_edge_irq+0x84/0x130
[   27.556054]  [<ffffffff810161b2>] handle_irq+0x22/0x40
[   27.556975]  [<ffffffff816a69ca>] do_IRQ+0x5a/0xe0
[   27.557770]  [<ffffffff8169c9aa>] common_interrupt+0x6a/0x6a
[   27.558816]  <EOI>
[   27.559105]  [<ffffffff813c3a66>] ? arch_local_irq_enable+0xb/0xd
[   27.561294]  [<ffffffff8108c68a>] ? sched_clock_idle_wakeup_event+0x1a/0x20
[   27.563067]  [<ffffffff813c4988>] acpi_idle_enter_bm+0x24a/0x28e
[   27.564709]  [<ffffffff81534f27>] ? menu_select+0xe7/0x2e0
[   27.566215]  [<ffffffff81533399>] cpuidle_enter+0x19/0x20
[   27.567716]  [<ffffffff815339bc>] cpuidle_idle_call+0xac/0x2a0
[   27.569352]  [<ffffffff8101d87f>] cpu_idle+0xcf/0x120
[   27.570856]  [<ffffffff8167920f>] start_secondary+0xc3/0xc5
[   27.572342] Code: 8d 44 37 20 48 8d 48 08 74 21 48 8b 49 08 31 c0
48 85 c9 74 0e 3b 51 08 77 09 48 8b 01 89 d2 48 8b 04 d0 5d c3 66 0f
1f 44 00 00 <48> 8b 40 08 5d c3 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
e5 0f
[   27.581968] RIP  [<ffffffff814e7410>] xhci_stream_id_to_ring+0x40/0x50

After applying this patch, this issue is fixed. And USB works as normal.

Tested-by: Yang Bai <hamo.by@gmail.com>

On Sat, May 25, 2013 at 9:33 AM, Julius Werner <jwerner@chromium.org> wrote:
> The current XHCI code treats a command completion event with the
> COMP_CMD_STOP code as a slightly different version of COMP_CMD_ABORT. In
> particular, it puts the pointed-to command TRB through the normal
> command completion handlers. This is not how this event works.
>
> As XHCI spec 4.6.1.1 describes, unlike other command completion events
> Command Ring Stopped sets the Command TRB Pointer to the *current*
> Command Ring Dequeue Pointer. This is the command TRB that the XHCI will
> execute next, and not a command that has already been executed. The
> driver's internal command ring dequeue pointer should not be increased
> after this event, since it does not really mark a command completion...
> it's just a hint for the driver that execution is stopped now and where
> it will be picked up again if the ring gets restarted.
>
> This patch gets rid of the handle_stopped_command_ring() function and
> splits its behavior into two distinct parts for COMP_CMD_STOP and
> COMP_CMD_ABORT events. It ensures that the former no longer messes with
> the dequeue pointer, while the latter's behavior is unchanged. This
> prevents the hardware and software dequeue pointer from going out of
> sync during command cancellations, which can lead to a variety of
> problems (up to a total HCD death if the next command after the one that
> was cancelled is Stop Endpoint, and the stop_endpoint_watchdog won't see
> the command's completion because it got skipped by the software dequeue
> pointer).
>
> This patch should be backported to kernels as far as 3.0 that contain
> the commit b63f4053cc8aa22a98e3f9a97845afe6c15d0a0d "xHCI: handle
> command after aborting the command ring".
>
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci-ring.c | 85 +++++++++++++++++---------------------------
>  1 file changed, 33 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 1969c00..98b7673 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -1314,47 +1314,11 @@ static int xhci_search_cmd_trb_in_cd_list(struct xhci_hcd *xhci,
>         return 0;
>  }
>
> -/*
> - * If the cmd_trb_comp_code is COMP_CMD_ABORT, we just check whether the
> - * trb pointed by the command ring dequeue pointer is the trb we want to
> - * cancel or not. And if the cmd_trb_comp_code is COMP_CMD_STOP, we will
> - * traverse the cancel_cmd_list to trun the all of the commands according
> - * to command descriptor to NO-OP trb.
> - */
> -static int handle_stopped_cmd_ring(struct xhci_hcd *xhci,
> -               int cmd_trb_comp_code)
> -{
> -       int cur_trb_is_good = 0;
> -
> -       /* Searching the cmd trb pointed by the command ring dequeue
> -        * pointer in command descriptor list. If it is found, free it.
> -        */
> -       cur_trb_is_good = xhci_search_cmd_trb_in_cd_list(xhci,
> -                       xhci->cmd_ring->dequeue);
> -
> -       if (cmd_trb_comp_code == COMP_CMD_ABORT)
> -               xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
> -       else if (cmd_trb_comp_code == COMP_CMD_STOP) {
> -               /* traversing the cancel_cmd_list and canceling
> -                * the command according to command descriptor
> -                */
> -               xhci_cancel_cmd_in_cd_list(xhci);
> -
> -               xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
> -               /*
> -                * ring command ring doorbell again to restart the
> -                * command ring
> -                */
> -               if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue)
> -                       xhci_ring_cmd_db(xhci);
> -       }
> -       return cur_trb_is_good;
> -}
> -
>  static void handle_cmd_completion(struct xhci_hcd *xhci,
>                 struct xhci_event_cmd *event)
>  {
>         int slot_id = TRB_TO_SLOT_ID(le32_to_cpu(event->flags));
> +       int comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
>         u64 cmd_dma;
>         dma_addr_t cmd_dequeue_dma;
>         struct xhci_input_control_ctx *ctrl_ctx;
> @@ -1377,16 +1341,34 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>                 return;
>         }
>
> -       if ((GET_COMP_CODE(le32_to_cpu(event->status)) == COMP_CMD_ABORT) ||
> -               (GET_COMP_CODE(le32_to_cpu(event->status)) == COMP_CMD_STOP)) {
> -               /* If the return value is 0, we think the trb pointed by
> -                * command ring dequeue pointer is a good trb. The good
> -                * trb means we don't want to cancel the trb, but it have
> -                * been stopped by host. So we should handle it normally.
> -                * Otherwise, driver should invoke inc_deq() and return.
> -                */
> -               if (handle_stopped_cmd_ring(xhci,
> -                               GET_COMP_CODE(le32_to_cpu(event->status)))) {
> +       /*
> +        * Command Ring Stopped events point at the xHC's *current* dequeue
> +        * pointer, i.e. the next command that will be executed. That TRB may
> +        * or may not have been issued yet. Just overwrite all canceled commands
> +        * with NOOPs and restart the ring, leaving our internal dequeue pointer
> +        * as it is (we will get another event for that position later, when
> +        * it has actually been executed).
> +        */
> +       if (comp_code == COMP_CMD_STOP) {
> +               xhci_cancel_cmd_in_cd_list(xhci);
> +               xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
> +               if (xhci->cmd_ring->dequeue != xhci->cmd_ring->enqueue)
> +                       xhci_ring_cmd_db(xhci);
> +               return;
> +       }
> +
> +       /*
> +        * If we aborted a command, we check if it is one of the commands we
> +        * meant to cancel. In that case, it will be freed and we just finish
> +        * up right here. If we aborted something else instead, we run it
> +        * through the normal handlers below. At any rate, the command ring is
> +        * stopped now, but the xHC will issue a Command Ring Stopped event
> +        * after this that will cause us to restart it.
> +        */
> +       if (comp_code == COMP_CMD_ABORT) {
> +               xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
> +               if (xhci_search_cmd_trb_in_cd_list(xhci,
> +                       xhci->cmd_ring->dequeue)) {
>                         inc_deq(xhci, xhci->cmd_ring);
>                         return;
>                 }
> @@ -1395,7 +1377,7 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>         switch (le32_to_cpu(xhci->cmd_ring->dequeue->generic.field[3])
>                 & TRB_TYPE_BITMASK) {
>         case TRB_TYPE(TRB_ENABLE_SLOT):
> -               if (GET_COMP_CODE(le32_to_cpu(event->status)) == COMP_SUCCESS)
> +               if (comp_code == COMP_SUCCESS)
>                         xhci->slot_id = slot_id;
>                 else
>                         xhci->slot_id = 0;
> @@ -1451,19 +1433,18 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
>                 }
>  bandwidth_change:
>                 xhci_dbg(xhci, "Completed config ep cmd\n");
> -               xhci->devs[slot_id]->cmd_status =
> -                       GET_COMP_CODE(le32_to_cpu(event->status));
> +               xhci->devs[slot_id]->cmd_status = comp_code;
>                 complete(&xhci->devs[slot_id]->cmd_completion);
>                 break;
>         case TRB_TYPE(TRB_EVAL_CONTEXT):
>                 virt_dev = xhci->devs[slot_id];
>                 if (handle_cmd_in_cmd_wait_list(xhci, virt_dev, event))
>                         break;
> -               xhci->devs[slot_id]->cmd_status = GET_COMP_CODE(le32_to_cpu(event->status));
> +               xhci->devs[slot_id]->cmd_status = comp_code;
>                 complete(&xhci->devs[slot_id]->cmd_completion);
>                 break;
>         case TRB_TYPE(TRB_ADDR_DEV):
> -               xhci->devs[slot_id]->cmd_status = GET_COMP_CODE(le32_to_cpu(event->status));
> +               xhci->devs[slot_id]->cmd_status = comp_code;
>                 complete(&xhci->addr_dev);
>                 break;
>         case TRB_TYPE(TRB_STOP_RING):
> --
> 1.7.12.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
