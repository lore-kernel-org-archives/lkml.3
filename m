Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3CUFDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:03:49 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:55264 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3CUFDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:03:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130320174947.GB31929@xanatos>
References: <1363774720-13187-1-git-send-email-gautam.vivek@samsung.com>
	<20130320174947.GB31929@xanatos>
Date: Thu, 21 Mar 2013 10:33:46 +0530
Message-ID: <CAFp+6iEo8typctEOxxXehs1MiKV=oUD=zZSQX46YPk3cfoBU-Q@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Fix TRB transfer length macro used for Event TRB.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Mar 20, 2013 at 11:19 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Wed, Mar 20, 2013 at 03:48:40PM +0530, Vivek Gautam wrote:
>> Use proper macro while extracting TRB transfer length from
>> Transfer event TRBs. Adding a macro EVENT_TRB_LEN (bits 0:23)
>> for the same, and use it instead of TRB_LEN (bits 0:16) in
>> case of event TRBs.
>
> Thanks for the patch!  Comments below.
>
>> Signed-off-by: Vivek gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/usb/host/xhci-ring.c |   45 +++++++++++++++++++++++------------------
>>  drivers/usb/host/xhci.h      |    4 +++
>>  2 files changed, 29 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
>> index 8828754..fe59a30 100644
>> --- a/drivers/usb/host/xhci-ring.c
>> +++ b/drivers/usb/host/xhci-ring.c
>> @@ -2027,8 +2027,8 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
>>               if (event_trb != ep_ring->dequeue &&
>>                               event_trb != td->last_trb)
>>                       td->urb->actual_length =
>> -                             td->urb->transfer_buffer_length
>> -                             - TRB_LEN(le32_to_cpu(event->transfer_len));
>> +                             td->urb->transfer_buffer_length -
>> +                             EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
>
> This looks fine.
>
>>               else
>>                       td->urb->actual_length = 0;
>>
>> @@ -2060,7 +2060,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
>>               /* Maybe the event was for the data stage? */
>>                       td->urb->actual_length =
>>                               td->urb->transfer_buffer_length -
>> -                             TRB_LEN(le32_to_cpu(event->transfer_len));
>> +                             EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
>
> Fine
>
>>                       xhci_dbg(xhci, "Waiting for status "
>>                                       "stage event\n");
>>                       return 0;
>> @@ -2096,7 +2096,7 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
>>       /* handle completion code */
>>       switch (trb_comp_code) {
>>       case COMP_SUCCESS:
>> -             if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
>> +             if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0) {
>
> Fine
>
>>                       frame->status = 0;
>>                       break;
>>               }
>> @@ -2137,11 +2137,13 @@ static int process_isoc_td(struct xhci_hcd *xhci, struct xhci_td *td,
>
> This bit of code is looping through the endpoint ring, and cur_trb
> points to a transfer TRB on the endpoint ring.  We're adding up the
> transfer buffer lengths, up to the TRB that had a completion event.
>
>>                    cur_seg = ep_ring->deq_seg; cur_trb != event_trb;
>>                    next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
>>                       if (!TRB_TYPE_NOOP_LE32(cur_trb->generic.field[3]) &&
>> -                         !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3]))
>> -                             len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
>> +                         !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3])) {
>> +                             len += EVENT_TRB_LEN(le32_to_cpu
>> +                                             (cur_trb->generic.field[2]));
>> +                     }
>
> In this case, cur_trb points to a transfer TRB, not an event TRB.  So
> this instance still needs to use the TRB_LEN macro.

Right, thanks.

>
> Adding the extra braces here makes it hard to review.  Please don't add
> extra braces, or do so in a second patch if it really bothers you.

Sure, will remove these.
>
>>               }
>> -             len += TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
>> -                     TRB_LEN(le32_to_cpu(event->transfer_len));
>> +             len += EVENT_TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
>> +                     EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
>
> Here, cur_trb points to a transfer TRB, and event points to an event
> TRB.  So you need to use the TRB_LEN macro for the first line, and the
> EVENT_TRB_LEN macro for the second line.

Ok

>
>>
>>               if (trb_comp_code != COMP_STOP_INVAL) {
>>                       frame->actual_length = len;
>> @@ -2199,7 +2201,7 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
>>       case COMP_SUCCESS:
>>               /* Double check that the HW transferred everything. */
>>               if (event_trb != td->last_trb ||
>> -                             TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
>> +                 EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
>
> Fine.
>
>>                       xhci_warn(xhci, "WARN Successful completion "
>>                                       "on short TX\n");
>>                       if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
>> @@ -2225,20 +2227,21 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
>>       if (trb_comp_code == COMP_SHORT_TX)
>>               xhci_dbg(xhci, "ep %#x - asked for %d bytes, "
>>                               "%d bytes untransferred\n",
>> -                             td->urb->ep->desc.bEndpointAddress,
>> -                             td->urb->transfer_buffer_length,
>> -                             TRB_LEN(le32_to_cpu(event->transfer_len)));
>> +                           td->urb->ep->desc.bEndpointAddress,
>> +                           td->urb->transfer_buffer_length,
>> +                           EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)));
>
> Please don't change indentation.  I know it's a pain to keep lines
> within 80 chars, but I would rather have a longer line than non-standard
> indentation.  The macro change is fine.

Sure, will keep the indentation intact.

>
>>       /* Fast path - was this the last TRB in the TD for this URB? */
>>       if (event_trb == td->last_trb) {
>> -             if (TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
>> +             if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) != 0) {
>>                       td->urb->actual_length =
>>                               td->urb->transfer_buffer_length -
>> -                             TRB_LEN(le32_to_cpu(event->transfer_len));
>> +                             EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
>>                       if (td->urb->transfer_buffer_length <
>>                                       td->urb->actual_length) {
>>                               xhci_warn(xhci, "HC gave bad length "
>>                                               "of %d bytes left\n",
>> -                                       TRB_LEN(le32_to_cpu(event->transfer_len)));
>> +                                     EVENT_TRB_LEN(le32_to_cpu
>> +                                                     (event->transfer_len)));
>
> This chunk is fine.
>
>>                               td->urb->actual_length = 0;
>>                               if (td->urb->transfer_flags & URB_SHORT_NOT_OK)
>>                                       *status = -EREMOTEIO;
>> @@ -2270,17 +2273,19 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
>>                               cur_trb != event_trb;
>>                               next_trb(xhci, ep_ring, &cur_seg, &cur_trb)) {
>>                       if (!TRB_TYPE_NOOP_LE32(cur_trb->generic.field[3]) &&
>> -                         !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3]))
>> +                         !TRB_TYPE_LINK_LE32(cur_trb->generic.field[3])) {
>>                               td->urb->actual_length +=
>> -                                     TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]));
>> +                                     EVENT_TRB_LEN(le32_to_cpu
>> +                                             (cur_trb->generic.field[2]));
>> +                  }
>
> Again, this is walking the endpoint ring's transfer TRBs to add up the
> transferred length, and thus those last two lines should still use the
> TRB_LEN macro.
>
> Also, don't add extra braces to one-line blocks.  And why was the
> indentation on the curly braces so odd?  Please only use tabs.

Sure

>
>>               }
>>               /* If the ring didn't stop on a Link or No-op TRB, add
>>                * in the actual bytes transferred from the Normal TRB
>>                */
>>               if (trb_comp_code != COMP_STOP_INVAL)
>>                       td->urb->actual_length +=
>> -                             TRB_LEN(le32_to_cpu(cur_trb->generic.field[2])) -
>> -                             TRB_LEN(le32_to_cpu(event->transfer_len));
>> +                       EVENT_TRB_LEN(le32_to_cpu(cur_trb->generic.field[2]))
>> +                       - EVENT_TRB_LEN(le32_to_cpu(event->transfer_len));
>
> cur_trb needs to use the TRB_LEN, and event needs to use the
> EVENT_TRB_LEN macro.
>
>>       }
>>
>>       return finish_td(xhci, td, event_trb, event, ep, status, false);
>> @@ -2368,7 +2373,7 @@ static int handle_tx_event(struct xhci_hcd *xhci,
>>        * transfer type
>>        */
>>       case COMP_SUCCESS:
>> -             if (TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
>> +             if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) == 0)
>
> Fine.
>
>>                       break;
>>               if (xhci->quirks & XHCI_TRUST_TX_LENGTH)
>>                       trb_comp_code = COMP_SHORT_TX;
>> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
>> index f791bd0..61f71ed 100644
>> --- a/drivers/usb/host/xhci.h
>> +++ b/drivers/usb/host/xhci.h
>> @@ -972,6 +972,10 @@ struct xhci_transfer_event {
>>       __le32  flags;
>>  };
>>
>> +/* Transfer event TRB length bit mask */
>> +/* bits 0:23 */
>> +#define      EVENT_TRB_LEN(p)                ((p) & 0xffffff)
>> +
>>  /** Transfer Event bit fields **/
>>  #define      TRB_TO_EP_ID(p) (((p) >> 16) & 0x1f)
>>
>> --
>> 1.7.6.5
>>
>
> Can you correct these and resubmit?  Thanks!
>

Thanks for the review Sarah. I shall update and resubmit this patch.

> Sarah Sharp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
