Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3FEGqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:46:42 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:34384 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3FEGqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:46:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1306031637420.2905@ionos>
References: <alpine.LFD.2.02.1305302147290.2905@ionos>
	<1370254322-17240-1-git-send-email-meltedpianoman@gmail.com>
	<alpine.LFD.2.02.1306031637420.2905@ionos>
Date: Wed, 5 Jun 2013 08:46:38 +0200
Message-ID: <CAMSQXEE85BW+w-7+gxWH257SQq9rBuFVym6urDjWGZ11p9GPxA@mail.gmail.com>
Subject: Re: [PATCH-v2] Set irq thread to RT priority on creation
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2013/6/3 Thomas Gleixner <tglx@linutronix.de>:
>
> The question is why there is data present in the UART when the UART
> driver has not initialized the UART. Up to the point where the UART is
> opened and the interrupt handler is installed the receiver should be
> disabled. Also there is the question why a flush does not kill
> everything including the pending data in the UART itself.
>
> And I don't think, that your issue is solved completely. Assume the
> following:
>
> Open UART
> Flush Buffers (including UART fifo)
>
> ---> UART receives data
> ---> Interrupt
>         Data is available in tty buffer
>
> Write data to UART
>
> Receive data from UART
>
> You still get data which got into the buffer before you sent stuff
> out. So your application should not be surpriced at all by random data
> on the receive line when it starts up.
>
> Thanks,
>
>         tglx

You are absolutely right, the real issue was that my UART device still
received data while the device was closed. And yes, the protocol that
we use should be robust to unexpected data. I solved & will solve
these problems now. So you indeed the uart explanation in my commit
log should be removed.

The point is that we while we were debugging & tracing this problem,
we didn't expect this behavior: in the trace we saw a threaded handler
scheduled in on 'normal' priority which surprised us. Also I think
there are situations thinkable (altough I cannot come up with a proper
example) where it is normal behavior that a IRQ directly kicks in
after enabling the interrupts.

Regards,
Ivo Sieben
