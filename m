Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3EOMzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:55:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:28536 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab3EOMzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:55:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,677,1363158000"; 
   d="scan'208";a="302803345"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: RE: [PATCH] x86: add a new SMP bring up way for tboot case
Thread-Topic: [PATCH] x86: add a new SMP bring up way for tboot case
Thread-Index: AQHOUKduon4Pn56HmkychJPawPQVZJkER8wAgAGLeBA=
Date: Wed, 15 May 2013 12:55:04 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE9B851C@SHSMSX102.ccr.corp.intel.com>
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
 <519257FC.8070708@zytor.com>
In-Reply-To: <519257FC.8070708@zytor.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-14, H. Peter Anvin wrote:
> On 05/14/2013 02:21 PM, Qiaowei Ren wrote:
>> tboot provides a better AP wakeup mechanism based on cpu MWAIT
>> feature for OS/VMM. With this mechanism, system will boot faster and
>> will NOT require VT to be enabled. But it requires that OS/VMM must
>> have support it, otherwise system can never boot up.
>> 
>> Once this mechanism is enabled, tboot will put APs waiting in MWAIT
>> loops before launching kernel. kernel can check the new flag field
>> in
>> v6 tboot shared page for the hint. If the bit
>> TB_FLAG_AP_WAKE_SUPPORT in flag field is set, kernel BSP has to
>> write the monitored memory
>> (tboot->ap_wake_trigger) to bring APs out of MWAIT loops. The sipi
>> vector should be written in
>> tboot->ap_wake_addr before waking up APs.
>> 
> 
> This really needs a *detailed* specification about the state the CPU is parked in.
> Most BIOSes do in fact park the CPUs in an mwait loop, but we can't
> use it because the CPU state they are parked in is ill-defined.
> 
> This is a good idea, but please write (or point to) a spec about what
> the parked CPU state looks like and how the OS gets control.  From the
> *looks* of the code I assume it is entered in 16-bit real mode but
> then it is important to know what parts of the register state are well-defined.

The following is how to do mwait for tboot & kernel:

For bootstrap processor (BSP), "tboot TXT pre-launch" is executed after BIOS. In this stage, tboot will issue GETSEC[SENTER], which broadcasts messages to the chipset and other physical or logical processors in the platform. In response, other logical processors perform basic cleanup and other tasks, and then finally enter SENTER sleep state.

Next, for BSP, SINIT will run and then enter "tboot post-launch", which will start all sleeping APs. If tboot command line option " ap_wake_mwait=true" is set, APs will do some work and then enter mwait loop. Kernel will be launched in BSP by tboot post-launch, and bring APs out of mwait loop.

Tboot works in protected mode (but paging is disabled), and closes interrupt. For APs, MONITOR and MWAIT related code in tboot is as follows:
    while ( _tboot_shared.ap_wake_trigger != cpuid ) {
        cpu_monitor(&_tboot_shared.ap_wake_trigger, 0, 0);
        mb();
        if ( _tboot_shared.ap_wake_trigger == cpuid )
            break;
        cpu_mwait(0, 0);
    }
Their extension and hint are all 0. According Intel manual:
	Extension=0: Treat interrupts as break events even if masked (e.g., even if EFLAGS.IF=0).
	Hint=0: the preferred optimized state the processor should enter is C0.
So, when "tboot->ap_wake_trigger" is set by kernel, APs can exit from mwait loop.

Peter, I don't know whether I explain your problem. What do you think about it?

Thanks,
Qiaowei
