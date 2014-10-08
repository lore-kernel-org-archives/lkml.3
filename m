Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaJHKyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:54:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61205 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbaJHKyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <20141008092347.GB1990@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
	<1411661254-5204-2-git-send-email-octavian.purdila@intel.com>
	<20141008092347.GB1990@localhost>
Date: Wed, 8 Oct 2014 13:54:07 +0300
Message-ID: <CAE1zotKHq1Fj_AqKzfnBHoypetb6Yz3OsHnqfeHN5PrVJtuHVw@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 12:23 PM, Johan Hovold <johan@kernel.org> wrote:
> On Thu, Sep 25, 2014 at 07:07:31PM +0300, Octavian Purdila wrote:
>
>> +static void dln2_rx_transfer(struct dln2_dev *dln2, struct urb *urb,
>> +                          u16 handle, u16 rx_slot)
>> +{
>> +     struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
>> +     struct dln2_rx_context *rxc;
>> +     struct device *dev = &dln2->interface->dev;
>> +
>> +     spin_lock(&rxs->lock);
>
> You must use spin_lock_irqsave here as you call it from the completion
> handler.

Why? AFAICS the completion handler gets called from the HCD irq handler:

[    2.503945] Call Trace:
[    2.503945]  <IRQ>  [<ffffffff81a73d14>] dump_stack+0x4e/0x7a
[    2.503945]  [<ffffffff81639fcb>] dln2_rx+0x1eb/0x2d0
[    2.503945]  [<ffffffff81742202>] __usb_hcd_giveback_urb+0x72/0x120
[    2.503945]  [<ffffffff817423cf>] usb_hcd_giveback_urb+0x3f/0x120
[    2.503945]  [<ffffffff81786ffa>] uhci_giveback_urb+0xaa/0x290
[    2.503945]  [<ffffffff811d36d7>] ? dma_pool_free+0xa7/0xd0
[    2.503945]  [<ffffffff81788fe3>] uhci_scan_schedule+0x493/0xb20
[    2.503945]  [<ffffffff81789c9e>] uhci_irq+0x9e/0x180
[    2.503945]  [<ffffffff81741546>] usb_hcd_irq+0x26/0x40
[    2.503945]  [<ffffffff8110e46e>] handle_irq_event_percpu+0x3e/0x1e0
[    2.503945]  [<ffffffff8110e64d>] handle_irq_event+0x3d/0x60
[    2.503945]  [<ffffffff811117f9>] handle_fasteoi_irq+0x99/0x160
[    2.503945]  [<ffffffff810492c2>] handle_irq+0x102/0x190
[    2.503945]  [<ffffffff810e493a>] ? atomic_notifier_call_chain+0x3a/0x50
[    2.503945]  [<ffffffff81a7fbcb>] do_IRQ+0x5b/0x100
[    2.503945]  [<ffffffff81a7dd6f>] common_interrupt+0x6f/0x6f
[    2.503945]  <EOI>  [<ffffffff810512ed>] ? default_idle+0x1d/0x100

>
>> +
>> +     rxc = &rxs->slots[rx_slot];
>> +
>> +     if (rxc->in_use && !rxc->urb) {
>> +             rxc->urb = urb;
>> +             complete(&rxc->done);
>> +             /* URB will be resubmitted in free_rx_slot */
>> +     } else {
>> +             dev_warn(dev, "bad/late response %d/%d\n", handle, rx_slot);
>> +             dln2_submit_urb(dln2, urb, GFP_ATOMIC);
>> +     }
>> +
>> +     spin_unlock(&rxs->lock);
>> +}
>
>> +static int _dln2_transfer(struct dln2_dev *dln2, u16 handle, u16 cmd,
>> +                       const void *obuf, unsigned obuf_len,
>> +                       void *ibuf, unsigned *ibuf_len)
>> +{
>> +     int ret = 0;
>> +     u16 result;
>> +     int rx_slot;
>> +     struct dln2_response *rsp;
>> +     struct dln2_rx_context *rxc;
>> +     struct device *dev;
>> +     const int timeout = DLN2_USB_TIMEOUT * HZ / 1000;
>> +     struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[handle];
>> +
>> +     spin_lock(&dln2->disconnect_lock);
>
> How did you test this version? You never initialise disconnect_lock so
> lockdep complains loudly when calling _dln2_transfer during probe.
>

Oops, missed that as lockdep was not enable in the lastest test setup.

>> +     if (!dln2->disconnect)
>> +             dln2->active_transfers++;
>> +     else
>> +             ret = -ENODEV;
>> +     spin_unlock(&dln2->disconnect_lock);
>> +
>> +     if (ret)
>> +             return ret;
>> +
>> +     rx_slot = alloc_rx_slot(dln2, handle);
>> +     if (rx_slot < 0) {
>> +             ret = rx_slot;
>> +             goto out_decr;
>> +     }
>> +
>> +     dev = &dln2->interface->dev;
>> +
>> +     ret = dln2_send_wait(dln2, handle, cmd, rx_slot, obuf, obuf_len);
>> +     if (ret < 0) {
>> +             dev_err(dev, "USB write failed: %d\n", ret);
>> +             goto out_free_rx_slot;
>> +     }
>> +
>> +     rxc = &rxs->slots[rx_slot];
>> +
>> +     ret = wait_for_completion_interruptible_timeout(&rxc->done, timeout);
>> +     if (ret <= 0) {
>> +             if (!ret)
>> +                     ret = -ETIMEDOUT;
>> +             goto out_free_rx_slot;
>> +     }
>> +
>> +     if (!rxc->urb) {
>> +             ret = -ENODEV;
>> +             goto out_free_rx_slot;
>> +     }
>> +
>> +     /* if we got here we know that the response header has been checked */
>> +     rsp = rxc->urb->transfer_buffer;
>> +
>> +     if (rsp->hdr.size < sizeof(*rsp)) {
>> +             ret = -EPROTO;
>> +             goto out_free_rx_slot;
>> +     }
>> +
>> +     result = le16_to_cpu(rsp->result);
>> +     if (result) {
>> +             dev_dbg(dev, "%d received response with error %d\n",
>> +                     handle, result);
>> +             ret = -EREMOTEIO;
>> +             goto out_free_rx_slot;
>> +     }
>> +
>> +     if (!ibuf) {
>> +             ret = 0;
>> +             goto out_free_rx_slot;
>> +     }
>> +
>> +     if (*ibuf_len > rsp->hdr.size - sizeof(*rsp))
>> +             *ibuf_len = rsp->hdr.size - sizeof(*rsp);
>> +
>> +     memcpy(ibuf, rsp + 1, *ibuf_len);
>> +
>> +out_free_rx_slot:
>> +     free_rx_slot(dln2, handle, rx_slot);
>> +out_decr:
>> +     spin_lock(&dln2->disconnect_lock);
>> +     dln2->active_transfers--;
>> +     spin_unlock(&dln2->disconnect_lock);
>> +     if (dln2->disconnect)
>> +             wake_up(&dln2->disconnect_wq);
>> +
>> +     return ret;
>> +}
>
>> +static void dln2_disconnect(struct usb_interface *interface)
>> +{
>> +     struct dln2_dev *dln2 = usb_get_intfdata(interface);
>> +     int i, j;
>> +
>> +     /* don't allow starting new transfers */
>> +     spin_lock(&dln2->disconnect_lock);
>> +     dln2->disconnect = true;
>> +     spin_unlock(&dln2->disconnect_lock);
>> +
>> +     /* cancel in progress transfers */
>> +     for (i = 0; i < DLN2_HANDLES; i++) {
>> +             struct dln2_mod_rx_slots *rxs = &dln2->mod_rx_slots[i];
>> +             unsigned long flags;
>> +
>> +             spin_lock_irqsave(&rxs->lock, flags);
>
> Just stick to spin_lock in this function.
>

AFAICS disconnect is called from a kernel thread. Are there guarantees
that we can't get a call to the completion routine while we are
running it?
