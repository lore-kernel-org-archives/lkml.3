Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBQPMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:12:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34515 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaBQPMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:12:46 -0500
Date: Mon, 17 Feb 2014 15:12:22 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2] serial/uart: Add tunable RX interrupt trigger I/F of
 FIFO buffers
Message-ID: <20140217151222.3488abb6@alan.etchedpixels.co.uk>
In-Reply-To: <20140217044812.4868.28106.stgit@yunodevel>
References: <20140217044812.4868.28106.stgit@yunodevel>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> According to HW specification of serial UART devices, RX interrupt trigger
> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
> the trigger to only 8bytes.
> 
> This patch makes a 16550A device change RX interrupt trigger from userland.

We probably need to be much smarter about how we set this as lots of non
16550A type devices have a tunable trigger. 

We tune it dynamically based upon baud rate for many platforms, and we
turn it on and off according to low latency settings. In other words we
can't just have an ioctl poking values about in parallel and without any
locking.

For the API IMHO this really belongs in sysfs IMHO. That does mean we need
to turn the existing sysfs API read/write by adding a few set methods not
just get ones in drivers/tty/serial/ but it would be a lot cleaner and
the uart_set_info path does the correct stopping and restarting as well
as locking for the fifo size change.

Alan
