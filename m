Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322Ab3DQK5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:57:35 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56472 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936303Ab3DQK5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <6C6B28D4DC342643927BEAFCE8707BF63EAAC0E5@DBDE01.ent.ti.com>
References: <1366126904-31605-1-git-send-email-ruslan.bilovol@ti.com>
	<6C6B28D4DC342643927BEAFCE8707BF63EAAC0E5@DBDE01.ent.ti.com>
Date: Wed, 17 Apr 2013 13:57:32 +0300
X-Google-Sender-Auth: 69CDW7AbVqWF-cx2K8D9ia3a4pg
Message-ID: <CAB=otbS1R+QTDo=MynMRydCZnv4+idWyosRUQ3d1qiFvXaGPpw@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: gadget: fix enumeration on heavy-loaded systems
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: "B, Ravi" <ravibabu@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ravi,

On Tue, Apr 16, 2013 at 7:57 PM, B, Ravi <ravibabu@ti.com> wrote:
>> -----Original Message-----
>> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
>> owner@vger.kernel.org] On Behalf Of Bilovol, Ruslan
>> Sent: Tuesday, April 16, 2013 9:12 PM
>> To: Balbi, Felipe; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: [PATCH] usb: musb: gadget: fix enumeration on heavy-loaded
>> systems
>>
>> From musb point of view, the Address Assignment sequence during
>> device enumeration is next:
>>  - first ep0 interrupt:
>>       * read the address from USB_REQ_SET_ADDRESS request
>>       * set up CSR0L.DataEnd bit (that is ACK
>>         signalization for the host)
>>  - second ep0 interrupt:
>>       * indicates that the request completed successfully
>>       * set up musb device address
>>         Now musb device should answer to this address
>>
>> From the host perspective, if peripheral device acquires
>> SET_ADDRESS request, it now may be accessed only using that address.
>> However, on heavy loaded systems, time between first and
>> second musb ep0 interrupts may be too long and musb controller
>> misses requests between.
>
> What is meant by heavily loaded system? Is the device is heavily loaded during enumeration stage? Why second ep0 interrupt is too long? whether interrupt occurrence to interrupt service is taking too long?

I mean production system with aggressive power management and tens of
interrupt sources.
On such systems and in low CPU frequency case, you may meet condition
when time between
IRQ firing and ISR entering is increased in few times.

In particular case of OMAP4 where I met this issue, time between first
and second ep0 interrupt
sometimes may be up to 800-900 uS and in this case the USB30CV test fails.
If this time is 200-300 uS, the test successfully passes.

Unfortunately, this time is not predictable and depends on many factors so
this patch ensures we change the address as soon as sent ACK to the host.

>
> As result, device enumeration may be
>> unsuccessful. This can be checked on USB3.0 Host and
>> using USB3.0 test suite (from usb.org) running ch9 tests
>> for USB2.0 devices.
>
> You mean the usb2.0 musb controller (in device mode) connected to USB3.0 host?

Correct. USB2.0 musb controller in device mode, connected to USB3.0
host that runs
USB30CV utility for USB2.0 devices

>
>> Usually 'Addressed state/TD9.1: Device Descriptor Test' will fail
>>
>> The fix consists in checking CSR0L.DataEnd state and assigning
>> the device address in the first ep0 interrupt handling, so
>> delay is as minimal as possible
>>
>> Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
>> ---
>>  drivers/usb/musb/musb_gadget_ep0.c |   31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/usb/musb/musb_gadget_ep0.c
>> b/drivers/usb/musb/musb_gadget_ep0.c
>> index c9c1ac4..59bc5a5 100644
>> --- a/drivers/usb/musb/musb_gadget_ep0.c
>> +++ b/drivers/usb/musb/musb_gadget_ep0.c
>> @@ -885,6 +885,37 @@ stall:
>>  finish:
>>                               musb_writew(regs, MUSB_CSR0,
>>                                               musb->ackpend);
>> +
>> +                             /*
>> +                              * If we are at end of SET_ADDRESS sequence,
>> +                              * update the address immediately if possible,
>> +                              * otherwise we may miss packets between
>> +                              * sending ACK from musb side and musb's next
>> +                              * interrupt handler firing (in which we update
>> +                              * the address). At least this fixes next
>> +                              * USB2.0 ch9 test of USB30CV utility:
>> +                              * "Addressed state - Device Descriptor test"
>> +                              */
>> +                             if (musb->set_address && (musb->ackpend &
>> +                                                     MUSB_CSR0_P_DATAEND) &&
>> +                                             (musb->ep0_state ==
>> +                                             MUSB_EP0_STAGE_STATUSIN)) {
>> +                                     u16 ack_delay = 500;
>> +
>> +                                     while ((musb_readw(regs, MUSB_CSR0) &
>> +                                                     MUSB_CSR0_P_DATAEND) &&
>> +                                                     --ack_delay) {
>> +                                             cpu_relax();
>> +                                             udelay(1);
>> +                                     }
>> +
>> +                                     if (ack_delay) {
>> +                                             musb->set_address = false;
>> +                                             musb_writeb(mbase, MUSB_FADDR,
>> +                                                             musb->address);
>> +                                     }
>> +                             }
>> +
>>                               musb->ackpend = 0;
>>                       }
>>               }
>
> --
> Ravi B
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Best regards,
Ruslan Bilvol
