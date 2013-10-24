Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3JXRWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 13:22:38 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:51594 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3JXRWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 13:22:36 -0400
Date: Thu, 24 Oct 2013 13:30:28 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: perf/ftrace lockup on 3.12-rc6 with trigger code
Message-ID: <alpine.DEB.2.10.1310241324330.4352@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-998472795-1382635835=:4352"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-998472795-1382635835=:4352
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello

after a month of trying I finally got a small test-case out of my 
perf_fuzzer suite that triggers a system lockup with just one syscall.

Attached is the code that triggers it.

I tried tracking through the ftrace code to find out what's going on, but 
I quickly get lost.  The perf/ftrace code does do questionable things like 
copy at 64-bit config value into an "int".

You may recall this bug triggers messages like this before total system 
lockup:

[   47.813436] ------------[ cut here ]------------                
[   47.813436] WARNING: CPU: 0 PID: 2781 at kernel/watchdog.c:245 watchdog_over)
[   47.813436] Watchdog detected hard LOCKUP on cpu 0                           
[   47.813436] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powern
[   47.813436] CPU: 0 PID: 2781 Comm: out Not tainted 3.12.0-rc6+ #79           
[   47.813436] Hardware name: AOpen   DE7000/nMCP7ALPx-DE R1.06 Oct.19.2012, BI2
[   47.813436]  00000000000000f5 ffff88011fc07c48 ffffffff8151a736 ffff88011fc08
[   47.813436]  ffffffff8103cd68 ffffffff817fac46 ffffffff810a0fe5 ffff88011b310
[   47.813436]  ffff88011fc07ef8 ffff88011fc07d58 0000000000000000 ffff88011fc08
[   47.813436] Call Trace:                                                      
[   47.813436]  <NMI>  [<ffffffff8151a736>] ? dump_stack+0x41/0x53              
[   47.813436]  [<ffffffff8103cd68>] ? warn_slowpath_common+0x81/0x9c           
[   47.813436]  [<ffffffff810a0fe5>] ? watchdog_overflow_callback+0x9b/0xa6     
[   47.813436]  [<ffffffff8103ce25>] ? warn_slowpath_fmt+0x46/0x48              
[   47.813436]  [<ffffffff810a0f53>] ? watchdog_overflow_callback+0x9/0xa6      
[   47.813436]  [<ffffffff810a0fe5>] ? watchdog_overflow_callback+0x9b/0xa6     
[   47.813436]  [<ffffffff810ca46b>] ? __perf_event_overflow+0x12e/0x1ab        
[   47.813436]  [<ffffffff81018047>] ? intel_pmu_save_and_restart+0xe/0x22      
[   47.813436]  [<ffffffff81018c95>] ? intel_pmu_handle_irq+0x2b8/0x34d         
[   47.813436]  [<ffffffff8152457c>] ? ftrace_call+0x5/0x2f                     
[   47.813436]  [<ffffffff810c4aa4>] ? irq_work_queue+0x71/0x72                 
[   47.813436]  [<ffffffff8151f0b3>] ? perf_event_nmi_handler+0x24/0x3d         
[   47.813436]  [<ffffffff8151e9f2>] ? nmi_handle+0x5e/0x13a                    
[   47.813436]  [<ffffffff810a17fa>] ? rcu_nmi_enter+0x9/0x5b                   
[   47.813436]  [<ffffffff8151eb75>] ? do_nmi+0xa7/0x2bd                        
[   47.813436]  [<ffffffff8151e177>] ? end_repeat_nmi+0x1e/0x2e                 
[   47.813436]  [<ffffffff810c4aa4>] ? irq_work_queue+0x71/0x72                 
[   47.813436]  [<ffffffff810c4aa4>] ? irq_work_queue+0x71/0x72                 
[   47.813436]  [<ffffffff810c4aa4>] ? irq_work_queue+0x71/0x72                 
[   47.813436]  <<EOE>>  <IRQ>  [<ffffffff810ca4d9>] ? __perf_event_overflow+0xb
[   47.813436]  [<ffffffff810a8f18>] ? ftrace_ops_control_func+0x9a/0xc8        
[   47.813436]  [<ffffffff810ca654>] ? perf_swevent_overflow+0x3f/0x58          
[   47.813436]  [<ffffffff810ca86e>] ? perf_tp_event+0xe9/0x1f6                 
[   47.813436]  [<ffffffff810a8f18>] ? ftrace_ops_control_func+0x9a/0xc8        
[   47.813436]  [<ffffffff8151d65c>] ? _raw_spin_unlock_irqrestore+0x4/0x11     
[   47.813436]  [<ffffffff810be8db>] ? perf_ftrace_function_call+0xc7/0xd1      
[   47.813436]  [<ffffffff81525d9a>] ? irq_work_interrupt+0x6a/0x70             
[   47.813436]  [<ffffffff81040cdb>] ? irq_exit+0x4/0xa1                        
[   47.813436]  [<ffffffff81525d9a>] ? irq_work_interrupt+0x6a/0x70             
[   47.813436]  [<ffffffff810be8db>] ? perf_ftrace_function_call+0xc7/0xd1      
[   47.813436]  [<ffffffff81040cdb>] ? irq_exit+0x4/0xa1                        
[   47.813436]  [<ffffffff810a8f18>] ? ftrace_ops_control_func+0x9a/0xc8        
[   47.813436]  [<ffffffff81040cdb>] ? irq_exit+0x4/0xa1                        
[   47.813436]  [<ffffffff810a8f18>] ? ftrace_ops_control_func+0x9a/0xc8        
[   47.813436]  [<ffffffff8151d661>] ? _raw_spin_unlock_irqrestore+0x9/0x11     
[   47.813436]  [<ffffffff8152457c>] ? ftrace_call+0x5/0x2f                     
[   47.813436]  [<ffffffff8111f7a4>] ? kill_fasync+0x74/0x86                    
[   47.813436]  [<ffffffff810cabc2>] ? perf_event_wakeup+0x8c/0xa1              
[   47.813436]  [<ffffffff81005f1f>] ? smp_irq_work_interrupt+0x9/0x21          
[   47.813436]  [<ffffffff81005f1f>] ? smp_irq_work_interrupt+0x9/0x21          
[   47.813436]  [<ffffffff810c4916>] ? __irq_work_run+0x5f/0x7b                 
[   47.813436]  [<ffffffff81040ce0>] ? irq_exit+0x9/0xa1                        
[   47.813436]  [<ffffffff81040ce0>] ? irq_exit+0x9/0xa1                        
[   47.813436]  [<ffffffff81525d9a>] ? irq_work_interrupt+0x6a/0x70             
[   47.813436]  <EOI>  [<ffffffff81520b5d>] ? __do_page_fault+0x10b/0x3f5       
[   47.813436]  [<ffffffff81520a6b>] ? __do_page_fault+0x19/0x3f5               
[   47.813436]  [<ffffffff8152457c>] ? ftrace_call+0x5/0x2f                     
[   47.813436]  [<ffffffff811281ce>] ? fget_raw_light+0x9/0x8a                  
[   47.813436]  [<ffffffff81520e50>] ? do_page_fault+0x9/0xf                    
[   47.813436]  [<ffffffff8151de72>] ? page_fault+0x22/0x30                     
[   47.813436] ---[ end trace 9a2f13d704fa7b22 ]---         
--8323329-998472795-1382635835=:4352
Content-Type: TEXT/x-csrc; name=perf_ftrace_event_crash.c
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1310241330280.4352@vincent-weaver-1.um.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=perf_ftrace_event_crash.c

LyogbG9nX3RvX2NvZGUgb3V0cHV0IGZyb20gLi9icm9rZW5fdHJhY2UvbmV3
LmJyb2tlbi43ICovDQovKiBieSBWaW5jZSBXZWF2ZXIgPHZpbmNlbnQud2Vh
dmVyIF9hdF8gbWFpbmUuZWR1ICovDQoNCiNkZWZpbmUgX0dOVV9TT1VSQ0Ug
MQ0KI2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8dW5pc3RkLmg+DQoj
aW5jbHVkZSA8ZmNudGwuaD4NCiNpbmNsdWRlIDxzdHJpbmcuaD4NCiNpbmNs
dWRlIDxzaWduYWwuaD4NCiNpbmNsdWRlIDxzeXMvbW1hbi5oPg0KI2luY2x1
ZGUgPHN5cy9zeXNjYWxsLmg+DQojaW5jbHVkZSA8c3lzL2lvY3RsLmg+DQoj
aW5jbHVkZSA8c3lzL3ByY3RsLmg+DQojaW5jbHVkZSA8cG9sbC5oPg0KI2lu
Y2x1ZGUgPGxpbnV4L2h3X2JyZWFrcG9pbnQuaD4NCiNpbmNsdWRlIDxsaW51
eC9wZXJmX2V2ZW50Lmg+DQoNCmludCBmZFsxMDI0XTsNCnN0cnVjdCBwZXJm
X2V2ZW50X2F0dHIgcGVbMTAyNF07DQpjaGFyICptbWFwX3Jlc3VsdFsxMDI0
XTsNCiNkZWZpbmUgTUFYX1JFQURfU0laRSA2NTUzNg0Kc3RhdGljIGxvbmcg
bG9uZyBkYXRhW01BWF9SRUFEX1NJWkVdOw0KDQojZGVmaW5lIE1BWF9QT0xM
X0ZEUyAxMjgNCnN0cnVjdCBwb2xsZmQgcG9sbGZkc1tNQVhfUE9MTF9GRFNd
Ow0KDQpsb25nIGxvbmcgaWQ7DQoNCmludCBmb3JrZWRfcGlkOw0KDQpzdHJ1
Y3Qgc2lnYWN0aW9uIHNhOw0Kc3RhdGljIGludCBvdmVyZmxvd3M9MDsNCnN0
YXRpYyBpbnQgc2lnaW9zPTA7DQoNCnN0YXRpYyB2b2lkIG91cl9oYW5kbGVy
KGludCBzaWdudW0sIHNpZ2luZm9fdCAqaW5mbywgdm9pZCAqdWMpIHsNCglp
bnQgZmQgPSBpbmZvLT5zaV9mZDsNCglpbnQgcmV0Ow0KDQoJb3ZlcmZsb3dz
Kys7DQoJaW9jdGwoZmQsUEVSRl9FVkVOVF9JT0NfRElTQUJMRSwwKTsNCglp
ZiAoc2lnaW9zKSByZXR1cm47DQoJcmV0PWlvY3RsKGZkLCBQRVJGX0VWRU5U
X0lPQ19SRUZSRVNILDEpOw0KfQ0KaW50IHBlcmZfZXZlbnRfb3BlbihzdHJ1
Y3QgcGVyZl9ldmVudF9hdHRyICpod19ldmVudF91cHRyLA0KCXBpZF90IHBp
ZCwgaW50IGNwdSwgaW50IGdyb3VwX2ZkLCB1bnNpZ25lZCBsb25nIGZsYWdz
KSB7DQoNCglyZXR1cm4gc3lzY2FsbChfX05SX3BlcmZfZXZlbnRfb3Blbixo
d19ldmVudF91cHRyLCBwaWQsIGNwdSwNCgkJZ3JvdXBfZmQsIGZsYWdzKTsN
Cn0NCg0KaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KSB7DQovKiAx
ICovDQoNCgltZW1zZXQoJnBlWzVdLDAsc2l6ZW9mKHN0cnVjdCBwZXJmX2V2
ZW50X2F0dHIpKTsNCglwZVs1XS50eXBlPVBFUkZfVFlQRV9UUkFDRVBPSU5U
Ow0KCXBlWzVdLnNpemU9NjQ7DQoJcGVbNV0uY29uZmlnPTB4N2ZmZmZmZmYw
MDAwMDAwMTsNCglwZVs1XS5zYW1wbGVfcGVyaW9kPTB4ZmZmZmZmZmZmZjAw
MDAwMDsNCg0KCXBlWzVdLnNhbXBsZV90eXBlPVBFUkZfU0FNUExFX0lQfFBF
UkZfU0FNUExFX1RJTUV8UEVSRl9TQU1QTEVfUkVBRHxQRVJGX1NBTVBMRV9J
RHxQRVJGX1NBTVBMRV9QRVJJT0R8UEVSRl9TQU1QTEVfU1RSRUFNX0lEfFBF
UkZfU0FNUExFX1dFSUdIVDsgLyogNDM1NSAqLw0KLy8JcGVbNV0ucmVhZF9m
b3JtYXQ9UEVSRl9GT1JNQVRfSUQ7IC8qIDQgKi8NCi8vCXBlWzVdLmV4Y2x1
c2l2ZT0xOw0KLy8JcGVbNV0uZXhjbHVkZV91c2VyPTE7DQovLwlwZVs1XS5l
eGNsdWRlX2lkbGU9MTsNCi8vCXBlWzVdLmVuYWJsZV9vbl9leGVjPTE7DQov
LwlwZVs1XS53YXRlcm1hcms9MTsNCi8vCXBlWzVdLnByZWNpc2VfaXA9Mjsg
LyogcmVxdWVzdCB6ZXJvIHNraWQgKi8NCi8vCXBlWzVdLnNhbXBsZV9pZF9h
bGw9MTsNCi8vCXBlWzVdLndha2V1cF93YXRlcm1hcms9MjU1Ow0KLy8JcGVb
NV0uYnBfdHlwZT1IV19CUkVBS1BPSU5UX0VNUFRZOw0KDQoJZmRbNV09cGVy
Zl9ldmVudF9vcGVuKCZwZVs1XSwwLDAsLTEsMCAvKjAqLyApOw0KDQovKiAy
ICovDQoJbWVtc2V0KCZzYSwgMCwgc2l6ZW9mKHN0cnVjdCBzaWdhY3Rpb24p
KTsNCglzYS5zYV9zaWdhY3Rpb24gPSBvdXJfaGFuZGxlcjsNCglzYS5zYV9m
bGFncyA9IFNBX1NJR0lORk87DQoJaWYgKHNpZ2FjdGlvbiggU0lHUlRNSU4r
MiwgJnNhLCBOVUxMKSA8IDApIHsNCgkJcHJpbnRmKCJFcnJvciBzZXR0aW5n
IHVwIHNpZ25hbCBoYW5kbGVyXG4iKTsNCgl9DQoJZmNudGwoZmRbNV0sIEZf
U0VURkwsIE9fUkRXUnxPX05PTkJMT0NLfE9fQVNZTkMpOw0KCWZjbnRsKGZk
WzVdLCBGX1NFVFNJRywgU0lHUlRNSU4rMik7DQoJZmNudGwoZmRbNV0sIEZf
U0VUT1dOLGdldHBpZCgpKTsNCgkvKiBSZXBsYXllZCAyIHN5c2NhbGxzICov
DQoJcmV0dXJuIDA7DQp9DQo=

--8323329-998472795-1382635835=:4352--
