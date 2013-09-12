Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3ILRbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:31:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53113 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab3ILRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:31:06 -0400
Date: Thu, 12 Sep 2013 10:30:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf-related lockup on 3.11
Message-ID: <20130912173058.GS3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.10.1309111130410.31828@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1309111130410.31828@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091217-1542-0000-0000-0000016325BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:35:24AM -0400, Vince Weaver wrote:
> 
> I got this hard lockup running my perf_fuzzer on 3.11 on a core2.
> I guess I should try to reproduce it on linus-git but was hoping
> I could wait until -rc1 before trying that.
> 
> I'm not really sure where to report lockups like this because it's sort
> of unclear what exactly the problem is.  perf? ftrace? nmi? rcu?

RCU is an innocent bystander on this one.  (Honest, officer!)

You see rcu_nmi_enter() because it is called on NMI.

							Thanx, Paul

> Vince
> 
> 
> [ 4022.356007] ------------[ cut here ]------------                             
> [ 4022.356007] WARNING: CPU: 0 PID: 3393 at kernel/watchdog.c:245 watchdog_overf
> low_callback+0x9b/0xa6()                                                        
> [ 4022.356007] Watchdog detected hard LOCKUP on cpu 0                           
> [ 4022.356007] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powers
> ave cpufreq_conservative f71882fg coretemp acpi_cpufreq mperf mcs7830 usbnet psm
> ouse pcspkr serio_raw evdev video wmi ohci_pci processor button thermal_sys ohci
> _hcd i2c_nforce2 sg ehci_pci ehci_hcd sd_mod usbcore usb_common                 
> [ 4022.356007] CPU: 0 PID: 3393 Comm: perf_fuzzer Not tainted 3.11.0 #2         
> [ 4022.356007] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BIO
> S 080015  10/19/2012                                                            
> [ 4022.356007]  00000000000000f5 ffff88011fc07c48 ffffffff81508364 ffff88011fc07
> c58                                                                             
> [ 4022.356007]  ffffffff8103cc81 ffffffff817d132a ffffffff8109b2e9 ffff88011b30e
> 400                                                                             
> [ 4022.356007]  ffff88011fc07ef8 ffff88011fc07d58 0000000000000000 ffff88011fc07
> ca8                                                                             
> [ 4022.356007] Call Trace:                                                      
> [ 4022.356007]  <NMI>  [<ffffffff81508364>] ? dump_stack+0x41/0x55              
> [ 4022.356007]  [<ffffffff8103cc81>] ? warn_slowpath_common+0x81/0x9c           
> [ 4022.356007]  [<ffffffff8109b2e9>] ? watchdog_overflow_callback+0x9b/0xa6     
> [ 4022.356007]  [<ffffffff8103cd3e>] ? warn_slowpath_fmt+0x46/0x48              
> [ 4022.356007]  [<ffffffff8109b257>] ? watchdog_overflow_callback+0x9/0xa6      
> [ 4022.356007]  [<ffffffff8109b2e9>] ? watchdog_overflow_callback+0x9b/0xa6     
> [ 4022.356007]  [<ffffffff810c90d8>] ? __perf_event_overflow+0x12e/0x1ab        
> [ 4022.356007]  [<ffffffff810c50ea>] ? perf_event_update_userpage+0x16/0xce     
> [ 4022.356007]  [<ffffffff81017dc8>] ? intel_pmu_save_and_restart+0xe/0x22      
> [ 4022.356007]  [<ffffffff81018a2f>] ? intel_pmu_handle_irq+0x2c4/0x35b         
> [ 4022.356007]  [<ffffffff815122fc>] ? ftrace_call+0x5/0x2f                     
> [ 4022.356007]  [<ffffffff8150b2ad>] ? _raw_spin_unlock_irqrestore+0xf/0x11     
> [ 4022.356007]  [<ffffffff8150ccab>] ? perf_event_nmi_handler+0x24/0x3d         
> [ 4022.356007]  [<ffffffff8150c4dd>] ? nmi_handle+0x5e/0x13a                    
> [ 4022.356007]  [<ffffffff810a0d70>] ? rcu_nmi_enter+0x9/0x5b                   
> [ 4022.356007]  [<ffffffff8150c660>] ? do_nmi+0xa7/0x2bd                        
> [ 4022.356007]  [<ffffffff8150bc77>] ? end_repeat_nmi+0x1e/0x2e                 
> [ 4022.356007]  [<ffffffff8150b2ad>] ? _raw_spin_unlock_irqrestore+0xf/0x11     
> [ 4022.356007]  [<ffffffff8150b2ad>] ? _raw_spin_unlock_irqrestore+0xf/0x11     
> [ 4022.356007]  [<ffffffff8150b2ad>] ? _raw_spin_unlock_irqrestore+0xf/0x11     
> [ 4022.356007]  <<EOE>>  [<ffffffff810bdf89>] ? perf_trace_event_unreg+0x3a/0xbd
> [ 4022.356007]  [<ffffffff810be03a>] ? perf_trace_destroy+0x2e/0x3b             
> [ 4022.356007]  [<ffffffff810c5f5d>] ? free_event+0xf6/0x11e                    
> [ 4022.356007]  [<ffffffff810cab5c>] ? SYSC_perf_event_open+0x6e4/0x771         
> [ 4022.356007]  [<ffffffff81055666>] ? put_pid+0xe/0x4f                         
> [ 4022.356007]  [<ffffffff815126c6>] ? system_call_fastpath+0x1a/0x1f           
> [ 4022.356007] ---[ end trace c426f99910c1c076 ]---                             
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

