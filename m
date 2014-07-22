Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaGVN7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:59:13 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:34330 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaGVN7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:59:10 -0400
Message-ID: <53CE6E5B.1070106@dev.rtsoft.ru>
Date: Tue, 22 Jul 2014 17:59:55 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, Raphos <raphoszap@laposte.net>,
        Jeff Layton <jlayton@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        "'Alexey Lugovskoy'" <lugovskoy@dev.rtsoft.ru>,
        Konstantin Kholopov <kkholopov@dev.rtsoft.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.10.y regression caused by:  lockd: ensure we tear down any
 live sockets when socket creation fails during lockd_up
References: <53A4177B.6060300@dev.rtsoft.ru> <20140707222721.GC11171@kroah.com>
In-Reply-To: <20140707222721.GC11171@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> With current 3.10.y, if kernel is booted with init=/bin/sh and then nfs mount
>> is attempted (without portmap or rpcbind running) using busybox mount, following
>> OOPS happen:
>>
>> # mount -t nfs 10.30.130.21:/opt /mnt
>> svc: failed to register lockdv1 RPC service (errno 111).
>> lockd_up: makesock failed, error=-111
>> Unable to handle kernel paging request for data at address 0x00000030
>> Faulting instruction address: 0xc055e65c
>> Oops: Kernel access of bad area, sig: 11 [#1]
>> MPC85xx CDS
>> Modules linked in:
>> CPU: 0 PID: 1338 Comm: mount Not tainted 3.10.44.cge #117
>> task: cf29cea0 ti: cf35c000 task.ti: cf35c000
>> NIP: c055e65c LR: c0566490 CTR: c055e648
>> REGS: cf35dad0 TRAP: 0300   Not tainted  (3.10.44.cge)
>> MSR: 00029000 <CE,EE,ME>  CR: 22442488  XER: 20000000
>> DEAR: 00000030, ESR: 00000000
>>
>> GPR00: c05606f4 cf35db80 cf29cea0 cf0ded80 cf0dedb8 00000001 1dec3086 00000000
>> GPR08: 00000000 c07b1640 00000007 1dec3086 22442482 100b9758 00000000 10090ae8
>> GPR16: 00000000 000186a5 00000000 00000000 100c3018 bfa46edc 100b0000 bfa46ef0
>> GPR24: cf386ae0 c07834f0 00000000 c0565f88 00000001 cf0dedb8 00000000 cf0ded80
>> NIP [c055e65c] call_start+0x14/0x34
>> LR [c0566490] __rpc_execute+0x70/0x250
>> Call Trace:
>> [cf35db80] [00000080] 0x80 (unreliable)
>> [cf35dbb0] [c05606f4] rpc_run_task+0x9c/0xc4
>> [cf35dbc0] [c0560840] rpc_call_sync+0x50/0xb8
>> [cf35dbf0] [c056ee90] rpcb_register_call+0x54/0x84
>> [cf35dc10] [c056f24c] rpcb_register+0xf8/0x10c
>> [cf35dc70] [c0569e18] svc_unregister.isra.23+0x100/0x108
>> [cf35dc90] [c0569e38] svc_rpcb_cleanup+0x18/0x30
>> [cf35dca0] [c0198c5c] lockd_up+0x1dc/0x2e0
>> [cf35dcd0] [c0195348] nlmclnt_init+0x2c/0xc8
>> [cf35dcf0] [c015bb5c] nfs_start_lockd+0x98/0xec
>> [cf35dd20] [c015ce6c] nfs_create_server+0x1e8/0x3f4
>> [cf35dd90] [c0171590] nfs3_create_server+0x10/0x44
>> [cf35dda0] [c016528c] nfs_try_mount+0x158/0x1e4
>> [cf35de20] [c01670d0] nfs_fs_mount+0x434/0x8c8
>> [cf35de70] [c00cd3bc] mount_fs+0x20/0xbc
>> [cf35de90] [c00e4f88] vfs_kern_mount+0x50/0x104
>> [cf35dec0] [c00e6e0c] do_mount+0x1d0/0x8e0
>> [cf35df10] [c00e75ac] SyS_mount+0x90/0xd0
>> [cf35df40] [c000ccf4] ret_from_syscall+0x0/0x3c
>> --- Exception: c01 at 0xff2acc4
>>      LR = 0x10048ab8
>> Instruction dump:
>> 3d20c056 3929e648 91230028 38600001 4e800020 38600000 4e800020 81230014
>> 8103000c 81490014 394a0001 91490014 <81280030> 81490018 394a0001 91490018
>> ---[ end trace 033b5b4715cb5452 ]---
>>
>>
>> This does not happen if
>>
>> commit 72a6e594497032bd911bd187a88fae4b4473abb3
>> Author: Jeff Layton <jlayton@redhat.com>
>> Date:   Tue Mar 25 11:55:26 2014 -0700
>>
>>      lockd: ensure we tear down any live sockets when socket creation fails during lockd_up
>>      
>>      commit 679b033df48422191c4cac52b610d9980e019f9b upstream.
>>
>> is reverted:
>>
>> # mount -t nfs 10.30.130.21:/opt /mnt
>> svc: failed to register lockdv1 RPC service (errno 111).
>> lockd_up: makesock failed, error=-111
>> mount: mounting 10.30.130.21:/opt on /mnt failed: Connection refused
>> #
>>
>>
>> Physical reason of the OOPS is that:
>>
>> - addition of svc_shutdown_net() call to error path of make_socks() causes
>> double call of svc_rpcb_cleanup():
>>    - first call is from within svc_shutdown_net(), because serv->sv_shutdown
>> points to svc_rpcb_cleanup() at this time,
>>    - immediately followed by second call from lockd_up_net()'s error path
>>
>> - when second svc_rpcb_cleanup() is executed, then at
>>    svc_unregister() -> __svc_unregister() -> rpcb_register() -> rpcb_register_call()
>> call path, rpcb_register_call() is called with clnt=NULL.
> 
> So, Jeff, what should I do here?  Drop this patch from 3.10?  Add
> something else to fix it up?  Something else entirely?

Problem is still there with 3.10.49

sh-4.2# /tmp/mount 10.150.42.24:/opt /mnt                                       
svc: failed to register lockdv1 RPC service (errno 111).                        
lockd_up: makesock failed, error=-111                                           
Unable to handle kernel paging request for data at address 0x00000038           
Faulting instruction address: 0xc055bb5c                                        
Oops: Kernel access of bad area, sig: 11 [#1]                                   
PREEMPT SMP NR_CPUS=2 MPC8572 DS                                                
Modules linked in:                                                              
CPU: 0 PID: 1315 Comm: mount Not tainted 3.10.49.cge #123                       
task: efb1f300 ti: c7ab0000 task.ti: c7ab0000                                   
NIP: c055bb5c LR: c0564df4 CTR: c055bb48                                        
REGS: c7ab1aa0 TRAP: 0300   Not tainted  (3.10.49.cge)                          
MSR: 00029000 <CE,EE,ME>  CR: 22442482  XER: 20000000                           
DEAR: 00000038, ESR: 00000000                                                   

GPR00: c055e124 c7ab1b50 efb1f300 ef8f8d80 ef8f8db8 00000001 5d3119ef 00000000  
GPR08: 00000000 c075e534 00000007 21964fef 22442482 100b9758 00000000 10090ae8  
GPR16: 00000000 000186a5 00000000 00000000 101e3018 c0564814 00000001 ef8f8db8  
GPR24: c0760000 00000000 c7ab0000 c055bb48 00000000 c055bb48 c7ab1bb8 ef8f8d80  
NIP [c055bb5c] call_start+0x14/0x34                                             
LR [c0564df4] __rpc_execute+0x90/0x388                                          
Call Trace:                                                                     
[c7ab1b50] [c00879e8] ktime_get+0x154/0x170 (unreliable)                        
[c7ab1ba0] [c055e124] rpc_run_task+0x9c/0xc4                                    
[c7ab1bb0] [c055e270] rpc_call_sync+0x50/0xb8                                   
[c7ab1be0] [c056e1e4] rpcb_register_call+0x54/0x84
[c7ab1c00] [c056e680] rpcb_register+0x108/0x11c
[c7ab1c70] [c0568d08] svc_unregister+0x110/0x118
[c7ab1c90] [c0568d28] svc_rpcb_cleanup+0x18/0x30
[c7ab1ca0] [c02803c4] lockd_up+0x1e4/0x2e8
[c7ab1cd0] [c027c8fc] nlmclnt_init+0x2c/0xc8
[c7ab1cf0] [c024b3bc] nfs_start_lockd+0x98/0xec
[c7ab1d20] [c024c744] nfs_create_server+0x1e8/0x3f4
[c7ab1d90] [c02622dc] nfs3_create_server+0x14/0x40
[c7ab1da0] [c0255558] nfs_try_mount+0x158/0x1e4
[c7ab1e20] [c0257420] nfs_fs_mount+0x438/0x8cc
[c7ab1e70] [c0140e3c] mount_fs+0x20/0xbc
[c7ab1e90] [c015b7a8] vfs_kern_mount+0x50/0x104
[c7ab1ec0] [c015dad0] do_mount+0x1d0/0x8ec
[c7ab1f10] [c015e27c] SyS_mount+0x90/0xd0
[c7ab1f40] [c000ee74] ret_from_syscall+0x0/0x3c
--- Exception: c01 at 0xff0ada0
    LR = 0x10048ab8
Instruction dump:
3d20c056 3929bb48 91230028 38600001 4e800020 38600000 4e800020 81230014 
8103000c 81490014 394a0001 91490014 <81280038> 81490018 394a0001 91490018 
---[ end trace 17b77871713e3175 ]---

