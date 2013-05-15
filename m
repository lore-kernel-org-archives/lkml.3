Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab3EOOpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:45:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59056 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759182Ab3EOOp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:45:29 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE9B851C@SHSMSX102.ccr.corp.intel.com>
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com> <519257FC.8070708@zytor.com> <9E0BE1322F2F2246BD820DA9FC397ADE9B851C@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH] x86: add a new SMP bring up way for tboot case
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 15 May 2013 07:44:59 -0700
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        "Wei, Gang" <gang.wei@intel.com>
Message-ID: <7877c9de-aa56-4f66-9e51-97987e34cc39@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, this does not really answer the question of what the CPU state looks like.

"Ren, Qiaowei" <qiaowei.ren@intel.com> wrote:

>On 2013-05-14, H. Peter Anvin wrote:
>> On 05/14/2013 02:21 PM, Qiaowei Ren wrote:
>>> tboot provides a better AP wakeup mechanism based on cpu MWAIT
>>> feature for OS/VMM. With this mechanism, system will boot faster and
>>> will NOT require VT to be enabled. But it requires that OS/VMM must
>>> have support it, otherwise system can never boot up.
>>> 
>>> Once this mechanism is enabled, tboot will put APs waiting in MWAIT
>>> loops before launching kernel. kernel can check the new flag field
>>> in
>>> v6 tboot shared page for the hint. If the bit
>>> TB_FLAG_AP_WAKE_SUPPORT in flag field is set, kernel BSP has to
>>> write the monitored memory
>>> (tboot->ap_wake_trigger) to bring APs out of MWAIT loops. The sipi
>>> vector should be written in
>>> tboot->ap_wake_addr before waking up APs.
>>> 
>> 
>> This really needs a *detailed* specification about the state the CPU
>is parked in.
>> Most BIOSes do in fact park the CPUs in an mwait loop, but we can't
>> use it because the CPU state they are parked in is ill-defined.
>> 
>> This is a good idea, but please write (or point to) a spec about what
>> the parked CPU state looks like and how the OS gets control.  From
>the
>> *looks* of the code I assume it is entered in 16-bit real mode but
>> then it is important to know what parts of the register state are
>well-defined.
>
>The following is how to do mwait for tboot & kernel:
>
>For bootstrap processor (BSP), "tboot TXT pre-launch" is executed after
>BIOS. In this stage, tboot will issue GETSEC[SENTER], which broadcasts
>messages to the chipset and other physical or logical processors in the
>platform. In response, other logical processors perform basic cleanup
>and other tasks, and then finally enter SENTER sleep state.
>
>Next, for BSP, SINIT will run and then enter "tboot post-launch", which
>will start all sleeping APs. If tboot command line option "
>ap_wake_mwait=true" is set, APs will do some work and then enter mwait
>loop. Kernel will be launched in BSP by tboot post-launch, and bring
>APs out of mwait loop.
>
>Tboot works in protected mode (but paging is disabled), and closes
>interrupt. For APs, MONITOR and MWAIT related code in tboot is as
>follows:
>    while ( _tboot_shared.ap_wake_trigger != cpuid ) {
>        cpu_monitor(&_tboot_shared.ap_wake_trigger, 0, 0);
>        mb();
>        if ( _tboot_shared.ap_wake_trigger == cpuid )
>            break;
>        cpu_mwait(0, 0);
>    }
>Their extension and hint are all 0. According Intel manual:
>	Extension=0: Treat interrupts as break events even if masked (e.g.,
>even if EFLAGS.IF=0).
>	Hint=0: the preferred optimized state the processor should enter is
>C0.
>So, when "tboot->ap_wake_trigger" is set by kernel, APs can exit from
>mwait loop.
>
>Peter, I don't know whether I explain your problem. What do you think
>about it?
>
>Thanks,
>Qiaowei

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
