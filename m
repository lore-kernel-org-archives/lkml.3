Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaEOO1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:27:45 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58663 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaEOO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:27:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, s-anna@ti.com,
        loic.pallardy@st.com, lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
Date: Thu, 15 May 2014 16:27:20 +0200
Message-ID: <7978295.UBGxYvcnvH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org> <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BypUVpo4WdTSHWQDEmQAZ6qkNJ5SyiA/7RWKPy/9col
 gvSmoUlprb/L5Pqg+w/gWY69r2H9HvlAzYiskfufOsNdk1ZF/l
 2vDWPfHluzgU23rPUOO5VJ1sajjvW8dlZu2PTp0UcadqFMN0rq
 MJK1PJW4mHZkve4Kvk3cjiOQQYJg68k2AdhduIgdMZF2kQLVP3
 CGeFmNDY2s2UdvdX2wxBaTJFdO29KUaTjEjO8boyzpbKaiaUZy
 D+DLxZM2EgBSiw7ntwSvlVAL/MRydgOpCiad5AHM2+ABXryfyd
 os3fxDTYa029dZq5DCoUl9Gp9MSe8LTfSKuXPLFgzRNhF9uGkX
 kkeiRaNdgikacRh7oEq0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 11:41:00 Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
> 
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>

I hadn't followed all the previous versions, but this looks very nice!

I only have comments about tiny details.

> new file mode 100644
> index 0000000..0eb2fb0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/mailbox.txt
> @@ -0,0 +1,30 @@
> +* Generic Mailbox Controller and client driver bindings
> +
> +Generic binding to provide a way for Mailbox controller drivers to assign appropriate mailbox channel to client drivers.
> +
> +* MAILBOX Controller

Just formatting: wrap the lines after 70 characters, and don't use
capital letters for 'mailbox'.
> +
> +enum mbox_result {
> +	MBOX_OK = 0,
> +	MBOX_ERR,
> +};

How about using a standard error number?

> +/**
> + * struct mbox_client - User of a mailbox
> + * @dev:		The client device
> + * @chan_name:		The "controller:channel" this client wants
> + * @rx_callback:	Atomic callback to provide client the data received
> + * @tx_done:		Atomic callback to tell client of data transmission
> + * @tx_block:		If the mbox_send_message should block until data is
> + *			transmitted.
> + * @tx_tout:		Max block period in ms before TX is assumed failure
> + * @knows_txdone:	if the client could run the TX state machine. Usually
> + *			if the client receives some ACK packet for transmission.
> + *			Unused if the controller already has TX_Done/RTR IRQ.
> + */
> +struct mbox_client {
> +	struct device *dev;
> +	const char *chan_name;
> +	void (*rx_callback)(struct mbox_client *cl, void *mssg);
> +	void (*tx_done)(struct mbox_client *cl, void *mssg, enum mbox_result r);
> +	bool tx_block;
> +	unsigned long tx_tout;
> +	bool knows_txdone;
> +};
> +
> +struct mbox_chan *mbox_request_channel(struct mbox_client *cl);

Is it possible to make the argument 'const'?

Maybe document how you expect an mbox_client to be allocated:
- static const definition in driver
- dynamically allocated and embedded in some client specific struct
- on the stack and discarded after mbox_request_channel()

> +/**
> + * struct mbox_controller - Controller of a class of communication chans
> + * @dev:		Device backing this controller
> + * @controller_name:	Literal name of the controller.
> + * @ops:		Operators that work on each communication chan
> + * @chans:		Null terminated array of chans.
> + * @txdone_irq:		Indicates if the controller can report to API when
> + *			the last transmitted data was read by the remote.
> + *			Eg, if it has some TX ACK irq.
> + * @txdone_poll:	If the controller can read but not report the TX
> + *			done. Ex, some register shows the TX status but
> + *			no interrupt rises. Ignored if 'txdone_irq' is set.
> + * @txpoll_period:	If 'txdone_poll' is in effect, the API polls for
> + *			last TX's status after these many millisecs
> + */
> +struct mbox_controller {
> +	struct device *dev;
> +	struct mbox_chan_ops *ops;
> +	struct mbox_chan *chans;
> +	int num_chans;
> +	bool txdone_irq;
> +	bool txdone_poll;
> +	unsigned txpoll_period;
> +	struct mbox_chan *(*of_xlate)(struct mbox_controller *mbox,
> +					const struct of_phandle_args *sp);
> +	/*
> +	 * If the controller supports only TXDONE_BY_POLL,
> +	 * this timer polls all the links for txdone.
> +	 */
> +	struct timer_list poll;
> +	unsigned period;
> +	/* Hook to add to the global controller list */
> +	struct list_head node;
> +} __aligned(32);

What is the __aligned(32) for?

	Arnd
