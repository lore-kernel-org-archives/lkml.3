Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaI3IoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:44:25 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:54605 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaI3IoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:44:21 -0400
X-ASG-Debug-ID: 1412066658-0759e74bdc798f30002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Tue, 30 Sep 2014 10:44:16 +0200
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Peter Hurley <peter@hurleysoftware.com>, <tony@atomide.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140930084416.GB31111@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <5412C21A.8020203@linutronix.de>
 <20140912102816.GF28458@ci00147.xsens-tech.local>
 <541716DC.9020904@linutronix.de>
 <20140917102812.GA20438@ci00147.xsens-tech.local>
 <20140921204100.GA10111@linutronix.de>
 <20140922092853.GH20438@ci00147.xsens-tech.local>
 <20140925151403.GH19396@linutronix.de>
 <20140929085042.GA13952@ci00147.xsens-tech.local>
 <20140929095440.GB13142@linutronix.de>
 <20140929103042.GA31111@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140929103042.GA31111@ci00147.xsens-tech.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1412066658
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10058
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 12:30:43PM +0200, Frans Klaver wrote:
> On Mon, Sep 29, 2014 at 11:54:40AM +0200, Sebastian Andrzej Siewior wrote:
> > For your "too much work for irq" problem: Could you add trace_printk()
> > in tx/rx dma start/complete, and irq routine? The interresting part is
> > what is the irq routine doing once entered. It might be a condition that
> > is ignored at first and "acked" later while serving another event. Or it
> > is really doing something and this is more or less "legal".
> 

Here's some trace output I get. I hope branches become clear by the
calls they do.

       uart_test-482   [000] .ns.    17.860139: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
       uart_test-482   [000] .ns.    17.860141: __dma_rx_do_complete: rx_dma(p, 0)
       uart_test-480   [000] ..s.    17.860260: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
       uart_test-480   [000] ..s.    17.860263: __dma_rx_do_complete: rx_dma(p, 0)
       uart_test-478   [000] ..s.    17.860369: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
       uart_test-478   [000] ..s.    17.860372: __dma_rx_do_complete: rx_dma(p, 0)
     kworker/0:1-10    [000] ..s.    17.860508: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
     kworker/0:1-10    [000] ..s.    17.860512: __dma_rx_do_complete: rx_dma(p, 0)
       uart_test-477   [000] ..s.    17.860634: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
       uart_test-477   [000] ..s.    17.860642: __dma_rx_do_complete: rx_dma(p, 0)
       uart_test-477   [000] ..s.    17.860768: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
       uart_test-477   [000] ..s.    17.860772: __dma_rx_do_complete: rx_dma(p, 0)
     kworker/0:1-10    [000] ..s.    17.860900: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
     kworker/0:1-10    [000] ..s.    17.860904: __dma_rx_do_complete: rx_dma(p, 0)
       uart_test-483   [000] dnh.    17.861018: serial8250_interrupt: irq 89
       uart_test-483   [000] dnh.    17.861026: serial8250_interrupt: 89 e
       uart_test-483   [000] .ns.    17.861045: __dma_rx_do_complete: error: 0, uart_bug_dma: 32
       uart_test-483   [000] .ns.    17.861047: __dma_rx_do_complete: rx_dma(p, 0)
       uart_test-479   [000] d.H.    17.861124: serial8250_interrupt: irq 89
       uart_test-479   [000] d.H.    17.861133: serial8250_handle_irq: l1 IIR cc LSR 61
       uart_test-479   [000] d.H.    17.861135: serial8250_handle_irq: rx_dma(up, iir)
       uart_test-479   [000] d.H.    17.861139: serial8250_rx_dma: l1, UART_IIR_RX_TIMEOUT
       uart_test-479   [000] d.H.    17.861147: __dma_rx_do_complete: error: 1, uart_bug_dma: 32
       uart_test-479   [000] d.H.    17.861150: serial8250_handle_irq: rx_chars(up, status)
       uart_test-479   [000] d.H.    17.861190: serial8250_handle_irq: rx_dma(up, 0)
       uart_test-479   [000] d.H.    17.861205: serial8250_interrupt: 89 e
     kworker/0:1-10    [000] dnH.    17.864949: serial8250_interrupt: irq 89

So far so good. We're just entered interrupt where stuff goes awry. The
following pattern repeats over 600 times:

     kworker/0:1-10    [000] dnH.    17.865198: serial8250_handle_irq: l1 IIR cc LSR 61
     kworker/0:1-10    [000] dnH.    17.865254: serial8250_handle_irq: rx_dma(up, iir)
     kworker/0:1-10    [000] dnH.    17.865333: serial8250_rx_dma: l1, UART_IIR_RX_TIMEOUT
     kworker/0:1-10    [000] dnH.    17.865626: __dma_rx_do_complete: error: 1, uart_bug_dma: 32
     kworker/0:1-10    [000] dnH.    17.865747: serial8250_handle_irq: rx_chars(up, status)
     kworker/0:1-10    [000] dnH.    17.868797: serial8250_handle_irq: rx_dma(up, 0)

ending with:

     kworker/0:1-10    [000] dnH.    20.027093: serial8250_interrupt: serial8250: too much work for irq89
     kworker/0:1-10    [000] dnH.    20.027181: serial8250_interrupt: 89 e

This clogs the entire system until I disconnect the communication lines.

So we get an RX timeout. The receiver fifo trigger level was not reached
and 8250_core is left to copy the remaining data. I would expect that if
the trigger level wasn't reached, we wouldn't need to be doing this that
often. On the other hand, could we be trapped reading data from rx
without dma helping us? And how could we resolve this?

Frans
