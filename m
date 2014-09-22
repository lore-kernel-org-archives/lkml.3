Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaIVMSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:18:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28728 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691AbaIVMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:18:17 -0400
Date: Mon, 22 Sep 2014 08:18:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: duzhiping <duzhiping.du@huawei.com>
Cc: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>
Subject: Re: itrace: An interrupts tracing tool
Message-ID: <20140922081814.71cf11ea@gandalf.local.home>
In-Reply-To: <541F990F.7030806@huawei.com>
References: <541F990F.7030806@huawei.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 11:35:43 +0800
duzhiping <duzhiping.du@huawei.com> wrote:

>   Many functions depends on interrupts in Linux system, when the interrupts occur an error, it may cause fatal problem.
> 
>   Then, we should record their trace when interrupts in and out. The recorded information could help us analyze interrupts errors.
> 
>   Itrace is such an interrupts trace tool we have developed, it provides config interface and trace information through "procfs".
> 
>   Do you think it has the value to upstream?
> 

You mean like:

# trace-cmd record -p function_graph -l do_IRQ -e irq_handler_entry sleep 10
# trace-cmd report
       trace-cmd-3165  [002]    53.201912: funcgraph_entry:                   |  do_IRQ() {
       trace-cmd-3165  [002]    53.201920: irq_handler_entry:    irq=21 name=uhci_hcd:usb4
       trace-cmd-3165  [002]    53.201924: irq_handler_entry:    irq=21 name=eth0
       trace-cmd-3165  [002]    53.201927: funcgraph_exit:       + 12.738 us  |  }
          <idle>-0     [003]    53.202140: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [003]    53.202146: irq_handler_entry:    irq=21 name=uhci_hcd:usb4
          <idle>-0     [003]    53.202148: irq_handler_entry:    irq=21 name=eth0
          <idle>-0     [003]    53.202151: funcgraph_exit:       + 10.172 us  |  }
          <idle>-0     [000]    58.679619: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [000]    58.679625: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [000]    58.679630: funcgraph_exit:         8.040 us   |  }
          <idle>-0     [001]    58.680176: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [001]    58.680178: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [001]    58.680181: funcgraph_exit:         4.160 us   |  }
          <idle>-0     [002]    58.680633: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [002]    58.680635: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [002]    58.680637: funcgraph_exit:         3.489 us   |  }
          <idle>-0     [003]    58.680913: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [003]    58.680915: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [003]    58.680917: funcgraph_exit:         3.368 us   |  }
    kworker/u8:1-40    [000]    58.681191: funcgraph_entry:                   |  do_IRQ() {
    kworker/u8:1-40    [000]    58.681192: irq_handler_entry:    irq=14 name=ata_piix
    kworker/u8:1-40    [000]    58.681196: funcgraph_exit:         4.551 us   |  }
          <idle>-0     [001]    58.681415: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [001]    58.681417: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [001]    58.681420: funcgraph_exit:         3.991 us   |  }
          <idle>-0     [002]    58.681632: funcgraph_entry:                   |  do_IRQ() {
          <idle>-0     [002]    58.681633: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [002]    58.681635: funcgraph_exit:         2.183 us   |  }


Or just use the irq events only?

# trace-cmd record -e irq_handler_entry -e irq_handler_exit sleep 10
# trace-cmd report
          <idle>-0     [003]   198.853342: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [003]   198.853344: irq_handler_exit:     irq=14 ret=handled
          <idle>-0     [000]   198.862038: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [000]   198.862040: irq_handler_exit:     irq=14 ret=handled
          <idle>-0     [001]   198.862227: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [001]   198.862228: irq_handler_exit:     irq=14 ret=handled
          <idle>-0     [002]   198.870423: irq_handler_entry:    irq=14 name=ata_piix
          <idle>-0     [002]   198.870424: irq_handler_exit:     irq=14 ret=handled


It's a bit cleaner, but the function_graph gives the times nicely. But
I do plan on updating trace-cmd to give times between different events.

-- Steve
