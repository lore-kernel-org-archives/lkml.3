Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaLCDgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:36:37 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44799 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaLCDgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:36:35 -0500
Message-ID: <547E853C.3090300@hitachi.com>
Date: Wed, 03 Dec 2014 12:36:28 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: William Cohen <wcohen@redhat.com>
Cc: Steve Capper <steve.capper@linaro.org>, David Long <dave.long@linaro.org>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com> <547C36DB.7060903@hitachi.com> <547E129C.1090308@redhat.com>
In-Reply-To: <547E129C.1090308@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/03 4:27), William Cohen wrote:
> On 12/01/2014 04:37 AM, Masami Hiramatsu wrote:
>> (2014/11/29 1:01), Steve Capper wrote:
>>> On 27 November 2014 at 06:07, Masami Hiramatsu
>>> <masami.hiramatsu.pt@hitachi.com> wrote:
>>>> (2014/11/27 3:59), Steve Capper wrote:
>>>>> The crash is extremely easy to reproduce.
>>>>>
>>>>> I've not observed any missed events on a kprobe on an arm64 system
>>>>> that's still alive.
>>>>> My (limited!) understanding is that this suggests there could be a
>>>>> problem with how missed events from a recursive call to memcpy are
>>>>> being handled.
>>>>
>>>> I think so too. BTW, could you bisect that? :)
>>>>
>>>
>>> I can't bisect, but the following functions look suspicious to me
>>> (again I'm new to kprobes...):
>>> kprobes_save_local_irqflag
>>> kprobes_restore_local_irqflag
>>>
>>> I think these are breaking somehow when nested (i.e. from a recursive probe).
>>
>> Agreed. On x86, prev_kprobe has old_flags and saved_flags, this
>> at least must have saved_irqflag and save/restore it in
>> save/restore_previous_kprobe().
>>
>> What about adding this?
>>
>>  struct prev_kprobe {
>>  	struct kprobe *kp;
>>  	unsigned int status;
>> +	unsigned long saved_irqflag;
>>  };
>>
>> and
>>
>>  static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
>>  {
>>  	kcb->prev_kprobe.kp = kprobe_running();
>>  	kcb->prev_kprobe.status = kcb->kprobe_status;
>> +	kcb->prev_kprobe.saved_irqflag = kcb->saved_irqflag;
>>  }
>>
>>  static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
>>  {
>>  	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
>>  	kcb->kprobe_status = kcb->prev_kprobe.status;
>> +	kcb->saved_irqflag = kcb->prev_kprobe.saved_irqflag;
>>  }
>>
> 
> Hi Masami and Dave,
> 
> I have applied the suggested patch above to my local kernel. However, I have noticed systemtap testsuite consistently getting panics when running both before AND after applying that patch to the kernel.  Any thoughts on why "perf stat" would cause that? Below is an example output

Thanks for reporting. But it seems another bug, which is related to
perf subsystem and irqflag recovering process.
Please make sure by using ftrace to test as Steve reported for this bug.
We'd better fix bugs one by one...

Thank you,

> 
> -Will
> 
> # perf stat make install
> 
> ...
> 
> Running ./systemtap/notest.exp ...
> Running ./systemtap.apps/java.exp ...
> [ 6734.986063] Bad mode in FIQ handler detected, code 0x56000000
> [ 6734.991788] CPU: 0 PID: 3968 Comm: stap Tainted: G            E  3.18.0-rc5kp3+ #3
> [ 6734.999317] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.004602] task: fffffe0016c25a00 ti: fffffe03d8aa8000 task.ti: fffffe03d8aa8000
> [ 6735.012052] PC is at 0x3ff7fc0d1fc
> [ 6735.015434] LR is at 0x3ff7fc31838
> [ 6735.018815] pc : [<000003ff7fc0d1fc>] lr : [<000003ff7fc31838>] pstate: 00000000
> [ 6735.026172] sp : fffffe03d8aabff0
> [ 6735.029467] x29: 000003fffe4f6460 x28: 000003ff7fb23640 
> [ 6735.034772] x27: 000003ff7fb23578 x26: 000000000059a420 
> [ 6735.040074] x25: 000000000000005f x24: 000003ff7fb3f000 
> [ 6735.045375] x23: 000000004178ee40 x22: 0000000000000006 
> [ 6735.050680] x21: 0000000000000001 x20: 0000000000008000 
> [ 6735.055980] x19: 000000004178ee40 x18: 000003fffe4f64a0 
> [ 6735.061282] x17: 000003ff7fc0d1fc x16: 000003ff7fd00008 
> [ 6735.066585] x15: 00000013cd9f3df0 x14: 0000000051c4a1f8 
> [ 6735.071886] x13: 0000000001519f64 x12: 000000000000000e 
> [ 6735.077187] x11: 646f6d2f62696c2f x10: 6174732f706d742f 
> [ 6735.082488] x9 : 312e332f73656c75 x8 : 0000000000000038 
> [ 6735.087790] x7 : 5f34366372617073 x6 : 000000000000007c 
> [ 6735.093094] x5 : 0000000000000000 x4 : 0000000000000001 
> [ 6735.098397] x3 : 0000000000000000 x2 : 0000000000000000 
> [ 6735.103697] x1 : 0000000000000001 x0 : 0000000000008030 
> [ 6735.108999] 
> [ 6735.110483] Bad mode in Synchronous Abort handler detected, code 0x8600000f
> [ 6735.117408] CPU: 0 PID: 3968 Comm: stap Tainted: G            E  3.18.0-rc5kp3+ #3
> [ 6735.124936] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.130220] task: fffffe0016c25a00 ti: fffffe03d8aa8000 task.ti: fffffe03d8aa8000
> [ 6735.137662] PC is at 0x3ff7fc31838
> [ 6735.141044] LR is at 0x3ff7fc31838
> [ 6735.144426] pc : [<000003ff7fc31838>] lr : [<000003ff7fc31838>] pstate: 600003c5
> [ 6735.151782] sp : fffffe03d8aabed0
> [ 6735.155077] x29: 000003fffe4f6460 x28: 000003ff7fb23640 
> [ 6735.160380] x27: 000003ff7fb23578 x26: 000000000059a420 
> [ 6735.165681] x25: 000000000000005f x24: 000003ff7fb3f000 
> [ 6735.170983] x23: 0000000000000000 x22: 000003ff7fc0d1fc 
> [ 6735.176285] x21: fffffe03d8aabff0 x20: 0000000000008000 
> [ 6735.181587] x19: 000000004178ee40 x18: 000003fffe4f64a0 
> [ 6735.186888] x17: 000003ff7fc0d1fc x16: 000003ff7fd00008 
> [ 6735.192189] x15: 00000013cd9f3df0 x14: 30303030203a6574 
> [ 6735.197490] x13: fffffe00008eda38 x12: cb88537fdc8cb000 
> [ 6735.202792] x11: fffffe03d8aabb70 x10: fffffe03d8aabb70 
> [ 6735.208094] x9 : 000000000000015f x8 : 0000000000000000 
> [ 6735.213395] x7 : 0000000000000200 x6 : fffffe0000095cd4 
> [ 6735.218698] x5 : fffffe0300030001 x4 : 0000000000000000 
> [ 6735.224001] x3 : fffffe03d8aabc80 x2 : 000000000000027e 
> [ 6735.229304] x1 : cb88537fdc8cb000 x0 : cb88537fdc8cb000 
> [ 6735.234607] 
> [ 6735.236088] Internal error: Oops - bad mode: 0 [#1] SMP
> [ 6735.241285] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 iptable_filter ip_tables bridge stp llc cfg80211 rfkill vfat fat nfsd uio_pdrv_genirq uio xfs libcrc32c dm_mirror dm_region_hash dm_log dm_mod realtek(E)
> [ 6735.273612] CPU: 0 PID: 3968 Comm: stap Tainted: G            E  3.18.0-rc5kp3+ #3
> [ 6735.281140] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.286422] task: fffffe0016c25a00 ti: fffffe03d8aa8000 task.ti: fffffe03d8aa8000
> [ 6735.293865] PC is at 0x3ff7fc31838
> [ 6735.297246] LR is at 0x3ff7fc31838
> [ 6735.300627] pc : [<000003ff7fc31838>] lr : [<000003ff7fc31838>] pstate: 600003c5
> [ 6735.307982] sp : fffffe03d8aabed0
> [ 6735.311277] x29: 000003fffe4f6460 x28: 000003ff7fb23640 
> [ 6735.316580] x27: 000003ff7fb23578 x26: 000000000059a420 
> [ 6735.321882] x25: 000000000000005f x24: 000003ff7fb3f000 
> [ 6735.327184] x23: 0000000000000000 x22: 000003ff7fc0d1fc 
> [ 6735.332485] x21: fffffe03d8aabff0 x20: 0000000000008000 
> [ 6735.337790] x19: 000000004178ee40 x18: 000003fffe4f64a0 
> [ 6735.343093] x17: 000003ff7fc0d1fc x16: 000003ff7fd00008 
> [ 6735.348393] x15: 00000013cd9f3df0 x14: 30303030203a6574 
> [ 6735.353695] x13: fffffe00008eda38 x12: cb88537fdc8cb000 
> [ 6735.358997] x11: fffffe03d8aabb70 x10: fffffe03d8aabb70 
> [ 6735.364299] x9 : 000000000000015f x8 : 0000000000000000 
> [ 6735.369602] x7 : 0000000000000200 x6 : fffffe0000095cd4 
> [ 6735.374905] x5 : fffffe0300030001 x4 : 0000000000000000 
> [ 6735.380207] x3 : fffffe03d8aabc80 x2 : 000000000000027e 
> [ 6735.385507] x1 : cb88537fdc8cb000 x0 : cb88537fdc8cb000 
> [ 6735.390810] 
> [ 6735.392290] Process stap (pid: 3968, stack limit = 0xfffffe03d8aa8058)
> [ 6735.398784] Stack: (0xfffffe03d8aabed0 to 0xfffffe03d8aac000)
> [ 6735.404500] bec0:                                     00008030 00000000 00000001 00000000
> [ 6735.412634] bee0: 00000000 00000000 00000000 00000000 00000001 00000000 00000000 00000000
> [ 6735.420768] bf00: 0000007c 00000000 72617073 5f343663 00000038 00000000 73656c75 312e332f
> [ 6735.428902] bf20: 706d742f 6174732f 62696c2f 646f6d2f 0000000e 00000000 01519f64 00000000
> [ 6735.437037] bf40: 51c4a1f8 00000000 cd9f3df0 00000013 7fd00008 000003ff 7fc0d1fc 000003ff
> [ 6735.445171] bf60: fe4f64a0 000003ff 4178ee40 00000000 00008000 00000000 00000001 00000000
> [ 6735.453305] bf80: 00000006 00000000 4178ee40 00000000 7fb3f000 000003ff 0000005f 00000000
> [ 6735.461439] bfa0: 0059a420 00000000 7fb23578 000003ff 7fb23640 000003ff fe4f6460 000003ff
> [ 6735.469574] bfc0: 7fc31838 000003ff d8aabff0 fffffe03 7fc0d1fc 000003ff 00000000 00000000
> [ 6735.477709] bfe0: ffffff9c ffffffff 00000038 00000000 00001030 18770000 00000048 00001034
> [ 6735.485841] Call trace:
> [ 6735.488274] Code: d2800600 f2a00200 d2a00214 97fdf3b7 (aa0003f3) 
> [ 6735.494367] ---[ end trace ca753992e46532e9 ]---
> [ 6735.498961] Kernel panic - not syncing: Fatal exception
> [ 6735.504162] CPU6: stopping
> [ 6735.506858] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6735.514560] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.519843] Call trace:
> [ 6735.522281] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6735.527653] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6735.532679] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6735.537703] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6735.542901] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6735.548270] Exception stack(0xfffffe03dbebfe20 to 0xfffffe03dbebff40)
> [ 6735.554678] fe20: 00000006 00000000 dbebc000 fffffe03 dbebff60 fffffe03 000940b4 fffffe00
> [ 6735.562813] fe40: 00000000 00000000 00000000 00000000 fbf40fc0 fffffe03 fbf40d0c fffffe03
> [ 6735.570948] fe60: 00000008 00000000 00000010 00000000 44a22180 00000626 01097980 fffffe00
> [ 6735.579083] fe80: dbe1ae20 fffffe03 dbebfd50 fffffe03 0009d014 00000001 006d82f8 fffffe00
> [ 6735.587217] fea0: 00000000 00000000 1e4347c0 fffffe00 00c10df0 fffffe00 05711f7c 0037a8e7
> [ 6735.595351] fec0: 001ec620 fffffe00 004f0468 00000000 e30dd8e0 000003ff 00000006 00000000
> [ 6735.603486] fee0: dbebc000 fffffe03 00cd0518 fffffe00 00c9e000 fffffe00 00cd2560 fffffe00
> [ 6735.611621] ff00: 00cd0e18 fffffe00 00c9d812 fffffe00 00000001 00000000 008ec980 fffffe00
> [ 6735.619756] ff20: 006d67e8 fffffe00 dbebff60 fffffe03 000940b0 fffffe00 dbebff60 fffffe03
> [ 6735.627890] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6735.632656] [<fffffe00000ecf84>] cpu_startup_entry+0x118/0x1bc
> [ 6735.638457] [<fffffe000009b054>] secondary_start_kernel+0x100/0x110
> [ 6735.644690] CPU7: stopping
> [ 6735.647385] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6735.655087] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.660368] Call trace:
> [ 6735.662802] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6735.668173] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6735.673197] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6735.678221] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6735.683417] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6735.688786] Exception stack(0xfffffe03dbec3e20 to 0xfffffe03dbec3f40)
> [ 6735.695193] 3e20: 00000007 00000000 dbec0000 fffffe03 dbec3f60 fffffe03 000940b4 fffffe00
> [ 6735.703327] 3e40: 00000000 00000000 00000000 00000000 fbf60fc0 fffffe03 fbf60d0c fffffe03
> [ 6735.711463] 3e60: 00000020 00000000 00000010 00000000 1a4d6580 00000620 fbf61788 fffffe03
> [ 6735.719598] 3e80: dbe1b960 fffffe03 dbec3d50 fffffe03 0009d1a4 00000001 00000040 00000000
> [ 6735.727732] 3ea0: 00000001 00000000 00000000 00000000 00000000 00000000 b96c1a6a 00261821
> [ 6735.735866] 3ec0: 000b8af0 fffffe00 a48e0010 000003ff d69cf010 000003ff 00000007 00000000
> [ 6735.744001] 3ee0: dbec0000 fffffe03 00cd0518 fffffe00 00c9e000 fffffe00 00cd2560 fffffe00
> [ 6735.752134] 3f00: 00cd0e18 fffffe00 00c9d812 fffffe00 00000001 00000000 008ec980 fffffe00
> [ 6735.760268] 3f20: 006d67e8 fffffe00 dbec3f60 fffffe03 000940b0 fffffe00 dbec3f60 fffffe03
> [ 6735.768402] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6735.773167] [<fffffe00000ecf84>] cpu_startup_entry+0x118/0x1bc
> [ 6735.778968] [<fffffe000009b054>] secondary_start_kernel+0x100/0x110
> [ 6735.785202] CPU2: stopping
> [ 6735.787896] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6735.795598] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.800881] Call trace:
> [ 6735.803316] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6735.808687] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6735.813712] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6735.818736] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6735.823932] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6735.829301] Exception stack(0xfffffe03dbeafe20 to 0xfffffe03dbeaff40)
> [ 6735.835708] fe20: 00000002 00000000 dbeac000 fffffe03 dbeaff60 fffffe03 000940b4 fffffe00
> [ 6735.843843] fe40: 00000000 00000000 00000000 00000000 fbec0fc0 fffffe03 fbec0d0c fffffe03
> [ 6735.851978] fe60: 00000000 00000000 dbeafee0 fffffe03 0000003f 00000000 00000000 00000000
> [ 6735.860113] fe80: dbe18120 fffffe03 dbeafd50 fffffe03 0009d18f 00000001 006d82f8 fffffe00
> [ 6735.868248] fea0: 01010101 01010101 00000028 00000000 fffffffe 0fffffff 00000000 00000000
> [ 6735.876382] fec0: 001f8794 fffffe00 840d20c0 000003ff 0000000d 00000000 00000002 00000000
> [ 6735.884518] fee0: dbeac000 fffffe03 00cd0518 fffffe00 00c9e000 fffffe00 00cd2560 fffffe00
> [ 6735.892652] ff00: 00cd0e18 fffffe00 00c9d812 fffffe00 00000001 00000000 008ec980 fffffe00
> [ 6735.900786] ff20: 006d67e8 fffffe00 dbeaff60 fffffe03 000940b0 fffffe00 dbeaff60 fffffe03
> [ 6735.908919] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6735.913685] [<fffffe00000ecf84>] cpu_startup_entry+0x118/0x1bc
> [ 6735.919487] [<fffffe000009b054>] secondary_start_kernel+0x100/0x110
> [ 6735.925720] CPU3: stopping
> [ 6735.928413] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6735.936115] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.941397] Call trace:
> [ 6735.943831] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6735.949202] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6735.954226] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6735.959250] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6735.964446] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6735.969815] Exception stack(0xfffffe03dbeb3e20 to 0xfffffe03dbeb3f40)
> [ 6735.976222] 3e20: 00000003 00000000 dbeb0000 fffffe03 dbeb3f60 fffffe03 000940b4 fffffe00
> [ 6735.984358] 3e40: 00000000 00000000 00000000 00000000 fbee0fc0 fffffe03 fbee0d0c fffffe03
> [ 6735.992492] 3e60: 00000008 00000000 00000010 00000000 66819c80 0000065e d5647e20 fffffe03
> [ 6736.000627] 3e80: dc109838 fffffe03 00000001 00000000 00001001 00000000 00000040 00000000
> [ 6736.008761] 3ea0: 00000018 00000000 e8000000 00000003 00000001 00000000 e45e1b65 003ba59e
> [ 6736.016895] 3ec0: 0010a39c fffffe00 a5d85cb0 000003ff f7dad6c0 000003ff 00000003 00000000
> [ 6736.025030] 3ee0: dbeb0000 fffffe03 00cd0518 fffffe00 00c9e000 fffffe00 00cd2560 fffffe00
> [ 6736.033163] 3f00: 00cd0e18 fffffe00 00c9d812 fffffe00 00000001 00000000 008ec980 fffffe00
> [ 6736.041297] 3f20: 006d67e8 fffffe00 dbeb3f60 fffffe03 000940b0 fffffe00 dbeb3f60 fffffe03
> [ 6736.049431] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6736.054196] [<fffffe00000ecf84>] cpu_startup_entry+0x118/0x1bc
> [ 6736.059998] [<fffffe000009b054>] secondary_start_kernel+0x100/0x110
> [ 6736.066232] CPU5: stopping
> [ 6736.068928] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6736.076631] Hardware name: APM X-Gene Mustang board (DT)
> [ 6736.081914] Call trace:
> [ 6736.084350] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6736.089721] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6736.094746] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6736.099770] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6736.104966] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6736.110335] Exception stack(0xfffffe03dbebbe20 to 0xfffffe03dbebbf40)
> [ 6736.116742] be20: 00000005 00000000 dbeb8000 fffffe03 dbebbf60 fffffe03 000940b4 fffffe00
> [ 6736.124877] be40: 00000000 00000000 00000000 00000000 fbf20fc0 fffffe03 fbf20d0c fffffe03
> [ 6736.133011] be60: 00000008 00000000 00000010 00000000 87aec580 00000623 d565b840 fffffe03
> [ 6736.141145] be80: dbe1a2e0 fffffe03 dbebbd50 fffffe03 0009d0db 00000001 00055dbd 00000000
> [ 6736.149279] bea0: 00000018 00000000 e8000000 00000003 00000000 00000000 e035cf9c 0014f62d
> [ 6736.157413] bec0: 001f8794 fffffe00 aa6720c0 000003ff 0000000d 00000000 00000005 00000000
> [ 6736.165547] bee0: dbeb8000 fffffe03 00cd0518 fffffe00 00c9e000 fffffe00 00cd2560 fffffe00
> [ 6736.173681] bf00: 00cd0e18 fffffe00 00c9d812 fffffe00 00000001 00000000 008ec980 fffffe00
> [ 6736.181815] bf20: 006d67e8 fffffe00 dbebbf60 fffffe03 000940b0 fffffe00 dbebbf60 fffffe03
> [ 6736.189949] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6736.194714] [<fffffe00000ecf84>] cpu_startup_entry+0x118/0x1bc
> [ 6736.200515] [<fffffe000009b054>] secondary_start_kernel+0x100/0x110
> [ 6736.206749] CPU4: stopping
> [ 6736.209442] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6736.217144] Hardware name: APM X-Gene Mustang board (DT)
> [ 6736.222425] Call trace:
> [ 6736.224859] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6736.230230] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6736.235254] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6736.240278] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6736.245474] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6736.250843] Exception stack(0xfffffe03dbeb7e20 to 0xfffffe03dbeb7f40)
> [ 6736.257251] 7e20: 00000004 00000000 dbeb4000 fffffe03 dbeb7f60 fffffe03 000940b4 fffffe00
> [ 6736.265385] 7e40: 00000000 00000000 00000000 00000000 fbf00fc0 fffffe03 fbf00d0c fffffe03
> [ 6736.273519] 7e60: 00000000 00000000 fbf01788 fffffe03 d4dd6800 00000620 d5387d10 fffffe03
> [ 6736.281653] 7e80: dbe197a0 fffffe03 dbeb7d50 fffffe03 0009d0ec 00000001 0009d7c5 00000000
> [ 6736.289787] 7ea0: 00000018 00000000 e8000000 00000003 00000000 00000000 427abb63 002672da
> [ 6736.297923] 7ec0: 00229414 fffffe00 8851ab88 000003ff 0000000d 00000000 00000004 00000000
> [ 6736.306057] 7ee0: dbeb4000 fffffe03 00cd0518 fffffe00 00c9e000 fffffe00 00cd2560 fffffe00
> [ 6736.314191] 7f00: 00cd0e18 fffffe00 00c9d812 fffffe00 00000001 00000000 008ec980 fffffe00
> [ 6736.322326] 7f20: 006d67e8 fffffe00 dbeb7f60 fffffe03 000940b0 fffffe00 dbeb7f60 fffffe03
> [ 6736.330459] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6736.335224] [<fffffe00000ecf84>] cpu_startup_entry+0x118/0x1bc
> [ 6736.341026] [<fffffe000009b054>] secondary_start_kernel+0x100/0x110
> [ 6736.347260] CPU1: stopping
> [ 6736.349957] CPU: 1 PID: 628 Comm: rs:main Q:Reg Tainted: G      D     E  3.18.0-rc5kp3+ #3
> [ 6736.358179] Hardware name: APM X-Gene Mustang board (DT)
> [ 6736.363462] Call trace:
> [ 6736.365897] [<fffffe0000096b70>] dump_backtrace+0x0/0x184
> [ 6736.371268] [<fffffe0000096d04>] show_stack+0x10/0x1c
> [ 6736.376293] [<fffffe000069a0f8>] dump_stack+0x74/0x98
> [ 6736.381317] [<fffffe000009b578>] handle_IPI+0x184/0x200
> [ 6736.386513] [<fffffe0000090370>] gic_handle_irq+0x74/0x7c
> [ 6736.391882] Exception stack(0xfffffe00010f75f0 to 0xfffffe00010f7710)
> [ 6736.398289] 75e0:                                     00bc1000 fffffe00 00000000 00000000
> [ 6736.406423] 7600: 010f7730 fffffe00 000b9714 fffffe00 00000040 00000000 00cd0e80 fffffe00
> [ 6736.414557] 7620: 00cd0000 fffffe00 00000040 00000000 00cd0e80 fffffe00 0009d1a8 00000001
> [ 6736.422691] 7640: 0000000a 00000000 fbea1788 fffffe03 00000020 00000000 00000000 00000000
> [ 6736.430825] 7660: 006d82fc fffffe00 006d82f8 fffffe00 00000018 00000000 e8000000 00000003
> [ 6736.438959] 7680: 00c00000 fffffe00 f2e8383d 0017e03a 001e4d60 fffffe00 a7e8fa20 000003ff
> [ 6736.447093] 76a0: a60ae420 000003ff 00bc1000 fffffe00 00000000 00000000 00000001 00000000
> [ 6736.455228] 76c0: 00000082 00000000 60000145 00000000 00c9dd90 fffffe00 00c66000 fffffe00
> [ 6736.463362] 76e0: 00c00000 fffffe00 00bb0c70 fffffe00 1fc7a800 fffffe00 010f7730 fffffe00
> [ 6736.471496] 7700: 000b9688 fffffe00 010f7730 fffffe00
> [ 6736.476520] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6736.481285] [<fffffe00000b9b74>] irq_exit+0x90/0xd0
> [ 6736.486138] [<fffffe00000f8c48>] __handle_domain_irq+0x68/0xb4
> [ 6736.491940] [<fffffe000009032c>] gic_handle_irq+0x30/0x7c
> [ 6736.497309] Exception stack(0xfffffe00010f7820 to 0xfffffe00010f7940)
> [ 6736.503715] 7820: 00db49f0 fffffe00 00000140 00000000 010f7960 fffffe00 0069fe40 fffffe00
> [ 6736.511851] 7840: 00db49f0 fffffe00 00000140 00000000 00002eb3 00000000 00004006 00000000
> [ 6736.519985] 7860: 00002eb2 00000000 000ecb74 fffffe00 dc8cb000 cb88537f 0002da98 00000000
> [ 6736.528119] 7880: 0002da99 00000000 00000000 00000000 dc8cb000 cb88537f 00061cbb 00000000
> [ 6736.536253] 78a0: 00000018 00000000 e8000000 00000003 00000000 00000000 f2e8383d 0017e03a
> [ 6736.544159] SMP: failed to stop secondary CPUs
> [ 6736.544162] ---[ end Kernel panic - not syncing: Fatal exception
> [ 6736.554775] 78c0: 001e4d60 fffffe00 a7e8fa20 000003ff a60ae420 000003ff 00db49f0 fffffe00
> [ 6736.562911] 78e0: 00000140 00000000 010f79f8 fffffe00 00cd0000 fffffe00 14e76800 fffffe00
> [ 6736.571045] 7900: 00400040 00000000 00c66000 fffffe00 00748ca8 fffffe00 00748ee8 fffffe00
> [ 6736.579179] 7920: 1fc7a800 fffffe00 010f7960 fffffe00 0040434c fffffe00 010f7960 fffffe00
> [ 6736.587312] [<fffffe0000092ce0>] el1_irq+0x60/0xc0
> [ 6736.592079] [<fffffe00003f17fc>] tty_port_block_til_ready+0x14c/0x2e4
> [ 6736.598485] [<fffffe0000407818>] uart_open+0xc4/0x148
> [ 6736.603510] [<fffffe00003e94c0>] tty_open+0x15c/0x584
> [ 6736.608535] [<fffffe00001e9b94>] chrdev_open+0xc8/0x190
> [ 6736.613733] [<fffffe00001e332c>] do_dentry_open+0x1c8/0x2e0
> [ 6736.619275] [<fffffe00001e38cc>] vfs_open+0x3c/0x48
> [ 6736.624126] [<fffffe00001f28ac>] do_last+0x154/0xd0c
> [ 6736.629064] [<fffffe00001f3520>] path_openat+0xbc/0x688
> [ 6736.634260] [<fffffe00001f4afc>] do_filp_open+0x3c/0xb0
> [ 6736.639458] [<fffffe00001e4c64>] do_sys_open+0x160/0x234
> [ 6736.644741] [<fffffe00001e4d6c>] SyS_openat+0xc/0x18
> 
> 
>>
>>
>>> That would explain why the state of play of the interrupts is in an
>>> unexpected state in the crash I reported:
>>> "The point of failure in the panic was:
>>> fs/buffer.c:1257
>>>
>>> static inline void check_irqs_on(void)
>>> {
>>> #ifdef irqs_disabled
>>>         BUG_ON(irqs_disabled());
>>> #endif
>>> }
>>> "
>>>
>>> This is all new to me so I'm still at the head-scratching stage.
>>
>> Ah, I see.
>>
>> Thank you,
>>
>>>
>>> David,
>>> Does the above make sense to you? Have you managed to reproduce the crash I get?
>>>
>>> Cheers,
>>> --
>>> Steve
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


