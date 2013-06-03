Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3FCOqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:46:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:49059 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3FCOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:45:58 -0400
Date: Mon, 3 Jun 2013 16:45:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ivo Sieben <meltedpianoman@gmail.com>
cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH-v2] Set irq thread to RT priority on creation
In-Reply-To: <1370254322-17240-1-git-send-email-meltedpianoman@gmail.com>
Message-ID: <alpine.LFD.2.02.1306031637420.2905@ionos>
References: <alpine.LFD.2.02.1305302147290.2905@ionos> <1370254322-17240-1-git-send-email-meltedpianoman@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Ivo Sieben wrote:

> When a threaded irq handler is installed the irq thread is initially created
> on normal scheduling priority. Only after the the irq thread is woken up it
> immediately sets its priority to RT_FIFO MAX_USER_RT_PRIO/2.
> 
> This means that interrupts that occur directly after the irq handler is
> installed will be handled on a normal scheduling priority instead of the
> realtime priority that you would expect. Fixed this by setting the RT
> priority on creation of the irq_thread.
> 
> This solves the following issue with a UART device driver:
> On start of the application there is already data present in the uart RX
> fifo buffer. On opening the uart device the hard & threaded interrupt
> handlers are installed and the interrupts are enabled. Immediately a hard
> irq occurs because there is still data in the RX fifo. Because the threaded
> irq handler is still on normal scheduling, my application is not immediatly
> interrupted by the threaded handler and continues to run: it tries to flush
> the uart input buffer and writes data to the uart device. After this the
> threaded handler finally gets scheduled in and fills the buffer with the
> "old" received data. When my application reads data from the uart port it
> receives the "old" data and gives an error.

While I in principle agree with the patch, the issue you are
describing is just solved accidentaly.

The question is why there is data present in the UART when the UART
driver has not initialized the UART. Up to the point where the UART is
opened and the interrupt handler is installed the receiver should be
disabled. Also there is the question why a flush does not kill
everything including the pending data in the UART itself.

And I don't think, that your issue is solved completely. Assume the
following:

Open UART
Flush Buffers (including UART fifo)

---> UART receives data
---> Interrupt
	Data is available in tty buffer

Write data to UART

Receive data from UART

You still get data which got into the buffer before you sent stuff
out. So your application should not be surpriced at all by random data
on the receive line when it starts up.

Thanks,

	tglx
