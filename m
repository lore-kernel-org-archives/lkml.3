Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaDOTmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:42:54 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:57790 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaDOTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <534D2899.3030503@linux.intel.com>
References: <1392959535-29654-1-git-send-email-jwerner@chromium.org>
	<20140228205358.GA5340@xanatos>
	<CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>
	<534D2899.3030503@linux.intel.com>
Date: Tue, 15 Apr 2014 12:42:51 -0700
X-Google-Sender-Auth: _nYC209C-DfpEd1RdUyR-MkbFlw
Message-ID: <CAODwPW-RK9Un-ou-fwZJw6iP=dNF0_D4vA0Wmx8meQNocfo69w@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb
From: Julius Werner <jwerner@chromium.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        "Nyman, Mathias" <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+hdegoede

> I tried to apply this patch on top of 3.15-rc1, but it fails because of the
> streams support added to xhci_find_new_dequeue_state()
>
> After some manual editing the interesting parts of
> xhci_find_new_dequeue_state() looks like this:
>
> @@ -577,46 +568,57 @@ void xhci_find_new_dequeue_state(struct xhci_hcd
> *xhci,
>         if (ep->ep_state & EP_HAS_STREAMS) {
>                 struct xhci_stream_ctx *ctx =
>                         &ep->stream_info->stream_ctx_array[stream_id];
> -               state->new_cycle_state = 0x1 &
> le64_to_cpu(ctx->stream_ring);
> +               hw_dequeue = le64_to_cpu(ctx->stream_ring);
>         } else {
>                 struct xhci_ep_ctx *ep_ctx
>
>                         = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
> -               state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
> +               hw_dequeue = le64_to_cpu(ep_ctx->deq);
>         }
>
> +       /* Find virtual address and segment of hardware dequeue pointer */
>
> +       state->new_deq_seg = ep_ring->deq_seg;
> +       state->new_deq_ptr = ep_ring->dequeue;
> +       while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
> +                       != (dma_addr_t)(hw_dequeue & ~0x1)) {
> +               next_trb(xhci, ep_ring, &state->new_deq_seg,
> +                                       &state->new_deq_ptr);
> +               if (state->new_deq_ptr == ep_ring->dequeue) {
> +                       WARN_ON(1);
> +                       return;
> +               }
> +       }
>
> Also the comparison of the dequeue pointers, using (hw_dequeue & ~0x1) might
> have some troubles with streams. Endpoint context TR dequeue pointer LO
> field has bits 3:1 reserved (probably zero) but stream context uses those
> bits. Would it make sense to use (hw_dequeue & ~0xf) here instead?

Ah, yes, looks like that patch wasn't in Linus' tree yet back when I
wrote this. I think your merge looks pretty good... just use
(hw_dequeue & ~0xf) instead of (hw_dequeue & ~0x1) to get the pointer
as you said, and this should work fine.

> But I'm still concerned about the dequeue pointer in the streams case.
> streams may be nested, we might be pointing at another stream context
> instead of the dequeue pointer.
>
> So there's still some work needed. Are you interested in re-working this to
> fit on top of 3.15-rc1 or should I add it to my todo list?

Hmmm... maybe the stream_id parameter is already pointing to the
correct secondary stream (if applicable) so you can rely on having a
normal dequeue pointer there? The xhci_triad_to_transfer_ring()
function seems to make the same assumption... At any rate, if there is
a problem here it would also be in the original c4bedb77e ("xhci: For
streams the css flag most be read from the stream-ctx on ep stop")
already, so I think you should follow up with that patch's author and
fix it in a separate commit if necessary.

I unfortunately don't have a device using streams to test with, so I
couldn't do more for this patch than you've already done. I think if
you change the hw_dequeue masking as you said that should guarantee
that the patch at least won't make things worse for streams, and that
should be good enough.
