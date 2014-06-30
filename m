Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaF3QWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:22:35 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:38825 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaF3QWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:22:32 -0400
MIME-Version: 1.0
In-Reply-To: <1404144980.6148.6.camel@hobbes>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
	<1404144980.6148.6.camel@hobbes>
Date: Mon, 30 Jun 2014 21:52:27 +0530
Message-ID: <CAJe_Zhdg8J_GhxJJvJTyGDK-bAmXwEXmWh6d0biisM4M8o3a4g@mail.gmail.com>
Subject: Re: [PATCHv7 0/5] Common Mailbox Framework
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Patch Tracking <patches@linaro.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>, pa@jasper.es
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2014 21:46, Lubomir Rintel <lkundrak@v3.sk> wrote:
> Hi Jassi,
>
> On Thu, 2014-06-12 at 22:28 +0530, Jassi Brar wrote:
>> Hello,
>>   Here is the next revision of Mailbox framwork.
>
> I'm wondering whether you keep a Git tree with the framework we could
> keep the Raspberry Pi mailbox driver based on (bcm2835-mbox)?
>
> Also, from look at the API it does not seem to me that it's possible to
> synchronously (that is without a tx_done callback) collect a response
> when a message is sent with tx_block enabled. Equivalent to this: [1]
>
Thanks, good catch.

Could you please give this a try...

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index afa63cd..4059602 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -101,10 +101,11 @@ static void tx_tick(struct mbox_chan *chan, int r)
        _msg_submit(chan);

        /* Notify the client */
+       if (mssg && chan->cl->tx_done)
+               chan->cl->tx_done(chan->cl, mssg, r);
+
        if (chan->cl->tx_block)
                complete(&chan->tx_complete);
-       else if (mssg && chan->cl->tx_done)
-               chan->cl->tx_done(chan->cl, mssg, r);
 }

 static void poll_txdone(unsigned long data)

-jassi
