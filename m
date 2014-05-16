Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbaEPNdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:32 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:65323 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaEPNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:26 -0400
MIME-Version: 1.0
In-Reply-To: <7978295.UBGxYvcnvH@wuerfel>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
	<1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
	<7978295.UBGxYvcnvH@wuerfel>
Date: Fri, 16 May 2014 19:03:25 +0530
Message-ID: <CAJe_Zhe_VFTpPW0sKBsqit347MR7QmEDvzvQTyh1DWr3v991tg@mail.gmail.com>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Rob Herring <robherring2@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 May 2014 19:57, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 15 May 2014 11:41:00 Jassi Brar wrote:
>> Introduce common framework for client/protocol drivers and
>> controller drivers of Inter-Processor-Communication (IPC).
>>
>> Client driver developers should have a look at
>>  include/linux/mailbox_client.h to understand the part of
>> the API exposed to client drivers.
>> Similarly controller driver developers should have a look
>> at include/linux/mailbox_controller.h
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>
> I hadn't followed all the previous versions, but this looks very nice!
>
> I only have comments about tiny details.
>
>> new file mode 100644
>> index 0000000..0eb2fb0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
>> @@ -0,0 +1,30 @@
>> +* Generic Mailbox Controller and client driver bindings
>> +
>> +Generic binding to provide a way for Mailbox controller drivers to assign appropriate mailbox channel to client drivers.
>> +
>> +* MAILBOX Controller
>
> Just formatting: wrap the lines after 70 characters, and don't use
> capital letters for 'mailbox'.
>
OK, will fix. I usually do care about 80 char limits, but here
checkpatch didn't catch it either.

>> +
>> +enum mbox_result {
>> +     MBOX_OK = 0,
>> +     MBOX_ERR,
>> +};
>
> How about using a standard error number?
>
OK

>> +/**
>> + * struct mbox_client - User of a mailbox
>> + * @dev:             The client device
>> + * @chan_name:               The "controller:channel" this client wants
>> + * @rx_callback:     Atomic callback to provide client the data received
>> + * @tx_done:         Atomic callback to tell client of data transmission
>> + * @tx_block:                If the mbox_send_message should block until data is
>> + *                   transmitted.
>> + * @tx_tout:         Max block period in ms before TX is assumed failure
>> + * @knows_txdone:    if the client could run the TX state machine. Usually
>> + *                   if the client receives some ACK packet for transmission.
>> + *                   Unused if the controller already has TX_Done/RTR IRQ.
>> + */
>> +struct mbox_client {
>> +     struct device *dev;
>> +     const char *chan_name;
>> +     void (*rx_callback)(struct mbox_client *cl, void *mssg);
>> +     void (*tx_done)(struct mbox_client *cl, void *mssg, enum mbox_result r);
>> +     bool tx_block;
>> +     unsigned long tx_tout;
>> +     bool knows_txdone;
>> +};
>> +
>> +struct mbox_chan *mbox_request_channel(struct mbox_client *cl);
>
> Is it possible to make the argument 'const'?
>
Yes, will do.

> Maybe document how you expect an mbox_client to be allocated:
> - static const definition in driver
> - dynamically allocated and embedded in some client specific struct
> - on the stack and discarded after mbox_request_channel()
>
OK. The struct needs to be preserved until free_channel returns. So
clients may allocate on stack for quick single xfer or dynamically
allocated for 'server' type clients.

>> +/**
>> + * struct mbox_controller - Controller of a class of communication chans
>> + * @dev:             Device backing this controller
>> + * @controller_name: Literal name of the controller.
>> + * @ops:             Operators that work on each communication chan
>> + * @chans:           Null terminated array of chans.
>> + * @txdone_irq:              Indicates if the controller can report to API when
>> + *                   the last transmitted data was read by the remote.
>> + *                   Eg, if it has some TX ACK irq.
>> + * @txdone_poll:     If the controller can read but not report the TX
>> + *                   done. Ex, some register shows the TX status but
>> + *                   no interrupt rises. Ignored if 'txdone_irq' is set.
>> + * @txpoll_period:   If 'txdone_poll' is in effect, the API polls for
>> + *                   last TX's status after these many millisecs
>> + */
>> +struct mbox_controller {
>> +     struct device *dev;
>> +     struct mbox_chan_ops *ops;
>> +     struct mbox_chan *chans;
>> +     int num_chans;
>> +     bool txdone_irq;
>> +     bool txdone_poll;
>> +     unsigned txpoll_period;
>> +     struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
>> +                                     const struct of_phandle_args *sp);
>> +     /*
>> +      * If the controller supports only TXDONE_BY_POLL,
>> +      * this timer polls all the links for txdone.
>> +      */
>> +     struct timer_list poll;
>> +     unsigned period;
>> +     /* Hook to add to the global controller list */
>> +     struct list_head node;
>> +} __aligned(32);
>
> What is the __aligned(32) for?
>
Attempt to align access to mailbox?

I am still open to opinion about whether the mailbox ownership should
be exclusive or shared among clients. Need to handle async messages
from remote is one reason one might want more than one client to own a
channel. Allowing for RX via notifiers might be one option but that
breaks semantics of 'ownership' of a mailbox channel.
 Also, some platform might need to communicate with remote master
during very early boot like for initializing system timers and clocks.
The API isn't working then.

Thanks
Jassi
