Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3EISLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:11:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33872 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3EISLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:11:06 -0400
Message-ID: <518BE566.5090504@ti.com>
Date: Thu, 9 May 2013 13:05:26 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 2/4] mailbox: Introduce a new common API
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org> <1367825046-6229-1-git-send-email-jaswinder.singh@linaro.org> <518BCF4B.1060504@ti.com> <CAJe_Zhd=FDV3YP=XR8Yay1iy_geAt3tqj+diUxrVkd2BFSfb-g@mail.gmail.com> <518BD197.2030502@ti.com> <CABb+yY2CnO5RiQNdcB_L5ZiGi829Ys0ODH2UmhtZxj=aJo3ioQ@mail.gmail.com>
In-Reply-To: <CABb+yY2CnO5RiQNdcB_L5ZiGi829Ys0ODH2UmhtZxj=aJo3ioQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jassi,

On 05/09/2013 12:48 PM, Jassi Brar wrote:
> On Thu, May 9, 2013 at 10:10 PM, Suman Anna <s-anna@ti.com> wrote:
>> On 05/09/2013 11:41 AM, Jassi Brar wrote:
>>> On 9 May 2013 22:01, Suman Anna <s-anna@ti.com> wrote:
>>>> Hi Jassi,
>>>>
>>>> On 05/06/2013 02:24 AM, Jassi Brar wrote:
>>>>> +++ b/include/linux/mailbox_client.h
>>>>> @@ -0,0 +1,85 @@
>>>>> +/*
>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>> + * published by the Free Software Foundation.
>>>>> + */
>>>>> +
>>>>> +#ifndef __MAILBOX_CLIENT_H
>>>>> +#define __MAILBOX_CLIENT_H
>>>>> +
>>>>> +#include <linux/mailbox.h>
>>>>> +
>>>>> +/**
>>>>> + * struct ipc_client - User of a mailbox
>>>>> + * @chan_name: the "controller:channel" this client wants
>>>>> + * @rxcb: atomic callback to provide client the data received
>>>>> + * @txcb: atomic callback to tell client of data transmission
>>>>> + * @tx_block: if the ipc_send_message should block until data is transmitted
>>>>> + * @tx_tout: Max block period in ms before TX is assumed failure
>>>>> + * @knows_txdone: if the client could run the TX state machine. Usually if
>>>>> + *    the client receives some ACK packet for transmission. Unused if the
>>>>> + *    controller already has TX_Done/RTR IRQ.
>>>>> + * @cntlr_data: Optional controller specific parameters during channel request
>>>>> + */
>>>>> +struct ipc_client {
>>>>> +     char *chan_name;
>>>>> +     void (*rxcb)(void *data);
>>>>> +     void (*txcb)(request_token_t t, enum xfer_result r);
>>>>
>>>> We have to introduce a callback data pointer, so that the calling
>>>> clients can retrieve a context object variable or some other useful
>>>> data within the callback functions, just like most normal callback
>>>> function declarations and registrations do.
>>>>
>>> I meant the request_token_t for the purpose. That's how we do with DMAEngine.
>>
>> I faced this issue on the rxcb while adopting the
>> omap_rproc_mbox_callback. omap_remoteproc is a common driver for all the
>> OMAP co-processors and there can be multiple instances, providing the
>> same set of features. Look at the code in
>> drivers/remoteproc/omap_remoteproc.c and you will get the idea. But in
>> general, the users registering callback functions would prefer to get
>> some context pointer back.
>>
> Of course they do. The request_token_t returned corresponds to the
> request they submit via ipc_send_message.
> 
> Perhaps we should change the following
> 
>    void ipc_link_txdone(struct ipc_link *link, enum xfer_result r)
> to
>    void ipc_link_txdone(struct ipc_link *link, enum xfer_result r, void *data)
> 
> So that the API could pass that onto clients ?

That's if the controller needs to pass some data back to client. I am
fine with that as well, but I am talking mainly about providing a client
user data ptr back to it during callbacks.

struct ipc_client {
	char *chan_name;
+	void *cl_data; /* store it to ipc_chan as well */
-	void (*rxcb)(void *data);
-	void (*txcb)(request_token_t t, enum xfer_result r);
+	void (*rxcb)(void *cl_data, void *data);
+	void (*txcb)(request_token_t t, enum xfer_result r, void *cl_data);
	...
}

I am obviously interested in the rxcb. The controller implementations do
not see the cl_data.

regards
Suman
