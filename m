Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3HTGBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:01:33 -0400
Received: from mout.gmx.net ([212.227.15.15]:52150 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab3HTGBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:01:32 -0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Date: Tue, 20 Aug 2013 08:01:28 +0200
From: "Tibor Billes" <tbilles@gmx.com>
Message-ID: <20130820060128.168660@gmx.com>
MIME-Version: 1.0
Subject: Unusually high system CPU usage with recent kernels
To: linux-kernel@vger.kernel.org
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
X-GMX-UID: b2NhcoYgeSEqJL5QQHchQBV+IGRvb8Ax
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was using the 3.9.7 stable release and tried to upgrade to the 3.10.x series.
The 3.10.x series was showing unusually high (>75%) system CPU usage in some
situations, making things really slow. The latest stable I tried is 3.10.7.
I also tried 3.11-rc5, they both show this behaviour. This behaviour doesn't
show up when the system is idling, only when doing some CPU intensive work,
like compiling with multiple threads. Compiling with only one thread seems not
to trigger this behaviour.

To be more precise I did a `perf record -a` while compiling a large C++ program
with scons using 4 threads, the result is appended at the end of this email.

I also tried bisecting it and got the following:
There are only 'skip'ped commits left to test.
The first bad commit could be any of:
b8462084a2a88a6a0489f9bb7d8b1bb95bc455ab
bd9f0686fc8c9a01c6850b1c611d1c9ad80b86d6
8b425aa8f1acfe48aed919c7aadff2ed290fe969
b92db6cb7efcbd41e469e1d757c47da4865f7622
0446be489795d8bb994125a916ef03211f539e54
c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
910ee45db2f4837c8440e770474758493ab94bf7
We cannot bisect more!

I skipped these commits because they didn't boot. (I didn't spend any time to
figure out why.) They are all RCU-related changes. The perf I mentioned above
was done using commit 910ee45db2f4837c8440e770474758493ab94bf7,
which is the first bad commit I could boot into.

Does anyone have any idea why is this happening?

I'd be happy to provide more information if needed.

Tibor

Here's the perf report:
Note: I truncated the output, so it doesn't show lines with less than 0.01%
overhead.
# ========
# captured on: Sun Aug 11 23:08:27 2013
# hostname : altair
# os release : 3.9.0-rc2+
# perf version : 3.9.3.g4bb086
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM) i5-3210M CPU @ 2.50GHz
# cpuid : GenuineIntel,6,58,9
# total memory : 7981164 kB
# cmdline : /home/tbilles/linux/stable/tools/perf/perf record -a 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, tracepoint = 2, breakpoint = 5
# ========
#
# Samples: 1M of event 'cycles'
# Event count (approx.): 1179107753326
#
# Overhead          Command                    Shared Object                                                  Symbol
# ........  ...............  ...............................  ......................................................
#
     2.49%          cc1plus  [kernel.kallsyms]                [k] __switch_to                                       
     2.06%          cc1plus  [kernel.kallsyms]                [k] __schedule                                        
     1.58%          cc1plus  [kernel.kallsyms]                [k] native_sched_clock                                
     1.36%          cc1plus  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     1.32%      ksoftirqd/1  [kernel.kallsyms]                [k] __switch_to                                       
     1.28%      ksoftirqd/3  [kernel.kallsyms]                [k] __switch_to                                       
     1.24%           python  python2.7                        [.] 0x0000000000023f62                                
     1.20%          cc1plus  [kernel.kallsyms]                [k] update_curr                                       
     1.18%      ksoftirqd/3  [kernel.kallsyms]                [k] __schedule                                        
     1.18%      ksoftirqd/0  [kernel.kallsyms]                [k] __switch_to                                       
     1.13%      ksoftirqd/1  [kernel.kallsyms]                [k] __schedule                                        
     1.10%      ksoftirqd/2  [kernel.kallsyms]                [k] __switch_to                                       
     1.08%          cc1plus  [kernel.kallsyms]                [k] enqueue_entity                                    
     1.05%      ksoftirqd/0  [kernel.kallsyms]                [k] __schedule                                        
     1.03%      ksoftirqd/2  [kernel.kallsyms]                [k] __schedule                                        
     0.98%          cc1plus  [kernel.kallsyms]                [k] local_clock                                       
     0.95%          cc1plus  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.92%          cc1plus  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.90%           python  [kernel.kallsyms]                [k] __switch_to                                       
     0.84%           python  [kernel.kallsyms]                [k] __schedule                                        
     0.78%          cc1plus  [kernel.kallsyms]                [k] try_to_wake_up                                    
     0.75%          cc1plus  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.70%      ksoftirqd/0  [kernel.kallsyms]                [k] native_sched_clock                                
     0.70%      ksoftirqd/3  [kernel.kallsyms]                [k] native_sched_clock                                
     0.69%      ksoftirqd/2  [kernel.kallsyms]                [k] native_sched_clock                                
     0.67%      ksoftirqd/1  [kernel.kallsyms]                [k] native_sched_clock                                
     0.65%          cc1plus  [kernel.kallsyms]                [k] gs_change                                         
     0.63%      ksoftirqd/2  [kernel.kallsyms]                [k] gs_change                                         
     0.61%           python  [kernel.kallsyms]                [k] native_sched_clock                                
     0.59%          cc1plus  [kernel.kallsyms]                [k] rcu_eqs_enter_common.isra.44                      
     0.58%          cc1plus  [kernel.kallsyms]                [k] rcu_eqs_exit_common.isra.43                       
     0.58%          cc1plus  [kernel.kallsyms]                [k] enqueue_task_fair                                 
     0.57%          cc1plus  [kernel.kallsyms]                [k] account_system_time                               
     0.57%          cc1plus  [kernel.kallsyms]                [k] __enqueue_entity                                  
     0.55%      ksoftirqd/2  [kernel.kallsyms]                [k] rcu_process_callbacks                             
     0.55%      ksoftirqd/0  [kernel.kallsyms]                [k] rcu_process_callbacks                             
     0.54%      ksoftirqd/3  [kernel.kallsyms]                [k] rcu_process_callbacks                             
     0.53%          cc1plus  [kernel.kallsyms]                [k] user_enter                                        
     0.53%      ksoftirqd/1  [kernel.kallsyms]                [k] rcu_process_callbacks                             
     0.53%          cc1plus  [kernel.kallsyms]                [k] check_preempt_wakeup                              
     0.53%           python  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.50%      ksoftirqd/0  [kernel.kallsyms]                [k] gs_change                                         
     0.50%      ksoftirqd/3  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.49%      ksoftirqd/1  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.48%      ksoftirqd/0  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.48%      ksoftirqd/2  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.46%           python  [kernel.kallsyms]                [k] update_curr                                       
     0.46%          cc1plus  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.45%      ksoftirqd/0  [kernel.kallsyms]                [k] smpboot_thread_fn                                 
     0.45%      ksoftirqd/2  [kernel.kallsyms]                [k] smpboot_thread_fn                                 
     0.45%               sh  [kernel.kallsyms]                [k] __switch_to                                       
     0.44%      ksoftirqd/3  [kernel.kallsyms]                [k] smpboot_thread_fn                                 
     0.44%      ksoftirqd/1  [kernel.kallsyms]                [k] smpboot_thread_fn                                 
     0.44%          cc1plus  [kernel.kallsyms]                [k] user_exit                                         
     0.43%          cc1plus  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.43%      ksoftirqd/3  [kernel.kallsyms]                [k] local_clock                                       
     0.43%      ksoftirqd/0  [kernel.kallsyms]                [k] local_clock                                       
     0.42%      ksoftirqd/2  [kernel.kallsyms]                [k] local_clock                                       
     0.42%          cc1plus  [kernel.kallsyms]                [k] resched_task                                      
     0.42%      ksoftirqd/1  [kernel.kallsyms]                [k] local_clock                                       
     0.41%          cc1plus  [kernel.kallsyms]                [k] raise_softirq                                     
     0.40%          cc1plus  [kernel.kallsyms]                [k] finish_task_switch                                
     0.38%               sh  [kernel.kallsyms]                [k] __schedule                                        
     0.37%      ksoftirqd/1  [kernel.kallsyms]                [k] gs_change                                         
     0.37%           python  [kernel.kallsyms]                [k] local_clock                                       
     0.37%      ksoftirqd/3  [kernel.kallsyms]                [k] gs_change                                         
     0.37%      ksoftirqd/2  [kernel.kallsyms]                [k] account_system_time                               
     0.36%           python  [kernel.kallsyms]                [k] enqueue_entity                                    
     0.36%      ksoftirqd/1  [kernel.kallsyms]                [k] check_for_new_grace_period.isra.37                
     0.36%      ksoftirqd/0  [kernel.kallsyms]                [k] check_for_new_grace_period.isra.37                
     0.36%      ksoftirqd/3  [kernel.kallsyms]                [k] check_for_new_grace_period.isra.37                
     0.35%      ksoftirqd/2  [kernel.kallsyms]                [k] __do_softirq                                      
     0.35%      ksoftirqd/2  [kernel.kallsyms]                [k] check_for_new_grace_period.isra.37                
     0.35%      ksoftirqd/0  [kernel.kallsyms]                [k] account_system_time                               
     0.35%      ksoftirqd/3  [kernel.kallsyms]                [k] dequeue_entity                                    
     0.35%      ksoftirqd/0  [kernel.kallsyms]                [k] __do_softirq                                      
     0.35%      ksoftirqd/3  [kernel.kallsyms]                [k] __do_softirq                                      
     0.35%      ksoftirqd/1  [kernel.kallsyms]                [k] account_system_time                               
     0.35%      ksoftirqd/1  [kernel.kallsyms]                [k] __do_softirq                                      
     0.35%           python  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.34%      ksoftirqd/0  [kernel.kallsyms]                [k] rcu_process_gp_end                                
     0.34%      ksoftirqd/3  [kernel.kallsyms]                [k] account_system_time                               
     0.34%      ksoftirqd/1  [kernel.kallsyms]                [k] dequeue_entity                                    
     0.34%           python  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.34%      ksoftirqd/2  [kernel.kallsyms]                [k] rcu_process_gp_end                                
     0.34%      ksoftirqd/1  [kernel.kallsyms]                [k] rcu_process_gp_end                                
     0.33%          cc1plus  [kernel.kallsyms]                [k] select_task_rq_fair                               
     0.33%      ksoftirqd/2  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.33%      ksoftirqd/3  [kernel.kallsyms]                [k] rcu_process_gp_end                                
     0.33%      ksoftirqd/0  [kernel.kallsyms]                [k] dequeue_entity                                    
     0.33%          cc1plus  [kernel.kallsyms]                [k] int_careful                                       
     0.32%      ksoftirqd/2  [kernel.kallsyms]                [k] dequeue_entity                                    
     0.32%      ksoftirqd/0  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.32%          cc1plus  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.31%      ksoftirqd/1  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.31%      ksoftirqd/3  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.30%          cc1plus  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.29%          cc1plus  [kernel.kallsyms]                [k] set_next_entity                                   
     0.29%          cc1plus  [kernel.kallsyms]                [k] vtime_account_user                                
     0.29%           python  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.29%               sh  [kernel.kallsyms]                [k] native_sched_clock                                
     0.28%      ksoftirqd/0  [kernel.kallsyms]                [k] dequeue_task_fair                                 
     0.28%           python  [kernel.kallsyms]                [k] try_to_wake_up                                    
     0.28%      ksoftirqd/0  [kernel.kallsyms]                [k] set_next_entity                                   
     0.28%          cc1plus  [kernel.kallsyms]                [k] clear_buddies                                     
     0.27%      ksoftirqd/2  [kernel.kallsyms]                [k] dequeue_task_fair                                 
     0.27%          cc1plus  [kernel.kallsyms]                [k] _raw_spin_lock_irqsave                            
     0.27%          cc1plus  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.27%      ksoftirqd/1  [kernel.kallsyms]                [k] set_next_entity                                   
     0.27%      ksoftirqd/3  [kernel.kallsyms]                [k] set_next_entity                                   
     0.26%      ksoftirqd/2  [kernel.kallsyms]                [k] set_next_entity                                   
     0.26%          cc1plus  [kernel.kallsyms]                [k] place_entity                                      
     0.26%      ksoftirqd/0  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.26%  arm-none-eabi-g  [kernel.kallsyms]                [k] __switch_to                                       
     0.26%      ksoftirqd/1  [kernel.kallsyms]                [k] dequeue_task_fair                                 
     0.26%          cc1plus  [kernel.kallsyms]                [k] rb_insert_color                                   
     0.26%      ksoftirqd/3  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.25%               sh  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.25%      ksoftirqd/1  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.25%      ksoftirqd/2  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.25%      ksoftirqd/3  [kernel.kallsyms]                [k] dequeue_task_fair                                 
     0.24%          cc1plus  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.23%      ksoftirqd/3  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.23%           python  [kernel.kallsyms]                [k] rcu_eqs_enter_common.isra.44                      
     0.23%          cc1plus  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.23%               sh  [kernel.kallsyms]                [k] update_curr                                       
     0.23%      ksoftirqd/1  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.22%          cc1plus  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.22%      ksoftirqd/2  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.22%          cc1plus  [kernel.kallsyms]                [k] _raw_spin_unlock_irqrestore                       
     0.22%           python  [kernel.kallsyms]                [k] account_system_time                               
     0.22%           python  [kernel.kallsyms]                [k] __enqueue_entity                                  
     0.22%           python  [kernel.kallsyms]                [k] rcu_eqs_exit_common.isra.43                       
     0.22%           python  [kernel.kallsyms]                [k] enqueue_task_fair                                 
     0.22%      ksoftirqd/1  [kernel.kallsyms]                [k] update_curr                                       
     0.22%          cc1plus  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.22%      ksoftirqd/3  [kernel.kallsyms]                [k] update_curr                                       
     0.21%      ksoftirqd/0  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.21%      ksoftirqd/3  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.21%          cc1plus  [kernel.kallsyms]                [k] enqueue_task                                      
     0.20%  arm-none-eabi-g  [kernel.kallsyms]                [k] __schedule                                        
     0.20%      ksoftirqd/0  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.20%      ksoftirqd/2  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.20%           python  [kernel.kallsyms]                [k] user_enter                                        
     0.20%      ksoftirqd/2  [kernel.kallsyms]                [k] update_curr                                       
     0.19%          cc1plus  [kernel.kallsyms]                [k] account_user_time                                 
     0.19%      ksoftirqd/3  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.19%      ksoftirqd/1  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.19%      ksoftirqd/1  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.19%      ksoftirqd/0  [kernel.kallsyms]                [k] update_curr                                       
     0.19%          cc1plus  [kernel.kallsyms]                [k] check_preempt_curr                                
     0.19%      ksoftirqd/0  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.18%      ksoftirqd/2  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.18%      ksoftirqd/1  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.18%           python  [kernel.kallsyms]                [k] finish_task_switch                                
     0.18%           python  [kernel.kallsyms]                [k] check_preempt_wakeup                              
     0.18%               sh  [kernel.kallsyms]                [k] local_clock                                       
     0.18%      ksoftirqd/2  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.18%      ksoftirqd/0  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.18%           python  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.18%             perf  [kernel.kallsyms]                [k] aes_encrypt                                       
     0.17%           python  [kernel.kallsyms]                [k] user_exit                                         
     0.17%               sh  [kernel.kallsyms]                [k] enqueue_entity                                    
     0.17%           python  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.17%               sh  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.16%               sh  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.16%          cc1plus  [kernel.kallsyms]                [k] rcu_try_advance_all_cbs                           
     0.16%      ksoftirqd/3  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.16%          cc1plus  [kernel.kallsyms]                [k] ttwu_do_wakeup                                    
     0.15%          cc1plus  [kernel.kallsyms]                [k] set_next_buddy                                    
     0.15%      ksoftirqd/1  [kernel.kallsyms]                [k] vtime_account_system                              
     0.15%           python  [kernel.kallsyms]                [k] raise_softirq                                     
     0.15%          cc1plus  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.15%          cc1plus  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.15%  arm-none-eabi-g  [kernel.kallsyms]                [k] native_sched_clock                                
     0.15%      ksoftirqd/2  [kernel.kallsyms]                [k] vtime_account_system                              
     0.15%          cc1plus  [kernel.kallsyms]                [k] wakeup_preempt_entity.isra.39                     
     0.15%          cc1plus  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.15%      ksoftirqd/3  [kernel.kallsyms]                [k] vtime_account_system                              
     0.15%          cc1plus  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.14%      ksoftirqd/0  [kernel.kallsyms]                [k] vtime_account_system                              
     0.14%           python  [kernel.kallsyms]                [k] resched_task                                      
     0.14%          cc1plus  [kernel.kallsyms]                [k] rcu_eqs_exit                                      
     0.14%               sh  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.13%          cc1plus  [kernel.kallsyms]                [k] vtime_user_enter                                  
     0.13%      ksoftirqd/2  [kernel.kallsyms]                [k] rb_erase                                          
     0.13%          cc1plus  [kernel.kallsyms]                [k] vtime_account_system                              
     0.13%      ksoftirqd/2  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.13%      ksoftirqd/1  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.13%      ksoftirqd/0  [kernel.kallsyms]                [k] rb_erase                                          
     0.13%          cc1plus  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.13%      ksoftirqd/0  [kernel.kallsyms]                [k] dequeue_task                                      
     0.13%               sh  [kernel.kallsyms]                [k] try_to_wake_up                                    
     0.13%  arm-none-eabi-g  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.13%      ksoftirqd/1  [kernel.kallsyms]                [k] rb_erase                                          
     0.13%      ksoftirqd/0  [kernel.kallsyms]                [k] clear_buddies                                     
     0.13%  arm-none-eabi-g  [kernel.kallsyms]                [k] update_curr                                       
     0.12%      ksoftirqd/2  [kernel.kallsyms]                [k] dequeue_task                                      
     0.12%          cc1plus  [kernel.kallsyms]                [k] schedule_user                                     
     0.12%      ksoftirqd/0  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.12%      ksoftirqd/3  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.12%      ksoftirqd/1  [kernel.kallsyms]                [k] dequeue_task                                      
     0.12%          cc1plus  [kernel.kallsyms]                [k] ttwu_stat                                         
     0.12%      ksoftirqd/3  [kernel.kallsyms]                [k] dequeue_task                                      
     0.12%           python  [kernel.kallsyms]                [k] select_task_rq_fair                               
     0.12%          cc1plus  [kernel.kallsyms]                [k] ttwu_do_activate.constprop.87                     
     0.12%      ksoftirqd/3  [kernel.kallsyms]                [k] rb_erase                                          
     0.12%          cc1plus  [kernel.kallsyms]                [k] __raise_softirq_irqoff                            
     0.12%          cc1plus  [kernel.kallsyms]                [k] rb_erase                                          
     0.12%           python  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.12%          cc1plus  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.11%          cc1plus  cc1plus                          [.] 0x00000000009bd77f                                
     0.11%          cc1plus  [kernel.kallsyms]                [k] rcu_eqs_enter                                     
     0.11%               as  [kernel.kallsyms]                [k] __switch_to                                       
     0.11%           python  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.11%               sh  [kernel.kallsyms]                [k] __enqueue_entity                                  
     0.11%      ksoftirqd/2  [kernel.kallsyms]                [k] clear_buddies                                     
     0.11%      ksoftirqd/2  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.11%      ksoftirqd/3  [kernel.kallsyms]                [k] clear_buddies                                     
     0.11%           python  [kernel.kallsyms]                [k] set_next_entity                                   
     0.11%      ksoftirqd/0  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.11%               sh  [kernel.kallsyms]                [k] enqueue_task_fair                                 
     0.11%           python  libc-2.15.so                     [.] 0x0000000000147fc5                                
     0.11%      ksoftirqd/1  [kernel.kallsyms]                [k] clear_buddies                                     
     0.11%      ksoftirqd/1  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.11%               sh  [kernel.kallsyms]                [k] rcu_eqs_exit_common.isra.43                       
     0.10%      ksoftirqd/3  [kernel.kallsyms]                [k] finish_task_switch                                
     0.10%               sh  [kernel.kallsyms]                [k] rcu_eqs_enter_common.isra.44                      
     0.10%           python  [kernel.kallsyms]                [k] clear_buddies                                     
     0.10%           python  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.10%      ksoftirqd/3  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.10%      ksoftirqd/0  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.10%           python  [kernel.kallsyms]                [k] _raw_spin_lock_irqsave                            
     0.10%               sh  [kernel.kallsyms]                [k] account_system_time                               
     0.10%      ksoftirqd/3  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.10%      ksoftirqd/1  [kernel.kallsyms]                [k] finish_task_switch                                
     0.10%  arm-none-eabi-g  [kernel.kallsyms]                [k] enqueue_entity                                    
     0.10%               sh  [kernel.kallsyms]                [k] user_enter                                        
     0.10%           python  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.10%           python  [kernel.kallsyms]                [k] vtime_account_user                                
     0.10%           python  [kernel.kallsyms]                [k] int_careful                                       
     0.10%      ksoftirqd/2  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.10%      ksoftirqd/0  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.10%           python  [kernel.kallsyms]                [k] place_entity                                      
     0.10%  arm-none-eabi-g  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.09%      ksoftirqd/1  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.09%              cc1  cc1                              [.] 0x00000000000c4674                                
     0.09%      ksoftirqd/2  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.09%               as  [kernel.kallsyms]                [k] __schedule                                        
     0.09%      ksoftirqd/1  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.09%              cc1  [kernel.kallsyms]                [k] __switch_to                                       
     0.09%               sh  [kernel.kallsyms]                [k] check_preempt_wakeup                              
     0.09%      ksoftirqd/2  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.09%      ksoftirqd/3  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.09%  arm-none-eabi-g  [kernel.kallsyms]                [k] local_clock                                       
     0.09%      ksoftirqd/0  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.09%      ksoftirqd/0  [kernel.kallsyms]                [k] cpu_needs_another_gp                              
     0.09%      ksoftirqd/0  [kernel.kallsyms]                [k] finish_task_switch                                
     0.09%      ksoftirqd/2  [kernel.kallsyms]                [k] cpu_needs_another_gp                              
     0.09%      ksoftirqd/3  [kernel.kallsyms]                [k] cpu_needs_another_gp                              
     0.09%      ksoftirqd/2  [kernel.kallsyms]                [k] finish_task_switch                                
     0.09%      ksoftirqd/1  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.09%      ksoftirqd/2  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.09%           python  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.09%      ksoftirqd/3  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.09%          cc1plus  [kernel.kallsyms]                [k] rb_next                                           
     0.09%           python  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.09%      ksoftirqd/0  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.09%          cc1plus  [kernel.kallsyms]                [k] wake_up_process                                   
     0.09%           python  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.09%               sh  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.09%      ksoftirqd/0  [kernel.kallsyms]                [k] rb_next                                           
     0.09%  arm-none-eabi-g  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.08%      ksoftirqd/1  [kernel.kallsyms]                [k] cpu_needs_another_gp                              
     0.08%               sh  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.08%           python  [kernel.kallsyms]                [k] _raw_spin_unlock_irqrestore                       
     0.08%           python  [kernel.kallsyms]                [k] enqueue_task                                      
     0.08%      ksoftirqd/2  [kernel.kallsyms]                [k] rb_next                                           
     0.08%               sh  [kernel.kallsyms]                [k] finish_task_switch                                
     0.08%               sh  [kernel.kallsyms]                [k] user_exit                                         
     0.08%      ksoftirqd/1  [kernel.kallsyms]                [k] rb_next                                           
     0.08%              cc1  [kernel.kallsyms]                [k] __schedule                                        
     0.08%      ksoftirqd/0  [kernel.kallsyms]                [k] __local_bh_enable                                 
     0.08%          cc1plus  [kernel.kallsyms]                [k] int_with_check                                    
     0.08%      ksoftirqd/0  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.08%           python  [kernel.kallsyms]                [k] rb_insert_color                                   
     0.08%      ksoftirqd/1  [kernel.kallsyms]                [k] __local_bh_enable                                 
     0.08%      ksoftirqd/3  [kernel.kallsyms]                [k] __local_bh_enable                                 
     0.07%          cc1plus  [kernel.kallsyms]                [k] invoke_rcu_core                                   
     0.07%      ksoftirqd/2  [kernel.kallsyms]                [k] __local_bh_enable                                 
     0.07%           python  [kernel.kallsyms]                [k] account_user_time                                 
     0.07%               sh  [kernel.kallsyms]                [k] raise_softirq                                     
     0.07%  arm-none-eabi-g  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.07%          cc1plus  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.07%               as  [kernel.kallsyms]                [k] native_sched_clock                                
     0.07%      ksoftirqd/2  [kernel.kallsyms]                [k] kthread_should_stop                               
     0.07%  arm-none-eabi-g  [kernel.kallsyms]                [k] try_to_wake_up                                    
     0.07%          cc1plus  [kernel.kallsyms]                [k] calc_delta_mine                                   
     0.07%      ksoftirqd/1  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.07%      ksoftirqd/3  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.07%      ksoftirqd/3  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.07%      ksoftirqd/2  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.07%      ksoftirqd/3  [kernel.kallsyms]                [k] rb_next                                           
     0.07%          cc1plus  [kernel.kallsyms]                [k] wakeup_softirqd                                   
     0.07%           python  [kernel.kallsyms]                [k] check_preempt_curr                                
     0.07%      ksoftirqd/0  [kernel.kallsyms]                [k] kthread_should_stop                               
     0.07%      ksoftirqd/3  [kernel.kallsyms]                [k] kthread_should_stop                               
     0.07%               sh  [kernel.kallsyms]                [k] resched_task                                      
     0.07%               as  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.06%      ksoftirqd/0  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.06%      ksoftirqd/1  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.06%      ksoftirqd/0  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.06%      ksoftirqd/3  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.06%          cc1plus  [kernel.kallsyms]                [k] schedule                                          
     0.06%      ksoftirqd/1  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.06%      ksoftirqd/3  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.06%           python  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.06%               sh  [kernel.kallsyms]                [k] int_careful                                       
     0.06%      ksoftirqd/1  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.06%           python  [kernel.kallsyms]                [k] ttwu_do_wakeup                                    
     0.06%              cc1  [kernel.kallsyms]                [k] native_sched_clock                                
     0.06%      ksoftirqd/2  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.06%           python  [kernel.kallsyms]                [k] rcu_try_advance_all_cbs                           
     0.06%           python  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.06%           python  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.06%      ksoftirqd/2  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.06%  arm-none-eabi-g  [kernel.kallsyms]                [k] __enqueue_entity                                  
     0.06%           python  [kernel.kallsyms]                [k] wakeup_preempt_entity.isra.39                     
     0.06%      ksoftirqd/1  [kernel.kallsyms]                [k] kthread_should_stop                               
     0.06%  arm-none-eabi-g  [kernel.kallsyms]                [k] enqueue_task_fair                                 
     0.06%               sh  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.06%           python  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.06%           python  [kernel.kallsyms]                [k] vtime_user_enter                                  
     0.06%               as  [kernel.kallsyms]                [k] update_curr                                       
     0.06%               sh  [kernel.kallsyms]                [k] select_task_rq_fair                               
     0.06%  arm-none-eabi-g  [kernel.kallsyms]                [k] rcu_eqs_exit_common.isra.43                       
     0.06%          cc1plus  [kernel.kallsyms]                [k] task_waking_fair                                  
     0.05%               sh  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.05%      ksoftirqd/0  [kernel.kallsyms]                [k] kthread_should_park                               
     0.05%  arm-none-eabi-g  [kernel.kallsyms]                [k] user_enter                                        
     0.05%      ksoftirqd/0  [kernel.kallsyms]                [k] vtime_account_irq_exit                            
     0.05%              cc1  [kernel.kallsyms]                [k] _raw_spin_lock                                    
     0.05%           python  [kernel.kallsyms]                [k] rcu_eqs_exit                                      
     0.05%           python  [kernel.kallsyms]                [k] set_next_buddy                                    
     0.05%      ksoftirqd/3  [kernel.kallsyms]                [k] vtime_account_irq_exit                            
     0.05%      ksoftirqd/3  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.05%               sh  [kernel.kallsyms]                [k] set_next_entity                                   
     0.05%           python  [kernel.kallsyms]                [k] vtime_account_system                              
     0.05%  arm-none-eabi-g  [kernel.kallsyms]                [k] account_system_time                               
     0.05%      ksoftirqd/2  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.05%      ksoftirqd/1  [kernel.kallsyms]                [k] vtime_account_irq_exit                            
     0.05%  arm-none-eabi-g  [kernel.kallsyms]                [k] rcu_eqs_enter_common.isra.44                      
     0.05%      ksoftirqd/2  [kernel.kallsyms]                [k] vtime_account_irq_exit                            
     0.05%      ksoftirqd/1  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.05%               sh  [kernel.kallsyms]                [k] _raw_spin_lock_irqsave                            
     0.05%      ksoftirqd/0  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.05%      ksoftirqd/1  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.05%      ksoftirqd/3  [kernel.kallsyms]                [k] kthread_should_park                               
     0.05%           python  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.05%      ksoftirqd/3  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.05%      ksoftirqd/0  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.05%               as  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.05%               as  as                               [.] 0x000000000000df9c                                
     0.05%               as  [kernel.kallsyms]                [k] local_clock                                       
     0.05%           python  [kernel.kallsyms]                [k] ttwu_stat                                         
     0.05%      ksoftirqd/2  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.05%           python  [kernel.kallsyms]                [k] ttwu_do_activate.constprop.87                     
     0.05%               sh  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.05%      ksoftirqd/2  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.05%      ksoftirqd/1  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.05%               as  [kernel.kallsyms]                [k] enqueue_entity                                    
     0.05%      ksoftirqd/0  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.05%  arm-none-eabi-g  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.05%  arm-none-eabi-g  [kernel.kallsyms]                [k] check_preempt_wakeup                              
     0.05%              cc1  [kernel.kallsyms]                [k] update_curr                                       
     0.04%      ksoftirqd/3  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.04%           python  [kernel.kallsyms]                [k] rb_erase                                          
     0.04%               as  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.04%      ksoftirqd/3  [kernel.kallsyms]                [k] schedule                                          
     0.04%               sh  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.04%      ksoftirqd/0  [kernel.kallsyms]                [k] schedule                                          
     0.04%  arm-none-eabi-g  [kernel.kallsyms]                [k] gs_change                                         
     0.04%               sh  [kernel.kallsyms]                [k] place_entity                                      
     0.04%           python  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.04%           python  [kernel.kallsyms]                [k] schedule_user                                     
     0.04%           python  [kernel.kallsyms]                [k] __raise_softirq_irqoff                            
     0.04%         postgres  postgres                         [.] 0x00000000001fab33                                
     0.04%               sh  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.04%               sh  [kernel.kallsyms]                [k] vtime_account_user                                
     0.04%      ksoftirqd/2  [kernel.kallsyms]                [k] kthread_should_park                               
     0.04%          cc1plus  [kernel.kallsyms]                [k] native_load_gs_index                              
     0.04%               sh  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.04%               sh  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.04%      ksoftirqd/2  [kernel.kallsyms]                [k] _cond_resched                                     
     0.04%      ksoftirqd/2  [kernel.kallsyms]                [k] schedule                                          
     0.04%  arm-none-eabi-g  [kernel.kallsyms]                [k] finish_task_switch                                
     0.04%      ksoftirqd/3  [kernel.kallsyms]                [k] _cond_resched                                     
     0.04%  arm-none-eabi-g  [kernel.kallsyms]                [k] user_exit                                         
     0.04%      ksoftirqd/0  [kernel.kallsyms]                [k] run_ksoftirqd                                     
     0.04%  arm-none-eabi-g  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.04%           python  [kernel.kallsyms]                [k] rcu_eqs_enter                                     
     0.04%               sh  [kernel.kallsyms]                [k] _raw_spin_unlock_irqrestore                       
     0.04%           python  [kernel.kallsyms]                [k] retint_careful                                    
     0.04%      ksoftirqd/1  [kernel.kallsyms]                [k] kthread_should_park                               
     0.04%              cc1  [kernel.kallsyms]                [k] enqueue_entity                                    
     0.04%      ksoftirqd/3  [kernel.kallsyms]                [k] run_ksoftirqd                                     
     0.04%      ksoftirqd/0  [kernel.kallsyms]                [k] _cond_resched                                     
     0.04%      ksoftirqd/1  [kernel.kallsyms]                [k] _cond_resched                                     
     0.04%      ksoftirqd/2  [kernel.kallsyms]                [k] vtime_account_irq_enter                           
     0.04%      ksoftirqd/2  [kernel.kallsyms]                [k] run_ksoftirqd                                     
     0.04%  arm-none-eabi-g  [kernel.kallsyms]                [k] raise_softirq                                     
     0.04%      ksoftirqd/1  [kernel.kallsyms]                [k] schedule                                          
     0.04%      ksoftirqd/1  [kernel.kallsyms]                [k] vtime_account_irq_enter                           
     0.04%               sh  [kernel.kallsyms]                [k] rb_insert_color                                   
     0.04%      ksoftirqd/3  [kernel.kallsyms]                [k] vtime_account_irq_enter                           
     0.04%  arm-none-eabi-g  [kernel.kallsyms]                [k] resched_task                                      
     0.04%               sh  [kernel.kallsyms]                [k] clear_buddies                                     
     0.04%          cc1plus  [kernel.kallsyms]                [k] activate_task                                     
     0.04%               sh  [kernel.kallsyms]                [k] enqueue_task                                      
     0.04%      ksoftirqd/0  [kernel.kallsyms]                [k] vtime_account_irq_enter                           
     0.04%          cc1plus  [kernel.kallsyms]                [k] rcu_user_enter                                    
     0.04%      ksoftirqd/3  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.04%              cc1  [kernel.kallsyms]                [k] local_clock                                       
     0.04%      ksoftirqd/0  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.04%      ksoftirqd/1  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.04%               as  [kernel.kallsyms]                [k] try_to_wake_up                                    
     0.04%      ksoftirqd/1  [kernel.kallsyms]                [k] run_ksoftirqd                                     
     0.03%               as  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.03%          cc1plus  [kernel.kallsyms]                [k] rcu_user_exit                                     
     0.03%    mate-terminal  libgdk_pixbuf-2.0.so.0.2600.1    [.] 0x0000000000014868                                
     0.03%              cc1  [kernel.kallsyms]                [k] put_prev_task_fair                                
     0.03%               sh  [kernel.kallsyms]                [k] check_preempt_curr                                
     0.03%           python  [kernel.kallsyms]                [k] rb_next                                           
     0.03%              cc1  [kernel.kallsyms]                [k] __acct_update_integrals                           
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] int_careful                                       
     0.03%               sh  [kernel.kallsyms]                [k] account_user_time                                 
     0.03%               sh  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.03%      ksoftirqd/2  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] vtime_account_user                                
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.03%      ksoftirqd/2  [kernel.kallsyms]                [k] ksoftirqd_should_run                              
     0.03%          swapper  [kernel.kallsyms]                [k] intel_idle                                        
     0.03%      ksoftirqd/0  [kernel.kallsyms]                [k] rcu_bh_qs                                         
     0.03%           python  [kernel.kallsyms]                [k] wakeup_softirqd                                   
     0.03%      ksoftirqd/2  [kernel.kallsyms]                [k] rcu_bh_qs                                         
     0.03%              cc1  [kernel.kallsyms]                [k] try_to_wake_up                                    
     0.03%           python  [kernel.kallsyms]                [k] wake_up_process                                   
     0.03%              cc1  [kernel.kallsyms]                [k] sched_clock_cpu                                   
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] select_task_rq_fair                               
     0.03%      ksoftirqd/1  [kernel.kallsyms]                [k] ksoftirqd_should_run                              
     0.03%               as  [kernel.kallsyms]                [k] __enqueue_entity                                  
     0.03%      ksoftirqd/1  [kernel.kallsyms]                [k] rcu_bh_qs                                         
     0.03%               sh  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] set_next_entity                                   
     0.03%          cc1plus  [kernel.kallsyms]                [k] hrtick_update                                     
     0.03%               sh  [kernel.kallsyms]                [k] rcu_try_advance_all_cbs                           
     0.03%      ksoftirqd/3  [kernel.kallsyms]                [k] rcu_bh_qs                                         
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] clear_buddies                                     
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] rb_insert_color                                   
     0.03%               sh  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.03%               sh  [kernel.kallsyms]                [k] vtime_user_enter                                  
     0.03%               as  [kernel.kallsyms]                [k] user_enter                                        
     0.03%              cc1  [kernel.kallsyms]                [k] gs_change                                         
     0.03%               sh  [kernel.kallsyms]                [k] ttwu_do_wakeup                                    
     0.03%      ksoftirqd/0  [kernel.kallsyms]                [k] ksoftirqd_should_run                              
     0.03%               as  [kernel.kallsyms]                [k] account_system_time                               
     0.03%               sh  [kernel.kallsyms]                [k] set_next_buddy                                    
     0.03%           python  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.03%             perf  [kernel.kallsyms]                [k] memcpy                                            
     0.03%               sh  [kernel.kallsyms]                [k] wakeup_preempt_entity.isra.39                     
     0.03%               as  [kernel.kallsyms]                [k] enqueue_task_fair                                 
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] _raw_spin_lock_irqsave                            
     0.03%               sh  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.03%               as  [kernel.kallsyms]                [k] rcu_eqs_enter_common.isra.44                      
     0.03%  arm-none-eabi-g  [kernel.kallsyms]                [k] place_entity                                      
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.02%           python  [kernel.kallsyms]                [k] calc_delta_mine                                   
     0.02%      ksoftirqd/3  [kernel.kallsyms]                [k] ksoftirqd_should_run                              
     0.02%               as  [kernel.kallsyms]                [k] rcu_eqs_exit_common.isra.43                       
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.02%           python  [kernel.kallsyms]                [k] invoke_rcu_core                                   
     0.02%              cc1  [kernel.kallsyms]                [k] __enqueue_entity                                  
     0.02%          cc1plus  libc-2.15.so                     [.] 0x0000000000127d50                                
     0.02%               sh  [kernel.kallsyms]                [k] schedule_user                                     
     0.02%           python  [kernel.kallsyms]                [k] schedule                                          
     0.02%           python  [kernel.kallsyms]                [k] int_with_check                                    
     0.02%               sh  [kernel.kallsyms]                [k] rcu_eqs_exit                                      
     0.02%               sh  [kernel.kallsyms]                [k] vtime_account_system                              
     0.02%              cc1  [kernel.kallsyms]                [k] rcu_eqs_exit_common.isra.43                       
     0.02%              cc1  [kernel.kallsyms]                [k] enqueue_task_fair                                 
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.02%               sh  [kernel.kallsyms]                [k] __raise_softirq_irqoff                            
     0.02%               sh  [kernel.kallsyms]                [k] ttwu_stat                                         
     0.02%               as  [kernel.kallsyms]                [k] check_preempt_wakeup                              
     0.02%              cc1  [kernel.kallsyms]                [k] account_system_time                               
     0.02%              cc1  [kernel.kallsyms]                [k] rcu_eqs_enter_common.isra.44                      
     0.02%               sh  [kernel.kallsyms]                [k] rb_erase                                          
     0.02%          cc1plus  [kernel.kallsyms]                [k] retint_careful                                    
     0.02%               as  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.02%              cc1  libc-2.15.so                     [.] 0x0000000000127cd7                                
     0.02%               as  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.02%           python  [kernel.kallsyms]                [k] task_waking_fair                                  
     0.02%               sh  [kernel.kallsyms]                [k] ttwu_do_activate.constprop.87                     
     0.02%               sh  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] _raw_spin_unlock_irqrestore                       
     0.02%               as  [kernel.kallsyms]                [k] user_exit                                         
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] check_preempt_curr                                
     0.02%      ksoftirqd/2  [kernel.kallsyms]                [k] deactivate_task                                   
     0.02%              cc1  [kernel.kallsyms]                [k] user_enter                                        
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.02%      ksoftirqd/2  [kernel.kallsyms]                [k] msecs_to_jiffies                                  
     0.02%      ksoftirqd/3  [kernel.kallsyms]                [k] msecs_to_jiffies                                  
     0.02%              cc1  [kernel.kallsyms]                [k] get_vtime_delta                                   
     0.02%              cc1  [kernel.kallsyms]                [k] check_preempt_wakeup                              
     0.02%               sh  [kernel.kallsyms]                [k] rcu_eqs_enter                                     
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] enqueue_task                                      
     0.02%               as  [kernel.kallsyms]                [k] select_task_rq_fair                               
     0.02%      ksoftirqd/0  [kernel.kallsyms]                [k] deactivate_task                                   
     0.02%               as  [kernel.kallsyms]                [k] raise_softirq                                     
     0.02%      ksoftirqd/1  [kernel.kallsyms]                [k] deactivate_task                                   
     0.02%               as  [kernel.kallsyms]                [k] finish_task_switch                                
     0.02%      ksoftirqd/1  [kernel.kallsyms]                [k] msecs_to_jiffies                                  
     0.02%               sh  [kernel.kallsyms]                [k] wakeup_softirqd                                   
     0.02%      ksoftirqd/3  [kernel.kallsyms]                [k] hrtick_update                                     
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.02%      ksoftirqd/0  [kernel.kallsyms]                [k] msecs_to_jiffies                                  
     0.02%              cc1  [kernel.kallsyms]                [k] user_exit                                         
     0.02%               as  [kernel.kallsyms]                [k] resched_task                                      
     0.02%      ksoftirqd/2  [kernel.kallsyms]                [k] native_load_gs_index                              
     0.02%               sh  [kernel.kallsyms]                [k] int_with_check                                    
     0.02%      ksoftirqd/3  [kernel.kallsyms]                [k] deactivate_task                                   
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] rcu_try_advance_all_cbs                           
     0.02%           python  [kernel.kallsyms]                [k] activate_task                                     
     0.02%              cc1  [kernel.kallsyms]                [k] context_tracking_task_switch                      
     0.02%              cc1  [kernel.kallsyms]                [k] resched_task                                      
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] account_user_time                                 
     0.02%               sh  [kernel.kallsyms]                [k] wake_up_process                                   
     0.02%               as  [kernel.kallsyms]                [k] int_careful                                       
     0.02%               sh  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.02%              cc1  [kernel.kallsyms]                [k] raise_softirq                                     
     0.02%  arm-none-eabi-g  [kernel.kallsyms]                [k] ttwu_do_wakeup                                    
     0.02%               as  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.01%               sh  [kernel.kallsyms]                [k] rb_next                                           
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] ttwu_stat                                         
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.01%             perf  [kernel.kallsyms]                [k] crypto_xor                                        
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] wakeup_preempt_entity.isra.39                     
     0.01%           python  [kernel.kallsyms]                [k] rcu_user_enter                                    
     0.01%              cc1  [kernel.kallsyms]                [k] finish_task_switch                                
     0.01%               as  [kernel.kallsyms]                [k] set_next_entity                                   
     0.01%               sh  [kernel.kallsyms]                [k] calc_delta_mine                                   
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] set_next_buddy                                    
     0.01%      ksoftirqd/1  [kernel.kallsyms]                [k] hrtick_update                                     
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.01%               as  [kernel.kallsyms]                [k] _raw_spin_lock_irqsave                            
     0.01%               as  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.01%           python  [kernel.kallsyms]                [k] rcu_user_exit                                     
     0.01%              cc1  [kernel.kallsyms]                [k] select_task_rq_fair                               
     0.01%           python  [kernel.kallsyms]                [k] aes_decrypt                                       
     0.01%               as  [kernel.kallsyms]                [k] rb_insert_color                                   
     0.01%               sh  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] rcu_eqs_exit                                      
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] schedule_user                                     
     0.01%               sh  [kernel.kallsyms]                [k] invoke_rcu_core                                   
     0.01%              cc1  [kernel.kallsyms]                [k] vtime_account_user                                
     0.01%      ksoftirqd/2  [kernel.kallsyms]                [k] hrtick_update                                     
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] vtime_user_enter                                  
     0.01%               sh  [kernel.kallsyms]                [k] schedule                                          
     0.01%      ksoftirqd/0  [kernel.kallsyms]                [k] hrtick_update                                     
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] rcu_eqs_enter                                     
     0.01%              cc1  [kernel.kallsyms]                [k] clear_buddies                                     
     0.01%               as  [kernel.kallsyms]                [k] vtime_account_user                                
     0.01%              cc1  [kernel.kallsyms]                [k] pick_next_task_fair                               
     0.01%              cc1  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] ttwu_do_activate.constprop.87                     
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.01%               as  [kernel.kallsyms]                [k] gs_change                                         
     0.01%             Xorg  Xorg                             [.] 0x0000000000046479                                
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] vtime_account_system                              
     0.01%              cc1  [kernel.kallsyms]                [k] jiffies_to_timeval                                
     0.01%               as  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.01%               as  [kernel.kallsyms]                [k] clear_buddies                                     
     0.01%               as  [kernel.kallsyms]                [k] update_stats_wait_end                             
     0.01%               as  [kernel.kallsyms]                [k] aes_encrypt                                       
     0.01%              cc1  [kernel.kallsyms]                [k] int_careful                                       
     0.01%           python  [kernel.kallsyms]                [k] hrtick_update                                     
     0.01%      ksoftirqd/0  [kernel.kallsyms]                [k] native_load_gs_index                              
     0.01%               as  [kernel.kallsyms]                [k] place_entity                                      
     0.01%              cc1  [kernel.kallsyms]                [k] set_next_entity                                   
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] rb_erase                                          
     0.01%              cc1  [kernel.kallsyms]                [k] _raw_spin_lock_irqsave                            
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.01%               as  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.01%               as  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.01%               as  [kernel.kallsyms]                [k] _raw_spin_unlock_irqrestore                       
     0.01%               sh  [kernel.kallsyms]                [k] task_waking_fair                                  
     0.01%      ksoftirqd/1  [kernel.kallsyms]                [k] native_load_gs_index                              
     0.01%              cc1  [kernel.kallsyms]                [k] _raw_spin_lock_irq                                
     0.01%               as  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] __raise_softirq_irqoff                            
     0.01%              cc1  [kernel.kallsyms]                [k] place_entity                                      
     0.01%           python  [kernel.kallsyms]                [k] aes_encrypt                                       
     0.01%      ksoftirqd/3  [kernel.kallsyms]                [k] native_load_gs_index                              
     0.01%               as  libc-2.15.so                     [.] 0x0000000000134c3a                                
     0.01%               as  [kernel.kallsyms]                [k] enqueue_task                                      
     0.01%               as  [kernel.kallsyms]                [k] account_user_time                                 
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] rb_next                                           
     0.01%              cc1  [kernel.kallsyms]                [k] __vtime_account_system                            
     0.01%              cc1  [kernel.kallsyms]                [k] rb_insert_color                                   
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] wakeup_softirqd                                   
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] int_with_check                                    
     0.01%              cc1  [kernel.kallsyms]                [k] arch_vtime_task_switch                            
     0.01%               as  [kernel.kallsyms]                [k] check_preempt_curr                                
     0.01%              cc1  [kernel.kallsyms]                [k] cpuacct_charge                                    
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] wake_up_process                                   
     0.01%               as  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.01%  multiload-apple  libc-2.15.so                     [.] 0x00000000000f4f57                                
     0.01%               as  [kernel.kallsyms]                [k] update_rq_clock                                   
     0.01%              cc1  [kernel.kallsyms]                [k] account_user_time                                 
     0.01%             perf  [kernel.kallsyms]                [k] crypto_cbc_encrypt                                
     0.01%               as  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.01%              cc1  [kernel.kallsyms]                [k] enqueue_task                                      
     0.01%              cc1  [kernel.kallsyms]                [k] _raw_spin_unlock_irqrestore                       
     0.01%               as  [kernel.kallsyms]                [k] ttwu_do_wakeup                                    
     0.01%              cc1  [kernel.kallsyms]                [k] check_preempt_curr                                
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] vtime_task_switch                                 
     0.01%           python  [kernel.kallsyms]                [k] page_fault                                        
     0.01%               as  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.01%               sh  [kernel.kallsyms]                [k] activate_task                                     
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] schedule                                          
     0.01%               as  [kernel.kallsyms]                [k] rcu_try_advance_all_cbs                           
     0.01%               sh  [kernel.kallsyms]                [k] rcu_user_exit                                     
     0.01%               sh  [kernel.kallsyms]                [k] rcu_user_enter                                    
     0.01%               as  [kernel.kallsyms]                [k] set_next_buddy                                    
     0.01%           python  [kernel.kallsyms]                [k] crypto_aes_expand_key                             
     0.01%               as  [kernel.kallsyms]                [k] ttwu_stat                                         
     0.01%      ksoftirqd/0  [iwlwifi]                        [k] iwl_trans_pcie_read32                             
     0.01%              cc1  [kernel.kallsyms]                [k] update_cfs_rq_blocked_load                        
     0.01%              cc1  [kernel.kallsyms]                [k] ttwu_do_wakeup                                    
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] invoke_rcu_core                                   
     0.01%              cc1  [kernel.kallsyms]                [k] update_cfs_shares                                 
     0.01%               as  [kernel.kallsyms]                [k] rb_erase                                          
     0.01%          cc1plus  [iwlwifi]                        [k] iwl_trans_pcie_read32                             
     0.01%  arm-none-eabi-g  [kernel.kallsyms]                [k] calc_delta_mine                                   
     0.01%               as  [kernel.kallsyms]                [k] rcu_eqs_exit                                      
     0.01%               as  [kernel.kallsyms]                [k] vtime_account_system                              
     0.01%              cc1  [kernel.kallsyms]                [k] acct_account_cputime                              
     0.01%         postgres  libc-2.15.so                     [.] 0x00000000000c0707                                
     0.01%               as  [kernel.kallsyms]                [k] rcu_note_context_switch                           
     0.01%              cc1  [kernel.kallsyms]                [k] rcu_eqs_enter                                     
     0.01%               as  [kernel.kallsyms]                [k] vtime_user_enter                                  
     0.01%              cc1  [kernel.kallsyms]                [k] rcu_try_advance_all_cbs                           
     0.01%              cc1  [kernel.kallsyms]                [k] vtime_user_enter                                  
     0.01%               as  [kernel.kallsyms]                [k] rcu_eqs_enter                                     
     0.01%              cc1  [kernel.kallsyms]                [k] wakeup_preempt_entity.isra.39                     
     0.01%               as  [kernel.kallsyms]                [k] schedule_user                                     
     0.01%             perf  [kernel.kallsyms]                [k] __switch_to                                       
     0.01%               as  [kernel.kallsyms]                [k] wakeup_preempt_entity.isra.39                     
     0.01%              cc1  [kernel.kallsyms]                [k] perf_event_task_sched_out                         
     0.01%           python  [kernel.kallsyms]                [k] str2hashbuf_signed                                
     0.01%               as  [kernel.kallsyms]                [k] __raise_softirq_irqoff                            
     0.01%               as  [kernel.kallsyms]                [k] aes_decrypt                                       
     0.01%             Xorg  libc-2.15.so                     [.] 0x0000000000080b76                                
     0.01%    zabbix_agentd  libc-2.15.so                     [.] 0x000000000007c65d                                
     0.01%              cc1  [kernel.kallsyms]                [k] vtime_account_system                              
     0.01%               as  [kernel.kallsyms]                [k] ttwu_do_activate.constprop.87                    
