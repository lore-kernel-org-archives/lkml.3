Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935486AbaH0Ru5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:50:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54358 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbaH0Ruz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:50:55 -0400
Message-ID: <53FE1A7A.4010906@wwwdotorg.org>
Date: Wed, 27 Aug 2014 11:50:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Jassi Brar <jassisinghbrar@gmail.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>	<1408381705-3623-3-git-send-email-abrestic@chromium.org>	<53FB8820.4010202@wwwdotorg.org> <CAL1qeaERHeKKNpqh9qHOppgT7ymvntisdjVvZheP78U6NaPz-A@mail.gmail.com>
In-Reply-To: <CAL1qeaERHeKKNpqh9qHOppgT7ymvntisdjVvZheP78U6NaPz-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 11:38 AM, Andrew Bresticker wrote:
> On Mon, Aug 25, 2014 at 12:01 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
>>>
>>> The Tegra xHCI controller's firmware communicates requests to the host
>>> processor through a mailbox interface.  While there is only a single
>>> communication channel, messages sent by the controller can be divided
>>> into two groups: those intended for the PHY driver and those intended
>>> for the host-controller driver.  This mailbox driver exposes the two
>>> channels and routes incoming messages to the appropriate channel based
>>> on the command encoded in the message.
>>
>>
>>> diff --git a/drivers/mailbox/tegra-xusb-mailbox.c
>>> b/drivers/mailbox/tegra-xusb-mailbox.c

>>> +static struct mbox_chan *mbox_cmd_to_chan(struct tegra_xusb_mbox *mbox,
>>> u32 cmd)
>>> +{
>>> +       switch (cmd) {
>>> +       case MBOX_CMD_INC_FALC_CLOCK:
>>> +       case MBOX_CMD_DEC_FALC_CLOCK:
>>> +       case MBOX_CMD_INC_SSPI_CLOCK:
>>> +       case MBOX_CMD_DEC_SSPI_CLOCK:
>>> +       case MBOX_CMD_SET_BW:
>>> +               return &mbox->mbox.chans[TEGRA_XUSB_MBOX_CHAN_HOST];
>>> +       case MBOX_CMD_SAVE_DFE_CTLE_CTX:
>>> +       case MBOX_CMD_START_HSIC_IDLE:
>>> +       case MBOX_CMD_STOP_HSIC_IDLE:
>>> +               return &mbox->mbox.chans[TEGRA_XUSB_MBOX_CHAN_PHY];
>>> +       default:
>>> +               return NULL;
>>> +       }
>>> +}
>>
>>
>> This makes me think that the CHAN_HOST/CHAN_PHY values are purely a facet of
>> the Linux driver's message de-multiplexing, rather than anything to do with
>> the HW.
>
> Yup, they are...
>
>> I'm not even sure if it's appropriate for the low-level mailbox driver to
>> know about the semantics of the message, rather than simply sending them on
>> to the client driver? Perhaps when drivers register(?) for callbacks(?) for
>> messages, they should state which types of messages they want to listen to?
>
> So there's not really a way for the client driver to tell the mailbox
> driver which types of messages it wants to listen to on a particular
> channel with the mailbox framework - it simply provides a way for
> clients to bind with channels.  I think there are a couple of options
> here, either: a) have a channel per message (as you mentioned in the
> previous patch), which allows the client to only register for messages
> (channels) it wants to handle, or b) extend the mailbox framework to
> allow shared channels so that both clients can receive messages on the
> single channel and handle messages appropriately.   The disadvantage
> of (a) is that the commands are firmware defined and could
> theoretically change between releases of the firmware, though I'm not
> sure how common that is in practice.  So that leaves (b) - Jassi, what
> do you think about having shared (non-exclusive) channels?

Another alternative might be for each client driver to hard-code a 
unique dummy channel ID so that each client still gets a separate 
exclusive channel, but then have the mbox driver broadcast each message 
to each of those channels. I'm not sure that would be any better though; 
adding (b) as an explicit option to the mbox subsystem would almost 
certainly be cleaner.

>>> +static int tegra_xusb_mbox_probe(struct platform_device *pdev)
>>
>>
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>
>>> +       if (!res)
>>> +               return -ENODEV;
>>
>>
>> Should devm_request_mem_region() be called here to claim the region?
>
> No, the xHCI host driver also needs to map these registers, so they
> cannot be mapped exclusively here.

That's unfortunate. Having multiple drivers with overlapping register 
regions is not a good idea. Can we instead have a top-level driver map 
all the IO regions, then instantiate the various different 
sub-components internally, and divide up the address space. Probably via 
MFD or similar. That would prevent multiple drivers from touching the 
same register region.
