Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3EMWeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:34:37 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40569 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3EMWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:34:36 -0400
Message-ID: <519169BF.4080208@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 04:01:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
References: <87ip2opntp.fsf@nemi.mork.no> <20130512113905.GH3648@linux.vnet.ibm.com>	<87li7kp50r.fsf@nemi.mork.no> <20130512172135.GJ3648@linux.vnet.ibm.com>	<87a9o0ukll.fsf@nemi.mork.no> <87sj1rydol.fsf@nemi.mork.no> <87wqr3j656.fsf@nemi.mork.no>
In-Reply-To: <87wqr3j656.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051322-5140-0000-0000-00000333BE72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 08:09 PM, Bjørn Mork wrote:
> Bjørn Mork <bjorn@mork.no> writes:
> 
>> I was unable to recreate the problem in a virtual machine, which is
>> slightly suspicious.  And bisecting it ended up pointing to a merge
>> commit: 
>>
>>  commit ab86e974f04b1cd827a9c7c35273834ebcd9ab38
>>  Merge: 8700c95 6f7a05d
>>  Author: Linus Torvalds <torvalds@linux-foundation.org>
>>  Date:   Tue Apr 30 08:15:40 2013 -0700
>>
>>      Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>>  ..
>>
>>
>> which I don't think makes much sense at all.  The bisect log leading to
>> this was:
>>
>> bjorn@canardo:/usr/local/src/build-tmp/linux$ git bisect log
>> # bad: [f722406faae2d073cc1d01063d1123c35425939e] Linux 3.10-rc1
>> # good: [c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1] Linux 3.9
>> git bisect start 'v3.10-rc1' 'v3.9'
>> # bad: [73287a43cc79ca06629a88d1a199cd283f42456a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
>> git bisect bad 73287a43cc79ca06629a88d1a199cd283f42456a
>> # bad: [5d434fcb255dec99189f1c58a06e4f56e12bf77d] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
>> git bisect bad 5d434fcb255dec99189f1c58a06e4f56e12bf77d
>> # good: [507ffe4f3840ac24890a8123c702cf1b7fe4d33c] Merge tag 'tty-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
>> git bisect good 507ffe4f3840ac24890a8123c702cf1b7fe4d33c
>> # good: [4a7b4d2360175f67ab2c58effeeb8362a3057c25] x86: pageattr-test: remove srandom32 call
>> git bisect good 4a7b4d2360175f67ab2c58effeeb8362a3057c25
>> # good: [46d9be3e5eb01f71fc02653755d970247174b400] Merge branch 'for-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
>> git bisect good 46d9be3e5eb01f71fc02653755d970247174b400
>> # good: [e0972916e8fe943f342b0dd1c9d43dbf5bc261c2] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> git bisect good e0972916e8fe943f342b0dd1c9d43dbf5bc261c2
>> # bad: [ab86e974f04b1cd827a9c7c35273834ebcd9ab38] Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> git bisect bad ab86e974f04b1cd827a9c7c35273834ebcd9ab38
>> # good: [8700c95adb033843fc163d112b9d21d4fda78018] Merge branch 'smp-hotplug-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>> git bisect good 8700c95adb033843fc163d112b9d21d4fda78018
>> # good: [0ed2aef9b3bffe598045b62a31a50d912eee92d8] Merge branch 'fortglx/3.10/time' of git://git.linaro.org/people/jstultz/linux into timers/core
>> git bisect good 0ed2aef9b3bffe598045b62a31a50d912eee92d8
>> # good: [8f294b5a139ee4b75e890ad5b443c93d1e558a8b] hrtimer: Add expiry time overflow check in hrtimer_interrupt
>> git bisect good 8f294b5a139ee4b75e890ad5b443c93d1e558a8b
>> # good: [60cf7ea849e77c8782dee147cfb8c38d1984236e] timer_list: Split timer_list_show_tickdevices
>> git bisect good 60cf7ea849e77c8782dee147cfb8c38d1984236e
>> # good: [d2054b2c11682495fca41e9d4092e654df63b517] posix-timers: Remove unused variable
>> git bisect good d2054b2c11682495fca41e9d4092e654df63b517
>> # good: [6402c7dc2a19c19bd8cdc7d80878b850da418942] Merge branch 'linus' into timers/core Reason: Get upstream fixes before adding conflicting code.
>> git bisect good 6402c7dc2a19c19bd8cdc7d80878b850da418942
>> # good: [6f7a05d7018de222e40ca003721037a530979974] clockevents: Set dummy handler on CPU_DEAD shutdown
>> git bisect good 6f7a05d7018de222e40ca003721037a530979974
>>
>>
>> So there it stands.  I have no clue and I don't think I'm able to
>> provide any clue for anyone else either.  Given that the problem seems
>> to be very consistently reproducible on my laptop, I am a bit puzzled as
>> to how the bisect would fail like that.
> 
> Hey, hey, hey.  Turns out this wasn't that wrong after all.  That merge
> includes a oneline diff in kernel/cpu/idle.c and it *is* actually this
> diff which trigger the problem for me.  Reverting it, using the attached
> patch, makes the warning go away.  Which means that it had nothing to do
> with your RCU changes.
> 
> But I haven't the faintest idea how this is supposed to work, or even
> how to explain the patch properly, so I think I need some help from
> Thomas here.  Unless this makes you understand the real issue?
> 
> Thomas, why does powertop trigger the
> 
>   WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common.isra.48+0x3d/0x125()
> 
> without the attached patch?  And what is the proper resolution?
> 
 
The problem appears to be in the cpu idle poll implementation. You can trigger
this problem by passing idle=poll in the kernel cmd-line as well, right?

I think I understand what is going on here. Can you please try the fix below?
(It is only compile-tested since its very late here and I really need to get
some sleep!).

Regards,
Srivatsa S. Bhat


----------------------------------------------------------------------->


From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] rcu/idle: Wrap cpu-idle poll mode within rcu_idle_enter/exit

Bjørn Mork reported the following warning when running powertop.

[   49.289034] ------------[ cut here ]------------
[   49.289055] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common.isra.48+0x3d/0x125()
[   49.289059] Modules linked in: msr cpufreq_stats xt_multiport iptable_filter ip_tables rfcomm bnep xt_hl binfmt_misc ip6table_filter ip6_tables x_tables nfsd nfs_acl nfs lockd fscache sunrpc 8021q garp stp llc tun cdc_mbim cdc_ncm cdc_wdm usbnet mii loop fuse btusb bluetooth iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant arc4 iwldvm mac80211 thinkpad_acpi nvram snd_seq_midi snd_seq_midi_event snd_rawmidi snd_hda_intel snd_seq snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss iwlwifi snd_pcm coretemp kvm_intel kvm snd_seq_device evdev psmouse serio_raw lpc_ich mfd_core cfg80211 snd_page_alloc i2c_i801 snd_timer snd soundcore rfkill battery ac acpi_cpufreq mperf i915 wmi video i2c_algo_bit drm_kms_helper button drm i2c_core processor ext4 crc16 jbd2 mbcache nbd sg sr_mod cdrom sd_mod crc_t10dif ahci libahci libata microcode scsi_mod ehci_pci uhci_hcd ehci_hcd usbcore usb_common thermal thermal_sys e1000e ptp pps_core
[   49.289244] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-bisect-rcu-warn+ #107
[   49.289247] Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
[   49.289251]  ffffffff8157d8c8 ffffffff81801e28 ffffffff8137e4e3 ffffffff81801e68
[   49.289260]  ffffffff8103094f ffffffff81801e68 0000000000000000 ffff88023afcd9b0
[   49.289268]  0000000000000000 0140000000000000 ffff88023bee7700 ffffffff81801e78
[   49.289276] Call Trace:
[   49.289285]  [<ffffffff8137e4e3>] dump_stack+0x19/0x1b
[   49.289293]  [<ffffffff8103094f>] warn_slowpath_common+0x62/0x7b
[   49.289300]  [<ffffffff8103097d>] warn_slowpath_null+0x15/0x17
[   49.289306]  [<ffffffff810a9006>] rcu_eqs_exit_common.isra.48+0x3d/0x125
[   49.289314]  [<ffffffff81079b49>] ? trace_hardirqs_off_caller+0x37/0xa6
[   49.289320]  [<ffffffff810a9692>] rcu_idle_exit+0x85/0xa8
[   49.289327]  [<ffffffff8107076e>] trace_cpu_idle_rcuidle+0xae/0xff
[   49.289334]  [<ffffffff810708b1>] cpu_startup_entry+0x72/0x115
[   49.289341]  [<ffffffff813689e5>] rest_init+0x149/0x150
[   49.289347]  [<ffffffff8136889c>] ? csum_partial_copy_generic+0x16c/0x16c
[   49.289355]  [<ffffffff81a82d34>] start_kernel+0x3f0/0x3fd
[   49.289362]  [<ffffffff81a8274c>] ? repair_env_string+0x5a/0x5a
[   49.289368]  [<ffffffff81a82481>] x86_64_start_reservations+0x2a/0x2c
[   49.289375]  [<ffffffff81a82550>] x86_64_start_kernel+0xcd/0xd1
[   49.289379] ---[ end trace 07a1cc95e29e9036 ]---

The warning is that 'rdtp->dynticks' has an unexpected value, which roughly
translates to - the calls to rcu_idle_enter() and rcu_idle_exit() were not
made in the correct order, or otherwise messed up.

And Bjørn's painstaking debugging indicated that this happens when the idle
loop enters the poll mode. Looking at the poll function cpu_idle_poll(), and
the implementation of trace_cpu_idle_rcuidle(), the problem becomes very clear:
cpu_idle_poll() lacks calls to rcu_idle_enter/exit(), and trace_cpu_idle_rcuidle()
calls them in the reverse order - first rcu_idle_exit(), and then rcu_idle_enter().
Hence the even/odd alternative sequencing of rdtp->dynticks goes for a toss.

And powertop readily triggers this because powertop uses the idle-tracing
infrastructure extensively.

So, to fix this, wrap the code in cpu_idle_poll() within rcu_idle_enter/exit(),
so that it blends properly with the calls inside trace_cpu_idle_rcuidle() and
thus get the function ordering right.

Reported-by: Bjørn Mork <bjorn@mork.no>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/cpu/idle.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 8b86c0c..d5585f5 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -40,11 +40,13 @@ __setup("hlt", cpu_idle_nopoll_setup);
 
 static inline int cpu_idle_poll(void)
 {
+	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	rcu_idle_exit();
 	return 1;
 }
 



