Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaDOM2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:28:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:48433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbaDOM2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:28:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,864,1389772800"; 
   d="scan'208";a="521164403"
Message-ID: <534D2899.3030503@linux.intel.com>
Date: Tue, 15 Apr 2014 15:39:53 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: "Nyman, Mathias" <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: xhci: Prefer endpoint context dequeue pointer over
 stopped_trb
References: <1392959535-29654-1-git-send-email-jwerner@chromium.org>	<20140228205358.GA5340@xanatos> <CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>
In-Reply-To: <CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 12:29 AM, Julius Werner wrote:
> Hi Mathias,
>
>> The patch looks fine.  Mathias is taking over for xHCI driver
>> maintainership in 3.15.  He's currently handling queuing bug fix patches
>> for 3.14 while I finish queueing feature patches for 3.15.  Mathias,
>> will you test and queue this up for 3.14?
>
> Did you pick this patch up anywhere yet or are there still issues with
> it? I just want to make sure it doesn't slip through the cracks.
> (Maybe I just didn't see it yet... are you still queueing patches in
> sarah/xhci.git or do you have your own repository somewhere?)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I tried to apply this patch on top of 3.15-rc1, but it fails because of 
the streams support added to xhci_find_new_dequeue_state()

After some manual editing the interesting parts of 
xhci_find_new_dequeue_state() looks like this:

@@ -577,46 +568,57 @@ void xhci_find_new_dequeue_state(struct xhci_hcd 
*xhci,
         if (ep->ep_state & EP_HAS_STREAMS) {
                 struct xhci_stream_ctx *ctx =
                         &ep->stream_info->stream_ctx_array[stream_id];
-               state->new_cycle_state = 0x1 & 
le64_to_cpu(ctx->stream_ring);
+               hw_dequeue = le64_to_cpu(ctx->stream_ring);
         } else {
                 struct xhci_ep_ctx *ep_ctx
                         = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
-               state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
+               hw_dequeue = le64_to_cpu(ep_ctx->deq);
         }

+       /* Find virtual address and segment of hardware dequeue pointer */
+       state->new_deq_seg = ep_ring->deq_seg;
+       state->new_deq_ptr = ep_ring->dequeue;
+       while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
+                       != (dma_addr_t)(hw_dequeue & ~0x1)) {
+               next_trb(xhci, ep_ring, &state->new_deq_seg,
+                                       &state->new_deq_ptr);
+               if (state->new_deq_ptr == ep_ring->dequeue) {
+                       WARN_ON(1);
+                       return;
+               }
+       }


But I'm still concerned about the dequeue pointer in the streams case. 
streams may be nested, we might be pointing at another stream context 
instead of the dequeue pointer.

Also the comparison of the dequeue pointers, using (hw_dequeue & ~0x1) 
might have some troubles with streams. Endpoint context TR dequeue 
pointer LO field has bits 3:1 reserved (probably zero) but stream 
context uses those bits. Would it make sense to use (hw_dequeue & ~0xf) 
here instead?

So there's still some work needed. Are you interested in re-working this 
to fit on top of 3.15-rc1 or should I add it to my todo list?

-Mathias



