Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaIQKnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:43:20 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:56849 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaIQKnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:43:18 -0400
Date: Wed, 17 Sep 2014 11:40:29 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: <suravee.suthikulpanit@amd.com>
Cc: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-apci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <Sudeep.Holla@arm.com>, <olof@lixom.net>,
        <grant.likely@linaro.org>, <graeme.gregory@linaro.org>,
        <arnd@arndb.de>, <jason@lakedaemon.net>
Subject: Re: [PATCH 4/4] [RFC PATCH for Juno 2/2] tty: SBSA compatible UART
Message-ID: <20140917114029.190eb8f9@alan.etchedpixels.co.uk>
In-Reply-To: <1410828446-28502-5-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1410828446-28502-5-git-send-email-suravee.suthikulpanit@amd.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly provide some useful information about the hardware. It's no good
wavng your arms at a document that requires agreeing to a giant ARM T&C
to get access to. Most of don't work for ARM and we'd have to get our own
corporate legal to approve the legal garbage involved.

Secondly explain why you can't use PL011 given that it already supports
non DMA accesses. What would it take to tweak it further for this ?


> +static void sbsa_tty_do_write(const char *buf, unsigned count)
> +{
> +	unsigned long irq_flags;
> +	struct sbsa_tty *qtty = sbsa_tty;
> +	void __iomem *base = qtty->base;
> +	unsigned n;
> +
> +	spin_lock_irqsave(&qtty->lock, irq_flags);
> +	for (n = 0; n < count; n++) {
> +		while (readw(base + UART01x_FR) & UART01x_FR_TXFF)
> +			mdelay(10);
> +		writew(buf[n], base + UART01x_DR);

serious - you are going to sit and spin in kernel space with interrupts
off for an indefinite period ?

No. Even if your hardware is so completely brain dead and broken that it
hasn't got an interrupt for 'write room' that's not acceptable. You need
error handling and some kind of sensible timer based solution.

To put it simply. You have a queue (or you should - your driver is broken
in that respect too), you have a baud rate, you have a bit time. From
that you can compute sensible wakeup points to try and refill the
hardware FIFO. Assuming the hardware fifo is not tiny you don't even have
to be that good an aim.

It's acceptable for the printk console code to spin, if you think getting
the message out on a failure or error outweighs the pain. It's not
acceptable for the tty layer.

> +static void sbsauart_fifo_to_tty(struct sbsa_tty *qtty)
> +{
> +	void __iomem *base = qtty->base;
> +	unsigned int flag, max_count = 32;
> +	u16 status, ch;
> +
> +	while (max_count--) {
> +		status = readw(base + UART01x_FR);
> +		if (status & UART01x_FR_RXFE)
> +			break;
> +
> +		/* Take chars from the FIFO and update status */
> +		ch = readw(base + UART01x_DR);
> +		flag = TTY_NORMAL;
> +
> +		if (ch & UART011_DR_BE)
> +			flag = TTY_BREAK;
> +		else if (ch & UART011_DR_PE)
> +			flag = TTY_PARITY;
> +		else if (ch & UART011_DR_FE)
> +			flag = TTY_FRAME;
> +		else if (ch & UART011_DR_OE)
> +			flag = TTY_OVERRUN;
> +
> +		ch &= SBSAUART_CHAR_MASK;
> +
> +		tty_insert_flip_char(&qtty->port, ch, flag);

If its a console you ought to support the sysrq interfaces.

> +static int sbsa_tty_write_room(struct tty_struct *tty)
> +{
> +	return 32;
> +}

You can't do this. You need a proper queue and queueing mechanism or
you'll break in some situations (aside from sitting spinning in your
write code trashing your system performance entirely). We have a kfifo
object in the kernel which is really trivial to use and should do what
you need without any effort.

> +
> +static void sbsa_tty_console_write(struct console *co, const char *b,
> +								unsigned count)
> +{
> +	sbsa_tty_do_write(b, count);
> +
> +	if(b[count - 1] == '\n');
> +		sbsa_tty_do_write("\r", 1);

I would expect \r\n to be the order ?

> +static struct tty_port_operations sbsa_port_ops = {
> +};

No power management ?

> +
> +static const struct tty_operations sbsa_tty_ops = {
> +	.open = sbsa_tty_open,
> +	.close = sbsa_tty_close,
> +	.hangup = sbsa_tty_hangup,
> +	.write = sbsa_tty_write,
> +	.write_room = sbsa_tty_write_room,

No termios handling ?

> +static int sbsa_tty_probe(struct platform_device *pdev)
> +{
> +	struct sbsa_tty *qtty;
> +	int ret = -EINVAL;
> +	int i;
> +	struct resource *r;
> +	struct device *ttydev;
> +	void __iomem *base;
> +	u32 irq;
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (r == NULL)
> +		return -EINVAL;
> +
> +	base = ioremap(r->start, r->end - r->start);
> +	if (base == NULL)
> +		pr_err("sbsa_tty: unable to remap base\n");

So you are then going to continue and randomly crash  ???

Also you've got a device so use dev_err() and friends on it

> +	if (pdev->id > 0)
> +		goto err_unmap;

Why not test this before you do all the mapping ??


It's clean code, it's easy to understand it just doesn't seem to be very
complete ?

Alan
