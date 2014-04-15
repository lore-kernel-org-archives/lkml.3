Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaDOUlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:41:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaDOUls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:41:48 -0400
Message-ID: <534D9981.4030607@redhat.com>
Date: Tue, 15 Apr 2014 22:41:37 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
CC: "Nyman, Mathias" <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] usb: xhci: Prefer endpoint context dequeue pointer over
 stopped_trb
References: <1392959535-29654-1-git-send-email-jwerner@chromium.org>	<20140228205358.GA5340@xanatos>	<CAODwPW9ziqrT2THof7D6Y6_AVbk9Mvo9YteLJp7-KstAKoSzSA@mail.gmail.com>	<534D2899.3030503@linux.intel.com> <CAODwPW-RK9Un-ou-fwZJw6iP=dNF0_D4vA0Wmx8meQNocfo69w@mail.gmail.com>
In-Reply-To: <CAODwPW-RK9Un-ou-fwZJw6iP=dNF0_D4vA0Wmx8meQNocfo69w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/15/2014 09:42 PM, Julius Werner wrote:
> +hdegoede
>
>> I tried to apply this patch on top of 3.15-rc1, but it fails because of the
>> streams support added to xhci_find_new_dequeue_state()
>>
>> After some manual editing the interesting parts of
>> xhci_find_new_dequeue_state() looks like this:
>>
>> @@ -577,46 +568,57 @@ void xhci_find_new_dequeue_state(struct xhci_hcd
>> *xhci,
>>          if (ep->ep_state & EP_HAS_STREAMS) {
>>                  struct xhci_stream_ctx *ctx =
>>                          &ep->stream_info->stream_ctx_array[stream_id];
>> -               state->new_cycle_state = 0x1 &
>> le64_to_cpu(ctx->stream_ring);
>> +               hw_dequeue = le64_to_cpu(ctx->stream_ring);
>>          } else {
>>                  struct xhci_ep_ctx *ep_ctx
>>
>>                          = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
>> -               state->new_cycle_state = 0x1 & le64_to_cpu(ep_ctx->deq);
>> +               hw_dequeue = le64_to_cpu(ep_ctx->deq);
>>          }
>>
>> +       /* Find virtual address and segment of hardware dequeue pointer */
>>
>> +       state->new_deq_seg = ep_ring->deq_seg;
>> +       state->new_deq_ptr = ep_ring->dequeue;
>> +       while (xhci_trb_virt_to_dma(state->new_deq_seg, state->new_deq_ptr)
>> +                       != (dma_addr_t)(hw_dequeue & ~0x1)) {
>> +               next_trb(xhci, ep_ring, &state->new_deq_seg,
>> +                                       &state->new_deq_ptr);
>> +               if (state->new_deq_ptr == ep_ring->dequeue) {
>> +                       WARN_ON(1);
>> +                       return;
>> +               }
>> +       }
>>
>> Also the comparison of the dequeue pointers, using (hw_dequeue & ~0x1) might
>> have some troubles with streams. Endpoint context TR dequeue pointer LO
>> field has bits 3:1 reserved (probably zero) but stream context uses those
>> bits. Would it make sense to use (hw_dequeue & ~0xf) here instead?
>
> Ah, yes, looks like that patch wasn't in Linus' tree yet back when I
> wrote this. I think your merge looks pretty good... just use
> (hw_dequeue & ~0xf) instead of (hw_dequeue & ~0x1) to get the pointer
> as you said, and this should work fine.
>
>> But I'm still concerned about the dequeue pointer in the streams case.
>> streams may be nested, we might be pointing at another stream context
>> instead of the dequeue pointer.

Since I've not followed the entire discussion previously to this I cannot
really provide any useful feedback on this patch. Other then 2 remarks:

1) We don't use nested streams, so no need to worry about those
2) You're right that for streams to get the dequeue address you need
to mask with ~0xf

Regards,

Hans
