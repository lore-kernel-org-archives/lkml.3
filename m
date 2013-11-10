Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008Ab3KJFDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 00:03:48 -0500
Received: from relais.videotron.ca ([24.201.245.36]:10420 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3KJFDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 00:03:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Sun, 10 Nov 2013 00:03:42 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Christopher Covington <cov@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
In-reply-to: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
Message-id: <alpine.LFD.2.10.1311092357090.2314@knanqh.ubzr>
References: <1383951632-6090-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013, Stephen Boyd wrote:

> If we're running on a v7 ARM CPU, detect if the CPU supports the
> sdiv/udiv instructions and replace the signed and unsigned
> division library functions with an sdiv/udiv instruction.
> 
> Running the perf messaging benchmark in pipe mode
> 
>  $ perf bench sched messaging -p
> 
> shows a modest improvement on my v7 CPU.
> 
> before:
> (5.060 + 5.960 + 5.971 + 5.643 + 6.029 + 5.665 + 6.050 + 5.870 + 6.117 + 5.683) / 10 = 5.805
> 
> after:
> (4.884 + 5.549 + 5.749 + 6.001 + 5.460 + 5.103 + 5.956 + 6.112 + 5.468 + 5.093) / 10 = 5.538
> 
> (5.805 - 5.538) / 5.805 = 4.6%
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Bah..... NAK.

We are doing runtime patching of the kernel for many many things
already.  So why not do the same here?

The obvious strategy is to simply overwrite the start of the existing 
__aeabi_idiv code with the "sdiv r0, r0, r1" and "bx lr" opcodes.  

Similarly for the unsigned case.

That let you test the hardware capability only once during boot instead 
of everytime a divide operation is performed.


Nicolas
