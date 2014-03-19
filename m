Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaCSFUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:20:24 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40548 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaCSFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAKrE-KcorYUZOpUOaU7qcBbyJ+FHUFZN_r+paMrL7gq+052RwQ@mail.gmail.com>
References: <1395168169-28978-1-git-send-email-jaswinder.singh@linaro.org>
	<1395168335-29119-1-git-send-email-jaswinder.singh@linaro.org>
	<CAKrE-KcorYUZOpUOaU7qcBbyJ+FHUFZN_r+paMrL7gq+052RwQ@mail.gmail.com>
Date: Wed, 19 Mar 2014 10:50:22 +0530
Message-ID: <CAJe_ZhcM6d0ODTsOsuUwLwWSWE_hyCufmwW8_hxnqPdMQ2ukSg@mail.gmail.com>
Subject: Re: [PATCHv4 2/5] mailbox: Introduce framework for mailbox
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Girish KS <girishks2000@gmail.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Anna, Suman" <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 09:30, Girish KS <girishks2000@gmail.com> wrote:
> On Wed, Mar 19, 2014 at 12:15 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:

>> +int mbox_send_message(struct mbox_chan *chan, void *mssg)
>> +{
>> +       int t;
>> +
>> +       if (!chan || !chan->cl)
>> +               return -EINVAL;
>> +
>> +       t = _add_to_rbuf(chan, mssg);
>> +       if (t < 0) {
>> +               pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
>> +               return t;
>> +       }
>> +
>> +       _msg_submit(chan);
>> +
>> +       if (chan->txdone_method == TXDONE_BY_POLL)
>> +               poll_txdone((unsigned long)chan->con);
>
> I came across a panic in the complete function. When i traced bact the
> call sequence it was
> When a client sets chan->cl->tx_block = true, and polling is enabled
> for controller.
> 1.Client sends the message with  mbox_send_message. This function as
> seen above will call __msg_submit (this calls the controller specific
> send function).
> 2. Since the tx method is polling the above condition is satisfied and
> calls the poll_txdone function.
> 3. In this poll function, the tx_tick function is invoked.
> 4. In this tick function since the client has enabled the tx_block it
> calls the notify function complete(&chan->tx_complete);
> 5. Here there is a panic. because the complete is called before
> initialization. init_completion needs to be called but not called.
>
Are you sure you have applied the patch "[PATCHv4 4/5] mailbox: Fix TX
completion init" ?

Thanks
Jassi
