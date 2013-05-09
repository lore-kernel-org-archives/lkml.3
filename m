Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3EIStd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:49:33 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51422 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3EIStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <518BE566.5090504@ti.com>
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
	<1367825046-6229-1-git-send-email-jaswinder.singh@linaro.org>
	<518BCF4B.1060504@ti.com>
	<CAJe_Zhd=FDV3YP=XR8Yay1iy_geAt3tqj+diUxrVkd2BFSfb-g@mail.gmail.com>
	<518BD197.2030502@ti.com>
	<CABb+yY2CnO5RiQNdcB_L5ZiGi829Ys0ODH2UmhtZxj=aJo3ioQ@mail.gmail.com>
	<518BE566.5090504@ti.com>
Date: Fri, 10 May 2013 00:19:31 +0530
Message-ID: <CAJe_Zhffm9FOk83dAdX194gN3r5JnG78sdcWNv6WnWCsTF3YuA@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2013 23:35, Suman Anna <s-anna@ti.com> wrote:

>>
>> Perhaps we should change the following
>>
>>    void ipc_link_txdone(struct ipc_link *link, enum xfer_result r)
>> to
>>    void ipc_link_txdone(struct ipc_link *link, enum xfer_result r, void *data)
>>
>> So that the API could pass that onto clients ?
>
> That's if the controller needs to pass some data back to client. I am
> fine with that as well,
No, I misunderstood you wanted request_token_t to be replaced with the
pointer of request that was executed.

> but I am talking mainly about providing a client
> user data ptr back to it during callbacks.
>
> struct ipc_client {
>         char *chan_name;
> +       void *cl_data; /* store it to ipc_chan as well */
> -       void (*rxcb)(void *data);
> -       void (*txcb)(request_token_t t, enum xfer_result r);
> +       void (*rxcb)(void *cl_data, void *data);
> +       void (*txcb)(request_token_t t, enum xfer_result r, void *cl_data);
>         ...
> }
>
> I am obviously interested in the rxcb. The controller implementations do
> not see the cl_data.
>
OK I see what you mean. However the API storing and passing back
ad-hoc data to clients doesn't seem very neat.

Such purposes are usually served by :

- void (*rxcb)(void *data);
+ void (*rxcb)(struct ipc_client *cl, void *data);  /* client for
which data was received */

- void (*txcb)(request_token_t t, enum xfer_result r);
+ void (*txcb)(struct ipc_client *cl, request_token_t t, enum
xfer_result r); /* client whose data was sent */

You could then get relevant omap_rproc using container_of() on 'cl',
in rxcb() and txcb().


Apart from this, in txcb, perhaps we should drop request_token_t in
favor of the request's pointer (void *data) that was last executed.
That should make things easier for clients.

regards,
-jassi
