Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3H3NXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:23:20 -0400
Received: from smtp-out-137.synserver.de ([212.40.185.137]:1074 "EHLO
	smtp-out-137.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3H3NXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:23:18 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8199
Message-ID: <52209D1D.3080102@metafoo.de>
Date: Fri, 30 Aug 2013 15:24:45 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Clock framework deadlock with external SPI clockchip
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently facing a deadlock in the common clock framework that
unfortunately is not addressed by the reentrancy patches. I have a external
clock chip that is controlled via SPI. So for example to configure the rate
of the clock chip you need to send a SPI message. Naturally the clock
framework will hold the prepare lock while configuring the rate.
Communication in the SPI framework happens asynchronously, spi_sync() will
enqueue a message in the SPI masters queue and then wait using
wait_for_completion(). The master will call complete() once the transfer has
been finished. The SPI master runs in it's own thread in which it processes
the messages. In this thread it also calls clk_set_rate() to configure the
SPI transfer clock rate based on what the message says. Now the deadlock
happens as we try to take the prepare_lock again and since the clock chip
and the SPI master run in different threads the reentrancy code does not
kick in.

The basic sequence is like this:

=== Clock chip driver ===        === SPI master driver ===
 clk_prepare_lock()
 spi_sync()
   wait_for_completion(X)
                                 clk_get_rate()
			           clk_prepare_lock() <--- DEADLOCK
				   clk_prepare_unlock()
				 ...
				 complete(X)
 ...
 clk_prepare_unlock()

I'm wondering if you have any idea how this can be fixed. In my opinion we'd
need a per clock mutex to address this properly.

Thanks,
- Lars
