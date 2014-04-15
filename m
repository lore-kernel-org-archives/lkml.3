Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaDOKLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:11:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44443 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaDOKLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:11:02 -0400
Date: Tue, 15 Apr 2014 11:10:33 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V5.1] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
Message-ID: <20140415111033.102bc5af@alan.etchedpixels.co.uk>
In-Reply-To: <20140415080649.19209.60645.stgit@yunodevel>
References: <20140415055216.14660.18270.stgit@yunodevel>
	<20140415080649.19209.60645.stgit@yunodevel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
> +{
> +	const struct serial8250_config *conf_type = &uart_config[up->port.type];
> +	int i;
> +
> +	if (!conf_type->rx_trig_byte[FCR_RX_TRIG_BITS(UART_FCR_R_TRIG_00)]) {
> +		pr_info("Not support RX-trigger setting for this serial %s\n",
> +			conf_type->name);
> +		return -EOPNOTSUPP;

We don't want the pr_info here - otherwise users can flood the logs. The
err code is sufficient.

> +	for (i = 1; i < FCR_RX_TRIG_MAX_STATE; i++) {
> +		if (val < conf_type->rx_trig_byte[i])
> +			/* Use the nearest lower value */
> +			return (--i) << FCR_RX_TRIG_OFFSET;

Odd case here - your 16654 entry has a minimum of 8 so if I pass 1 then
it'll return -1 ? I guess for that case the best we can do is to set 8.

Other trivial thing to tweak - you have "uaser" in spot instead of "user".

With those two fixed it looks good to me.

Alan
