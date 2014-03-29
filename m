Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaC2Dyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 23:54:47 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63426 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaC2Dyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 23:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <1396044491-22854-1-git-send-email-markus.mayer@linaro.org>
References: <1395168335-29119-1-git-send-email-jaswinder.singh@linaro.org>
	<1396044491-22854-1-git-send-email-markus.mayer@linaro.org>
Date: Sat, 29 Mar 2014 09:24:45 +0530
Message-ID: <CABb+yY3N0e3yTf=+2aqM0gWM8xcnybBWNSJxGezUC5uckAQBGg@mail.gmail.com>
Subject: Re: [PATCHv4,2/5] mailbox: Introduce framework for mailbox
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Suman Anna <s-anna@ti.com>,
        Tony Lindgren <tony@atomide.com>,
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
        Kumar Gala <galak@codeaurora.org>, Girish K S <ks.giri@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 3:38 AM, Markus Mayer <markus.mayer@linaro.org> wrote:

.....

>> +int mbox_send_message(struct mbox_chan *chan, void *mssg)
>> +{
>> +     int t;
>> +
>> +     if (!chan || !chan->cl)
>> +             return -EINVAL;
>> +
>> +     t = _add_to_rbuf(chan, mssg);
>> +     if (t < 0) {
>> +             pr_err("Try increasing MBOX_TX_QUEUE_LEN\n");
>> +             return t;
>> +     }
>> +
>> +     _msg_submit(chan);
>> +
>> +     if (chan->txdone_method == TXDONE_BY_POLL)
>> +             poll_txdone((unsigned long)chan->con);
>
> Wouldn't it be cleaner to use
>                 poll_txdone((unsigned long)&chan->con);
> ?
>
Here's how we use it ...

static void poll_txdone(unsigned long data)
{
     struct mbox_con *con = (struct mbox_con *)data;
     .....
}

To me, unnecessarily passing a pointer to a pointer seems unclean.


>> +int mbox_controller_register(struct mbox_controller *mbox)
>> +{
>> +     int i, num_links, txdone;
>> +     struct mbox_chan *chan;
>> +     struct mbox_con *con;
>> +
>> +     /* Sanity check */
>> +     if (!mbox || !mbox->ops)
>> +             return -EINVAL;
>> +
>> +     for (i = 0; mbox->links[i]; i++)
>> +             ;
>> +     if (!i)
>> +             return -EINVAL;
>> +     num_links = i;
>> +
>> +     mutex_lock(&con_mutex);
>> +     /* Check if already populated */
>> +     list_for_each_entry(con, &mbox_cons, node)
>> +             if (!strcmp(mbox->controller_name, con->name)) {
>> +                     mutex_unlock(&con_mutex);
>> +                     return -EINVAL;
>> +             }
>> +
>> +     con = kzalloc(sizeof(struct mbox_con), GFP_KERNEL);
>> +     if (!con)
>> +             return -ENOMEM;
>
> The mutex is not freed here.
>
>> +
>> +     chan = kzalloc(sizeof(struct mbox_chan) * num_links, GFP_KERNEL);
>> +     if (!chan) {
>> +             kfree(con);
>> +             return -ENOMEM;
>
> Again, the mutex is not freed.
>
> You could move both allocations above the mutex. Then you won't have to
> worry about it.
>
Yes thanks. I overlooked. Will fix it.

Regards,
-Jassi
