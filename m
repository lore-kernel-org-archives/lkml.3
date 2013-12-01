Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LASJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 13:09:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:16670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab3LASIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 13:08:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,806,1378882800"; 
   d="txt'?scan'208";a="444896061"
Message-ID: <529B7B27.4070801@linux.intel.com>
Date: Sun, 01 Dec 2013 20:08:39 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com
Subject: Re: [RFC][PATCH 0/7] sched: Optimize sched_clock bits
References: <20131129173657.252094369@infradead.org>
In-Reply-To: <20131129173657.252094369@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------030007040200040004090608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030007040200040004090608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 29/11/2013 19:36, Peter Zijlstra wrote:
> Hi all,
> 
> This series is supposed to optimize the kernel/sched/clock.c and x86
> sched_clock() implementations.
> 
> So far its only been boot tested. So no clue if it really makes the thing
> faster, but it does remove the need to disable IRQs.
> 
> I'm hoping Eliezer will test this with his benchmark where he could measure a
> performance regression between using sched_clock() and local_clock().

So I tested and retested, but I'm not sure I understand the results.

The numbers I previously reported were with turbo boost enabled.
Since turbo boost changes the CPU frequency depending on how hot it is,
it has a complicated interaction with busy polling.
In general you see better numbers, but it's harder to tell what's
going on.

With turbo boost disabled in BIOS to try to get a more linear behavior I
see:

3.13.0-rc2 (no pathces) 82.0 KRR/s
with busy poll using local clock 80.2 KRR/s.
Note that there is a big variance between cores and on the SMT sibling
of the core that has the packets steered to I see 81.8 KRR/s. (on the
other tests this core is slightly lower than on the one that accepts the
packets, I'm not sure I can explain this.)
local clock + sched_clock patches 80.6 KRR/s
sched patches (busy poll using sched_clock) 80.6 KRR/s

Maybe I'm doing something wrong?

Perf clearly affects the netperf results but the delta is only a few
percent so the numbers might still be good.
On the other hand, I'm seeing repeated warnings that the perf MNI
handler took too long to run, and I need to reboot to get perf to run
again.

Attached are the perf outputs.

If you can think of any other interesting tests, or anything I'm doing
wrong, I'm open to suggestions.

Thanks,
Eliezer

--------------030007040200040004090608
Content-Type: text/plain; charset=windows-1255;
 name="perf.local-clock.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf.local-clock.txt"

# ========
# captured on: Sun Dec  1 06:15:44 2013
# hostname : ladj537.jer.intel.com
# os release : 3.13.0-rc2-local-clockmin3+IPv6+
# perf version : 3.11.9-200.fc19.x86_64
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz
# cpuid : GenuineIntel,6,45,7
# total memory : 32905936 kB
# cmdline : /usr/bin/perf record netperf -t TCP_RR -H 192.168.1.1 -l 30 -T 4,4 -C -c 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, uncore_pcu = 15, uncore_imc_0 = 17, uncore_imc_1 = 18, uncore_imc_2 = 19, uncore_imc_3 = 20, uncore_qpi_0 = 21, uncore_qpi_1 = 22, uncore_cbox_0 = 7, uncore_cbox_1 = 8, uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 = 12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_ha = 16, uncore_r2pcie = 23, uncore_r3qpi_0 = 24, uncore_r3qpi_1 = 25, breakpoint = 5, uncore_ubox = 6
# ========
#
# Samples: 119K of event 'cycles'
# Event count (approx.): 79804562284
#
# Overhead  Command      Shared Object                                      Symbol
# ........  .......  .................  ..........................................
#
    17.65%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_bh                     
     8.74%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_bh                   
     8.44%  netperf  [kernel.kallsyms]  [k] native_sched_clock                    
     7.90%  netperf  [kernel.kallsyms]  [k] tcp_recvmsg                           
     7.71%  netperf  [kernel.kallsyms]  [k] local_clock                           
     6.55%  netperf  [ixgbe]            [k] ixgbe_clean_rx_irq                    
     5.76%  netperf  [kernel.kallsyms]  [k] sched_clock_cpu                       
     5.60%  netperf  [ixgbe]            [k] ixgbe_low_latency_recv                
     3.95%  netperf  [kernel.kallsyms]  [k] local_bh_enable_ip                    
     1.29%  netperf  [kernel.kallsyms]  [k] tcp_ack                               
     1.14%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock                        
     0.88%  netperf  [kernel.kallsyms]  [k] tcp_sendmsg                           
     0.81%  netperf  [ixgbe]            [k] ixgbe_xmit_frame_ring                 
     0.81%  netperf  [kernel.kallsyms]  [k] tcp_transmit_skb                      
     0.79%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb_core              
     0.74%  netperf  netperf            [.] send_omni_inner                       
     0.71%  netperf  [kernel.kallsyms]  [k] system_call                           
     0.68%  netperf  [kernel.kallsyms]  [k] local_bh_disable                      
     0.63%  netperf  [kernel.kallsyms]  [k] tcp_write_xmit                        
     0.51%  netperf  [kernel.kallsyms]  [k] ip_rcv                                
     0.51%  netperf  [kernel.kallsyms]  [k] tcp_rcv_established                   
     0.38%  netperf  [kernel.kallsyms]  [k] tcp_v4_rcv                            
     0.36%  netperf  [kernel.kallsyms]  [k] fget_light                            
     0.36%  netperf  netperf            [.] send_data                             
     0.34%  netperf  [kernel.kallsyms]  [k] dev_hard_start_xmit                   
     0.33%  netperf  [kernel.kallsyms]  [k] __copy_skb_header                     
     0.32%  netperf  [kernel.kallsyms]  [k] build_skb                             
     0.32%  netperf  [kernel.kallsyms]  [k] __might_sleep                         
     0.31%  netperf  [kernel.kallsyms]  [k] __alloc_skb                           
     0.30%  netperf  netperf            [.] recv_data                             
     0.28%  netperf  [kernel.kallsyms]  [k] ip_finish_output                      
     0.28%  netperf  [kernel.kallsyms]  [k] ip_queue_xmit                         
     0.27%  netperf  [kernel.kallsyms]  [k] __getnstimeofday                      
     0.27%  netperf  [kernel.kallsyms]  [k] kmem_cache_free                       
     0.26%  netperf  [kernel.kallsyms]  [k] sock_def_readable                     
     0.26%  netperf  [kernel.kallsyms]  [k] tcp_queue_rcv                         
     0.25%  netperf  [kernel.kallsyms]  [k] read_tsc                              
     0.25%  netperf  [kernel.kallsyms]  [k] __tcp_select_window                   
     0.24%  netperf  [kernel.kallsyms]  [k] skb_release_data                      
     0.24%  netperf  [kernel.kallsyms]  [k] __kfree_skb                           
     0.24%  netperf  [kernel.kallsyms]  [k] __inet_lookup_established             
     0.23%  netperf  [kernel.kallsyms]  [k] local_bh_enable                       
     0.22%  netperf  [kernel.kallsyms]  [k] skb_clone                             
     0.21%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_frag                   
     0.21%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc_node                 
     0.21%  netperf  [kernel.kallsyms]  [k] __skb_clone                           
     0.21%  netperf  [kernel.kallsyms]  [k] tcp_schedule_loss_probe               
     0.20%  netperf  [kernel.kallsyms]  [k] __slab_free                           
     0.20%  netperf  libc-2.17.so       [.] __libc_send                           
     0.19%  netperf  [kernel.kallsyms]  [k] __kmalloc_node_track_caller           
     0.19%  netperf  libc-2.17.so       [.] __libc_recv                           
     0.19%  netperf  [kernel.kallsyms]  [k] skb_free_head                         
     0.18%  netperf  [kernel.kallsyms]  [k] tcp_v4_do_rcv                         
     0.18%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit                        
     0.18%  netperf  [kernel.kallsyms]  [k] tcp_event_data_recv                   
     0.17%  netperf  [kernel.kallsyms]  [k] memcpy                                
     0.17%  netperf  [kernel.kallsyms]  [k] lock_sock_nested                      
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_cleanup_rbuf                      
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_v4_early_demux                    
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_set_skb_tso_segs                  
     0.16%  netperf  [kernel.kallsyms]  [k] tcp_established_options               
     0.16%  netperf  [kernel.kallsyms]  [k] mod_timer                             
     0.16%  netperf  [kernel.kallsyms]  [k] ipv4_dst_check                        
     0.16%  netperf  [kernel.kallsyms]  [k] sk_filter                             
     0.16%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit_nit                    
     0.16%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc                      
     0.15%  netperf  [kernel.kallsyms]  [k] skb_network_protocol                  
     0.15%  netperf  [kernel.kallsyms]  [k] tcp_send_mss                          
     0.15%  netperf  [kernel.kallsyms]  [k] __tcp_v4_send_check                   
     0.15%  netperf  [kernel.kallsyms]  [k] __netdev_pick_tx                      
     0.15%  netperf  [ixgbe]            [k] ixgbe_poll                            
     0.15%  netperf  [kernel.kallsyms]  [k] sockfd_lookup_light                   
     0.14%  netperf  [kernel.kallsyms]  [k] put_compound_page                     
     0.14%  netperf  [kernel.kallsyms]  [k] ip_send_check                         
     0.13%  netperf  [kernel.kallsyms]  [k] skb_copy_datagram_iovec               
     0.13%  netperf  [kernel.kallsyms]  [k] sch_direct_xmit                       
     0.13%  netperf  [kernel.kallsyms]  [k] tcp_rearm_rto                         
     0.12%  netperf  [kernel.kallsyms]  [k] sk_stream_alloc_skb                   
     0.12%  netperf  [kernel.kallsyms]  [k] tcp_rtt_estimator                     
     0.12%  netperf  [kernel.kallsyms]  [k] swiotlb_map_page                      
     0.12%  netperf  [kernel.kallsyms]  [k] skb_push                              
     0.12%  netperf  [ixgbe]            [k] ixgbe_alloc_rx_buffers                
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_send_delayed_ack                  
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_init_tso_segs                     
     0.11%  netperf  [kernel.kallsyms]  [k] ip_local_deliver                      
     0.11%  netperf  [kernel.kallsyms]  [k] SYSC_recvfrom                         
     0.11%  netperf  [kernel.kallsyms]  [k] sock_put                              
     0.11%  netperf  [kernel.kallsyms]  [k] __sk_dst_check                        
     0.11%  netperf  [kernel.kallsyms]  [k] eth_type_trans                        
     0.11%  netperf  [kernel.kallsyms]  [k] ksize                                 
     0.11%  netperf  [kernel.kallsyms]  [k] inet_ehashfn                          
     0.10%  netperf  [kernel.kallsyms]  [k] memcpy_toiovec                        
     0.10%  netperf  [kernel.kallsyms]  [k] __tcp_ack_snd_check                   
     0.10%  netperf  [kernel.kallsyms]  [k] tcp_parse_aligned_timestamp           
     0.10%  netperf  [kernel.kallsyms]  [k] bictcp_acked                          
     0.10%  netperf  [kernel.kallsyms]  [k] tcp_wfree                             
     0.10%  netperf  [kernel.kallsyms]  [k] bictcp_cong_avoid                     
     0.10%  netperf  [ixgbe]            [k] ixgbe_tx_ctxtdesc                     
     0.09%  netperf  [kernel.kallsyms]  [k] tcp_check_space                       
     0.09%  netperf  [kernel.kallsyms]  [k] SYSC_sendto                           
     0.09%  netperf  [kernel.kallsyms]  [k] __kmalloc_reserve.clone.52            
     0.09%  netperf  [kernel.kallsyms]  [k] might_fault                           
     0.09%  netperf  [kernel.kallsyms]  [k] sock_rfree                            
     0.09%  netperf  [kernel.kallsyms]  [k] sock_sendmsg                          
     0.09%  netperf  [kernel.kallsyms]  [k] skb_release_head_state                
     0.09%  netperf  [kernel.kallsyms]  [k] tcp_rcv_space_adjust                  
     0.09%  netperf  [kernel.kallsyms]  [k] sock_recvmsg                          
     0.08%  netperf  [kernel.kallsyms]  [k] release_sock                          
     0.08%  netperf  [kernel.kallsyms]  [k] raw_local_deliver                     
     0.08%  netperf  [kernel.kallsyms]  [k] irq_entries_start                     
     0.08%  netperf  [kernel.kallsyms]  [k] msecs_to_jiffies                      
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_service_net_dma                   
     0.07%  netperf  [kernel.kallsyms]  [k] ns_to_timespec                        
     0.07%  netperf  [kernel.kallsyms]  [k] sock_wfree                            
     0.07%  netperf  [kernel.kallsyms]  [k] netdev_pick_tx                        
     0.07%  netperf  [ixgbe]            [k] __ixgbe_xmit_frame                    
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_options_write                     
     0.07%  netperf  [kernel.kallsyms]  [k] get_seconds                           
     0.07%  netperf  [kernel.kallsyms]  [k] ktime_get_real                        
     0.07%  netperf  [kernel.kallsyms]  [k] netif_receive_skb                     
     0.07%  netperf  [kernel.kallsyms]  [k] ipv4_mtu                              
     0.07%  netperf  [kernel.kallsyms]  [k] kmalloc_slab                          
     0.06%  netperf  [kernel.kallsyms]  [k] sk_reset_timer                        
     0.06%  netperf  [kernel.kallsyms]  [k] kfree                                 
     0.06%  netperf  [kernel.kallsyms]  [k] skb_release_all                       
     0.06%  netperf  [kernel.kallsyms]  [k] copy_user_generic_string              
     0.05%  netperf  [kernel.kallsyms]  [k] tcp_current_mss                       
     0.05%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_skb                    
     0.05%  netperf  [kernel.kallsyms]  [k] __ip_local_out                        
     0.05%  netperf  [kernel.kallsyms]  [k] inet_recvmsg                          
     0.05%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single                   
     0.05%  netperf  [kernel.kallsyms]  [k] harmonize_features                    
     0.05%  netperf  [kernel.kallsyms]  [k] getnstimeofday                        
     0.05%  netperf  [kernel.kallsyms]  [k] inet_sendmsg                          
     0.05%  netperf  [kernel.kallsyms]  [k] netif_skb_features                    
     0.04%  netperf  [kernel.kallsyms]  [k] __copy_user_nocache                   
     0.04%  netperf  [kernel.kallsyms]  [k] __slab_alloc                          
     0.04%  netperf  [kernel.kallsyms]  [k] napi_by_id                            
     0.04%  netperf  [kernel.kallsyms]  [k] ip_output                             
     0.04%  netperf  [kernel.kallsyms]  [k] skb_put                               
     0.04%  netperf  [kernel.kallsyms]  [k] _copy_to_user                         
     0.04%  netperf  [kernel.kallsyms]  [k] swiotlb_dma_mapping_error             
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_is_cwnd_limited                   
     0.04%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb                   
     0.04%  netperf  [kernel.kallsyms]  [k] ns_to_timeval                         
     0.04%  netperf  [kernel.kallsyms]  [k] __skb_dst_set_noref                   
     0.04%  netperf  [ixgbe]            [k] ixgbe_xmit_frame                      
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_md5_do_lookup                     
     0.03%  netperf  [kernel.kallsyms]  [k] dql_completed                         
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_v4_send_check                     
     0.03%  netperf  [kernel.kallsyms]  [k] __tcp_push_pending_frames             
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_prequeue                          
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_parse_md5sig_option               
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_event_new_data_sent               
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_stream_memory_free                
     0.03%  netperf  [kernel.kallsyms]  [k] radix_tree_lookup_element             
     0.03%  netperf  [kernel.kallsyms]  [k] put_page                              
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_release_cb                        
     0.02%  netperf  [kernel.kallsyms]  [k] ip_local_out                          
     0.02%  netperf  [kernel.kallsyms]  [k] __do_softirq                          
     0.02%  netperf  [kernel.kallsyms]  [k] dev_kfree_skb_any                     
     0.02%  netperf  [kernel.kallsyms]  [k] native_apic_msr_eoi_write             
     0.02%  netperf  [kernel.kallsyms]  [k] eth_header                            
     0.02%  netperf  [kernel.kallsyms]  [k] ktime_get                             
     0.02%  netperf  [kernel.kallsyms]  [k] neigh_resolve_output                  
     0.01%  netperf  [kernel.kallsyms]  [k] add_interrupt_randomness              
     0.01%  netperf  [kernel.kallsyms]  [k] dma_issue_pending_all                 
     0.01%  netperf  [kernel.kallsyms]  [k] tcp_v4_md5_lookup                     
     0.01%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single_for_device        
     0.01%  netperf  [kernel.kallsyms]  [k] handle_edge_irq                       
     0.01%  netperf  [kernel.kallsyms]  [k] update_curr                           
     0.01%  netperf  [kernel.kallsyms]  [k] sys_sendto                            
     0.01%  netperf  [kernel.kallsyms]  [k] net_rx_action                         
     0.01%  netperf  [ixgbe]            [k] ixgbe_msix_clean_rings                
     0.01%  netperf  [kernel.kallsyms]  [k] rcu_irq_enter                         
     0.01%  netperf  [kernel.kallsyms]  [k] __napi_complete                       
     0.01%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single_for_cpu           
     0.01%  netperf  [kernel.kallsyms]  [k] do_softirq                            
     0.01%  netperf  [kernel.kallsyms]  [k] __local_bh_enable                     
     0.01%  netperf  [kernel.kallsyms]  [k] rcu_irq_exit                          
     0.01%  netperf  [kernel.kallsyms]  [k] unmap_single                          
     0.01%  netperf  [kernel.kallsyms]  [k] handle_irq_event                      
     0.01%  netperf  [kernel.kallsyms]  [k] common_interrupt                      
     0.01%  netperf  [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context        
     0.01%  netperf  [kernel.kallsyms]  [k] napi_complete                         
     0.01%  netperf  [kernel.kallsyms]  [k] do_IRQ                                
     0.01%  netperf  netperf            [.] recv@plt                              
     0.01%  netperf  [kernel.kallsyms]  [k] do_softirq_own_stack                  
     0.01%  netperf  netperf            [.] send@plt                              
     0.01%  netperf  [kernel.kallsyms]  [k] radix_tree_lookup                     
     0.01%  netperf  [kernel.kallsyms]  [k] irq_enter                             
     0.01%  netperf  [kernel.kallsyms]  [k] __napi_schedule                       
     0.00%  netperf  [kernel.kallsyms]  [k] handle_irq_event_percpu               
     0.00%  netperf  [kernel.kallsyms]  [k] handle_irq                            
     0.00%  netperf  [kernel.kallsyms]  [k] consume_skb                           
     0.00%  netperf  [kernel.kallsyms]  [k] swiotlb_unmap_page                    
     0.00%  netperf  [kernel.kallsyms]  [k] sha_transform                         
     0.00%  netperf  [kernel.kallsyms]  [k] restore_args                          
     0.00%  netperf  [kernel.kallsyms]  [k] net_rps_action_and_irq_enable.clone.82
     0.00%  netperf  [kernel.kallsyms]  [k] rcu_bh_qs                             
     0.00%  netperf  [kernel.kallsyms]  [k] napi_gro_flush                        
     0.00%  netperf  [kernel.kallsyms]  [k] note_interrupt                        
     0.00%  netperf  [kernel.kallsyms]  [k] ir_ack_apic_edge                      
     0.00%  netperf  [kernel.kallsyms]  [k] irq_to_desc                           
     0.00%  netperf  [kernel.kallsyms]  [k] sys_recvfrom                          
     0.00%  netperf  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load            
     0.00%  netperf  [kernel.kallsyms]  [k] internal_add_timer                    
     0.00%  netperf  [kernel.kallsyms]  [k] apic_timer_interrupt                  
     0.00%  netperf  [kernel.kallsyms]  [k] lapic_next_deadline                   
     0.00%  netperf  [kernel.kallsyms]  [k] __d_alloc                             
     0.00%  netperf  [kernel.kallsyms]  [k] update_group_power                    
     0.00%  netperf  [kernel.kallsyms]  [k] __update_entity_load_avg_contrib      
     0.00%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave                
     0.00%  netperf  [kernel.kallsyms]  [k] rb_next                               
     0.00%  netperf  [kernel.kallsyms]  [k] retint_restore_args                   
     0.00%  netperf  [kernel.kallsyms]  [k] smp_apic_timer_interrupt              
     0.00%  netperf  [kernel.kallsyms]  [k] account_system_time                   
     0.00%  netperf  [kernel.kallsyms]  [k] __remove_hrtimer                      
     0.00%  netperf  [kernel.kallsyms]  [k] rcu_check_callbacks                   
     0.00%  netperf  [kernel.kallsyms]  [k] timerqueue_del                        
     0.00%  netperf  [kernel.kallsyms]  [k] cpuacct_charge                        
     0.00%  netperf  [kernel.kallsyms]  [k] lookup_fast                           
     0.00%  netperf  [kernel.kallsyms]  [k] hrtimer_interrupt                     
     0.00%  netperf  [kernel.kallsyms]  [k] kill_fasync                           
     0.00%  netperf  [kernel.kallsyms]  [k] find_next_bit                         
     0.00%  netperf  [kernel.kallsyms]  [k] find_busiest_group                    
     0.00%  netperf  [kernel.kallsyms]  [k] put_cpu_partial                       
     0.00%  netperf  libc-2.17.so       [.] _IO_vfscanf                           
     0.00%  netperf  [kernel.kallsyms]  [k] update_blocked_averages               
     0.00%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore           
     0.00%  netperf  [kernel.kallsyms]  [k] irq_exit                              
     0.00%  netperf  [kernel.kallsyms]  [k] update_rq_clock                       
     0.00%  netperf  [kernel.kallsyms]  [k] load_balance                          
     0.00%  netperf  [kernel.kallsyms]  [k] perf_event_task_tick                  
     0.00%  netperf  [kernel.kallsyms]  [k] vma_adjust                            
     0.00%  netperf  [kernel.kallsyms]  [k] __schedule                            
     0.00%  netperf  [kernel.kallsyms]  [k] pick_next_task_stop                   
     0.00%  netperf  [kernel.kallsyms]  [k] __perf_event_task_sched_in            
     0.00%  netperf  [kernel.kallsyms]  [k] sk_wait_data                          
     0.00%  netperf  [kernel.kallsyms]  [k] schedule_timeout                      
     0.00%  netperf  [kernel.kallsyms]  [k] intel_pmu_enable_all                  
     0.00%  netperf  [kernel.kallsyms]  [k] dst_release                           


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--------------030007040200040004090608
Content-Type: text/plain; charset=windows-1255;
 name="perf.local-clock+patched.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf.local-clock+patched.txt"

# ========
# captured on: Sun Dec  1 07:36:27 2013
# hostname : ladj537.jer.intel.com
# os release : 3.13.0-rc2-local-clock+sched-pathcesmin3+IPv6+
# perf version : 3.11.9-200.fc19.x86_64
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz
# cpuid : GenuineIntel,6,45,7
# total memory : 32905936 kB
# cmdline : /usr/bin/perf record netperf -t TCP_RR -H 192.168.1.1 -l 30 -T 4,4 -C -c 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, uncore_pcu = 15, uncore_imc_0 = 17, uncore_imc_1 = 18, uncore_imc_2 = 19, uncore_imc_3 = 20, uncore_qpi_0 = 21, uncore_qpi_1 = 22, uncore_cbox_0 = 7, uncore_cbox_1 = 8, uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 = 12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_ha = 16, uncore_r2pcie = 23, uncore_r3qpi_0 = 24, uncore_r3qpi_1 = 25, breakpoint = 5, uncore_ubox = 6
# ========
#
# Samples: 24K of event 'cycles'
# Event count (approx.): 15493465
#
# Overhead  Command      Shared Object                                      Symbol
# ........  .......  .................  ..........................................
#
     7.71%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_bh                     
     5.14%  netperf  [kernel.kallsyms]  [k] profile_tick                          
     4.15%  netperf  [kernel.kallsyms]  [k] lapic_next_deadline                   
     4.12%  netperf  [kernel.kallsyms]  [k] hrtimer_forward                       
     3.75%  netperf  [kernel.kallsyms]  [k] tcp_recvmsg                           
     3.60%  netperf  [kernel.kallsyms]  [k] run_posix_cpu_timers                  
     3.45%  netperf  [kernel.kallsyms]  [k] sk_wait_data                          
     3.07%  netperf  [kernel.kallsyms]  [k] ktime_get                             
     2.30%  netperf  [ixgbe]            [k] ixgbe_clean_rx_irq                    
     2.24%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_bh                   
     2.20%  netperf  [kernel.kallsyms]  [k] tick_sched_timer                      
     2.12%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock                        
     2.11%  netperf  [kernel.kallsyms]  [k] hrtimer_interrupt                     
     1.76%  netperf  [kernel.kallsyms]  [k] __run_hrtimer.clone.33                
     1.74%  netperf  [ixgbe]            [k] ixgbe_low_latency_recv                
     1.55%  netperf  [kernel.kallsyms]  [k] schedule_timeout                      
     1.47%  netperf  [kernel.kallsyms]  [k] clockevents_program_event             
     1.30%  netperf  [kernel.kallsyms]  [k] tcp_rcv_established                   
     1.26%  netperf  [kernel.kallsyms]  [k] timerqueue_add                        
     1.21%  netperf  [kernel.kallsyms]  [k] tcp_ack                               
     1.06%  netperf  [kernel.kallsyms]  [k] __do_softirq                          
     1.05%  netperf  [kernel.kallsyms]  [k] local_bh_enable                       
     1.02%  netperf  libc-2.17.so       [.] __libc_recv                           
     0.97%  netperf  [kernel.kallsyms]  [k] tcp_prequeue_process                  
     0.95%  netperf  [kernel.kallsyms]  [k] tcp_v4_do_rcv                         
     0.95%  netperf  [kernel.kallsyms]  [k] idle_cpu                              
     0.93%  netperf  [kernel.kallsyms]  [k] tcp_service_net_dma                   
     0.92%  netperf  [kernel.kallsyms]  [k] intel_pmu_enable_all                  
     0.92%  netperf  [kernel.kallsyms]  [k] __might_sleep                         
     0.86%  netperf  [kernel.kallsyms]  [k] find_busiest_group                    
     0.85%  netperf  [kernel.kallsyms]  [k] rcu_irq_exit                          
     0.84%  netperf  [kernel.kallsyms]  [k] local_bh_enable_ip                    
     0.81%  netperf  [kernel.kallsyms]  [k] lock_sock_nested                      
     0.79%  netperf  netperf            [.] send_omni_inner                       
     0.78%  netperf  [kernel.kallsyms]  [k] system_call                           
     0.77%  netperf  [kernel.kallsyms]  [k] rb_insert_color                       
     0.68%  netperf  [kernel.kallsyms]  [k] read_tsc                              
     0.67%  netperf  netperf            [.] send_data                             
     0.67%  netperf  [kernel.kallsyms]  [k] trigger_load_balance                  
     0.65%  netperf  [kernel.kallsyms]  [k] run_timer_softirq                     
     0.58%  netperf  [kernel.kallsyms]  [k] local_bh_disable                      
     0.58%  netperf  [kernel.kallsyms]  [k] __schedule                            
     0.54%  netperf  [kernel.kallsyms]  [k] tick_program_event                    
     0.51%  netperf  [kernel.kallsyms]  [k] raise_softirq                         
     0.47%  netperf  [kernel.kallsyms]  [k] tcp_md5_do_lookup                     
     0.45%  netperf  [kernel.kallsyms]  [k] tcp_event_data_recv                   
     0.40%  netperf  [kernel.kallsyms]  [k] tcp_transmit_skb                      
     0.39%  netperf  [kernel.kallsyms]  [k] tcp_cleanup_rbuf                      
     0.38%  netperf  [kernel.kallsyms]  [k] tcp_write_xmit                        
     0.38%  netperf  [kernel.kallsyms]  [k] finish_task_switch                    
     0.37%  netperf  [kernel.kallsyms]  [k] sock_def_readable                     
     0.37%  netperf  [kernel.kallsyms]  [k] ipv4_dst_check                        
     0.36%  netperf  [kernel.kallsyms]  [k] irq_exit                              
     0.35%  netperf  [kernel.kallsyms]  [k] fget_light                            
     0.33%  netperf  [ixgbe]            [k] ixgbe_poll                            
     0.33%  netperf  [kernel.kallsyms]  [k] copy_user_generic_string              
     0.32%  netperf  [kernel.kallsyms]  [k] dev_hard_start_xmit                   
     0.31%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit                        
     0.30%  netperf  libc-2.17.so       [.] __libc_send                           
     0.30%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc                      
     0.29%  netperf  [kernel.kallsyms]  [k] sock_poll                             
     0.29%  netperf  [kernel.kallsyms]  [k] napi_by_id                            
     0.29%  netperf  [kernel.kallsyms]  [k] page_fault                            
     0.27%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irq                    
     0.27%  netperf  [kernel.kallsyms]  [k] __perf_event_task_sched_in            
     0.27%  netperf  [kernel.kallsyms]  [k] dequeue_entity                        
     0.27%  netperf  netperf            [.] recv_data                             
     0.26%  netperf  [kernel.kallsyms]  [k] __getnstimeofday                      
     0.26%  netperf  [kernel.kallsyms]  [k] ip_rcv                                
     0.25%  netperf  [kernel.kallsyms]  [k] irq_entries_start                     
     0.24%  netperf  [kernel.kallsyms]  [k] skb_release_data                      
     0.24%  netperf  [kernel.kallsyms]  [k] tcp_sendmsg                           
     0.23%  netperf  [kernel.kallsyms]  [k] common_interrupt                      
     0.22%  netperf  [kernel.kallsyms]  [k] native_apic_msr_eoi_write             
     0.22%  netperf  [kernel.kallsyms]  [k] radix_tree_lookup_element             
     0.22%  netperf  [kernel.kallsyms]  [k] eth_type_trans                        
     0.22%  netperf  [kernel.kallsyms]  [k] skb_copy_datagram_iovec               
     0.22%  netperf  [kernel.kallsyms]  [k] finish_wait                           
     0.20%  netperf  [kernel.kallsyms]  [k] update_process_times                  
     0.20%  netperf  [kernel.kallsyms]  [k] __kfree_skb                           
     0.19%  netperf  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load            
     0.19%  netperf  libc-2.17.so       [.] _int_malloc                           
     0.19%  netperf  [kernel.kallsyms]  [k] perf_event_aux_ctx                    
     0.19%  netperf  [kernel.kallsyms]  [k] vma_interval_tree_insert              
     0.19%  netperf  [kernel.kallsyms]  [k] do_select                             
     0.18%  netperf  [kernel.kallsyms]  [k] ksize                                 
     0.18%  netperf  [kernel.kallsyms]  [k] SYSC_sendto                           
     0.17%  netperf  [kernel.kallsyms]  [k] cpumask_next_and                      
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_v4_rcv                            
     0.17%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc_node                 
     0.17%  netperf  [kernel.kallsyms]  [k] scheduler_tick                        
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_parse_aligned_timestamp           
     0.16%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit_nit                    
     0.16%  netperf  [kernel.kallsyms]  [k] native_sched_clock                    
     0.16%  netperf  [kernel.kallsyms]  [k] lock_timer_base.clone.26              
     0.15%  netperf  [kernel.kallsyms]  [k] tcp_v4_early_demux                    
     0.15%  netperf  [kernel.kallsyms]  [k] perf_event_task_tick                  
     0.15%  netperf  [kernel.kallsyms]  [k] dequeue_task_fair                     
     0.15%  netperf  [kernel.kallsyms]  [k] load_balance                          
     0.15%  netperf  [kernel.kallsyms]  [k] find_next_bit                         
     0.15%  netperf  [kernel.kallsyms]  [k] __skb_clone                           
     0.15%  netperf  [kernel.kallsyms]  [k] __tcp_v4_send_check                   
     0.14%  netperf  [kernel.kallsyms]  [k] kfree                                 
     0.14%  netperf  [kernel.kallsyms]  [k] mod_timer                             
     0.13%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_frag                   
     0.12%  netperf  [kernel.kallsyms]  [k] tcp_rearm_rto                         
     0.12%  netperf  [kernel.kallsyms]  [k] kmem_cache_free                       
     0.12%  netperf  [kernel.kallsyms]  [k] local_clock                           
     0.12%  netperf  [kernel.kallsyms]  [k] _copy_to_user                         
     0.12%  netperf  [kernel.kallsyms]  [k] rcu_note_context_switch               
     0.12%  netperf  [kernel.kallsyms]  [k] SYSC_recvfrom                         
     0.12%  netperf  [kernel.kallsyms]  [k] might_fault                           
     0.12%  netperf  [kernel.kallsyms]  [k] __local_bh_enable                     
     0.12%  netperf  [kernel.kallsyms]  [k] clear_buddies                         
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_check_space                       
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_rtt_estimator                     
     0.11%  netperf  [kernel.kallsyms]  [k] __copy_user_nocache                   
     0.11%  netperf  [kernel.kallsyms]  [k] memcpy_toiovec                        
     0.11%  netperf  [kernel.kallsyms]  [k] skb_free_head                         
     0.11%  netperf  [kernel.kallsyms]  [k] do_softirq_own_stack                  
     0.11%  netperf  [kernel.kallsyms]  [k] update_group_power                    
     0.10%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb_core              
     0.10%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave                
     0.10%  netperf  [kernel.kallsyms]  [k] kfree_skb_partial                     
     0.10%  netperf  [kernel.kallsyms]  [k] release_sock                          
     0.10%  netperf  [kernel.kallsyms]  [k] update_rq_clock                       
     0.10%  netperf  [ixgbe]            [k] ixgbe_xmit_frame_ring                 
     0.10%  netperf  [kernel.kallsyms]  [k] get_seconds                           
     0.10%  netperf  netperf            [.] send_request_n                        
     0.10%  netperf  libc-2.17.so       [.] __strchrnul                           
     0.10%  netperf  libc-2.17.so       [.] __get_nprocs                          
     0.10%  netperf  libc-2.17.so       [.] __nss_database_lookup                 
     0.10%  netperf  ld-2.17.so         [.] _dl_map_object_from_fd                
     0.10%  netperf  ld-2.17.so         [.] check_match.9336                      
     0.10%  netperf  ld-2.17.so         [.] _dl_lookup_symbol_x                   
     0.10%  netperf  ld-2.17.so         [.] dl_open_worker                        
     0.10%  netperf  [vdso]             [.] 0x0000000000000a21                    
     0.10%  netperf  [kernel.kallsyms]  [k] down_read_trylock                     
     0.10%  netperf  [kernel.kallsyms]  [k] page_waitqueue                        
     0.10%  netperf  [kernel.kallsyms]  [k] get_page_from_freelist                
     0.10%  netperf  [kernel.kallsyms]  [k] anon_vma_interval_tree_remove         
     0.10%  netperf  [kernel.kallsyms]  [k] unmap_single_vma                      
     0.10%  netperf  [kernel.kallsyms]  [k] unlink_file_vma                       
     0.10%  netperf  [kernel.kallsyms]  [k] vma_wants_writenotify                 
     0.10%  netperf  [kernel.kallsyms]  [k] proc_lookup_de                        
     0.10%  netperf  [kernel.kallsyms]  [k] copy_page_rep                         
     0.10%  netperf  [kernel.kallsyms]  [k] strncpy_from_user                     
     0.10%  netperf  [kernel.kallsyms]  [k] tcp_poll                              
     0.10%  netperf  [kernel.kallsyms]  [k] tcp_stream_memory_free                
     0.10%  netperf  [kernel.kallsyms]  [k] mutex_unlock                          
     0.10%  netperf  [kernel.kallsyms]  [k] __do_page_fault                       
     0.09%  netperf  [kernel.kallsyms]  [k] __netdev_pick_tx                      
     0.09%  netperf  [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context        
     0.09%  netperf  [kernel.kallsyms]  [k] tcp_rcv_space_adjust                  
     0.09%  netperf  [kernel.kallsyms]  [k] __inet_lookup_established             
     0.09%  netperf  [kernel.kallsyms]  [k] prepare_to_wait                       
     0.09%  netperf  [ixgbe]            [k] ixgbe_msix_clean_rings                
     0.09%  netperf  [kernel.kallsyms]  [k] update_curr                           
     0.08%  netperf  [kernel.kallsyms]  [k] do_softirq                            
     0.07%  netperf  [kernel.kallsyms]  [k] memcpy                                
     0.07%  netperf  [kernel.kallsyms]  [k] net_rx_action                         
     0.07%  netperf  [kernel.kallsyms]  [k] kmalloc_slab                          
     0.07%  netperf  [kernel.kallsyms]  [k] skb_network_protocol                  
     0.07%  netperf  [kernel.kallsyms]  [k] ip_output                             
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_init_tso_segs                     
     0.07%  netperf  [kernel.kallsyms]  [k] __tcp_select_window                   
     0.07%  netperf  [kernel.kallsyms]  [k] rcu_process_callbacks                 
     0.07%  netperf  [kernel.kallsyms]  [k] bictcp_acked                          
     0.07%  netperf  [kernel.kallsyms]  [k] sockfd_lookup_light                   
     0.07%  netperf  [kernel.kallsyms]  [k] __kmalloc_node_track_caller           
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_wfree                             
     0.07%  netperf  [kernel.kallsyms]  [k] run_rebalance_domains                 
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_schedule_loss_probe               
     0.07%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore           
     0.07%  netperf  [kernel.kallsyms]  [k] __slab_free                           
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_parse_md5sig_option               
     0.06%  netperf  [kernel.kallsyms]  [k] inet_ehashfn                          
     0.06%  netperf  [kernel.kallsyms]  [k] tcp_v4_send_check                     
     0.06%  netperf  [kernel.kallsyms]  [k] schedule                              
     0.06%  netperf  [kernel.kallsyms]  [k] sock_recvmsg                          
     0.06%  netperf  [kernel.kallsyms]  [k] inet_sendmsg                          
     0.06%  netperf  [kernel.kallsyms]  [k] wakeup_softirqd                       
     0.06%  netperf  [kernel.kallsyms]  [k] sk_reset_timer                        
     0.06%  netperf  [kernel.kallsyms]  [k] add_interrupt_randomness              
     0.06%  netperf  [kernel.kallsyms]  [k] __napi_schedule                       
     0.06%  netperf  [kernel.kallsyms]  [k] __queue_work                          
     0.05%  netperf  [kernel.kallsyms]  [k] sock_sendmsg                          
     0.05%  netperf  [kernel.kallsyms]  [k] sch_direct_xmit                       
     0.05%  netperf  [kernel.kallsyms]  [k] handle_edge_irq                       
     0.05%  netperf  [kernel.kallsyms]  [k] __tcp_ack_snd_check                   
     0.05%  netperf  [kernel.kallsyms]  [k] tcp_send_mss                          
     0.05%  netperf  [kernel.kallsyms]  [k] bictcp_cong_avoid                     
     0.05%  netperf  [kernel.kallsyms]  [k] update_blocked_averages               
     0.05%  netperf  [kernel.kallsyms]  [k] net_rps_action_and_irq_enable.clone.82
     0.05%  netperf  [kernel.kallsyms]  [k] perf_pmu_rotate_start.clone.45        
     0.05%  netperf  [kernel.kallsyms]  [k] inet_recvmsg                          
     0.05%  netperf  [ixgbe]            [k] __ixgbe_xmit_frame                    
     0.04%  netperf  [kernel.kallsyms]  [k] dst_release                           
     0.04%  netperf  [kernel.kallsyms]  [k] sk_stream_alloc_skb                   
     0.04%  netperf  [kernel.kallsyms]  [k] raw_local_deliver                     
     0.04%  netperf  [kernel.kallsyms]  [k] put_page                              
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_write_timer_handler               
     0.04%  netperf  [kernel.kallsyms]  [k] netif_receive_skb                     
     0.04%  netperf  [kernel.kallsyms]  [k] netdev_pick_tx                        
     0.04%  netperf  [kernel.kallsyms]  [k] __sk_mem_reclaim                      
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_current_mss                       
     0.04%  netperf  [kernel.kallsyms]  [k] enqueue_entity                        
     0.04%  netperf  [kernel.kallsyms]  [k] build_skb                             
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_release_cb                        
     0.04%  netperf  [kernel.kallsyms]  [k] handle_irq_event_percpu               
     0.04%  netperf  [kernel.kallsyms]  [k] rcu_irq_enter                         
     0.04%  netperf  [kernel.kallsyms]  [k] handle_irq_event                      
     0.04%  netperf  [kernel.kallsyms]  [k] restore_args                          
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_queue_rcv                         
     0.03%  netperf  [kernel.kallsyms]  [k] ns_to_timeval                         
     0.03%  netperf  [kernel.kallsyms]  [k] sock_wfree                            
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_established_options               
     0.03%  netperf  [kernel.kallsyms]  [k] ns_to_timespec                        
     0.03%  netperf  [kernel.kallsyms]  [k] __alloc_skb                           
     0.03%  netperf  [kernel.kallsyms]  [k] ip_local_out                          
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_v4_md5_lookup                     
     0.03%  netperf  [kernel.kallsyms]  [k] try_to_wake_up                        
     0.03%  netperf  [kernel.kallsyms]  [k] check_preempt_wakeup                  
     0.03%  netperf  [kernel.kallsyms]  [k] enqueue_task_fair                     
     0.03%  netperf  [kernel.kallsyms]  [k] napi_complete                         
     0.03%  netperf  [kernel.kallsyms]  [k] dequeue_task                          
     0.03%  netperf  [kernel.kallsyms]  [k] cpuacct_charge                        
     0.03%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single                   
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_event_new_data_sent               
     0.03%  netperf  [kernel.kallsyms]  [k] pick_next_task_fair                   
     0.03%  netperf  [kernel.kallsyms]  [k] smp_apic_timer_interrupt              
     0.03%  netperf  [kernel.kallsyms]  [k] skb_push                              
     0.02%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb                   
     0.02%  netperf  [kernel.kallsyms]  [k] __perf_event_task_sched_out           
     0.02%  netperf  [kernel.kallsyms]  [k] perf_event_context_sched_in           
     0.02%  netperf  [kernel.kallsyms]  [k] deactivate_task                       
     0.02%  netperf  [kernel.kallsyms]  [k] ktime_get_real                        
     0.02%  netperf  [kernel.kallsyms]  [k] __tcp_push_pending_frames             
     0.02%  netperf  [kernel.kallsyms]  [k] irq_to_desc                           
     0.02%  netperf  [kernel.kallsyms]  [k] consume_skb                           
     0.02%  netperf  [kernel.kallsyms]  [k] handle_irq                            
     0.02%  netperf  [kernel.kallsyms]  [k] __slab_alloc                          
     0.02%  netperf  [kernel.kallsyms]  [k] hrtimer_run_pending                   
     0.02%  netperf  [kernel.kallsyms]  [k] source_load                           
     0.02%  netperf  [kernel.kallsyms]  [k] idle_balance                          
     0.02%  netperf  [kernel.kallsyms]  [k] _raw_spin_trylock                     
     0.02%  netperf  netperf            [.] send@plt                              
     0.02%  netperf  [kernel.kallsyms]  [k] irq_enter                             
     0.02%  netperf  [kernel.kallsyms]  [k] note_interrupt                        
     0.02%  netperf  [kernel.kallsyms]  [k] target_load                           
     0.02%  netperf  [kernel.kallsyms]  [k] hrtick_update                         
     0.02%  netperf  [kernel.kallsyms]  [k] skb_release_all                       
     0.02%  netperf  [kernel.kallsyms]  [k] get_pwq.clone.19                      
     0.02%  netperf  [kernel.kallsyms]  [k] do_IRQ                                
     0.01%  netperf  libc-2.17.so       [.] _IO_file_write@@GLIBC_2.2.5           
     0.01%  netperf  [kernel.kallsyms]  [k] set_next_buddy                        
     0.01%  netperf  libc-2.17.so       [.] __GI___libc_write                     


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--------------030007040200040004090608
Content-Type: text/plain; charset=windows-1255;
 name="perf.patched.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf.patched.txt"

# ========
# captured on: Sun Dec  1 09:53:03 2013
# hostname : ladj537.jer.intel.com
# os release : 3.13.0-rc2-sched-pathcesmin3+IPv6+
# perf version : 3.11.9-200.fc19.x86_64
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz
# cpuid : GenuineIntel,6,45,7
# total memory : 32905936 kB
# cmdline : /usr/bin/perf record netperf -t TCP_RR -H 192.168.1.1 -l 30 -T 4,4 -C -c 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, uncore_pcu = 15, uncore_imc_0 = 17, uncore_imc_1 = 18, uncore_imc_2 = 19, uncore_imc_3 = 20, uncore_qpi_0 = 21, uncore_qpi_1 = 22, uncore_cbox_0 = 7, uncore_cbox_1 = 8, uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 = 12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_ha = 16, uncore_r2pcie = 23, uncore_r3qpi_0 = 24, uncore_r3qpi_1 = 25, breakpoint = 5, uncore_ubox = 6
# ========
#
# Samples: 36K of event 'cycles'
# Event count (approx.): 19610852
#
# Overhead  Command      Shared Object                                Symbol
# ........  .......  .................  ....................................
#
    11.60%  netperf  [kernel.kallsyms]  [k] hrtimer_interrupt               
     7.19%  netperf  [kernel.kallsyms]  [k] timerqueue_add                  
     5.62%  netperf  [kernel.kallsyms]  [k] __run_hrtimer.clone.33          
     5.21%  netperf  [kernel.kallsyms]  [k] hrtimer_forward                 
     4.25%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_bh               
     4.08%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock                  
     3.80%  netperf  [kernel.kallsyms]  [k] sk_wait_data                    
     3.76%  netperf  [kernel.kallsyms]  [k] lapic_next_deadline             
     3.65%  netperf  [kernel.kallsyms]  [k] tick_program_event              
     3.41%  netperf  [kernel.kallsyms]  [k] ktime_get                       
     3.04%  netperf  [kernel.kallsyms]  [k] finish_wait                     
     2.60%  netperf  [kernel.kallsyms]  [k] tick_sched_timer                
     2.51%  netperf  [kernel.kallsyms]  [k] tcp_recvmsg                     
     2.43%  netperf  [kernel.kallsyms]  [k] rb_insert_color                 
     1.88%  netperf  [kernel.kallsyms]  [k] lock_sock_nested                
     1.78%  netperf  [kernel.kallsyms]  [k] __might_sleep                   
     1.46%  netperf  [kernel.kallsyms]  [k] profile_tick                    
     1.40%  netperf  netperf            [.] recv_data                       
     1.27%  netperf  netperf            [.] send_omni_inner                 
     1.24%  netperf  [kernel.kallsyms]  [k] tcp_service_net_dma             
     1.23%  netperf  [kernel.kallsyms]  [k] clockevents_program_event       
     1.10%  netperf  [kernel.kallsyms]  [k] tcp_rcv_established             
     0.99%  netperf  [kernel.kallsyms]  [k] local_bh_enable                 
     0.99%  netperf  [ixgbe]            [k] ixgbe_clean_rx_irq              
     0.86%  netperf  [kernel.kallsyms]  [k] local_bh_disable                
     0.59%  netperf  [kernel.kallsyms]  [k] run_posix_cpu_timers            
     0.54%  netperf  [kernel.kallsyms]  [k] tcp_ack                         
     0.54%  netperf  [kernel.kallsyms]  [k] tcp_prequeue_process            
     0.52%  netperf  netperf            [.] send_data                       
     0.51%  netperf  [kernel.kallsyms]  [k] build_skb                       
     0.51%  netperf  [kernel.kallsyms]  [k] read_tsc                        
     0.50%  netperf  [kernel.kallsyms]  [k] idle_cpu                        
     0.49%  netperf  [kernel.kallsyms]  [k] run_timer_softirq               
     0.41%  netperf  [kernel.kallsyms]  [k] tcp_md5_do_lookup               
     0.40%  netperf  [kernel.kallsyms]  [k] perf_event_task_tick            
     0.39%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_bh             
     0.36%  netperf  [kernel.kallsyms]  [k] ipv4_dst_check                  
     0.35%  netperf  [kernel.kallsyms]  [k] system_call                     
     0.35%  netperf  [kernel.kallsyms]  [k] trigger_load_balance            
     0.35%  netperf  [kernel.kallsyms]  [k] rcu_irq_exit                    
     0.35%  netperf  [kernel.kallsyms]  [k] intel_pmu_enable_all            
     0.33%  netperf  [ixgbe]            [k] ixgbe_low_latency_recv          
     0.32%  netperf  [kernel.kallsyms]  [k] __do_softirq                    
     0.31%  netperf  [kernel.kallsyms]  [k] mod_timer                       
     0.31%  netperf  [kernel.kallsyms]  [k] tcp_parse_aligned_timestamp     
     0.27%  netperf  [kernel.kallsyms]  [k] fget_light                      
     0.27%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb_core        
     0.26%  netperf  [kernel.kallsyms]  [k] tcp_event_data_recv             
     0.26%  netperf  [kernel.kallsyms]  [k] sock_def_readable               
     0.25%  netperf  [kernel.kallsyms]  [k] irq_entries_start               
     0.25%  netperf  [kernel.kallsyms]  [k] find_busiest_group              
     0.24%  netperf  [kernel.kallsyms]  [k] tcp_v4_do_rcv                   
     0.22%  netperf  [kernel.kallsyms]  [k] local_bh_enable_ip              
     0.22%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc                
     0.22%  netperf  libc-2.17.so       [.] __libc_recv                     
     0.22%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_frag             
     0.20%  netperf  [kernel.kallsyms]  [k] __kmalloc_node_track_caller     
     0.20%  netperf  [kernel.kallsyms]  [k] irq_exit                        
     0.20%  netperf  [kernel.kallsyms]  [k] common_interrupt                
     0.19%  netperf  [kernel.kallsyms]  [k] tcp_sendmsg                     
     0.18%  netperf  libc-2.17.so       [.] __libc_send                     
     0.18%  netperf  [kernel.kallsyms]  [k] copy_user_generic_string        
     0.18%  netperf  [kernel.kallsyms]  [k] tcp_rearm_rto                   
     0.17%  netperf  [kernel.kallsyms]  [k] rcu_process_callbacks           
     0.17%  netperf  [kernel.kallsyms]  [k] finish_task_switch              
     0.17%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irq              
     0.16%  netperf  [kernel.kallsyms]  [k] tcp_rcv_space_adjust            
     0.16%  netperf  [kernel.kallsyms]  [k] scheduler_tick                  
     0.16%  netperf  [kernel.kallsyms]  [k] __getnstimeofday                
     0.16%  netperf  [kernel.kallsyms]  [k] skb_release_data                
     0.16%  netperf  [kernel.kallsyms]  [k] restore_args                    
     0.15%  netperf  [kernel.kallsyms]  [k] native_apic_msr_eoi_write       
     0.15%  netperf  [kernel.kallsyms]  [k] raise_softirq                   
     0.12%  netperf  [kernel.kallsyms]  [k] ip_queue_xmit                   
     0.12%  netperf  [kernel.kallsyms]  [k] ip_rcv                          
     0.12%  netperf  [kernel.kallsyms]  [k] skb_copy_datagram_iovec         
     0.12%  netperf  [kernel.kallsyms]  [k] tcp_transmit_skb                
     0.12%  netperf  [kernel.kallsyms]  [k] load_balance                    
     0.12%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore     
     0.12%  netperf  [kernel.kallsyms]  [k] schedule_timeout                
     0.12%  netperf  [kernel.kallsyms]  [k] radix_tree_lookup_element       
     0.11%  netperf  [kernel.kallsyms]  [k] __kfree_skb                     
     0.11%  netperf  [kernel.kallsyms]  [k] do_softirq                      
     0.11%  netperf  [kernel.kallsyms]  [k] __inet_lookup_established       
     0.11%  netperf  [kernel.kallsyms]  [k] inet_ehashfn                    
     0.10%  netperf  [kernel.kallsyms]  [k] memcpy_toiovec                  
     0.10%  netperf  [kernel.kallsyms]  [k] netif_skb_features              
     0.09%  netperf  [kernel.kallsyms]  [k] tcp_write_xmit                  
     0.09%  netperf  [kernel.kallsyms]  [k] tcp_rtt_estimator               
     0.09%  netperf  [ixgbe]            [k] ixgbe_xmit_frame_ring           
     0.08%  netperf  [kernel.kallsyms]  [k] kmem_cache_free                 
     0.08%  netperf  [kernel.kallsyms]  [k] tcp_check_space                 
     0.08%  netperf  [kernel.kallsyms]  [k] __local_bh_enable               
     0.08%  netperf  [kernel.kallsyms]  [k] SYSC_sendto                     
     0.08%  netperf  [kernel.kallsyms]  [k] might_fault                     
     0.08%  netperf  ld-2.17.so         [.] do_lookup_x                     
     0.08%  netperf  [kernel.kallsyms]  [k] __inc_zone_state                
     0.08%  netperf  [kernel.kallsyms]  [k] bictcp_acked                    
     0.08%  netperf  [kernel.kallsyms]  [k] skb_free_head                   
     0.08%  netperf  [kernel.kallsyms]  [k] note_gp_changes                 
     0.08%  netperf  [kernel.kallsyms]  [k] tcp_cleanup_rbuf                
     0.07%  netperf  [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context  
     0.07%  netperf  [kernel.kallsyms]  [k] __schedule                      
     0.07%  netperf  [kernel.kallsyms]  [k] get_seconds                     
     0.07%  netperf  [kernel.kallsyms]  [k] sockfd_lookup_light             
     0.07%  netperf  [kernel.kallsyms]  [k] ip_local_deliver                
     0.07%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave          
     0.07%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit_nit              
     0.06%  netperf  [kernel.kallsyms]  [k] ip_send_check                   
     0.06%  netperf  [kernel.kallsyms]  [k] tcp_wfree                       
     0.06%  netperf  [kernel.kallsyms]  [k] sk_filter                       
     0.06%  netperf  [kernel.kallsyms]  [k] tcp_current_mss                 
     0.06%  netperf  [kernel.kallsyms]  [k] tcp_write_timer_handler         
     0.06%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit                  
     0.06%  netperf  [kernel.kallsyms]  [k] prepare_to_wait                 
     0.06%  netperf  [kernel.kallsyms]  [k] __queue_work                    
     0.06%  netperf  [kernel.kallsyms]  [k] kfree                           
     0.05%  netperf  [kernel.kallsyms]  [k] put_prev_task_fair              
     0.05%  netperf  libc-2.17.so       [.] __sysconf                       
     0.05%  netperf  libc-2.17.so       [.] freeaddrinfo                    
     0.05%  netperf  ld-2.17.so         [.] _dl_lookup_symbol_x             
     0.05%  netperf  [kernel.kallsyms]  [k] find_get_page                   
     0.05%  netperf  [kernel.kallsyms]  [k] filemap_fault                   
     0.05%  netperf  [kernel.kallsyms]  [k] link_path_walk                  
     0.05%  netperf  [kernel.kallsyms]  [k] clear_page_c                    
     0.05%  netperf  [kernel.kallsyms]  [k] sys_sendto                      
     0.05%  netperf  [kernel.kallsyms]  [k] page_fault                      
     0.05%  netperf  [kernel.kallsyms]  [k] tcp_prequeue                    
     0.05%  netperf  [kernel.kallsyms]  [k] eth_header                      
     0.05%  netperf  [kernel.kallsyms]  [k] sock_wfree                      
     0.05%  netperf  [kernel.kallsyms]  [k] __skb_clone                     
     0.05%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single             
     0.05%  netperf  [kernel.kallsyms]  [k] native_sched_clock              
     0.05%  netperf  [kernel.kallsyms]  [k] raw_local_deliver               
     0.05%  netperf  [kernel.kallsyms]  [k] add_interrupt_randomness        
     0.05%  netperf  [kernel.kallsyms]  [k] tcp_is_cwnd_limited             
     0.05%  netperf  [kernel.kallsyms]  [k] update_process_times            
     0.05%  netperf  [kernel.kallsyms]  [k] __x2apic_send_IPI_mask          
     0.05%  netperf  [kernel.kallsyms]  [k] inet_sendmsg                    
     0.04%  netperf  [kernel.kallsyms]  [k] __copy_user_nocache             
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_schedule_loss_probe         
     0.04%  netperf  [kernel.kallsyms]  [k] deactivate_task                 
     0.04%  netperf  [kernel.kallsyms]  [k] do_softirq_own_stack            
     0.04%  netperf  [kernel.kallsyms]  [k] hrtimer_run_pending             
     0.04%  netperf  [kernel.kallsyms]  [k] net_rx_action                   
     0.04%  netperf  [kernel.kallsyms]  [k] SYSC_recvfrom                   
     0.04%  netperf  [kernel.kallsyms]  [k] kmalloc_slab                    
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_options_write               
     0.04%  netperf  [kernel.kallsyms]  [k] netif_receive_skb               
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_v4_rcv                      
     0.04%  netperf  [kernel.kallsyms]  [k] msecs_to_jiffies                
     0.04%  netperf  [kernel.kallsyms]  [k] __tcp_select_window             
     0.04%  netperf  [kernel.kallsyms]  [k] get_work_pool                   
     0.04%  netperf  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load      
     0.04%  netperf  [kernel.kallsyms]  [k] internal_add_timer              
     0.04%  netperf  [ixgbe]            [k] ixgbe_poll                      
     0.03%  netperf  [kernel.kallsyms]  [k] ip_finish_output                
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_parse_md5sig_option         
     0.03%  netperf  [kernel.kallsyms]  [k] skb_release_head_state          
     0.03%  netperf  [kernel.kallsyms]  [k] sock_rfree                      
     0.03%  netperf  [kernel.kallsyms]  [k] __tcp_ack_snd_check             
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_release_cb                  
     0.03%  netperf  [kernel.kallsyms]  [k] dequeue_entity                  
     0.03%  netperf  [kernel.kallsyms]  [k] irq_work_interrupt              
     0.03%  netperf  [kernel.kallsyms]  [k] __slab_free                     
     0.03%  netperf  [kernel.kallsyms]  [k] file_free_rcu                   
     0.03%  netperf  [kernel.kallsyms]  [k] rcu_irq_enter                   
     0.03%  netperf  [kernel.kallsyms]  [k] release_sock                    
     0.03%  netperf  [kernel.kallsyms]  [k] __sk_mem_reclaim                
     0.03%  netperf  [kernel.kallsyms]  [k] dql_completed                   
     0.03%  netperf  [kernel.kallsyms]  [k] update_curr                     
     0.03%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single_for_device  
     0.03%  netperf  [kernel.kallsyms]  [k] __alloc_skb                     
     0.03%  netperf  [kernel.kallsyms]  [k] put_cpu_partial                 
     0.03%  netperf  [kernel.kallsyms]  [k] __napi_schedule                 
     0.03%  netperf  [kernel.kallsyms]  [k] rcu_note_context_switch         
     0.03%  netperf  netperf            [.] memset@plt                      
     0.03%  netperf  netperf            [.] send_request_n                  
     0.03%  netperf  netperf            [.] recv_response_timed_n           
     0.03%  netperf  netperf            [.] get_remote_system_info          
     0.03%  netperf  libc-2.17.so       [.] __GI_____strtoll_l_internal     
     0.03%  netperf  libc-2.17.so       [.] _int_malloc                     
     0.03%  netperf  libc-2.17.so       [.] free                            
     0.03%  netperf  libc-2.17.so       [.] _getopt_internal_r              
     0.03%  netperf  libc-2.17.so       [.] getaddrinfo                     
     0.03%  netperf  libc-2.17.so       [.] __get_nprocs                    
     0.03%  netperf  libc-2.17.so       [.] __GI___bind                     
     0.03%  netperf  libc-2.17.so       [.] __GI___socket                   
     0.03%  netperf  libc-2.17.so       [.] __libc_alloca_cutoff            
     0.03%  netperf  libc-2.17.so       [.] __check_pf                      
     0.03%  netperf  libc-2.17.so       [.] __strcasecmp_l_avx              
     0.03%  netperf  ld-2.17.so         [.] _dl_fixup                       
     0.03%  netperf  [kernel.kallsyms]  [k] destroy_context                 
     0.03%  netperf  [kernel.kallsyms]  [k] sched_setaffinity               
     0.03%  netperf  [kernel.kallsyms]  [k] __wake_up_bit                   
     0.03%  netperf  [kernel.kallsyms]  [k] __mutex_init                    
     0.03%  netperf  [kernel.kallsyms]  [k] __alloc_pages_nodemask          
     0.03%  netperf  [kernel.kallsyms]  [k] lru_cache_add                   
     0.03%  netperf  [kernel.kallsyms]  [k] find_vma                        
     0.03%  netperf  [kernel.kallsyms]  [k] policy_nodemask                 
     0.03%  netperf  [kernel.kallsyms]  [k] path_init                       
     0.03%  netperf  [kernel.kallsyms]  [k] select_estimate_accuracy        
     0.03%  netperf  [kernel.kallsyms]  [k] do_select                       
     0.03%  netperf  [kernel.kallsyms]  [k] d_flags_for_inode               
     0.03%  netperf  [kernel.kallsyms]  [k] __d_lookup                      
     0.03%  netperf  [kernel.kallsyms]  [k] inode_init_always               
     0.03%  netperf  [kernel.kallsyms]  [k] fd_install                      
     0.03%  netperf  [kernel.kallsyms]  [k] proc_lookup_de                  
     0.03%  netperf  [kernel.kallsyms]  [k] sysfs_open_file                 
     0.03%  netperf  [kernel.kallsyms]  [k] security_d_instantiate          
     0.03%  netperf  [kernel.kallsyms]  [k] security_file_permission        
     0.03%  netperf  [kernel.kallsyms]  [k] strcmp                          
     0.03%  netperf  [kernel.kallsyms]  [k] strlen                          
     0.03%  netperf  [kernel.kallsyms]  [k] vsnprintf                       
     0.03%  netperf  [kernel.kallsyms]  [k] lockref_get_not_dead            
     0.03%  netperf  [kernel.kallsyms]  [k] bitmap_scnlistprintf            
     0.03%  netperf  [kernel.kallsyms]  [k] strncpy_from_user               
     0.03%  netperf  [kernel.kallsyms]  [k] __sock_create                   
     0.03%  netperf  [kernel.kallsyms]  [k] sys_bind                        
     0.03%  netperf  [kernel.kallsyms]  [k] sock_init_data                  
     0.03%  netperf  [kernel.kallsyms]  [k] __netlink_create                
     0.03%  netperf  [kernel.kallsyms]  [k] netlink_autobind.clone.30       
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_send_mss                    
     0.03%  netperf  [kernel.kallsyms]  [k] mutex_lock                      
     0.03%  netperf  [kernel.kallsyms]  [k] __do_page_fault                 
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_queue_rcv                   
     0.03%  netperf  [kernel.kallsyms]  [k] handle_irq_event                
     0.02%  netperf  [kernel.kallsyms]  [k] lock_timer_base.clone.26        
     0.02%  netperf  [kernel.kallsyms]  [k] group_balance_cpu               
     0.02%  netperf  [kernel.kallsyms]  [k] inet_recvmsg                    
     0.02%  netperf  [kernel.kallsyms]  [k] __kmalloc_reserve.clone.52      
     0.02%  netperf  [kernel.kallsyms]  [k] dequeue_task                    
     0.02%  netperf  [kernel.kallsyms]  [k] idle_balance                    
     0.02%  netperf  [kernel.kallsyms]  [k] find_next_bit                   
     0.02%  netperf  [kernel.kallsyms]  [k] ipv4_mtu                        
     0.02%  netperf  [kernel.kallsyms]  [k] __update_entity_load_avg_contrib
     0.02%  netperf  [ixgbe]            [k] ixgbe_alloc_rx_buffers          
     0.02%  netperf  [kernel.kallsyms]  [k] __compute_runnable_contrib      
     0.02%  netperf  [kernel.kallsyms]  [k] sk_stream_alloc_skb             
     0.02%  netperf  [kernel.kallsyms]  [k] __tcp_push_pending_frames       
     0.02%  netperf  [kernel.kallsyms]  [k] try_to_wake_up                  
     0.02%  netperf  [kernel.kallsyms]  [k] source_load                     
     0.02%  netperf  [kernel.kallsyms]  [k] __wake_up_common                
     0.02%  netperf  [kernel.kallsyms]  [k] rcu_accelerate_cbs              
     0.02%  netperf  [kernel.kallsyms]  [k] llist_add_batch                 
     0.02%  netperf  [kernel.kallsyms]  [k] __netdev_pick_tx                
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_set_skb_tso_segs            
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_stream_memory_free          
     0.02%  netperf  [kernel.kallsyms]  [k] memcpy                          
     0.02%  netperf  [kernel.kallsyms]  [k] swiotlb_map_page                
     0.02%  netperf  [kernel.kallsyms]  [k] harmonize_features              
     0.02%  netperf  [kernel.kallsyms]  [k] intel_pmu_disable_all           
     0.02%  netperf  [kernel.kallsyms]  [k] update_cfs_shares               
     0.02%  netperf  [kernel.kallsyms]  [k] enqueue_entity                  
     0.02%  netperf  [kernel.kallsyms]  [k] retint_restore_args             
     0.02%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_skb              
     0.02%  netperf  [kernel.kallsyms]  [k] irq_to_desc                     
     0.02%  netperf  [ixgbe]            [k] ixgbe_msix_clean_rings          
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_v4_early_demux              
     0.02%  netperf  [kernel.kallsyms]  [k] eth_type_trans                  
     0.02%  netperf  [kernel.kallsyms]  [k] update_rq_clock                 
     0.02%  netperf  [kernel.kallsyms]  [k] perf_pmu_rotate_start.clone.45  
     0.02%  netperf  [kernel.kallsyms]  [k] schedule                        
     0.02%  netperf  [kernel.kallsyms]  [k] dev_hard_start_xmit             
     0.02%  netperf  [kernel.kallsyms]  [k] put_page                        
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_send_delayed_ack            
     0.02%  netperf  libc-2.17.so       [.] vfprintf                        
     0.02%  netperf  libc-2.17.so       [.] fprintf                         
     0.02%  netperf  libc-2.17.so       [.] _IO_file_write@@GLIBC_2.2.5     
     0.02%  netperf  libc-2.17.so       [.] _IO_file_xsputn@@GLIBC_2.2.5    
     0.02%  netperf  [kernel.kallsyms]  [k] swiotlb_dma_mapping_error       
     0.02%  netperf  [kernel.kallsyms]  [k] netdev_pick_tx                  
     0.02%  netperf  [kernel.kallsyms]  [k] ns_to_timespec                  
     0.02%  netperf  [kernel.kallsyms]  [k] __note_gp_changes               
     0.02%  netperf  [kernel.kallsyms]  [k] unmap_single                    
     0.02%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb             
     0.02%  netperf  [kernel.kallsyms]  [k] __perf_event_task_sched_in      
     0.01%  netperf  [kernel.kallsyms]  [k] do_IRQ                          
     0.01%  netperf  [kernel.kallsyms]  [k] swiotlb_unmap_page              
     0.01%  netperf  [kernel.kallsyms]  [k] consume_skb                     
     0.01%  netperf  [kernel.kallsyms]  [k] dev_kfree_skb_any               
     0.01%  netperf  [kernel.kallsyms]  [k] skb_clone                       
     0.01%  netperf  [kernel.kallsyms]  [k] tcp_established_options         
     0.01%  netperf  [kernel.kallsyms]  [k] irq_enter                       
     0.01%  netperf  [kernel.kallsyms]  [k] handle_edge_irq                 
     0.01%  netperf  [kernel.kallsyms]  [k] tcp_v4_md5_lookup               


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--------------030007040200040004090608
Content-Type: text/plain; charset=windows-1255;
 name="perf.sched-clock.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf.sched-clock.txt"

# ========
# captured on: Sun Dec  1 06:43:34 2013
# hostname : ladj537.jer.intel.com
# os release : 3.13.0-rc2min3+IPv6+
# perf version : 3.11.9-200.fc19.x86_64
# arch : x86_64
# nrcpus online : 32
# nrcpus avail : 32
# cpudesc : Intel(R) Xeon(R) CPU E5-2680 0 @ 2.70GHz
# cpuid : GenuineIntel,6,45,7
# total memory : 32905936 kB
# cmdline : /usr/bin/perf record netperf -t TCP_RR -H 192.168.1.1 -l 30 -T 4,4 -C -c 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, uncore_pcu = 15, uncore_imc_0 = 17, uncore_imc_1 = 18, uncore_imc_2 = 19, uncore_imc_3 = 20, uncore_qpi_0 = 21, uncore_qpi_1 = 22, uncore_cbox_0 = 7, uncore_cbox_1 = 8, uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 = 12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_ha = 16, uncore_r2pcie = 23, uncore_r3qpi_0 = 24, uncore_r3qpi_1 = 25, breakpoint = 5, uncore_ubox = 6
# ========
#
# Samples: 119K of event 'cycles'
# Event count (approx.): 80231833254
#
# Overhead  Command      Shared Object                                      Symbol
# ........  .......  .................  ..........................................
#
    22.74%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_bh                     
    11.63%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_bh                   
    10.62%  netperf  [kernel.kallsyms]  [k] native_sched_clock                    
    10.45%  netperf  [kernel.kallsyms]  [k] tcp_recvmsg                           
     8.26%  netperf  [ixgbe]            [k] ixgbe_clean_rx_irq                    
     5.29%  netperf  [kernel.kallsyms]  [k] local_bh_enable_ip                    
     5.04%  netperf  [ixgbe]            [k] ixgbe_low_latency_recv                
     1.15%  netperf  [kernel.kallsyms]  [k] tcp_ack                               
     1.01%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock                        
     0.90%  netperf  [kernel.kallsyms]  [k] local_bh_disable                      
     0.89%  netperf  [kernel.kallsyms]  [k] tcp_sendmsg                           
     0.75%  netperf  netperf            [.] send_omni_inner                       
     0.74%  netperf  [ixgbe]            [k] ixgbe_xmit_frame_ring                 
     0.73%  netperf  [kernel.kallsyms]  [k] tcp_transmit_skb                      
     0.64%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb_core              
     0.63%  netperf  [kernel.kallsyms]  [k] system_call                           
     0.63%  netperf  [kernel.kallsyms]  [k] tcp_write_xmit                        
     0.48%  netperf  [kernel.kallsyms]  [k] tcp_rcv_established                   
     0.45%  netperf  [kernel.kallsyms]  [k] ip_rcv                                
     0.35%  netperf  [kernel.kallsyms]  [k] tcp_v4_rcv                            
     0.31%  netperf  [kernel.kallsyms]  [k] __copy_skb_header                     
     0.31%  netperf  [kernel.kallsyms]  [k] dev_hard_start_xmit                   
     0.30%  netperf  [kernel.kallsyms]  [k] ip_queue_xmit                         
     0.30%  netperf  [kernel.kallsyms]  [k] __might_sleep                         
     0.28%  netperf  [kernel.kallsyms]  [k] __alloc_skb                           
     0.27%  netperf  [kernel.kallsyms]  [k] fget_light                            
     0.26%  netperf  netperf            [.] send_data                             
     0.24%  netperf  netperf            [.] recv_data                             
     0.24%  netperf  [kernel.kallsyms]  [k] skb_release_data                      
     0.24%  netperf  [kernel.kallsyms]  [k] sock_def_readable                     
     0.24%  netperf  [kernel.kallsyms]  [k] tcp_queue_rcv                         
     0.23%  netperf  [kernel.kallsyms]  [k] __getnstimeofday                      
     0.23%  netperf  [kernel.kallsyms]  [k] __tcp_select_window                   
     0.23%  netperf  [kernel.kallsyms]  [k] __inet_lookup_established             
     0.23%  netperf  [kernel.kallsyms]  [k] ip_finish_output                      
     0.23%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit                        
     0.23%  netperf  [kernel.kallsyms]  [k] build_skb                             
     0.22%  netperf  libc-2.17.so       [.] __libc_recv                           
     0.22%  netperf  [kernel.kallsyms]  [k] skb_clone                             
     0.21%  netperf  [kernel.kallsyms]  [k] local_bh_enable                       
     0.21%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc_node                 
     0.21%  netperf  [kernel.kallsyms]  [k] tcp_schedule_loss_probe               
     0.20%  netperf  [kernel.kallsyms]  [k] kmem_cache_free                       
     0.19%  netperf  [kernel.kallsyms]  [k] tcp_v4_do_rcv                         
     0.19%  netperf  [kernel.kallsyms]  [k] __kmalloc_node_track_caller           
     0.19%  netperf  [kernel.kallsyms]  [k] read_tsc                              
     0.19%  netperf  [kernel.kallsyms]  [k] __skb_clone                           
     0.19%  netperf  [kernel.kallsyms]  [k] __slab_free                           
     0.18%  netperf  [kernel.kallsyms]  [k] __kfree_skb                           
     0.18%  netperf  libc-2.17.so       [.] __libc_send                           
     0.18%  netperf  [kernel.kallsyms]  [k] mod_timer                             
     0.18%  netperf  [kernel.kallsyms]  [k] __tcp_v4_send_check                   
     0.17%  netperf  [kernel.kallsyms]  [k] skb_free_head                         
     0.17%  netperf  [kernel.kallsyms]  [k] sockfd_lookup_light                   
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_cleanup_rbuf                      
     0.17%  netperf  [kernel.kallsyms]  [k] tcp_set_skb_tso_segs                  
     0.16%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_frag                   
     0.16%  netperf  [kernel.kallsyms]  [k] tcp_send_mss                          
     0.15%  netperf  [kernel.kallsyms]  [k] tcp_established_options               
     0.15%  netperf  [kernel.kallsyms]  [k] tcp_event_data_recv                   
     0.15%  netperf  [kernel.kallsyms]  [k] ksize                                 
     0.15%  netperf  [kernel.kallsyms]  [k] kmem_cache_alloc                      
     0.14%  netperf  [kernel.kallsyms]  [k] lock_sock_nested                      
     0.14%  netperf  [kernel.kallsyms]  [k] skb_network_protocol                  
     0.14%  netperf  [kernel.kallsyms]  [k] ip_send_check                         
     0.14%  netperf  [kernel.kallsyms]  [k] sk_filter                             
     0.14%  netperf  [kernel.kallsyms]  [k] memcpy                                
     0.14%  netperf  [kernel.kallsyms]  [k] __netdev_pick_tx                      
     0.13%  netperf  [kernel.kallsyms]  [k] skb_push                              
     0.13%  netperf  [kernel.kallsyms]  [k] swiotlb_map_page                      
     0.13%  netperf  [kernel.kallsyms]  [k] tcp_service_net_dma                   
     0.13%  netperf  [kernel.kallsyms]  [k] skb_copy_datagram_iovec               
     0.13%  netperf  [kernel.kallsyms]  [k] ipv4_dst_check                        
     0.13%  netperf  [kernel.kallsyms]  [k] dev_queue_xmit_nit                    
     0.12%  netperf  [kernel.kallsyms]  [k] tcp_rearm_rto                         
     0.12%  netperf  [kernel.kallsyms]  [k] sch_direct_xmit                       
     0.12%  netperf  [kernel.kallsyms]  [k] SYSC_recvfrom                         
     0.12%  netperf  [kernel.kallsyms]  [k] memcpy_toiovec                        
     0.12%  netperf  [kernel.kallsyms]  [k] tcp_init_tso_segs                     
     0.11%  netperf  [kernel.kallsyms]  [k] eth_type_trans                        
     0.11%  netperf  [kernel.kallsyms]  [k] raw_local_deliver                     
     0.11%  netperf  [ixgbe]            [k] ixgbe_poll                            
     0.11%  netperf  [kernel.kallsyms]  [k] __kmalloc_reserve.clone.52            
     0.11%  netperf  [kernel.kallsyms]  [k] ip_local_deliver                      
     0.11%  netperf  [kernel.kallsyms]  [k] sk_stream_alloc_skb                   
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_v4_early_demux                    
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_rtt_estimator                     
     0.11%  netperf  [kernel.kallsyms]  [k] put_compound_page                     
     0.11%  netperf  [kernel.kallsyms]  [k] tcp_send_delayed_ack                  
     0.10%  netperf  [kernel.kallsyms]  [k] sock_recvmsg                          
     0.10%  netperf  [kernel.kallsyms]  [k] __tcp_ack_snd_check                   
     0.10%  netperf  [kernel.kallsyms]  [k] SYSC_sendto                           
     0.10%  netperf  [kernel.kallsyms]  [k] __sk_dst_check                        
     0.10%  netperf  [kernel.kallsyms]  [k] sock_sendmsg                          
     0.09%  netperf  [kernel.kallsyms]  [k] bictcp_acked                          
     0.09%  netperf  [ixgbe]            [k] ixgbe_tx_ctxtdesc                     
     0.09%  netperf  [kernel.kallsyms]  [k] inet_ehashfn                          
     0.09%  netperf  [kernel.kallsyms]  [k] netdev_pick_tx                        
     0.09%  netperf  [kernel.kallsyms]  [k] sock_wfree                            
     0.09%  netperf  [kernel.kallsyms]  [k] kmalloc_slab                          
     0.09%  netperf  [kernel.kallsyms]  [k] ns_to_timespec                        
     0.09%  netperf  [kernel.kallsyms]  [k] bictcp_cong_avoid                     
     0.09%  netperf  [kernel.kallsyms]  [k] sock_put                              
     0.08%  netperf  [kernel.kallsyms]  [k] might_fault                           
     0.08%  netperf  [kernel.kallsyms]  [k] tcp_parse_aligned_timestamp           
     0.08%  netperf  [kernel.kallsyms]  [k] tcp_options_write                     
     0.08%  netperf  [kernel.kallsyms]  [k] tcp_rcv_space_adjust                  
     0.08%  netperf  [kernel.kallsyms]  [k] release_sock                          
     0.08%  netperf  [ixgbe]            [k] __ixgbe_xmit_frame                    
     0.08%  netperf  [kernel.kallsyms]  [k] sock_rfree                            
     0.08%  netperf  [ixgbe]            [k] ixgbe_alloc_rx_buffers                
     0.08%  netperf  [kernel.kallsyms]  [k] inet_sendmsg                          
     0.07%  netperf  [kernel.kallsyms]  [k] irq_entries_start                     
     0.07%  netperf  [kernel.kallsyms]  [k] skb_release_head_state                
     0.07%  netperf  [kernel.kallsyms]  [k] tcp_wfree                             
     0.07%  netperf  [kernel.kallsyms]  [k] get_seconds                           
     0.07%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single                   
     0.06%  netperf  [kernel.kallsyms]  [k] copy_user_generic_string              
     0.06%  netperf  [kernel.kallsyms]  [k] skb_release_all                       
     0.06%  netperf  [kernel.kallsyms]  [k] tcp_check_space                       
     0.06%  netperf  [kernel.kallsyms]  [k] msecs_to_jiffies                      
     0.06%  netperf  [kernel.kallsyms]  [k] ipv4_mtu                              
     0.05%  netperf  [kernel.kallsyms]  [k] __ip_local_out                        
     0.05%  netperf  [kernel.kallsyms]  [k] ktime_get_real                        
     0.05%  netperf  [kernel.kallsyms]  [k] tcp_current_mss                       
     0.05%  netperf  [kernel.kallsyms]  [k] getnstimeofday                        
     0.05%  netperf  [kernel.kallsyms]  [k] sk_reset_timer                        
     0.05%  netperf  [kernel.kallsyms]  [k] ip_output                             
     0.05%  netperf  [kernel.kallsyms]  [k] __copy_user_nocache                   
     0.05%  netperf  [kernel.kallsyms]  [k] __netdev_alloc_skb                    
     0.04%  netperf  [kernel.kallsyms]  [k] netif_skb_features                    
     0.04%  netperf  [kernel.kallsyms]  [k] harmonize_features                    
     0.04%  netperf  [kernel.kallsyms]  [k] netif_receive_skb                     
     0.04%  netperf  [kernel.kallsyms]  [k] __slab_alloc                          
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_parse_md5sig_option               
     0.04%  netperf  [ixgbe]            [k] ixgbe_xmit_frame                      
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_stream_memory_free                
     0.04%  netperf  [kernel.kallsyms]  [k] inet_recvmsg                          
     0.04%  netperf  [kernel.kallsyms]  [k] kfree                                 
     0.04%  netperf  [kernel.kallsyms]  [k] tcp_md5_do_lookup                     
     0.04%  netperf  [kernel.kallsyms]  [k] __skb_dst_set_noref                   
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_event_new_data_sent               
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_v4_send_check                     
     0.03%  netperf  [kernel.kallsyms]  [k] ns_to_timeval                         
     0.03%  netperf  [kernel.kallsyms]  [k] put_page                              
     0.03%  netperf  [kernel.kallsyms]  [k] skb_put                               
     0.03%  netperf  [kernel.kallsyms]  [k] swiotlb_dma_mapping_error             
     0.03%  netperf  [kernel.kallsyms]  [k] tcp_is_cwnd_limited                   
     0.03%  netperf  [kernel.kallsyms]  [k] __netif_receive_skb                   
     0.03%  netperf  [kernel.kallsyms]  [k] _copy_to_user                         
     0.03%  netperf  [kernel.kallsyms]  [k] dql_completed                         
     0.03%  netperf  [kernel.kallsyms]  [k] __tcp_push_pending_frames             
     0.03%  netperf  [kernel.kallsyms]  [k] neigh_resolve_output                  
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_release_cb                        
     0.02%  netperf  [kernel.kallsyms]  [k] ktime_get                             
     0.02%  netperf  [kernel.kallsyms]  [k] native_apic_msr_eoi_write             
     0.02%  netperf  [kernel.kallsyms]  [k] napi_by_id                            
     0.02%  netperf  [kernel.kallsyms]  [k] ip_local_out                          
     0.02%  netperf  [kernel.kallsyms]  [k] eth_header                            
     0.02%  netperf  [kernel.kallsyms]  [k] dev_kfree_skb_any                     
     0.02%  netperf  [kernel.kallsyms]  [k] radix_tree_lookup_element             
     0.02%  netperf  [kernel.kallsyms]  [k] tcp_prequeue                          
     0.02%  netperf  [kernel.kallsyms]  [k] __do_softirq                          
     0.02%  netperf  [kernel.kallsyms]  [k] handle_edge_irq                       
     0.01%  netperf  [kernel.kallsyms]  [k] net_rx_action                         
     0.01%  netperf  [kernel.kallsyms]  [k] add_interrupt_randomness              
     0.01%  netperf  [kernel.kallsyms]  [k] do_softirq                            
     0.01%  netperf  [kernel.kallsyms]  [k] unmap_single                          
     0.01%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single_for_cpu           
     0.01%  netperf  [kernel.kallsyms]  [k] dma_issue_pending_all                 
     0.01%  netperf  [kernel.kallsyms]  [k] rcu_irq_exit                          
     0.01%  netperf  [kernel.kallsyms]  [k] rcu_irq_enter                         
     0.01%  netperf  netperf            [.] recv@plt                              
     0.01%  netperf  [kernel.kallsyms]  [k] __napi_complete                       
     0.01%  netperf  [kernel.kallsyms]  [k] __napi_schedule                       
     0.01%  netperf  [kernel.kallsyms]  [k] tcp_v4_md5_lookup                     
     0.01%  netperf  [kernel.kallsyms]  [k] swiotlb_sync_single_for_device        
     0.01%  netperf  [kernel.kallsyms]  [k] swiotlb_unmap_page                    
     0.01%  netperf  [kernel.kallsyms]  [k] common_interrupt                      
     0.01%  netperf  netperf            [.] send@plt                              
     0.01%  netperf  [ixgbe]            [k] ixgbe_msix_clean_rings                
     0.01%  netperf  [kernel.kallsyms]  [k] do_IRQ                                
     0.01%  netperf  [kernel.kallsyms]  [k] sys_recvfrom                          
     0.01%  netperf  [kernel.kallsyms]  [k] consume_skb                           
     0.01%  netperf  [kernel.kallsyms]  [k] rcu_bh_qs                             
     0.01%  netperf  [kernel.kallsyms]  [k] sys_sendto                            
     0.01%  netperf  [kernel.kallsyms]  [k] irq_enter                             
     0.01%  netperf  [kernel.kallsyms]  [k] __local_bh_enable                     
     0.01%  netperf  [kernel.kallsyms]  [k] handle_irq_event_percpu               
     0.01%  netperf  [kernel.kallsyms]  [k] note_interrupt                        
     0.01%  netperf  [kernel.kallsyms]  [k] napi_complete                         
     0.01%  netperf  [kernel.kallsyms]  [k] update_curr                           
     0.00%  netperf  [kernel.kallsyms]  [k] do_softirq_own_stack                  
     0.00%  netperf  [kernel.kallsyms]  [k] sha_transform                         
     0.00%  netperf  [kernel.kallsyms]  [k] handle_irq                            
     0.00%  netperf  [kernel.kallsyms]  [k] rcu_check_callbacks                   
     0.00%  netperf  [kernel.kallsyms]  [k] task_tick_fair                        
     0.00%  netperf  [kernel.kallsyms]  [k] intel_pmu_disable_all                 
     0.00%  netperf  [kernel.kallsyms]  [k] irq_to_desc                           
     0.00%  netperf  [kernel.kallsyms]  [k] apic_timer_interrupt                  
     0.00%  netperf  [kernel.kallsyms]  [k] cpuacct_charge                        
     0.00%  netperf  [kernel.kallsyms]  [k] radix_tree_lookup                     
     0.00%  netperf  [kernel.kallsyms]  [k] put_cpu_partial                       
     0.00%  netperf  [kernel.kallsyms]  [k] __wake_up_bit                         
     0.00%  netperf  [kernel.kallsyms]  [k] ktime_get_update_offsets              
     0.00%  netperf  [kernel.kallsyms]  [k] lapic_next_deadline                   
     0.00%  netperf  [kernel.kallsyms]  [k] run_timer_softirq                     
     0.00%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irq                    
     0.00%  netperf  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave                
     0.00%  netperf  [kernel.kallsyms]  [k] handle_irq_event                      
     0.00%  netperf  [kernel.kallsyms]  [k] _mix_pool_bytes                       
     0.00%  netperf  [kernel.kallsyms]  [k] net_rps_action_and_irq_enable.clone.82
     0.00%  netperf  [kernel.kallsyms]  [k] internal_add_timer                    
     0.00%  netperf  [kernel.kallsyms]  [k] credit_entropy_bits                   
     0.00%  netperf  [kernel.kallsyms]  [k] restore_args                          
     0.00%  netperf  [kernel.kallsyms]  [k] exit_idle                             
     0.00%  netperf  [kernel.kallsyms]  [k] get_page_from_freelist                
     0.00%  netperf  [kernel.kallsyms]  [k] raise_softirq                         
     0.00%  netperf  [kernel.kallsyms]  [k] account_system_time                   
     0.00%  netperf  [kernel.kallsyms]  [k] __acct_update_integrals               
     0.00%  netperf  [kernel.kallsyms]  [k] update_rq_clock                       
     0.00%  netperf  [kernel.kallsyms]  [k] load_balance                          
     0.00%  netperf  [kernel.kallsyms]  [k] ir_ack_apic_edge                      
     0.00%  netperf  [kernel.kallsyms]  [k] sched_avg_update                      
     0.00%  netperf  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load            
     0.00%  netperf  [kernel.kallsyms]  [k] update_cpu_load_active                
     0.00%  netperf  [kernel.kallsyms]  [k] cpu_needs_another_gp                  
     0.00%  netperf  [kernel.kallsyms]  [k] queue_work_on                         
     0.00%  netperf  [kernel.kallsyms]  [k] rb_erase                              
     0.00%  netperf  [kernel.kallsyms]  [k] find_next_bit                         
     0.00%  netperf  [kernel.kallsyms]  [k] rb_next                               
     0.00%  netperf  [kernel.kallsyms]  [k] enqueue_entity                        
     0.00%  netperf  [kernel.kallsyms]  [k] update_blocked_averages               
     0.00%  netperf  [kernel.kallsyms]  [k] tick_program_event                    
     0.00%  netperf  [kernel.kallsyms]  [k] napi_gro_flush                        
     0.00%  netperf  [kernel.kallsyms]  [k] irq_exit                              
     0.00%  netperf  [kernel.kallsyms]  [k] __schedule                            
     0.00%  netperf  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore           
     0.00%  netperf  [kernel.kallsyms]  [k] perf_adjust_freq_unthr_context        
     0.00%  netperf  [kernel.kallsyms]  [k] touch_atime                           
     0.00%  netperf  [kernel.kallsyms]  [k] intel_pmu_enable_all                  
     0.00%  netperf  [kernel.kallsyms]  [k] perf_pmu_rotate_start.clone.45        


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--------------030007040200040004090608--
