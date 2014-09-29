Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaI2LRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:17:20 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39230 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaI2LRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:17:18 -0400
Message-ID: <54293F2C.2090206@gmail.com>
Date: Mon, 29 Sep 2014 16:44:52 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Anders Berg <anders.berg@avagotech.com>
CC: Wolfram Sang <wsa@the-dreams.de>, devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: axxia: Add I2C driver for AXM55xx
References: <1411983159-4692-1-git-send-email-anders.berg@avagotech.com>	<54292F74.2030209@gmail.com> <CAE0=X_0guSvMqZxHvdS39Zxx4G7qVvnddv96t72rp4FwpJLgfA@mail.gmail.com>
In-Reply-To: <CAE0=X_0guSvMqZxHvdS39Zxx4G7qVvnddv96t72rp4FwpJLgfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 04:43 PM, Anders Berg wrote:
> On Mon, Sep 29, 2014 at 12:07 PM, Varka Bhadram <varkabhadram@gmail.com> wrote:
>> On 09/29/2014 03:02 PM, Anders Berg wrote:
>>> Add I2C bus driver for the controller found in the LSI Axxia family SoCs.
>>> The
>>> driver implements 10-bit addressing and SMBus transfer modes via emulation
>>> (including SMBus block data read).
>>>
>>> Signed-off-by: Anders Berg <anders.berg@avagotech.com>
>>> ---
>>>
> (...)
>>> +
>>> +       if (!idev->msg) {
>>> +               dev_warn(idev->dev, "unexpected interrupt");
>>
>> Missed terminating new line '\n'
>>
> Right, I'll fix that (all occurrences)
>
>>> +               goto out;
>>> +       }
>>> +
>>> +       /* RX FIFO needs service? */
>>> +       if (i2c_m_rd(idev->msg) && (status & MST_STATUS_RFL))
>>> +               axxia_i2c_empty_rx_fifo(idev);
>>> +
>>> +       /* TX FIFO needs service? */
>>> +       if (!i2c_m_rd(idev->msg) && (status & MST_STATUS_TFL)) {
>>> +               if (axxia_i2c_fill_tx_fifo(idev) == 0)
>>> +                       i2c_int_disable(idev, MST_STATUS_TFL);
>>> +       }
>>> +
>>> +       if (status & MST_STATUS_SCC) {
>>> +               /* Stop completed */
>>> +               i2c_int_disable(idev, ~0);
>>> +               complete(&idev->msg_complete);
>>> +       } else if (status & MST_STATUS_SNS) {
>>> +               /* Transfer done */
>>> +               i2c_int_disable(idev, ~0);
>>> +               if (i2c_m_rd(idev->msg) && idev->msg_xfrd <
>>> idev->msg->len)
>>> +                       axxia_i2c_empty_rx_fifo(idev);
>>> +               complete(&idev->msg_complete);
>>> +       } else if (unlikely(status & MST_STATUS_ERR)) {
>>> +               /* Transfer error */
>>> +               i2c_int_disable(idev, ~0);
>>> +               if (status & MST_STATUS_AL)
>>> +                       idev->msg_err = -EAGAIN;
>>> +               else if (status & MST_STATUS_NAK)
>>> +                       idev->msg_err = -ENXIO;
>>> +               else
>>> +                       idev->msg_err = -EIO;
>>> +               dev_dbg(idev->dev, "error %#x, addr=%#x rx=%u/%u
>>> tx=%u/%u\n",
>>> +                       status,
>>> +                       idev->msg->addr,
>>> +                       readl(idev->base + MST_RX_BYTES_XFRD),
>>> +                       readl(idev->base + MST_RX_XFER),
>>> +                       readl(idev->base + MST_TX_BYTES_XFRD),
>>> +                       readl(idev->base + MST_TX_XFER));
>>> +               complete(&idev->msg_complete);
>>> +       }
>>> +
>>> +out:
>>> +       /* Clear interrupt */
>>> +       writel(INT_MST, idev->base + INTERRUPT_STATUS);
>>> +
>>> +       return IRQ_HANDLED;
>>> +}
>>> +
>>
>> Its looks good if we move the entire ISR above probe/remove
>> functionalities...
>>
> Not sure what you mean here... The ISR _is_ above probe/remove.

I mean ISR should immediately above probe functionality. So that we can see
devm_request_irq(..,isr_name,..) ISR directly with isr name..

-- 
Regards,
Varka Bhadram.

