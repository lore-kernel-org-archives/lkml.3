Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaIYXMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:12:47 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:15593 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaIYXMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:12:46 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: RE: ftrace function-graph and interprocessor interrupts
Thread-Topic: ftrace function-graph and interprocessor interrupts
Thread-Index: Ac/YBflZEtKWFiuHSyShYTcBfCN35AAO34MrAC/Os4AAAxBf8A==
Date: Thu, 25 Sep 2014 23:10:31 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9E8DF@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958C9BE4D@G9W0745.americas.hpqcorp.net>
	<87mw9oelje.fsf@tassilo.jf.intel.com>
 <20140925163843.23b28701@gandalf.local.home>
In-Reply-To: <20140925163843.23b28701@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
...
> Does, this patch fix it for you?
> 
> -- Steve
...

> -	if (type == TRACE_GRAPH_ENT)
> -		ret = trace_seq_puts(s, "==========>");
> -	else
> +	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
> +		ret = print_graph_lat_fmt(s, ent);
> +		if (ret == TRACE_TYPE_PARTIAL_LINE)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	if (*cpu_in_irq) {
>  		ret = trace_seq_puts(s, "<==========");
> +		*cpu_in_irq = 0;
> +	} else {
> +		ret = trace_seq_puts(s, "==========>");
> +		*cpu_in_irq = in_irq;
> +	}

That changes the direction of the arrows (which is fine, if
intended).

Results:
The beginning and end of do_IRQ are marked, but it drops off
during the middle.  The normal function trace shows all of those
still in hardirq context.


 10)   <========== |
 10)               |                            do_IRQ() {
 10)               |                              irq_enter() {
 10)   0.082 us    |                                rcu_irq_enter();
 10)   0.101 us    |                                irqtime_account_irq();
 10)   1.321 us    |                              } /* irq_enter */
 10)   ==========> |
 10)   0.058 us    |                              exit_idle();
 10)               |                              handle_irq() {
 10)   0.091 us    |                                irq_to_desc();
 10)               |                                handle_edge_irq() {
 10)   0.068 us    |                                  _raw_spin_lock();
 10)   0.142 us    |                                  ir_ack_apic_edge();
 10)               |                                  handle_irq_event() {
 10)               |                                    handle_irq_event_percpu() {
...
 10)   0.092 us    |                                      add_interrupt_randomness();
 10)   0.080 us    |                                      note_interrupt();
 10)   9.510 us    |                                    } /* handle_irq_event_percpu */
 10)   0.071 us    |                                    _raw_spin_lock();
 10) + 10.577 us   |                                  } /* handle_irq_event */
 10) + 12.310 us   |                                } /* handle_edge_irq */
 10) + 13.901 us   |                              } /* handle_irq */
 10)               |                              irq_exit() {
 10)   0.111 us    |                                irqtime_account_irq();
 10)   <========== |
 10)   0.074 us    |                                idle_cpu();
 10)   0.080 us    |                                rcu_irq_exit();
 10)   1.800 us    |                              } /* irq_exit */
 10) + 19.132 us   |                            } /* do_IRQ */
 10)   ==========> |


Same with smp_apic_timer_interrupt:
 10)   <========== |
 10)               |                              smp_apic_timer_interrupt() {
 10)               |                                irq_enter() {
 10)   0.072 us    |                                  rcu_irq_enter();
 10)   0.099 us    |                                  irqtime_account_irq();
 10)   1.069 us    |                                } /* irq_enter */
 10)   ==========> |
 10)   0.060 us    |                                exit_idle();
 10)               |                                local_apic_timer_interrupt() {
 10)               |                                  hrtimer_interrupt() {
...
 10)   1.810 us    |                                    } /* tick_program_event */
 10) + 32.361 us   |                                  } /* hrtimer_interrupt */
 10) + 32.904 us   |                                } /* local_apic_timer_interrupt */
 10)               |                                irq_exit() {
 10)   0.111 us    |                                  irqtime_account_irq();
 10)   <========== |
 10)               |                                  __do_softirq() {
 10)   0.058 us    |                                    msecs_to_jiffies();
 10)   0.099 us    |                                    irqtime_account_irq();
 10)               |                                    smp_call_function_single_interrupt() {
 10)               |                                      irq_enter() {
 10)   0.069 us    |                                        rcu_irq_enter();
 10)   0.100 us    |                                        irqtime_account_irq();
 10)   1.251 us    |                                      } /* irq_enter */
 10)   ==========> |


generic_smp_call_function_single_interrupt doesn't
seem to be getting marked, even though function trace 
finds many that are in hardirq context.

             fio-7146  [010] d...  2968.183376: smp_call_function_single_interrupt <-call_function_single_interrupt
             fio-7146  [010] d...  2968.183376: irq_enter <-smp_call_function_single_interrupt
             fio-7146  [010] d...  2968.183377: rcu_irq_enter <-irq_enter
             fio-7146  [010] d...  2968.183377: irqtime_account_irq <-irq_enter
             fio-7146  [010] d.h.  2968.183377: generic_smp_call_function_single_interrupt <-smp_call_function_single_interrupt
             fio-7146  [010] d.h.  2968.183377: flush_smp_call_function_queue <-generic_smp_call_function_single_interrupt
             fio-7146  [010] d.h.  2968.183378: __blk_mq_complete_request_remote <-flush_smp_call_function_queue
             fio-7146  [010] d.h.  2968.183378: scsi_softirq_done <-__blk_mq_complete_request_remote
             fio-7146  [010] d.h.  2968.183378: scsi_decide_disposition <-scsi_softirq_done

Here's a longer excerpt starting with back-to-back arrows.
After that they seem flipped again.  This shows a
generic_smp_call_function_single_interrupt call.


 10)   0.079 us    |                                          rcu_irq_exit();
 10)   1.829 us    |                                        } /* irq_exit */
 10) + 26.462 us   |                                      } /* do_IRQ */
 10)   <========== |
 10)   ==========> |
 10)               |                                      do_IRQ() {
 10)               |                                        irq_enter() {
 10)   0.078 us    |                                          rcu_irq_enter();
 10)   0.108 us    |                                          irqtime_account_irq();
 10)   1.200 us    |                                        } /* irq_enter */
 10)   0.053 us    |                                        exit_idle();
 10)               |                                        handle_irq() {
 10)   0.104 us    |                                          irq_to_desc();
 10)               |                                          handle_edge_irq() {
 10)   0.072 us    |                                            _raw_spin_lock();
 10)   0.153 us    |                                            ir_ack_apic_edge();
 10)               |                                            handle_irq_event() {
 10)               |                                              handle_irq_event_percpu() {
 10)               |                                                do_hpsa_intr_msi [hpsa]() {
 10)   0.144 us    |                                                  SA5_performant_completed [hpsa]();
 10)   0.749 us    |                                                } /* do_hpsa_intr_msi [hpsa] */
 10)   0.082 us    |                                                add_interrupt_randomness();
 10)   0.075 us    |                                                note_interrupt();
 10)   2.470 us    |                                              } /* handle_irq_event_percpu */
 10)   0.062 us    |                                              _raw_spin_lock();
 10)   3.556 us    |                                            } /* handle_irq_event */
 10)   5.332 us    |                                          } /* handle_edge_irq */
 10)   6.521 us    |                                        } /* handle_irq */
 10)               |                                        irq_exit() {
 10)   0.108 us    |                                          irqtime_account_irq();
 10)   0.060 us    |                                          idle_cpu();
 10)   0.079 us    |                                          rcu_irq_exit();
 10)   1.752 us    |                                        } /* irq_exit */
 10) + 11.513 us   |                                      } /* do_IRQ */
 10)   <========== |
 10)               |                                      scsi_init_io() {
 10)               |                                        scsi_init_sgtable() {
 10)   0.109 us    |                                          scsi_alloc_sgtable();
 10)               |                                          blk_rq_map_sg() {
 10)   0.134 us    |                                            __blk_bios_map_sg();
 10)   0.697 us    |                                          } /* blk_rq_map_sg */
 10)   1.864 us    |                                        } /* scsi_init_sgtable */
 10)   2.436 us    |                                      } /* scsi_init_io */
 10) + 42.767 us   |                                    } /* sd_setup_read_write_cmnd [sd_mod] */
 10) + 43.329 us   |                                  } /* sd_init_command [sd_mod] */
 10) + 43.886 us   |                                } /* scsi_setup_cmnd */
 10) + 45.100 us   |                              } /* scsi_mq_prep_fn */
 10)   0.080 us    |                              scsi_init_cmd_errh();
 10)               |                              scsi_dispatch_cmd() {
 10)   0.057 us    |                                scsi_log_send();
 10)               |                                hpsa_scsi_queue_command [hpsa]() {
 10)   0.125 us    |                                  cmd_tagged_alloc [hpsa]();
 10)               |                                  hpsa_ioaccel_submit [hpsa]() {
 10)   0.193 us    |                                    hpsa_cmd_init [hpsa]();
 10)               |                                    hpsa_scsi_ioaccel_queue_command [hpsa]() {
 10)               |                                      hpsa_scsi_ioaccel2_queue_command [hpsa]() {
 10)   0.057 us    |                                        fixup_ioaccel_cdb [hpsa]();
 10)   0.112 us    |                                        scsi_dma_map();
 10)               |                                        enqueue_cmd_and_start_io [hpsa]() {
 10)   0.087 us    |                                          __enqueue_cmd_and_start_io [hpsa]();
 10)   0.701 us    |                                        } /* enqueue_cmd_and_start_io [hpsa] */
 10)   2.627 us    |                                      } /* hpsa_scsi_ioaccel2_queue_command [hpsa] */
 10)   3.146 us    |                                    } /* hpsa_scsi_ioaccel_queue_command [hpsa] */
 10)   4.394 us    |                                  } /* hpsa_ioaccel_submit [hpsa] */
 10)   5.909 us    |                                } /* hpsa_scsi_queue_command [hpsa] */
 10)   7.034 us    |                              } /* scsi_dispatch_cmd */
 10) + 54.950 us   |                            } /* scsi_queue_rq */
 10) + 60.213 us   |                          } /* __blk_mq_run_hw_queue */
 10) + 60.760 us   |                        } /* blk_mq_run_hw_queue */
 10) ! 112.938 us  |                      } /* blk_sq_make_request */
 10) ! 115.912 us  |                    } /* generic_make_request */
 10) ! 116.470 us  |                  } /* submit_bio */
 10)               |                  blk_finish_plug() {
 10)   0.063 us    |                    blk_flush_plug_list();
 10)   0.695 us    |                  } /* blk_finish_plug */
 10)   0.104 us    |                  _raw_spin_lock_irqsave();
 10)   0.086 us    |                  _raw_spin_unlock_irqrestore();
 10) ! 179.456 us  |                } /* __blockdev_direct_IO */
 10) ! 180.009 us  |              } /* blkdev_direct_IO */
 10) ! 181.178 us  |            } /* generic_file_read_iter */
 10) ! 181.742 us  |          } /* blkdev_read_iter */
 10) ! 185.747 us  |        } /* aio_run_iocb */
 10) ! 189.350 us  |      } /* io_submit_one */
 10)               |      blk_finish_plug() {
 10)   0.060 us    |        blk_flush_plug_list();
 10)   0.576 us    |      } /* blk_finish_plug */
 10) ! 192.194 us  |    } /* do_io_submit */
 10) ! 192.749 us  |  } /* SyS_io_submit */
 10)               |  SyS_io_submit() {
 10)               |    do_io_submit() {
 10)   0.181 us    |      lookup_ioctx();
 10)   0.060 us    |      blk_start_plug();
 10)               |      io_submit_one() {
 10)               |        kmem_cache_alloc() {
 10)   0.061 us    |          _cond_resched();
 10)   0.062 us    |          kmemleak_alloc();
 10)   1.213 us    |        } /* kmem_cache_alloc */
 10)               |        fget() {
 10)   0.126 us    |          __fget();
 10)   0.638 us    |        } /* fget */
 10)               |        aio_run_iocb() {
 10)               |          rw_verify_area() {
 10)               |            security_file_permission() {
 10)   0.061 us    |              cap_file_permission();
 10)   0.062 us    |              __fsnotify_parent();
 10)   0.072 us    |              fsnotify();
 10)   1.761 us    |            } /* security_file_permission */
 10)   2.312 us    |          } /* rw_verify_area */
 10)   0.068 us    |          iov_iter_init();
 10)               |          blkdev_read_iter() {
 10)               |            generic_file_read_iter() {
 10)   0.064 us    |              filemap_write_and_wait_range();
 10)               |              blkdev_direct_IO() {
 10)               |                __blockdev_direct_IO() {
 10)   0.064 us    |                  iov_iter_alignment();
 10)               |                  kmem_cache_alloc() {
 10)   0.071 us    |                    _cond_resched();
 10)   0.070 us    |                    kmemleak_alloc();
 10)   1.467 us    |                  } /* kmem_cache_alloc */
 10)   0.072 us    |                  iov_iter_npages();
 10)   0.073 us    |                  blk_start_plug();
 10)               |                  do_direct_IO() {
 10)               |                    iov_iter_get_pages() {
 10)               |                      get_user_pages_fast() {
 10)               |                        gup_pud_range() {
 10)   0.263 us    |                          gup_pte_range();
 10)   0.857 us    |                        } /* gup_pud_range */
 10)   1.441 us    |                      } /* get_user_pages_fast */
 10)   2.043 us    |                    } /* iov_iter_get_pages */
 10)   ==========> |
 10)               |                    do_IRQ() {
 10)               |                      irq_enter() {
 10)   0.083 us    |                        rcu_irq_enter();
 10)   0.110 us    |                        irqtime_account_irq();
 10)   1.174 us    |                      } /* irq_enter */
 10)   0.068 us    |                      exit_idle();
 10)               |                      handle_irq() {
 10)   0.089 us    |                        irq_to_desc();
 10)               |                        handle_edge_irq() {
 10)   0.056 us    |                          _raw_spin_lock();
 10)   0.133 us    |                          ir_ack_apic_edge();
 10)               |                          handle_irq_event() {
 10)               |                            handle_irq_event_percpu() {
 10)               |                              do_hpsa_intr_msi [hpsa]() {
 10)   0.205 us    |                                SA5_performant_completed [hpsa]();
 10)               |                                complete_scsi_command [hpsa]() {
 10)   0.161 us    |                                  scsi_dma_unmap();
 10)               |                                  process_ioaccel2_completion [hpsa]() {
 10)               |                                    scsi_mq_done() {
 10)               |                                      blk_mq_complete_request() {
 10)               |                                        __blk_mq_complete_request() {
 10)               |                                          smp_call_function_single_async() {
 10)               |                                            generic_exec_single() {
 10)               |                                              native_send_call_func_single_ipi() {
 10)               |                                                x2apic_send_IPI_mask() {
 10)   0.337 us    |                                                  __x2apic_send_IPI_mask();
 10)   0.855 us    |                                                } /* x2apic_send_IPI_mask */
 10)   1.385 us    |                                              } /* native_send_call_func_single_ipi */
 10)   2.072 us    |                                            } /* generic_exec_single */
 10)   2.708 us    |                                          } /* smp_call_function_single_async */
 10)   3.347 us    |                                        } /* __blk_mq_complete_request */
 10)   3.952 us    |                                      } /* blk_mq_complete_request */
 10)   4.509 us    |                                    } /* scsi_mq_done */
 10)   5.265 us    |                                  } /* process_ioaccel2_completion [hpsa] */
 10)   6.650 us    |                                } /* complete_scsi_command [hpsa] */
 10)   8.007 us    |                              } /* do_hpsa_intr_msi [hpsa] */
 10)   0.089 us    |                              add_interrupt_randomness();
 10)   0.072 us    |                              note_interrupt();
 10)   9.711 us    |                            } /* handle_irq_event_percpu */
 10)   0.062 us    |                            _raw_spin_lock();
 10) + 10.808 us   |                          } /* handle_irq_event */
 10) + 12.396 us   |                        } /* handle_edge_irq */
 10) + 13.472 us   |                      } /* handle_irq */
 10)               |                      irq_exit() {
 10)   0.097 us    |                        irqtime_account_irq();
 10)   0.055 us    |                        idle_cpu();
 10)   0.086 us    |                        rcu_irq_exit();
 10)   1.773 us    |                      } /* irq_exit */
 10) + 18.513 us   |                    } /* do_IRQ */
 10)   <========== |
 10)               |                    smp_call_function_single_interrupt() {
 10)               |                      irq_enter() {
 10)   0.081 us    |                        rcu_irq_enter();
 10)   0.094 us    |                        irqtime_account_irq();
 10)   1.307 us    |                      } /* irq_enter */
 10)   ==========> |
 10)               |                      generic_smp_call_function_single_interrupt() {
 10)               |                        flush_smp_call_function_queue() {
 10)               |                          __blk_mq_complete_request_remote() {
 10)               |                            scsi_softirq_done() {
 10)               |                              scsi_decide_disposition() {
 10)   0.069 us    |                                scsi_handle_queue_ramp_up();
 10)   0.693 us    |                              } /* scsi_decide_disposition */
 10)   0.062 us    |                              scsi_log_completion();
 10)               |                              scsi_finish_command() {
 10)   0.113 us    |                                scsi_device_unbusy();

---
Rob Elliott    HP Server Storage



