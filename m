Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3HaCC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 22:02:56 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:20452 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3HaCCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 22:02:54 -0400
Message-ID: <52214EBC.90100@hp.com>
Date: Fri, 30 Aug 2013 22:02:36 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com> <5220E56A.80603@hp.com> <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com> <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk>
In-Reply-To: <20130830204852.GE13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 04:48 PM, Al Viro wrote:
> On Fri, Aug 30, 2013 at 04:35:49PM -0400, Waiman Long wrote:
>
>> The AIM7 test was run on a set of 16 ramdisk formated with ext3
>> filesystem with the following mount options:
>> barrier=0,async,noatime,nodiratime. Maybe that is a factor.
> I would be really surprised if it was...  Could you slap the following
> into __fput():
>
> 	struct mount *m = real_mount(mnt);
> 	if (unlikely(!m->mnt_ns)) {
> 		printk(KERN_INFO "type = %s",
> 			mnt->mnt_sb->s_type->name);
> 		WARN_ON(1);
> 	}
> and see what it catches?  That'll need #include "fs/mount.h" in
> fs/file_table.c to compile...

I slapped in the code segment, and the following was logged:

[  340.871590] type = tmpfs
[  340.871596] ------------[ cut here ]------------
[  340.871606] WARNING: CPU: 37 PID: 63276 at fs/file_table.c:239 
__fput+0x23d/0x270()
[  340.871607] Modules linked in: brd(F) ip6table_filter(F) 
ip6_tables(F) iptable_filter(F) ip_tables(F) ebtable_nat(F) ebtables(F) 
x_tables(F) edd(F) af_packet(F) bridge(F) stp(F) llc(F) 
cpufreq_conservative(F) cpufreq_userspace(F) cpufreq_powersave(F) 
pcc_cpufreq(F) microcode(F) fuse(F) loop(F) vhost_net(F) macvtap(F) 
macvlan(F) vhost(F) tun(F) kvm_intel(F) ipv6(F) kvm(F) iTCO_wdt(F) 
iTCO_vendor_support(F) joydev(F) igb(F) tpm_infineon(F) dca(F) ptp(F) 
hid_generic(F) i7core_edac(F) sr_mod(F) tpm_tis(F) pps_core(F) qlcnic(F) 
tpm(F) edac_core(F) be2net(F) netxen_nic(F) lpc_ich(F) ehci_pci(F) 
mfd_core(F) hpwdt(F) hpilo(F) pcspkr(F) serio_raw(F) cdrom(F) 
tpm_bios(F) sg(F) rtc_cmos(F) mperf(F) button(F) acpi_power_meter(F) 
ext3(F) jbd(F) mbcache(F) dm_mirror(F) dm_region_hash(F) dm_log(F) 
linear(F) radeon(F) ttm(F) drm_kms_helper(F) drm(F) i2c_algo_bit(F) 
i2c_core(F) usbhid(F) hid(F) uhci_hcd(F) ehci_hcd(F) usbcore(F) 
qla2xxx(F) sd_mod(F) usb_common(F) thermal(F) processor(F) 
thermal_sys(F) hwmon(F) scsi_dh_emc(F) scsi_dh_rdac(F) scsi_dh_hp_sw(F) 
scsi_dh_alua(F) scsi_dh(F) dm_snapshot(F) dm_mod(F) ata_generic(F) 
ata_piix(F) libata(F) hpsa(F) lpfc(F) scsi_transport_fc(F) scsi_tgt(F) 
crc_t10dif(F) cciss(F) scsi_mod(F)
[  340.871663] CPU: 37 PID: 63276 Comm: reaim Tainted: GF       W    
3.11.0-rc7-lockref-0.11-default #4
[  340.871665] Hardware name: HP ProLiant DL980 G7, BIOS P66 07/30/2012
[  340.871667]  00000000000000ef ffff899f6b03dd88 ffffffff814992f5 
ffff899f6b03ddc8
[  340.871681]  ffffffff8104a187 ffff899f6b03dda8 0000000000000000 
ffff899f6b03aa40
[  340.871686]  ffff899f68fc7cc0 ffff899f69ee8ae0 ffff899f69ee8ae0 
ffff899f6b03ddd8
[  340.871692] Call Trace:
[  340.871700]  [<ffffffff814992f5>] dump_stack+0x6a/0x7d
[  340.871705]  [<ffffffff8104a187>] warn_slowpath_common+0x87/0xb0
[  340.871709]  [<ffffffff8104a1c5>] warn_slowpath_null+0x15/0x20
[  340.871712]  [<ffffffff8116c5bd>] __fput+0x23d/0x270
[  340.871715]  [<ffffffff8116c699>] ____fput+0x9/0x10
[  340.871719]  [<ffffffff81068ae1>] task_work_run+0xb1/0xe0
[  340.871724]  [<ffffffff81002990>] do_notify_resume+0x80/0x1b0
[  340.871728]  [<ffffffff811ed120>] ? ipc_lock+0x30/0x50
[  340.871732]  [<ffffffff8113a356>] ? remove_vma+0x56/0x60
[  340.871736]  [<ffffffff8113c1bf>] ? do_munmap+0x34f/0x380
[  340.871741]  [<ffffffff814a5fda>] int_signal+0x12/0x17
[  340.871744] ---[ end trace aafa6c45f3388d65 ]---

Regards,
Longman
