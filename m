Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaIXVPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:15:34 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:9078 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXVPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:15:32 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: ftrace function-graph and interprocessor interrupts
Thread-Topic: ftrace function-graph and interprocessor interrupts
Thread-Index: Ac/YBflZEtKWFiuHSyShYTcBfCN35A==
Date: Wed, 24 Sep 2014 21:14:13 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9BE4D@G9W0745.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.193.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function-graph tracer marks some interrupt handler functions
with ==========>  and <========== labels.

 10)               |                                    sd_setup_read_write_cmnd [sd_mod]() {
 10)               |                                      scsi_init_io() {
 10)               |                                        scsi_init_sgtable() {
 10)               |                                          scsi_alloc_sgtable() {
 10)   ==========> |
 10)               |                                            smp_apic_timer_interrupt() {
 10)               |                                              irq_enter() {
 10)   0.093 us    |                                                rcu_irq_enter();
 10)   0.102 us    |                                                irqtime_account_irq();
 10)   1.213 us    |                                              } /* irq_enter */
...
 10)   0.054 us    |                                                idle_cpu();
 10)   0.077 us    |                                                rcu_irq_exit();
 10)   6.953 us    |                                              } /* irq_exit */
 10) + 45.238 us   |                                            } /* smp_apic_timer_interrupt */
 10)   <========== |
 10) + 46.256 us   |                                          } /* scsi_alloc_sgtable */
 10)               |                                          blk_rq_map_sg() {
 10)   0.101 us    |                                            __blk_bios_map_sg();


Interprocessor interrupts are not marked, though (on x86_64). In 
this example, smp_call_function_single_interrupt is really in hardirq
context.  The trace just shows it at the same level as the function
it interrupted.


 10)   0.068 us    |                              scsi_prep_state_check();
 10)   0.095 us    |                              get_device();
 10)               |                              scsi_mq_prep_fn() {
 10)   0.063 us    |                                init_timer_key();
 10)               |                                scsi_setup_cmnd() {
 10)               |                                  sd_init_command [sd_mod]() {
 10)               |                                    sd_setup_read_write_cmnd [sd_mod]() {
 10)               |                                    smp_call_function_single_interrupt() {
 10)               |                                      irq_enter() {
 10)   0.096 us    |                                        rcu_irq_enter();
 10)   0.116 us    |                                        irqtime_account_irq();
 10)   1.243 us    |                                      } /* irq_enter */
 10)               |                                      generic_smp_call_function_single_interrupt() {
 10)               |                                        flush_smp_call_function_queue() {
 10)               |                                          __blk_mq_complete_request_remote() {
 10)               |                                            scsi_softirq_done() {
 10)               |                                              scsi_decide_disposition() {
...
 10) + 36.788 us   |                                    } /* smp_call_function_single_interrupt */
 10)               |                                      scsi_init_io() {
 10)               |                                        scsi_init_sgtable() {
 10)   0.098 us    |                                          scsi_alloc_sgtable();
 10)               |                                          blk_rq_map_sg() {
 10)   0.148 us    |                                            __blk_bios_map_sg();
 10)   0.722 us    |                                          } /* blk_rq_map_sg */
 10)   1.862 us    |                                        } /* scsi_init_sgtable */
 10)   2.424 us    |                                      } /* scsi_init_io */
 10)   3.080 us    |                                    } /* sd_setup_read_write_cmnd [sd_mod] */
 10) + 41.431 us   |                                  } /* sd_init_command [sd_mod] */
 10) + 42.012 us   |                                } /* scsi_setup_cmnd */
 10) + 43.179 us   |                              } /* scsi_mq_prep_fn */

The plain function tracer shows that smp_call_function_single_interrupt 
is really in hardirq context, marking it with "h":
             fio-4607  [010] ....  5908.340807: blkdev_get_block <-do_direct_IO
             fio-4607  [010] ....  5908.340807: put_page <-do_direct_IO
             fio-4607  [010] d.h.  5908.340808: generic_smp_call_function_single_interrupt <-smp_call_function_single_interrupt
             fio-4607  [010] d.h.  5908.340808: flush_smp_call_function_queue <-generic_smp_call_function_single_interrupt
             fio-4607  [010] d.h.  5908.340808: __blk_mq_complete_request_remote <-flush_smp_call_function_queue
             fio-4607  [010] d.h.  5908.340808: scsi_softirq_done <-__blk_mq_complete_request_remote
             fio-4607  [010] d.h.  5908.340808: scsi_decide_disposition <-scsi_softirq_done
             fio-4607  [010] d.h.  5908.340808: scsi_handle_queue_ramp_up <-scsi_decide_disposition

blk-mq (and scsi-mq) can generate lots of IPIs if 
/sys/block/sdNN/device/rq_affinity is 1 or 2 (which force block layer 
completion processing to be done on the submitting CPU node or 
submitting CPU).

This code in check_irq_entry() apparently doesn't detect IPIs:
        if ((addr < (unsigned long)__irqentry_text_start) ||
            (addr >= (unsigned long)__irqentry_text_end))
                return 0;

In scsi-mq tests, do_IRQ and smp_apic_timer_interrupt are the only 
ones that show up.

The __irq_entry attribute apparently tells the linker to place
the functions in that range:
./arch/x86/kernel/irq.c:__visible unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
./arch/x86/kernel/apic/apic.c:__visible void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
./arch/x86/kernel/apic/apic.c:__visible void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)

but adding that attribute to these functions in irq.c does not help: 
./arch/x86/kernel/irq.c:__visible void __irq_entry smp_x86_platform_ipi(struct pt_regs *regs)
./arch/x86/kernel/irq.c:__visible void __irq_entry smp_trace_x86_platform_ipi(struct pt_regs *regs)

Unlike do_IRQ and smp_apic_timer_interrupt, those function names never 
appear in the function-graph; the first function I see is always 
generic_smp_call_function_single_interrupt.

blk-mq calls smp_call_function_single_async directly, which
can result in generic_smp_call_function_single_interrupt on the
local CPU, and that call chain shouldn't be treated as being in
a new interrupt context.  When this happens, it is already in a 
interupt context call chain from do_IRQ.

---
Rob Elliott    HP Server Storage


