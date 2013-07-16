Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3GPI2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:28:18 -0400
Received: from serv05.lahn.de ([85.214.212.93]:49890 "EHLO serv05.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3GPI2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:28:06 -0400
Authentication-Results: serv05.lahn.de; dkim=none (no signature);
	dkim-adsp=fail (insecure policy)
From: Philipp Hahn <pmhahn@pmhahn.de>
Organization: UUCP Freunde Lahn e.V.
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [BUG] 3.10.[01] modprobe snd-... hangs
Date: Tue, 16 Jul 2013 10:28:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, alsa-devel@alsa-project.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Lucas De Marchi" <lucas.demarchi@profusion.mobi>
References: <20130715182010.GA4853@pmhahn.de> <87ppujysbk.fsf@rustcorp.com.au> <s5h38rfngx3.wl%tiwai@suse.de>
In-Reply-To: <s5h38rfngx3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TQQ5RsqHYme4gU5"
Message-Id: <201307161028.03315.pmhahn@pmhahn.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TQQ5RsqHYme4gU5
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hello,

Am Dienstag 16 Juli 2013, 08:43:36 schrieb Takashi Iwai:
> At Tue, 16 Jul 2013 15:11:51 +0930, Rusty Russell wrote:
> > Philipp Matthias Hahn <pmhahn@pmhahn.de> writes:
> > > My x86_64 systems has some trouble loading some ALSA snd-* modules since
> > > the upgrade to 3.10.[01]: Several automatic modprobe calls hang, but
> > > loading snd-intel-hda and snd-audio-usb by hand still works.
> > 
> > Not a known problem to me, at least.  Perhaps it's a dep loop somehow.
> 
> I remember that someone reported it being Debian specific snd-seq-oss
> loading stuff.

FYI: "oss-compat" is installed.

> > > ...
> > >  1071 ?        S      0:00 sh -c /sbin/modprobe --ignore-install snd && { /sbin/modprobe --quiet snd
> > >  1080 ?        D      0:00  \_ /sbin/modprobe --quiet snd-seq
> > 
> > This was first, and it's waiting.  Which means it must be doing
> > something weird, because snd_seq_oss is loading now:
> > 
> > > snd_seq_oss 33717 1 - Loading 0xffffffffa041b000
> > 
> > Perhaps in the tangle of modprobe install commands somewhere this gets
> > invoked?
> 
> Likely, but I wonder what triggered a bug suddenly on 3.10.
> There is absolutely no change in sound/core/seq/*, and through a quick
> look, I couldn't find any suspicious change in kernel/module.c that
> may lead to this problem between 3.9 and 3.10.
> 
> Philipp, can you get a sysrq-T trace while the stall?

I've finally been able to reducte the number of processes to get a full trace; see attached file.

Please note that in this case the proprietary "nvidia" module was loaded, since I currently onyl have remove access to the machine.
The original trace from yesterday happend without the nvidia module ever being loaded.

Am Dienstag 16 Juli 2013, 08:42:35 schrieb Lucas De Marchi:
> On Tue, Jul 16, 2013 at 2:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> First thing to check is the /etc/modprobe.d/*.conf file that contains
> these install commands. Did they change besides the kernel upgrade?

Not that I know of: Booting 3.9.9 works fine, 3.10.x shows the problem.

...
> Philipp, which kernel are you upgrading from?
I just upgraded from 3.9.9 to 3.10.0; also tried 3.10.1 which did not improve the situation.

> I don't see anything to
> blame in the changes for the past releases. Any chance a bad entry in
> your .conf was added too? You may want to paste the output of modprobe
> -c, at least until "# End of configuration files. Dumping indexes
> now:"

blacklist snd_pcsp
blacklist arkfb
blacklist aty128fb
blacklist atyfb
blacklist radeonfb
blacklist cirrusfb
blacklist cyber2000fb
blacklist gx1fb
blacklist gxfb
blacklist kyrofb
blacklist matroxfb_base
blacklist mb862xxfb
blacklist neofb
blacklist nvidiafb
blacklist pm2fb
blacklist pm3fb
blacklist s3fb
blacklist savagefb
blacklist sisfb
blacklist tdfxfb
blacklist tridentfb
blacklist viafb
blacklist vt8623fb
blacklist garmin_gps
blacklist nouveau
install binfmt_0000 /bin/true
install sound_slot_0 /sbin/modprobe snd-card-0
install sound_slot_1 /sbin/modprobe snd-card-1
install sound_slot_2 /sbin/modprobe snd-card-2
install sound_slot_3 /sbin/modprobe snd-card-3
install sound_slot_4 /sbin/modprobe snd-card-4
install sound_slot_5 /sbin/modprobe snd-card-5
install sound_slot_6 /sbin/modprobe snd-card-6
install sound_slot_7 /sbin/modprobe snd-card-7
install snd /sbin/modprobe --ignore-install snd && { /sbin/modprobe --quiet snd-ioctl32 ; /sbin/modprobe --quiet snd-seq ; : ; }
install snd_rawmidi /sbin/modprobe --ignore-install snd-rawmidi && { /sbin/modprobe --quiet snd-seq-midi ; : ; }
install snd_emu10k1 /sbin/modprobe --ignore-install snd-emu10k1 && { /sbin/modprobe --quiet snd-emu10k1-synth ; : ; }
alias net_pf_16_proto_1 wire
alias net_pf_16_proto_3 ip_queue
alias net_pf_16_proto_8 scsi_transport_iscsi
alias net_pf_16_proto_9 audit
alias net_pf_16_proto_11 cn
alias net_pf_16_proto_13 ip6_queue
alias binfmt_204 binfmt_aout
alias binfmt_263 binfmt_aout
alias binfmt_264 binfmt_aout
alias binfmt_267 binfmt_aout
alias binfmt_387 binfmt_aout
alias block_major_3_* ide_generic
alias block_major_22_* ide_generic
alias block_major_33_* ide_generic
alias block_major_34_* ide_generic
alias block_major_37_* ide_tape
alias block_major_44_* ftl
alias block_major_46_* pcd
alias block_major_47_* pf
alias block_major_56_* ide_generic
alias block_major_57_* ide_generic
alias block_major_58_* lvm_mod
alias block_major_88_* ide_generic
alias block_major_89_* ide_generic
alias block_major_90_* ide_generic
alias block_major_91_* ide_generic
alias block_major_93_* nftl
alias block_major_97_* pg
alias char_major_10_1 psmouse
alias char_major_10_139 openprom
alias char_major_10_157 applicom
alias char_major_10_181 toshiba
alias char_major_10_183 hw_random
alias char_major_10_187 irnet
alias char_major_10_189 ussp
alias char_major_10_250 hci_vhci
alias char_major_13_0 joydev
alias char_major_13_1 joydev
alias char_major_13_2 joydev
alias char_major_13_3 joydev
alias char_major_13_32 mousedev
alias char_major_13_33 mousedev
alias char_major_13_34 mousedev
alias char_major_13_35 mousedev
alias char_major_13_63 mousedev
alias char_major_13_64 evdev
alias char_major_13_65 evdev
alias char_major_13_66 evdev
alias char_major_13_67 evdev
alias char_major_19_* cyclades
alias char_major_20_* cyclades
alias char_major_22_* pcxx
alias char_major_23_* pcxx
alias char_major_27_* ftape
alias char_major_34_* scc
alias char_major_35_* tclmidi
alias char_major_48_* riscom8
alias char_major_49_* riscom8
alias char_major_57_* esp
alias char_major_58_* esp
alias char_major_63_* kdebug
alias char_major_67_* coda
alias char_major_75_* specialix
alias char_major_76_* specialix
alias char_major_81_* videodev
alias char_major_83_* vtx
alias char_major_89_* i2c_dev
alias char_major_90_* mtdchar
alias char_major_96_* pt
alias char_major_97_* pg
alias char_major_107_* 3dfx
alias char_major_109_* lvm_mod
alias char_major_166_* cdc_acm
alias char_major_171_0 raw1394
alias char_major_171_1 video1394
alias char_major_171_2 dv1394
alias char_major_171_3 amdtp
alias char_major_180_* usbcore
alias char_major_195_* nvidia
alias char_major_200_* vxspec
alias char_major_202_* msr
alias char_major_203_* cpuid
alias char_major_206_* osst
alias char_major_208_* ussp
alias char_major_227_* tub3270
alias bt_proto_7 avdtp
alias cipcb0 cipcb
alias cipcb1 cipcb
alias cipcb2 cipcb
alias cipcb3 cipcb
alias dummy0 dummy
alias dummy1 dummy
alias plip0 plip
alias plip1 plip
alias slip0 slip
alias slip1 slip
alias tunl0 ipip
alias gre0 ip_gre
alias usbdevfs usbcore
alias char_major_195* nvidia
options snd_pcsp index=-2
options snd_usb_audio index=-2
options bt87x index=-2
options cx88_alsa index=-2
options snd_atiixp_modem index=-2
options snd_intel8x0m index=-2
options snd_via82xx_modem index=-2
options snd_hda_intel model=6stack-dig index=0
options snd_usb_audio index=1
options dvb_ttpci adapter_nr=1
options budget_ci adapter_nr=0
options nbd max_part=15
options nvidia NVreg_DeviceFileUID=0 NVreg_DeviceFileGID=44 NVreg_DeviceFileMode=0660
options libata force=noncq
options systemd log_target=kmsg
softdep uhci_hcd pre: ehci-hcd
softdep ohci_hcd pre: ehci-hcd
softdep snd_pcm post: snd-pcm-oss
softdep snd_mixer post: snd-mixer-oss
softdep snd_seq post: snd-seq-midi snd-seq-oss

# End of configuration files. Dumping indexes now:


Sincerely
Philipp
-- 
Philipp Hahn <pmhahn@pmhahn.de>

--Boundary-00=_TQQ5RsqHYme4gU5
Content-Type: text/plain;
  charset="UTF-8";
  name="bug.snd.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bug.snd.dmesg"

SysRq : Show State
  task                        PC stack   pid father
systemd         S ffff88023fc12640     0     1      0 0x00000000
 ffff8802350a3dd0 0000000000000086 ffff8802350a3fd8 ffff8802350a3fd8
 0000000000012640 ffff8802350a0040 ffff8802350a0040 0000000000000000
 0000000000000000 ffff8802350a3c60 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8110f347>] ? __d_free+0x4b/0x50
 [<ffffffff8110fc40>] ? d_free+0x3d/0x4e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
kthreadd        S ffff88023fc92640     0     2      0 0x00000000
 ffff8802350a7f00 0000000000000046 ffff8802350a7fd8 ffff8802350a7fd8
 0000000000012640 ffff8802350a4080 ffff88023fc12640 0000000000012640
 ffff8802351f8eb2 0000000000000246 ffff8802350a7e68 ffff8802350a7e68
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8105701b>] ? wake_up_new_task+0x12b/0x170
 [<ffffffff8102cf51>] ? do_fork+0x189/0x2c8
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8105713b>] ? set_cpus_allowed_ptr+0xdb/0xed
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8104b28b>] kthreadd+0xb7/0x139
 [<ffffffff8104b1d4>] ? kthread_create_on_cpu+0x48/0x48
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104b1d4>] ? kthread_create_on_cpu+0x48/0x48
ksoftirqd/0     S ffff88023fc12640     0     3      2 0x00000000
 ffff8802350ade58 0000000000000046 ffff8802350adfd8 ffff8802350adfd8
 0000000000012640 ffff8802350aa0c0 ffff880234fdbdf0 ffff8802350adde0
 ffffffff812ebfba 000000000000000a 0000000000013140 0000000000000000
Call Trace:
 [<ffffffff812ebfba>] ? net_tx_action+0xce/0x1bc
 [<ffffffff81033fe8>] ? __local_bh_enable+0x6c/0x6f
 [<ffffffff810343e7>] ? __do_softirq+0x1c9/0x25b
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81050f99>] smpboot_thread_fn+0x1f6/0x251
 [<ffffffff81050da3>] ? lg_global_unlock+0x63/0x63
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/0:0H    S ffff88023fc12640     0     5      2 0x00000000
 ffff8802350b7e58 0000000000000046 ffff8802350b7fd8 ffff8802350b7fd8
 0000000000012640 ffff8802350b4140 ffff8802353717a8 ffff8802350b7df0
 ffffffff812635b6 ffff8802350b7df0 ffffffff81056e91 ffff88023fc12640
Call Trace:
 [<ffffffff812635b6>] ? scsi_request_fn+0x131/0x470
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
migration/0     S 0000000000000000     0     7      2 0x00000000
 ffff8802350c1e58 0000000000000046 ffff8802350c1fd8 ffff8802350c1fd8
 0000000000012640 ffff8802350be1c0 ffff8802350c1da0 ffff8802350c1da0
 ffffffff8139ce72 ffff8802350c1e68 ffffffff81088934 ffff8802350c1fd8
Call Trace:
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff81088934>] ? cpu_stopper_thread+0x7b/0x13f
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81050f99>] smpboot_thread_fn+0x1f6/0x251
 [<ffffffff81050da3>] ? lg_global_unlock+0x63/0x63
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
rcu_preempt     S 0000000000000001     0     8      2 0x00000000
 ffff8802350c5e30 0000000000000046 ffff8802350c5fd8 ffff8802350c5fd8
 0000000000012640 ffff8802350c2200 0000000100000003 0000000000000000
 ffffffff815947c0 0000000000000246 ffff8802350c5da0 ffffffff810968a1
Call Trace:
 [<ffffffff810968a1>] ? rcu_report_qs_rsp+0x64/0x69
 [<ffffffff8109694a>] ? rcu_report_qs_rnp+0xa4/0xaf
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81096ad5>] ? force_qs_rnp+0x10c/0x119
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81098410>] rcu_gp_kthread+0x90/0x54d
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff81098380>] ? rcu_gp_fqs+0x5f/0x5f
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
rcu_bh          S 0000000000000001     0     9      2 0x00000000
 ffff8802350cbe30 0000000000000046 ffff8802350cbfd8 ffff8802350cbfd8
 0000000000012640 ffff8802350c8240 0000000100000003 0000000000000000
 ffffffff81594b00 0000000000000246 ffff8802350cbda0 ffffffff810968a1
Call Trace:
 [<ffffffff810968a1>] ? rcu_report_qs_rsp+0x64/0x69
 [<ffffffff8109694a>] ? rcu_report_qs_rnp+0xa4/0xaf
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81096ad5>] ? force_qs_rnp+0x10c/0x119
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81098410>] rcu_gp_kthread+0x90/0x54d
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff81098380>] ? rcu_gp_fqs+0x5f/0x5f
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
rcu_sched       S 0000000000000000     0    10      2 0x00000000
 ffff8802350cfe30 0000000000000046 ffff8802350cffd8 ffff8802350cffd8
 0000000000012640 ffff8802350cc280 ffff8802350cfd88 ffffffff8105c5f6
 ffff8802350cc2c8 ffff88023fc126b0 ffff8802350cc2c8 ffff8802350cfdb8
Call Trace:
 [<ffffffff8105c5f6>] ? set_next_entity+0x3f/0x96
 [<ffffffff8105c736>] ? pick_next_task_fair+0xb9/0x11f
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff8139bb9c>] ? __schedule+0x6a5/0x8b4
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81098410>] rcu_gp_kthread+0x90/0x54d
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff81098380>] ? rcu_gp_fqs+0x5f/0x5f
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
migration/1     S ffff88023fc92640     0    11      2 0x00000000
 ffff8802350ffe58 0000000000000046 ffff8802350fffd8 ffff8802350fffd8
 0000000000012640 ffff8802350fc380 ffff8802350ffda0 ffff8802350ffda0
 ffffffff8139ce72 ffff8802350ffe68 ffffffff81088934 ffff8802350fffd8
Call Trace:
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff81088934>] ? cpu_stopper_thread+0x7b/0x13f
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81050f99>] smpboot_thread_fn+0x1f6/0x251
 [<ffffffff81050da3>] ? lg_global_unlock+0x63/0x63
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ksoftirqd/1     S 0000000000000001     0    12      2 0x00000000
 ffff880235105e58 0000000000000046 ffff880235105fd8 ffff880235105fd8
 0000000000012640 ffff8802351023c0 ffffffff8139ce17 ffff880235105de0
 ffffffff812ec002 000000000000000a 0000000000013140 ffff88022bd251c0
Call Trace:
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff812ec002>] ? net_tx_action+0x116/0x1bc
 [<ffffffff81033fe8>] ? __local_bh_enable+0x6c/0x6f
 [<ffffffff810343e7>] ? __do_softirq+0x1c9/0x25b
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81050f99>] smpboot_thread_fn+0x1f6/0x251
 [<ffffffff81050da3>] ? lg_global_unlock+0x63/0x63
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/1:0H    S 0000000000000001     0    14      2 0x00000000
 ffff88023510fe58 0000000000000046 ffff88023510ffd8 ffff88023510ffd8
 0000000000012640 ffff88023510c440 ffff880235371038 ffff88023510fdf0
 ffffffff812635b6 ffff88023510fdf0 ffffffff81056e91 ffffffff8103a4ed
Call Trace:
 [<ffffffff812635b6>] ? scsi_request_fn+0x131/0x470
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
khelper         S 0000000000000001     0    15      2 0x00000000
 ffff880235119e48 0000000000000046 ffff880235119fd8 ffff880235119fd8
 0000000000012640 ffff880235112480 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880235119df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdevtmpfs       S 0000000000000001     0    16      2 0x00000000
 ffff88023511de80 0000000000000046 ffff88023511dfd8 ffff88023511dfd8
 0000000000012640 ffff88023511a4c0 ffff88023511ddc0 ffffffff8139ce45
 ffff88023511de10 ffffffff81056e91 ffff88023fc12640 0000000000000046
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff81056ee1>] ? default_wake_function+0xd/0xf
 [<ffffffff810514b9>] ? __wake_up_common+0x51/0x7e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81256d36>] devtmpfsd+0x11c/0x138
 [<ffffffff81256c1a>] ? handle_create.isra.2+0x1cf/0x1cf
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
netns           S 0000000000000000     0    17      2 0x00000000
 ffff880235143e48 0000000000000046 ffff880235143fd8 ffff880235143fd8
 0000000000012640 ffff880235140500 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880235143df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
writeback       S 0000000000000000     0   149      2 0x00000000
 ffff8802353dbe48 0000000000000046 ffff8802353dbfd8 ffff8802353dbfd8
 0000000000012640 ffff8802353d82c0 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802353dbdf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kintegrityd     S 0000000000000001     0   151      2 0x00000000
 ffff8802353e3e48 0000000000000046 ffff8802353e3fd8 ffff8802353e3fd8
 0000000000012640 ffff8802353e0340 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff8802353e3df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S 0000000000000001     0   152      2 0x00000000
 ffff880234c05e48 0000000000000046 ffff880234c05fd8 ffff880234c05fd8
 0000000000012640 ffff880234c02380 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880234c05df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kblockd         S 0000000000000001     0   154      2 0x00000000
 ffff880234c0fe48 0000000000000046 ffff880234c0ffd8 ffff880234c0ffd8
 0000000000012640 ffff880234c0c400 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880234c0fdf8 ffff880234c0fe20 ffffffff81058929
Call Trace:
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ata_sff         S 0000000000000001     0   280      2 0x00000000
 ffff880235381e48 0000000000000046 ffff880235381fd8 ffff880235381fd8
 0000000000012640 ffff8802353367c0 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880235381df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
khubd           S ffff88023fc92640     0   287      2 0x00000000
 ffff8802353afdc8 0000000000000046 ffff8802353affd8 ffff8802353affd8
 0000000000012640 ffff88023533a8c0 ffff880233634210 ffff8802336342c8
 ffff880233995488 ffff8802353afd30 ffffffff81258fa8 ffff880233634210
Call Trace:
 [<ffffffff81258fa8>] ? device_pm_sleep_init+0x44/0x69
 [<ffffffff8125152d>] ? device_register+0x15/0x18
 [<ffffffff81299072>] ? usb_create_ep_devs+0x78/0xae
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8128fe37>] hub_thread+0xc13/0xde4
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff8128f224>] ? hub_port_debounce+0xce/0xce
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
khungtaskd      S 0000000000000000     0   403      2 0x00000000
 ffff880233d39dc8 0000000000000046 ffff880233d39fd8 ffff880233d39fd8
 0000000000012640 ffff880234cce680 ffffffff81059a4c ffff880234cce6c8
 ffff88023fc12640 ffff880234cce6c8 ffff88023fc12640 0000000000000001
Call Trace:
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8105ba77>] ? dequeue_task_fair+0x62a/0x639
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffff8139a355>] schedule_timeout_interruptible+0x19/0x1b
 [<ffffffff81092182>] watchdog+0x45/0x208
 [<ffffffff8109213d>] ? hung_task_panic+0x12/0x12
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kswapd0         S 0000000000000001     0   409      2 0x00000000
 ffff880233d45e18 0000000000000046 ffff880233d45fd8 ffff880233d45fd8
 0000000000012640 ffff88023520a540 ffffffff8139ce45 ffff880233d45d80
 ffffffff8103a5ba 0000000033d45db0 0000000000000286 ffff880233d45db0
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8103a5ba>] ? try_to_del_timer_sync+0x50/0x5b
 [<ffffffff810bfc6e>] ? zone_watermark_ok_safe+0x9d/0xa8
 [<ffffffff810c8caa>] ? zone_balanced+0x19/0x3e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810cc002>] kswapd+0x266/0x3f2
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff810cbd9c>] ? balance_pgdat+0x489/0x489
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ksmd            S 0000000000000000     0   410      2 0x00000000
 ffff880233d85e20 0000000000000046 ffff880233d85fd8 ffff880233d85fd8
 0000000000012640 ffff880235384700 ffff88023fc126b0 ffff88023fc12640
 0000000000000005 ffff880233d85dd0 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810ee325>] ksm_scan_thread+0x3bd/0xb5d
 [<ffffffff810514b9>] ? __wake_up_common+0x51/0x7e
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff810edf68>] ? run_store+0x2ee/0x2ee
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
khugepaged      S 0000000000000001     0   411      2 0x00000000
 ffff880233d87d98 0000000000000046 ffff880233d87fd8 ffff880233d87fd8
 0000000000012640 ffff880234cb0500 ffffffff8139ce17 ffff880233d87d28
 0000000000000282 0000000933d87d20 0000000000000b80 ffffffff815cff50
Call Trace:
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff810c1b5d>] ? free_compound_page+0x33/0x38
 [<ffffffff810c56cd>] ? __put_compound_page+0x1a/0x1d
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810f405c>] khugepaged+0xe1f/0x1040
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff810f323d>] ? maybe_pmd_mkwrite+0x15/0x15
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
fsnotify_mark   S 0000000000000001     0   412      2 0x00000000
 ffff880233d89e40 0000000000000046 ffff880233d89fd8 ffff880233d89fd8
 0000000000012640 ffff880234c283c0 0000000000000000 000000000006ad0e
 0000000033d89d98 ffff880233d89d98 ffff8802339aa600 0000000033d89de0
Call Trace:
 [<ffffffff8104ee6e>] ? srcu_reschedule+0xaa/0xc2
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81132919>] fsnotify_mark_destroy+0x134/0x14a
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff811327e5>] ? fsnotify_put_mark+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
crypto          S 0000000000000000     0   413      2 0x00000000
 ffff880233da9e48 0000000000000046 ffff880233da9fd8 ffff880233da9fd8
 0000000000012640 ffff8802353d4280 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233da9df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
scsi_eh_0       S 0000000000000000     0   453      2 0x00000000
 ffff880233e19e28 0000000000000046 ffff880233e19fd8 ffff880233e19fd8
 0000000000012640 ffff880234c46380 0000000000000000 ffff880233d3ef00
 ffff880233d3eef8 0000000000000086 0000000000000000 ffff880233e19d90
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff810533cf>] ? __wake_up+0x3f/0x46
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8125dfa8>] ? __scsi_iterate_devices+0x56/0x71
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81261e27>] scsi_error_handler+0x75/0x3d8
 [<ffffffff81056ee1>] ? default_wake_function+0xd/0xf
 [<ffffffff81261db2>] ? scsi_eh_get_sense+0xa2/0xa2
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
scsi_eh_1       S 0000000000000000     0   456      2 0x00000000
 ffff880233e23e28 0000000000000046 ffff880233e23fd8 ffff880233e23fd8
 0000000000012640 ffff880233e20140 0000000000000000 ffff880233e12f00
 ffff880233e12ef8 0000000000000086 0000000000000000 ffff880233e23d90
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff810533cf>] ? __wake_up+0x3f/0x46
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8125dfa8>] ? __scsi_iterate_devices+0x56/0x71
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81261e27>] scsi_error_handler+0x75/0x3d8
 [<ffffffff81056ee1>] ? default_wake_function+0xd/0xf
 [<ffffffff81261db2>] ? scsi_eh_get_sense+0xa2/0xa2
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/u8:3    S 0000000000000001     0   460      2 0x00000000
 ffff880233e31e58 0000000000000046 ffff880233e31fd8 ffff880233e31fd8
 0000000000012640 ffff880233e2e180 0000000000000206 ffff880234f00908
 ffff880233e31fd8 ffff880233e31fd8 ffff880234f00b38 ffff880233e31dc8
Call Trace:
 [<ffffffff81120c91>] ? bdi_writeback_workfn+0x17c/0x20a
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
scsi_eh_2       S 0000000000000000     0   467      2 0x00000000
 ffff880233e51e28 0000000000000046 ffff880233e51fd8 ffff880233e51fd8
 0000000000012640 ffff880233e4e340 ffff880233e47848 ffff880233e427e8
 0000000000000246 ffff880233dd0040 ffff880233dd0000 0000000000000246
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81250072>] ? put_device+0x12/0x14
 [<ffffffff8125df4d>] ? scsi_device_put+0x3e/0x43
 [<ffffffff8125dfb5>] ? __scsi_iterate_devices+0x63/0x71
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81261e27>] scsi_error_handler+0x75/0x3d8
 [<ffffffff81056ee1>] ? default_wake_function+0xd/0xf
 [<ffffffff81261db2>] ? scsi_eh_get_sense+0xa2/0xa2
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
scsi_eh_3       S 0000000000000000     0   470      2 0x00000000
 ffff880233e5de28 0000000000000046 ffff880233e5dfd8 ffff880233e5dfd8
 0000000000012640 ffff880233e5a400 ffff880233e47048 ffff880233e42078
 0000000000000246 ffff880233dd8840 ffff880233dd8800 0000000000000246
Call Trace:
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81250072>] ? put_device+0x12/0x14
 [<ffffffff8125df4d>] ? scsi_device_put+0x3e/0x43
 [<ffffffff8125dfb5>] ? __scsi_iterate_devices+0x63/0x71
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81261e27>] scsi_error_handler+0x75/0x3d8
 [<ffffffff81056ee1>] ? default_wake_function+0xd/0xf
 [<ffffffff81261db2>] ? scsi_eh_get_sense+0xa2/0xa2
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/u8:4    S 0000000000000000     0   473      2 0x00000000
 ffff880233e69e58 0000000000000046 ffff880233e69fd8 ffff880233e69fd8
 0000000000012640 ffff880233e664c0 0000000000000206 ffff880234f00198
 ffff880233e69fd8 ffff880233e69fd8 ffff880234f003c8 ffff880233e69dc8
Call Trace:
 [<ffffffff81120c91>] ? bdi_writeback_workfn+0x17c/0x20a
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/0:2     S ffff88023fc12640     0   482      2 0x00000000
 ffff880233d3be58 0000000000000046 ffff880233d3bfd8 ffff880233d3bfd8
 0000000000012640 ffff880233e5e440 ffff88023e864a00 ffff880233d3bdb0
 ffff880233d3bdb8 ffffffff8139ccc6 ffff880233d3bdb8 ffffffff8139ce45
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8122d57a>] ? tty_ldisc_deref+0x6c/0x90
 [<ffffffff8122e793>] ? flush_to_ldisc+0x13e/0x14b
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
deferwq         S 0000000000000000     0   527      2 0x00000000
 ffff880233db7e48 0000000000000046 ffff880233db7fd8 ffff880233db7fd8
 0000000000012640 ffff880234c7a440 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233db7df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
firewire        S ffff88023fc92640     0   705      2 0x00000000
 ffff880233b0de48 0000000000000046 ffff880233b0dfd8 ffff880233b0dfd8
 0000000000012640 ffff880233bac580 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880233b0ddf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S 0000000000000000     0   726      2 0x00000000
 ffff880233aafe48 0000000000000046 ffff880233aaffd8 ffff880233aaffd8
 0000000000012640 ffff880233858200 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233aafdf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S 0000000000000000     0   727      2 0x00000000
 ffff880233569e48 0000000000000046 ffff880233569fd8 ffff880233569fd8
 0000000000012640 ffff880233b1c080 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233569df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S 0000000000000000     0   734      2 0x00000000
 ffff880233bb5e48 0000000000000046 ffff880233bb5fd8 ffff880233bb5fd8
 0000000000012640 ffff880233b18040 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233bb5df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S 0000000000000000     0   735      2 0x00000000
 ffff880233581e48 0000000000000046 ffff880233581fd8 ffff880233581fd8
 0000000000012640 ffff880233a14180 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233581df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S 0000000000000000     0   754      2 0x00000000
 ffff8802335a3e48 0000000000000046 ffff8802335a3fd8 ffff8802335a3fd8
 0000000000012640 ffff880233ef4180 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802335a3df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139b502>] ? __schedule+0xb/0x8b4
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
jbd2/dm-0-8     S 0000000000000000     0   767      2 0x00000000
 ffff880233ae1e30 0000000000000046 ffff880233ae1fd8 ffff880233ae1fd8
 0000000000012640 ffff880233a820c0 ffff8802337593ac 0001a0bf0001a0be
 ffff88020f312cf8 0000000000388028 ffff8802301c1f68 000000000000001f
Call Trace:
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa0158640>] kjournald2+0x1a8/0x22d [jbd2]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa0158498>] ? commit_timeout+0xb/0xb [jbd2]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ext4-dio-unwrit S 0000000000000000     0   768      2 0x00000000
 ffff880233fc7e48 0000000000000046 ffff880233fc7fd8 ffff880233fc7fd8
 0000000000012640 ffff880233bdc1c0 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880233fc7df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
systemd-journal S 0000000000000001     0   799      1 0x00000000
 ffff880233b5bdd0 0000000000000086 ffff880233b5bfd8 ffff880233b5bfd8
 0000000000012640 ffff880233b1e740 0000000000000000 0000000000000000
 0000000000000000 ffffffffa017bd17 0000000033b5bd70 0fe000020f09ccf8
Call Trace:
 [<ffffffffa017bd17>] ? ext4_mark_iloc_dirty+0x2cd/0x5ee [ext4]
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8110f347>] ? __d_free+0x4b/0x50
 [<ffffffff8110fc40>] ? d_free+0x3d/0x4e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
kauditd         S ffff88023fc92640     0   800      2 0x00000000
 ffff880233fbde50 0000000000000046 ffff880233fbdfd8 ffff880233fbdfd8
 0000000000012640 ffff880234c7e480 ffffffff8139ce72 ffff880233fbddb8
 ffffffff8105363f 0000000000012640 ffff880233b60400 0000000000000000
Call Trace:
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff8105363f>] ? finish_task_switch+0x48/0xbc
 [<ffffffff8139bb9c>] ? __schedule+0x6a5/0x8b4
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8108940a>] kauditd_thread+0x12b/0x159
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff810892df>] ? audit_printk_skb+0x5a/0x5a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
udevd           S 0000000000000001     0   824      1 0x00000000
 ffff880233f65dd0 0000000000000086 ffff880233f65fd8 ffff880233f65fd8
 0000000000012640 ffff880233ab6880 ffff880233f65ed0 ffff880233f65e60
 ffffffff812da83c 000000403fc8d340 ffff880233f65d58 0000000000000246
Call Trace:
 [<ffffffff812da83c>] ? sock_recvmsg+0xb1/0xd0
 [<ffffffff810979ae>] ? call_rcu+0x12/0x14
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff811360d3>] ? ep_scan_ready_list.isra.10+0x15e/0x17e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
ecryptfs-kthrea S 0000000000000000     0   853      2 0x00000000
 ffff880233a8de50 0000000000000046 ffff880233a8dfd8 ffff880233a8dfd8
 0000000000012640 ffff880233a8e080 ffffffff8139ce72 ffff880233a8ddb8
 ffffffff8105363f 0000000000012640 ffff880233b678c0 0000000000000000
Call Trace:
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff8105363f>] ? finish_task_switch+0x48/0xbc
 [<ffffffff8139bb9c>] ? __schedule+0x6a5/0x8b4
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa022f6c8>] ecryptfs_threadfn+0x9b/0x1f2 [ecryptfs]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa022f62d>] ? ecryptfs_add_global_auth_tok+0x98/0x98 [ecryptfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/0:1H    S 0000000000000000     0   865      2 0x00000000
 ffff8802334b5e58 0000000000000046 ffff8802334b5fd8 ffff8802334b5fd8
 0000000000012640 ffff880235200040 ffff880235371038 ffff8802334b5df0
 ffffffff812635b6 ffff8802339dbbc0 0000000000000000 0000000000012640
Call Trace:
 [<ffffffff812635b6>] ? scsi_request_fn+0x131/0x470
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kvm-irqfd-clean S 0000000000000001     0   873      2 0x00000000
 ffff880234cd5e48 0000000000000046 ffff880234cd5fd8 ffff880234cd5fd8
 0000000000012640 ffff880233bd0780 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880234cd5df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S ffff88023fc12640     0   948      2 0x00000000
 ffff880234571e48 0000000000000046 ffff880234571fd8 ffff880234571fd8
 0000000000012640 ffff88023456e240 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880234571df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S ffff88023fc12640     0   949      2 0x00000000
 ffff880234575e48 0000000000000046 ffff880234575fd8 ffff880234575fd8
 0000000000012640 ffff880234572280 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880234575df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S ffff88023fc12640     0   950      2 0x00000000
 ffff880234579e48 0000000000000046 ffff880234579fd8 ffff880234579fd8
 0000000000012640 ffff8802345762c0 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff880234579df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S ffff88023fc12640     0   951      2 0x00000000
 ffff88023459de48 0000000000000046 ffff88023459dfd8 ffff88023459dfd8
 0000000000012640 ffff88023459a300 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff88023459ddf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S ffff88023fc12640     0   952      2 0x00000000
 ffff8802345a1e48 0000000000000046 ffff8802345a1fd8 ffff8802345a1fd8
 0000000000012640 ffff88023459e340 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802345a1df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S ffff88023fc12640     0   953      2 0x00000000
 ffff8802345c5e48 0000000000000046 ffff8802345c5fd8 ffff8802345c5fd8
 0000000000012640 ffff8802345c2380 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802345c5df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S ffff88023fc12640     0   954      2 0x00000000
 ffff8802345cbe48 0000000000000046 ffff8802345cbfd8 ffff8802345cbfd8
 0000000000012640 ffff8802345c83c0 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802345cbdf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S ffff88023fc12640     0   955      2 0x00000000
 ffff8802345ede48 0000000000000046 ffff8802345edfd8 ffff8802345edfd8
 0000000000012640 ffff8802345ea400 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802345eddf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S ffff88023fc92640     0   959      2 0x00000000
 ffff88023415fe48 0000000000000046 ffff88023415ffd8 ffff88023415ffd8
 0000000000012640 ffff88023415c140 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff88023415fdf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S ffff88023fc92640     0   968      2 0x00000000
 ffff8802337f1e48 0000000000000046 ffff8802337f1fd8 ffff8802337f1fd8
 0000000000012640 ffff8802337ee5c0 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff8802337f1df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kdmflush        S ffff88023fc92640     0   973      2 0x00000000
 ffff88023421de48 0000000000000046 ffff88023421dfd8 ffff88023421dfd8
 0000000000012640 ffff88023421a680 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff88023421ddf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
bioset          S ffff88023fc92640     0   983      2 0x00000000
 ffff88023409fe48 0000000000000046 ffff88023409ffd8 ffff88023409ffd8
 0000000000012640 ffff88023409c040 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff88023409fdf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
udevd           S ffff88023fc92640     0   996    824 0x00000000
 ffff880233c7bdd0 0000000000000082 ffff880233c7bfd8 ffff880233c7bfd8
 0000000000012640 ffff880233c78380 ffff880233c7be98 0000000000000008
 0000000000000000 00007fff9a2da4e0 ffff880233c7be68 ffffffff812da731
Call Trace:
 [<ffffffff812da731>] ? sock_sendmsg+0x8f/0xab
 [<ffffffff812dafa2>] ? ___sys_sendmsg+0x1e1/0x256
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff811360d3>] ? ep_scan_ready_list.isra.10+0x15e/0x17e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
udevd           S ffff88023fc92640     0   997    824 0x00000000
 ffff880233c99dd0 0000000000000086 ffff880233c99fd8 ffff880233c99fd8
 0000000000012640 ffff880234568200 00000000810c285b ffff880233c99d68
 0000000000000009 ffffea0007a90990 0000000000000001 ffffffff815cff00
Call Trace:
 [<ffffffff810c5e70>] ? release_pages+0x1da/0x1e9
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff811360d3>] ? ep_scan_ready_list.isra.10+0x15e/0x17e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff811cf8ea>] ? __percpu_counter_add+0x6e/0x90
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
sh              S ffff88023fc92640     0  1050      1 0x00000000
 ffff88022fe57e78 0000000000000086 ffff88022fe57fd8 ffff88022fe57fd8
 0000000000012640 ffff880234fec040 ffff880234373100 000000000061c500
 ffff88023fc926b0 000000000061c500 ffff880234373100 ffff880234095d98
Call Trace:
 [<ffffffff810dc8c1>] ? handle_mm_fault+0x22f/0x26d
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff8103114a>] ? wait_consider_task+0x6f/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
kpsmoused       S ffff88023fc92640     0  1052      2 0x00000000
 ffff880234cc5e48 0000000000000046 ffff880234cc5fd8 ffff880234cc5fd8
 0000000000012640 ffff8802342960c0 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880234cc5df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
sh              S ffff88023fc12640     0  1057      1 0x00000000
 ffff88023433be78 0000000000000082 ffff88023433bfd8 ffff88023433bfd8
 0000000000012640 ffff8802342b8100 ffff880233891180 000000000061c500
 ffff88023fc126b0 000000000061c500 ffff880233891180 ffff880234598818
Call Trace:
 [<ffffffff810dc8c1>] ? handle_mm_fault+0x22f/0x26d
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff8103114a>] ? wait_consider_task+0x6f/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
modprobe        D ffff88023fc12640     0  1082   1050 0x00000000
 ffff88022fd9d948 0000000000000086 ffff88022fd9dfd8 ffff88022fd9dfd8
 0000000000012640 ffff880234cd26c0 ffff88022fd9d8a8 ffffffff8105363f
 0000000000012640 ffff880233c1eb00 ffff880233b60400 0000000000012640
Call Trace:
 [<ffffffff8105363f>] ? finish_task_switch+0x48/0xbc
 [<ffffffff8139bb9c>] ? __schedule+0x6a5/0x8b4
 [<ffffffff81054cd3>] ? check_preempt_curr+0x2b/0x67
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a16e>] schedule_timeout+0x2a/0x1f8
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139b301>] wait_for_common+0x10c/0x14c
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff8139b3bf>] wait_for_completion_killable+0x18/0x2c
 [<ffffffff81042ebb>] call_usermodehelper_exec+0xb1/0x119
 [<ffffffffa04ecb5f>] ? snd_seq_client_use_ptr+0xa9/0x12a [snd_seq]
 [<ffffffff8104310e>] __request_module+0x1eb/0x25c
 [<ffffffffa04ecb5f>] snd_seq_client_use_ptr+0xa9/0x12a [snd_seq]
 [<ffffffffa04ece13>] snd_seq_ioctl_query_next_client+0x54/0xa6 [snd_seq]
 [<ffffffffa04ec4fc>] snd_seq_do_ioctl+0x5d/0x71 [snd_seq]
 [<ffffffffa04ec554>] snd_seq_kernel_client_ctl+0x44/0x50 [snd_seq]
 [<ffffffffa0525300>] snd_seq_oss_midi_lookup_ports+0x77/0xc1 [snd_seq_oss]
 [<ffffffffa05251b0>] snd_seq_oss_create_client+0x5d/0x126 [snd_seq_oss]
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff8114d3e8>] ? proc_alloc_inum+0x4e/0xa9
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff8114d53e>] ? proc_register+0xfb/0x105
 [<ffffffff8114d6e1>] ? proc_create_data+0x86/0xa0
 [<ffffffffa03e5e0a>] ? snd_info_register+0xd8/0xe5 [snd]
 [<ffffffffa0525103>] alsa_seq_oss_init+0x103/0x153 [snd_seq_oss]
 [<ffffffffa0525000>] ? 0xffffffffa0524fff
 [<ffffffff81000263>] do_one_initcall+0x7b/0x10a
 [<ffffffff8107ab67>] load_module+0x15ed/0x1c32
 [<ffffffff81076f53>] ? sys_getegid16+0x50/0x50
 [<ffffffff8107b23e>] SyS_init_module+0x92/0x9f
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
modprobe        S ffff88023fc92640     0  1088   1057 0x00000000
 ffff8802345f5dd0 0000000000000086 ffff8802345f5fd8 ffff8802345f5fd8
 0000000000012640 ffff8802341da480 0000000000000163 ffffffffa0533000
 0000000300000000 ffff8802345f5d70 00000000000000d2 ffffffff81591ad0
Call Trace:
 [<ffffffff8104d1c1>] ? mutex_spin_on_owner+0x3e/0x4d
 [<ffffffff8139ac80>] ? __mutex_lock_slowpath+0x190/0x1b8
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81079eaf>] load_module+0x935/0x1c32
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff8107b23e>] SyS_init_module+0x92/0x9f
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
kworker/u8:3    S ffff88023fc92640     0  1125    460 0x00000000
 ffff88022f07de20 0000000000000046 ffff88022f07dfd8 ffff88022f07dfd8
 0000000000012640 ffff880234056880 ffff88022f07ddb8 ffffffff816eea70
 ffff88022f07dd98 ffffffff8104f390 0000000000000000 ffff88022f07ddb8
Call Trace:
 [<ffffffff8104f390>] ? __atomic_notifier_call_chain+0x40/0x4a
 [<ffffffff810599f3>] ? update_curr+0x7d/0x148
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff8103114a>] ? wait_consider_task+0x6f/0x9e8
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff81042df1>] wait_for_helper+0x7e/0x97
 [<ffffffff81042d73>] ? __call_usermodehelper+0x7b/0x7b
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81042d73>] ? __call_usermodehelper+0x7b/0x7b
modprobe        S ffff88023fc12640     0  1126   1125 0x00000000
 ffff880234181dd0 0000000000000082 ffff880234181fd8 ffff880234181fd8
 0000000000012640 ffff880234290080 0000000000000163 ffffffffa056e000
 0000000300000000 ffff880234181d70 00000000000000d2 ffffffff81591ad0
Call Trace:
 [<ffffffff8104d1c1>] ? mutex_spin_on_owner+0x3e/0x4d
 [<ffffffff8139ac80>] ? __mutex_lock_slowpath+0x190/0x1b8
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81079eaf>] load_module+0x935/0x1c32
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff8107b23e>] SyS_init_module+0x92/0x9f
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
hd-audio0       S 0000000000000001     0  1149      2 0x00000000
 ffff8802345fde48 0000000000000046 ffff8802345fdfd8 ffff8802345fdfd8
 0000000000012640 ffff88023370e700 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff8802345fddf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/u9:0    S 0000000000000000     0  1153      2 0x00000000
 ffff88022de33e58 0000000000000046 ffff88022de33fd8 ffff88022de33fd8
 0000000000012640 ffff88022fd36680 ffff88022fd36680 ffffffff81056ed4
 dead000000100100 dead000000200200 ffff880234194600 ffff88022dc7bf10
Call Trace:
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff8139ccfa>] ? _raw_spin_lock_irq+0x13/0x2f
 [<ffffffff81044a1c>] ? destroy_worker+0x97/0x9c
 [<ffffffff81045a3f>] ? manage_workers.isra.27+0x1ad/0x1bf
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
hci0            S ffff88023fc92640     0  1154      2 0x00000000
 ffff8802343e9e48 0000000000000046 ffff8802343e9fd8 ffff8802343e9fd8
 0000000000012640 ffff880233a34680 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff8802343e9df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
hci0            S ffff88023fc92640     0  1155      2 0x00000000
 ffff88022dc79e48 0000000000000046 ffff88022dc79fd8 ffff88022dc79fd8
 0000000000012640 ffff8802341a4640 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff88022dc79df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/u9:2    S 0000000000000000     0  1160      2 0x00000000
 ffff8802337f5e58 0000000000000046 ffff8802337f5fd8 ffff8802337f5fd8
 0000000000012640 ffff8802337f8640 ffff8802337f5db8 ffffffff8103a4ed
 ffff8802337f5db8 ffffffff8103a112 ffff8802337f5db8 ffffffff8139ce45
Call Trace:
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8103a112>] ? internal_add_timer+0x12/0x32
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8103a91f>] ? mod_timer+0x17a/0x1c8
 [<ffffffffa11336b6>] ? hci_cmd_work+0xab/0xd3 [bluetooth]
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
arm_mon         S 0000000000000001     0  1175      2 0x00000000
 ffff8802340eddb8 0000000000000046 ffff8802340edfd8 ffff8802340edfd8
 0000000000012640 ffff88022f062780 00000000fffb7f25 ffff8802340edd08
 ffff88023fc8d1c0 ffff8802350dc000 0000000000000000 0000000100000000
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa04c4883>] arm_thread+0xc8/0x389 [dvb_ttpci]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa04c47bb>] ? init_av7110_av+0x376/0x376 [dvb_ttpci]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
jbd2/dm-3-8     S 0000000000000000     0  1270      2 0x00000000
 ffff88022dda1e30 0000000000000046 ffff88022dda1fd8 ffff88022dda1fd8
 0000000000012640 ffff880234540180 ffff88022fcfe3ac 001db2c0001db2bf
 ffff88020f312358 0000000000c8800b ffff880230188678 0000000000000004
Call Trace:
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa0158640>] kjournald2+0x1a8/0x22d [jbd2]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa0158498>] ? commit_timeout+0xb/0xb [jbd2]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ext4-dio-unwrit S 0000000000000001     0  1271      2 0x00000000
 ffff88023426fe48 0000000000000046 ffff88023426ffd8 ffff88023426ffd8
 0000000000012640 ffff88022fe0e500 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff88023426fdf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
jbd2/dm-2-8     S 0000000000000000     0  1272      2 0x00000000
 ffff88023430be30 0000000000000046 ffff88023430bfd8 ffff88023430bfd8
 0000000000012640 ffff8802340a2080 ffff880234f20bac 0042d8210042d81f
 ffff88020f3127b8 0000000000108aca ffff88022b4957b0 0000000000000aba
Call Trace:
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa0158640>] kjournald2+0x1a8/0x22d [jbd2]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa0158498>] ? commit_timeout+0xb/0xb [jbd2]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ext4-dio-unwrit S 0000000000000000     0  1273      2 0x00000000
 ffff88022dd25e48 0000000000000046 ffff88022dd25fd8 ffff88022dd25fd8
 0000000000012640 ffff8802337f2600 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff88022dd25df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
jbd2/dm-5-8     S 0000000000000000     0  1295      2 0x00000000
 ffff88022f135e30 0000000000000046 ffff88022f135fd8 ffff88022f135fd8
 0000000000012640 ffff8802337a4500 ffff8802343033ac 0005532d0005532d
 ffff88022b5030b8 0000000000388049 ffff8800bb9d2198 0000000000000048
Call Trace:
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa0158640>] kjournald2+0x1a8/0x22d [jbd2]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa0158498>] ? commit_timeout+0xb/0xb [jbd2]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ext4-dio-unwrit S 0000000000000001     0  1296      2 0x00000000
 ffff880234233e48 0000000000000046 ffff880234233fd8 ffff880234233fd8
 0000000000012640 ffff880233c08080 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff880234233df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
jbd2/dm-4-8     S 0000000000000000     0  1298      2 0x00000000
 ffff880233505e30 0000000000000046 ffff880233505fd8 ffff880233505fd8
 0000000000012640 ffff88022f05c880 ffff880233ca13ac 0052194a00521948
 ffff88020f3139e8 0000000003e88040 ffff880234927a88 0000000000000027
Call Trace:
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa0158640>] kjournald2+0x1a8/0x22d [jbd2]
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffffa0158498>] ? commit_timeout+0xb/0xb [jbd2]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
ext4-dio-unwrit S 0000000000000001     0  1299      2 0x00000000
 ffff8802345f1e48 0000000000000046 ffff8802345f1fd8 ffff8802345f1fd8
 0000000000012640 ffff880233c9a3c0 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff8802345f1df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-worker-1  S 0000000000000000     0  1302      2 0x00000000
 ffff88022f18bd98 0000000000000046 ffff88022f18bfd8 ffff88022f18bfd8
 0000000000012640 ffff8802341e04c0 ffff88022f18bcf0 ffffffff81063bc1
 ffff8802341e0508 000000000000039c ffff88023fc926b0 ffff88022f18bd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-genwork-1 S 0000000000000000     0  1303      2 0x00000000
 ffff88022dd05d98 0000000000000046 ffff88022dd05fd8 ffff88022dd05fd8
 0000000000012640 ffff880233c545c0 ffff88022dd05cf0 ffffffff81063bc1
 ffff880233c54608 000000000000102c ffff88023fc126b0 ffff88022dd05d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-submit-1  S 0000000000000000     0  1304      2 0x00000000
 ffff880234351d98 0000000000000046 ffff880234351fd8 ffff880234351fd8
 0000000000012640 ffff880233ccc4c0 ffff880234351cf0 ffffffff81063bc1
 ffff880233ccc508 000000000001361d ffff88023fc126b0 ffff880234351d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-delalloc- S 0000000000000000     0  1305      2 0x00000000
 ffff8802337a3d98 0000000000000046 ffff8802337a3fd8 ffff8802337a3fd8
 0000000000012640 ffff88022f03e740 ffff8802337a3cf0 ffffffff81063bc1
 ffff88022f03e788 0000000000000c75 ffff88023fc126b0 ffff8802337a3d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-fixup-1   S 0000000000000001     0  1306      2 0x00000000
 ffff880233c11d98 0000000000000046 ffff880233c11fd8 ffff880233c11fd8
 0000000000012640 ffff88023417e040 ffff880233c11cf0 ffffffff81063bc1
 ffff88023417e088 0000000000000c1e ffff88023fc126b0 ffff880233c11d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-endio-1   S 0000000000000001     0  1307      2 0x00000000
 ffff88023406bd98 0000000000000046 ffff88023406bfd8 ffff88023406bfd8
 0000000000012640 ffff88022fe32540 ffff88023406bcf0 ffffffff81063bc1
 ffff88022fe32588 0000000000000bbc ffff88023fc126b0 ffff88023406bd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-endio-met S 0000000000000001     0  1308      2 0x00000000
 ffff880234589d98 0000000000000046 ffff880234589fd8 ffff880234589fd8
 0000000000012640 ffff88022fdf8800 0000000000000046 ffff88023379cc80
 ffff880234589d08 0000000000000282 ffff880233bbc340 ffff88023379cc80
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-rmw-1     S 0000000000000001     0  1309      2 0x00000000
 ffff88022dd03d98 0000000000000046 ffff88022dd03fd8 ffff88022dd03fd8
 0000000000012640 ffff880234fe2100 ffff88022dd03cf0 ffffffff81063bc1
 ffff880234fe2148 0000000000000c0c ffff88023fc126b0 ffff88022dd03d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-endio-rai S 0000000000000000     0  1310      2 0x00000000
 ffff88022dcedd98 0000000000000046 ffff88022dcedfd8 ffff88022dcedfd8
 0000000000012640 ffff88022dce4140 ffff88022dcedcf0 ffffffff81063bc1
 ffff88022dce4188 0000000000000c3f ffff88023fc126b0 ffff88022dcedd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-endio-met S 0000000000000001     0  1311      2 0x00000000
 ffff88022dd1fd98 0000000000000046 ffff88022dd1ffd8 ffff88022dd1ffd8
 0000000000012640 ffff88022f0d4180 ffff88022dd1fcf0 ffffffff81063bc1
 ffff88022f0d41c8 0000000000000d0e ffff88023fc126b0 ffff88022dd1fd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-endio-wri S 0000000000000001     0  1312      2 0x00000000
 ffff880233c49d98 0000000000000046 ffff880233c49fd8 ffff880233c49fd8
 0000000000012640 ffff8802341c61c0 ffff880233c49cf0 ffffffff81063bc1
 ffff8802341c6208 0000000000000bcd ffff88023fc126b0 ffff880233c49d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-freespace S 0000000000000001     0  1313      2 0x00000000
 ffff88022fe0dd98 0000000000000046 ffff88022fe0dfd8 ffff88022fe0dfd8
 0000000000012640 ffff88022fe74200 ffff88022fe0dcf0 ffffffff81063bc1
 ffff88022fe74248 00000000000008d3 ffff88023fc126b0 ffff88022fe0dd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-delayed-m S 0000000000000000     0  1314      2 0x00000000
 ffff88022de09d98 0000000000000046 ffff88022de09fd8 ffff88022de09fd8
 0000000000012640 ffff88022f074240 ffff88022de09cf0 ffffffff81063bc1
 ffff88022f074288 0000000000000bc4 ffff88023fc126b0 ffff88022de09d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-cache-1   S 0000000000000000     0  1315      2 0x00000000
 ffff88023431bd98 0000000000000046 ffff88023431bfd8 ffff88023431bfd8
 0000000000012640 ffff8802341be280 ffff88023431bcf0 ffffffff81063bc1
 ffff8802341be2c8 0000000000000bac ffff88023fc126b0 ffff88023431bd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-readahead S 0000000000000000     0  1316      2 0x00000000
 ffff88022dd11d98 0000000000000046 ffff88022dd11fd8 ffff88022dd11fd8
 0000000000012640 ffff8802343462c0 ffff88022dd11cf0 ffffffff81063bc1
 ffff880234346308 0000000000000ca2 ffff88023fc126b0 ffff88022dd11d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-flush_del S 0000000000000001     0  1317      2 0x00000000
 ffff8802337b7d98 0000000000000046 ffff8802337b7fd8 ffff8802337b7fd8
 0000000000012640 ffff8802343b8300 ffff8802337b7cf0 ffffffff81063bc1
 ffff8802343b8348 0000000000000c06 ffff88023fc126b0 ffff8802337b7d28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-qgroup-re S 0000000000000000     0  1318      2 0x00000000
 ffff88023402bd98 0000000000000046 ffff88023402bfd8 ffff88023402bfd8
 0000000000012640 ffff8802343fe340 ffff88023402bcf0 ffffffff81063bc1
 ffff8802343fe388 0000000000000bac ffff88023fc126b0 ffff88023402bd28
Call Trace:
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff81059a4c>] ? update_curr+0xd6/0x148
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8103a4ed>] ? lock_timer_base.isra.36+0x26/0x4a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00d89cf>] worker_loop+0x3f5/0x4cd [btrfs]
 [<ffffffffa00d85da>] ? btrfs_queue_worker+0x267/0x267 [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-cleaner   S 0000000000000000     0  1320      2 0x00000000
 ffff88022dce3e78 0000000000000046 ffff88022dce3fd8 ffff88022dce3fd8
 0000000000012640 ffff8802340c60c0 ffff88022dce3dd8 ffffffff810533cf
 0000000100000003 0000000000000000 ffff8802337ae000 ffff8802340c60c0
Call Trace:
 [<ffffffff810533cf>] ? __wake_up+0x3f/0x46
 [<ffffffffa00c2c47>] ? btrfs_run_defrag_inodes+0x2eb/0x2fc [btrfs]
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa00ac9c2>] cleaner_kthread+0xf6/0x119 [btrfs]
 [<ffffffffa00ac8cc>] ? transaction_kthread+0x1ab/0x1ab [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
btrfs-transacti S 0000000000000001     0  1321      2 0x00000000
 ffff880234ffbde8 0000000000000046 ffff880234ffbfd8 ffff880234ffbfd8
 0000000000012640 ffff880233cbe400 0000000000000082 ffff880037582100
 0000000000000000 ffff88023fc126b0 ffff88023fc12640 ffff88023fc126b0
Call Trace:
 [<ffffffff8105a1d0>] ? __enqueue_entity+0x67/0x69
 [<ffffffff8101d56a>] ? native_smp_send_reschedule+0x53/0x55
 [<ffffffff810548d9>] ? resched_task+0x5e/0x63
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a2d7>] schedule_timeout+0x193/0x1f8
 [<ffffffff8103a0ba>] ? call_timer_fn+0x15f/0x15f
 [<ffffffffa00ac8a3>] transaction_kthread+0x182/0x1ab [btrfs]
 [<ffffffffa00ac721>] ? free_fs_root+0x7e/0x7e [btrfs]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
rpciod          S ffff88023fc92640     0  1562      2 0x00000000
 ffff8802310f1e48 0000000000000046 ffff8802310f1fd8 ffff8802310f1fd8
 0000000000012640 ffff8802347da580 ffff88023fc926b0 ffff88023fc92640
 00000000ffffffec ffff8802310f1df8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
nfsiod          S 0000000000000000     0  1588      2 0x00000000
 ffff8802311dde48 0000000000000046 ffff8802311ddfd8 ffff8802311ddfd8
 0000000000012640 ffff88022ffd86c0 ffff88023fc126b0 ffff88023fc12640
 00000000ffffffec ffff8802311dddf8 ffffffff8105c4ec ffffffff81058929
Call Trace:
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff81058929>] ? sched_clock_local+0x12/0x72
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810463eb>] rescuer_thread+0x23b/0x26a
 [<ffffffff810461b0>] ? process_scheduled_works+0x2a/0x2a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
dbus-daemon     S ffff88023fc12640     0  2049      1 0x00000000
 ffff88022bdc9dd0 0000000000000086 ffff88022bdc9fd8 ffff88022bdc9fd8
 0000000000012640 ffff88022bdc61c0 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff812dafa2>] ? ___sys_sendmsg+0x1e1/0x256
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff811360d3>] ? ep_scan_ready_list.isra.10+0x15e/0x17e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
systemd-logind  S 0000000000000000     0  2064      1 0x00000000
 ffff88022bfb1dd0 0000000000000086 ffff88022bfb1fd8 ffff88022bfb1fd8
 0000000000012640 ffff88022bfae540 ffff88022bc88988 ffff88022bfb1d08
 ffff88022bfb1d08 ffffffff8174a0d0 0000000000000000 ffffffff811360f3
Call Trace:
 [<ffffffff811360f3>] ? ep_scan_ready_list.isra.10+0x17e/0x17e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81135e39>] ? ep_call_nested.constprop.12+0xe7/0xf9
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff811360d3>] ? ep_scan_ready_list.isra.10+0x15e/0x17e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8113637e>] ep_poll+0x277/0x2a8
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff811370e3>] SyS_epoll_wait+0x8d/0xc9
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
rsyslogd        S ffff88023fc92640     0  2068      1 0x00000000
 ffff88022ac41960 0000000000000082 ffff88022ac41fd8 ffff88022ac41fd8
 0000000000012640 ffff88022ac3e640 ffff88022ac41940 ffff880237128338
 ffff880233437848 ffff88022ac418c8 ffffffff811c17cf ffff88022ac41980
Call Trace:
 [<ffffffff811c17cf>] ? timerqueue_add+0x7a/0x98
 [<ffffffff8104d4b3>] ? enqueue_hrtimer+0x7b/0xa3
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104dd95>] ? __hrtimer_start_range_ns+0x2ba/0x322
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139ae73>] schedule_hrtimeout_range_clock+0xbb/0xeb
 [<ffffffff8104d827>] ? __run_hrtimer+0x21a/0x21a
 [<ffffffff8104de0c>] ? hrtimer_start_range_ns+0xf/0x11
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8110d8cd>] poll_schedule_timeout+0x3c/0x5c
 [<ffffffff8110e0ef>] do_select+0x4eb/0x523
 [<ffffffff81056ee1>] ? default_wake_function+0xd/0xf
 [<ffffffff8139ce5e>] ? _raw_spin_unlock_irqrestore+0x2c/0x2e
 [<ffffffff811364bb>] ? ep_poll_callback+0x10c/0x128
 [<ffffffff8109909f>] ? rcu_read_unlock_special+0x124/0x156
 [<ffffffff810488e5>] ? __rcu_read_unlock+0x3f/0x4c
 [<ffffffff812de34f>] ? sock_def_readable+0x6f/0x72
 [<ffffffff81356603>] ? unix_dgram_sendmsg+0x4f6/0x51e
 [<ffffffff812da731>] ? sock_sendmsg+0x8f/0xab
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff8110e2cd>] core_sys_select+0x1a6/0x2b7
 [<ffffffff8110fc40>] ? d_free+0x3d/0x4e
 [<ffffffff81050c85>] ? lg_local_unlock+0x24/0x40
 [<ffffffff811168f3>] ? mntput_no_expire+0x35/0x129
 [<ffffffff81116a0f>] ? mntput+0x28/0x2a
 [<ffffffff810ffba8>] ? __fput+0x1c2/0x1cf
 [<ffffffff810338f5>] ? timespec_add_safe+0x21/0x4e
 [<ffffffff8110e45d>] SyS_select+0x7f/0xb5
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
in:imuxsock     S ffff88023fc92640     0  2457      1 0x00000000
 ffff88022be03960 0000000000000082 ffff88022be03fd8 ffff88022be03fd8
 0000000000012640 ffff88023120c840 ffff880233c66480 0000000000012640
 ffff88022be039a0 ffffffff8139bb9c ffff88022be03fd8 ffff88022be03fd8
Call Trace:
 [<ffffffff8139bb9c>] ? __schedule+0x6a5/0x8b4
 [<ffffffff81063bc1>] ? cpuacct_charge+0x50/0x57
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104b3db>] ? add_wait_queue+0x3f/0x44
 [<ffffffff8110d888>] ? __pollwait+0xbf/0xc8
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8110d8cd>] poll_schedule_timeout+0x3c/0x5c
 [<ffffffff8110e0ef>] do_select+0x4eb/0x523
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff81356c07>] ? unix_dgram_recvmsg+0x3c2/0x3d4
 [<ffffffff812da83c>] ? sock_recvmsg+0xb1/0xd0
 [<ffffffff81072d18>] ? get_futex_key+0x90/0x200
 [<ffffffff810599f3>] ? update_curr+0x7d/0x148
 [<ffffffff81059c12>] ? update_cfs_shares+0xb5/0xbc
 [<ffffffff8105a3af>] ? check_preempt_wakeup+0x12b/0x1a7
 [<ffffffff81054cd3>] ? check_preempt_curr+0x2b/0x67
 [<ffffffff8110e2cd>] core_sys_select+0x1a6/0x2b7
 [<ffffffff81072f22>] ? wake_futex+0x57/0x6f
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff81074e80>] ? do_futex+0x4b6/0x85d
 [<ffffffff8110e45d>] SyS_select+0x7f/0xb5
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
in:imklog       S ffff88023fc92640     0  2458      1 0x00000000
 ffff88022bf5de50 0000000000000082 ffff88022bf5dfd8 ffff88022bf5dfd8
 0000000000012640 ffff8802313e2340 ffff88022bf5ddc0 ffffffff810532fd
 0000000000000001 0000000000000001 0000000000000004 0000000000012640
Call Trace:
 [<ffffffff810532fd>] ? ttwu_stat+0x35/0xc8
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81056e91>] ? try_to_wake_up+0x221/0x232
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8102faba>] do_syslog+0x146/0x491
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff81153d1e>] kmsg_read+0x28/0x4f
 [<ffffffff81149332>] proc_reg_read+0x45/0x65
 [<ffffffff810fe51a>] vfs_read+0x97/0x142
 [<ffffffff810fee47>] SyS_read+0x44/0x75
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
rs:main Q:Reg   S 0000000000000001     0  2459      1 0x00000000
 ffff88022ad51cb0 0000000000000082 ffff88022ad51fd8 ffff88022ad51fd8
 0000000000012640 ffff88022bfc0200 ffff88022b55ce18 ffff880234740cc0
 ffff88022b42a498 0000003f2ad51c28 000000000000029d 0000000000043da2
Call Trace:
 [<ffffffff810bc6cf>] ? generic_file_buffered_write+0x1cf/0x24b
 [<ffffffff81072d18>] ? get_futex_key+0x90/0x200
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81073000>] futex_wait_queue_me+0xc6/0xe2
 [<ffffffff81073760>] futex_wait+0x10f/0x228
 [<ffffffff810335af>] ? current_fs_time+0x20/0x23
 [<ffffffff81112d0a>] ? file_update_time+0x2a/0xb0
 [<ffffffff81074a70>] do_futex+0xa6/0x85d
 [<ffffffff811318a4>] ? fsnotify+0x23b/0x268
 [<ffffffff810752dc>] SyS_futex+0xb5/0x127
 [<ffffffff810feed5>] ? SyS_write+0x5d/0x73
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
agetty          S ffff88023fc92640     0  2093      1 0x00000000
 ffff88022bc6fd48 0000000000000086 ffff88022bc6ffd8 ffff88022bc6ffd8
 0000000000012640 ffff88022f1668c0 ffff88022bc6fc90 ffffffff8110fc4e
 ffff880230186840 000000000000f074 ffff88022bc6fcb0 000000000000f074
Call Trace:
 [<ffffffff8110fc4e>] ? d_free+0x4b/0x4e
 [<ffffffff8104f390>] ? __atomic_notifier_call_chain+0x40/0x4a
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104f3a9>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a16e>] schedule_timeout+0x2a/0x1f8
 [<ffffffff8104527a>] ? flush_work+0xfa/0x109
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8122bd81>] n_tty_read+0x380/0x7e0
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff8122742d>] tty_read+0x7d/0xc1
 [<ffffffff810fe51a>] vfs_read+0x97/0x142
 [<ffffffff810fee47>] SyS_read+0x44/0x75
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
rc.local        S 0000000000000000     0  2134      1 0x00000000
 ffff88022bdd3e78 0000000000000082 ffff88022bdd3fd8 ffff88022bdd3fd8
 0000000000012640 ffff88022bdd0300 ffff8802343dac40 00007fff8c9b5f58
 ffff88022bdd3dc8 00007fff8c9b5f58 ffff8802343dac40 ffff88022bfdc1e8
Call Trace:
 [<ffffffff810dc8c1>] ? handle_mm_fault+0x22f/0x26d
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff8103114a>] ? wait_consider_task+0x6f/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
modprobe        S 0000000000000000     0  2467   2134 0x00000000
 ffff88022ad73e78 0000000000000082 ffff88022ad73fd8 ffff88022ad73fd8
 0000000000012640 ffff88022be6c340 0000000000000000 ffff88023113c880
 ffff88022ad73dc8 ffffffff8104f3a9 ffff88022ad73e98 ffff88023fc926b0
Call Trace:
 [<ffffffff8104f3a9>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8105a1d0>] ? __enqueue_entity+0x67/0x69
 [<ffffffff8105c4ec>] ? enqueue_task_fair+0xa66/0xb31
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff8103114a>] ? wait_consider_task+0x6f/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
sh              S ffff88023fc12640     0  2468   2467 0x00000000
 ffff88022bdbde78 0000000000000082 ffff88022bdbdfd8 ffff88022bdbdfd8
 0000000000012640 ffff88023113c880 ffff880233e62840 000000000061c500
 ffff88023fc126b0 000000000061c500 ffff880233e62840 ffff88023455a1e8
Call Trace:
 [<ffffffff810dc8c1>] ? handle_mm_fault+0x22f/0x26d
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff8103114a>] ? wait_consider_task+0x6f/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
modprobe        S 0000000000000000     0  2471   2468 0x00000000
 ffff88022ad89dd0 0000000000000082 ffff88022ad89fd8 ffff88022ad89fd8
 0000000000012640 ffff88022ac8e400 0000000000000163 ffffffffa13e8000
 0000000300000000 ffff88022ad89d70 00000000000000d2 0000000000000003
Call Trace:
 [<ffffffff810e5d5e>] ? map_vm_area+0x29/0x3b
 [<ffffffff810e7085>] ? __vmalloc_node_range+0x146/0x1aa
 [<ffffffff8107951f>] ? module_alloc_update_bounds+0xf/0x5a
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81079eaf>] load_module+0x935/0x1c32
 [<ffffffff8104b68d>] ? wake_up_bit+0x25/0x25
 [<ffffffff8107b23e>] SyS_init_module+0x92/0x9f
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
sshd            S 0000000000000000     0  2508      1 0x00000000
 ffff8802313fb960 0000000000000086 ffff8802313fbfd8 ffff8802313fbfd8
 0000000000012640 ffff8802312501c0 ffffffff815cff00 0000000000000046
 ffffffff815cff00 ffff8802313fb968 ffffffff810c17b7 0000000000000002
Call Trace:
 [<ffffffff810c17b7>] ? get_page_from_freelist+0x409/0x498
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff810f99f5>] ? __mem_cgroup_try_charge+0x1e6/0x9d9
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104b3db>] ? add_wait_queue+0x3f/0x44
 [<ffffffff8110d888>] ? __pollwait+0xbf/0xc8
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8110d8cd>] poll_schedule_timeout+0x3c/0x5c
 [<ffffffff8110e0ef>] do_select+0x4eb/0x523
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff810f7fd3>] ? memcg_check_events+0x19f/0x1c7
 [<ffffffff810c59e5>] ? __activate_page+0x154/0x154
 [<ffffffff810f8f7c>] ? __mem_cgroup_commit_charge+0x2ab/0x2ba
 [<ffffffff810c6246>] ? __lru_cache_add+0x80/0xa0
 [<ffffffff810c6454>] ? lru_cache_add_lru+0x25/0x27
 [<ffffffff810e3608>] ? page_add_new_anon_rmap+0xde/0xef
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff810da488>] ? do_wp_page+0x711/0x752
 [<ffffffff8139ce17>] ? _raw_spin_unlock+0x11/0x2c
 [<ffffffff8110e2cd>] core_sys_select+0x1a6/0x2b7
 [<ffffffff8110fc40>] ? d_free+0x3d/0x4e
 [<ffffffff81050c85>] ? lg_local_unlock+0x24/0x40
 [<ffffffff811168f3>] ? mntput_no_expire+0x35/0x129
 [<ffffffff81116a0f>] ? mntput+0x28/0x2a
 [<ffffffff810ffba8>] ? __fput+0x1c2/0x1cf
 [<ffffffff8110e45d>] SyS_select+0x7f/0xb5
 [<ffffffff810025a4>] ? do_notify_resume+0x5e/0x6d
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
agetty          S 0000000000000000     0  2529      1 0x00000000
 ffff8802313a5d48 0000000000000082 ffff8802313a5fd8 ffff8802313a5fd8
 0000000000012640 ffff880231224400 ffff8802313a5c90 ffffffff8110fc4e
 ffff8802303be0c0 000000000000f074 ffff8802313a5cb0 000000000000f074
Call Trace:
 [<ffffffff8110fc4e>] ? d_free+0x4b/0x4e
 [<ffffffff8104f390>] ? __atomic_notifier_call_chain+0x40/0x4a
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104f3a9>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139a16e>] schedule_timeout+0x2a/0x1f8
 [<ffffffff8104527a>] ? flush_work+0xfa/0x109
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8122bd81>] n_tty_read+0x380/0x7e0
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81056ed4>] ? wake_up_process+0x32/0x32
 [<ffffffff8122742d>] tty_read+0x7d/0xc1
 [<ffffffff810fe51a>] vfs_read+0x97/0x142
 [<ffffffff810fee47>] SyS_read+0x44/0x75
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
krfcommd        S 0000000000000000     0  2731      2 0x00000000
 ffff880225933e18 0000000000000046 ffff880225933fd8 ffff880225933fd8
 0000000000012640 ffff880225848640 0000000000000000 0000000000000001
 ffff880225933d80 ffffffff810781ab 0000000000000000 ffff880225933d80
Call Trace:
 [<ffffffff810781ab>] ? module_put+0x82/0xd5
 [<ffffffff8139ce9e>] ? _raw_read_unlock+0x11/0x2c
 [<ffffffff81034076>] ? local_bh_enable_ip+0x7b/0x96
 [<ffffffffa13f13ee>] ? rfcomm_check_accept+0x84/0x84 [rfcomm]
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffffa13f1a85>] rfcomm_run+0x697/0xfb5 [rfcomm]
 [<ffffffff8139c086>] ? preempt_schedule+0x42/0x5b
 [<ffffffffa13f13ee>] ? rfcomm_check_accept+0x84/0x84 [rfcomm]
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/1:1H    S 0000000000000001     0  4176      2 0x00000000
 ffff880233b75e58 0000000000000046 ffff880233b75fd8 ffff880233b75fd8
 0000000000012640 ffff8802339ee600 ffff880235371038 ffff880233b75df0
 ffffffff812635b6 ffff88023fc92640 ffff880233b75db8 ffffffff8139ce72
Call Trace:
 [<ffffffff812635b6>] ? scsi_request_fn+0x131/0x470
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff8139ce72>] ? _raw_spin_unlock_irq+0x12/0x2d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
sshd            S 0000000000000000     0  4178   2508 0x00000000
 ffff88023377da78 0000000000000086 ffff88023377dfd8 ffff88023377dfd8
 0000000000012640 ffff880234fc4880 ffff88023377d9c8 ffffffff8139ccc6
 ffff88023377d9c8 ffffffff8139ce45 ffff88023377da08 ffffffff8109a9c9
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8109a9c9>] ? delayacct_end+0x77/0x82
 [<ffffffff8112483b>] ? generic_block_bmap+0x40/0x40
 [<ffffffff8109aaa4>] ? __delayacct_blkio_end+0x39/0x3b
 [<ffffffff8139c021>] ? io_schedule+0xae/0xd1
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff812e29e2>] ? __kmalloc_reserve.isra.31+0x27/0x65
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8104b3db>] ? add_wait_queue+0x3f/0x44
 [<ffffffff8110d888>] ? __pollwait+0xbf/0xc8
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8110d8cd>] poll_schedule_timeout+0x3c/0x5c
 [<ffffffff8110e906>] do_sys_poll+0x2cc/0x361
 [<ffffffff812da731>] ? sock_sendmsg+0x8f/0xab
 [<ffffffff811023b1>] ? chrdev_open+0x136/0x15d
 [<ffffffff8110227b>] ? cdev_put+0x1e/0x1e
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110a396>] ? do_last+0xa79/0xbdf
 [<ffffffff81107c3c>] ? link_path_walk+0x64/0x7a0
 [<ffffffff8110a5cd>] ? path_openat+0xd1/0x42a
 [<ffffffff8110b4b5>] ? do_filp_open+0x33/0x76
 [<ffffffff8110ea33>] SyS_poll+0x4b/0xb3
 [<ffffffff8139ec48>] ? device_not_available+0x18/0x20
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
sshd            S 0000000000000000     0  4199   4178 0x00000000
 ffff8801ebd7b960 0000000000000082 ffff8801ebd7bfd8 ffff8801ebd7bfd8
 0000000000012640 ffff8801f75b0640 ffff880233bf6000 ffff8801ebd7b900
 ffffffff812eef78 ffff880233bf6000 ffff8801ebd7b8c8 ffff000700000004
Call Trace:
 [<ffffffff812eef78>] ? dev_hard_start_xmit+0x2a6/0x4de
 [<ffffffff8139cc92>] ? _raw_spin_lock+0x12/0x2e
 [<ffffffff813030d9>] ? sch_direct_xmit+0x9c/0x180
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff8139adef>] schedule_hrtimeout_range_clock+0x37/0xeb
 [<ffffffff8104b3db>] ? add_wait_queue+0x3f/0x44
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8139aeb1>] schedule_hrtimeout_range+0xe/0x10
 [<ffffffff8110d8cd>] poll_schedule_timeout+0x3c/0x5c
 [<ffffffff8110e0ef>] do_select+0x4eb/0x523
 [<ffffffff813101bc>] ? ip_finish_output+0x2d3/0x31b
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff8110d9e0>] ? poll_select_copy_remaining+0xf3/0xf3
 [<ffffffff81034076>] ? local_bh_enable_ip+0x7b/0x96
 [<ffffffff8139d046>] ? _raw_spin_unlock_bh+0x1a/0x1c
 [<ffffffff812de941>] ? release_sock+0x128/0x150
 [<ffffffff813192b4>] ? tcp_sendmsg+0x9f5/0xb6a
 [<ffffffff81337945>] ? inet_sendmsg+0x6e/0x97
 [<ffffffff8110e2cd>] core_sys_select+0x1a6/0x2b7
 [<ffffffff8104eab2>] ? __srcu_read_lock+0x75/0x99
 [<ffffffff811318a4>] ? fsnotify+0x23b/0x268
 [<ffffffff8110e45d>] SyS_select+0x7f/0xb5
 [<ffffffff810feebc>] ? SyS_write+0x44/0x73
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
bash            S 0000000000000001     0  4200   4199 0x00000000
 ffff880234f3de78 0000000000000086 ffff880234f3dfd8 ffff880234f3dfd8
 0000000000012640 ffff880234106740 ffff8802343080c0 000000000070b208
 0000000000000001 000000000070b208 ffff8802343080c0 ffff8801ebd8ece8
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff81047d34>] ? pid_vnr+0x21/0x24
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff81031757>] ? wait_consider_task+0x67c/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
kworker/1:1     S 0000000000000001     0  4951      2 0x00000000
 ffff880037581e58 0000000000000046 ffff880037581fd8 ffff880037581fd8
 0000000000012640 ffff8800375745c0 000000005393ef38 ffff880037581dc8
 ffff880233e28200 ffff880233e280b8 ffff880233e28000 0000000133e28158
Call Trace:
 [<ffffffff81281839>] ? ata_sff_pio_task+0x130/0x14d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/0:0     S 0000000000000000     0  5093      2 0x00000000
 ffff88022bfebe58 0000000000000046 ffff88022bfebfd8 ffff88022bfebfd8
 0000000000012640 ffff880235108380 00000000b2765260 ffff88022bfebdc8
 ffff88023520c200 ffff88023520c0b8 ffff88023520c000 000000013520c158
Call Trace:
 [<ffffffff81281839>] ? ata_sff_pio_task+0x130/0x14d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/1:2     S 0000000000000001     0  5094      2 0x00000000
 ffff880233b0be58 0000000000000046 ffff880233b0bfd8 ffff880233b0bfd8
 0000000000012640 ffff880234fcc400 00000000f7fc8148 ffff880233b0bdb0
 ffff880233b0bdb8 ffffffff8139ccc6 ffff880233b0bdb8 ffffffff8139ce45
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8122d57a>] ? tty_ldisc_deref+0x6c/0x90
 [<ffffffff8122e793>] ? flush_to_ldisc+0x13e/0x14b
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
su              S 0000000000000000     0  5162   4200 0x00000000
 ffff8801f7703e78 0000000000000086 ffff8801f7703fd8 ffff8801f7703fd8
 0000000000012640 ffff88022ae9a7c0 ffff880233c66100 00000000006081c8
 ffff8801f7703dc8 00000000006081c8 ffff880233c66100 ffff88022bf12ef8
Call Trace:
 [<ffffffff810dc8c1>] ? handle_mm_fault+0x22f/0x26d
 [<ffffffff8118a752>] ? security_task_wait+0x11/0x13
 [<ffffffff81031757>] ? wait_consider_task+0x67c/0x9e8
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff81031c76>] do_wait+0x1b3/0x24d
 [<ffffffff81032b57>] SyS_wait4+0x90/0xb4
 [<ffffffff81030ce9>] ? task_stopped_code+0x41/0x41
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
bash            R  running task        0  5242   5162 0x00000000
 00000000000330e8 ffff8802125e3e58 ffffffff81056b99 ffff88020a400300
 ffff88020a400300 ffff8802125e3e88 ffffffff81056bfe ffff88020a400558
 ffffffff815ae750 0000000000000004 0000000000000246 ffff8802125e3e98
Call Trace:
 [<ffffffff81056b99>] sched_show_task+0xcc/0xd1
 [<ffffffff81056bfe>] show_state_filter+0x60/0x8f
 [<ffffffff81230899>] sysrq_handle_showstate+0xb/0xd
 [<ffffffff81230dc1>] __handle_sysrq+0x9b/0x133
 [<ffffffff81231121>] write_sysrq_trigger+0x23/0x32
 [<ffffffff811492ce>] proc_reg_write+0x45/0x64
 [<ffffffff810fe687>] vfs_write+0xc2/0x190
 [<ffffffff810feebc>] SyS_write+0x44/0x73
 [<ffffffff8139db92>] system_call_fastpath+0x16/0x1b
kworker/0:1     S 0000000000000000     0  5303      2 0x00000000
 ffff88023514de58 0000000000000046 ffff88023514dfd8 ffff88023514dfd8
 0000000000012640 ffff880233786480 000000005395e070 ffff88023514ddc8
 ffff88023520c200 ffff88023520c0b8 ffff88023520c000 000000013520c158
Call Trace:
 [<ffffffff81281839>] ? ata_sff_pio_task+0x130/0x14d
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
kworker/1:0     S ffff88023fc92640     0  5305      2 0x00000000
 ffff8802337abe58 0000000000000046 ffff8802337abfd8 ffff8802337abfd8
 0000000000012640 ffff8802351f88c0 ffff88023fc8ecf0 ffff8802337abdb0
 ffff8802337abdb8 ffffffff8139ccc6 ffff8802337abdb8 ffffffff8139ce45
Call Trace:
 [<ffffffff8139ccc6>] ? _raw_spin_lock_irqsave+0x18/0x39
 [<ffffffff8139ce45>] ? _raw_spin_unlock_irqrestore+0x13/0x2e
 [<ffffffff8122d57a>] ? tty_ldisc_deref+0x6c/0x90
 [<ffffffff8122e793>] ? flush_to_ldisc+0x13e/0x14b
 [<ffffffff81046101>] ? process_one_work+0x336/0x3bb
 [<ffffffff8139be0b>] schedule+0x60/0x62
 [<ffffffff810466b9>] worker_thread+0x29f/0x2bd
 [<ffffffff8104641a>] ? rescuer_thread+0x26a/0x26a
 [<ffffffff8104ab99>] kthread+0xb5/0xbd
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
 [<ffffffff8139daec>] ret_from_fork+0x7c/0xb0
 [<ffffffff8104aae4>] ? kthread_create_on_node+0x113/0x113
Sched Debug Version: v0.10, 3.10.1 #3
ktime                                   : 3026266.436370
sched_clk                               : 3026359.216938
cpu_clk                                 : 3026261.001841
jiffies                                 : 4297693557
sched_clock_stable                      : 0

sysctl_sched
  .sysctl_sched_latency                    : 12.000000
  .sysctl_sched_min_granularity            : 1.500000
  .sysctl_sched_wakeup_granularity         : 2.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 11899
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 2666.629 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 3328123
  .nr_load_updates               : 1481968
  .nr_uninterruptible            : -528
  .next_balance                  : 4297.693757
  .curr->pid                     : 0
  .clock                         : 3026260.020204
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 128
  .cpu_load[4]                   : 64
  .yld_count                     : 320515
  .sched_count                   : 3652502
  .sched_goidle                  : 1477344
  .avg_idle                      : 875663
  .ttwu_count                    : 1717688
  .ttwu_local                    : 1116921

cfs_rq[0]:/autogroup-163
  .exec_clock                    : 102.858287
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 109.255920
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1033112.640998
  .nr_spread_over                : 0
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_avg                   : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 8
  .tg->runnable_avg              : 8
  .se->exec_start                : 3026260.019553
  .se->vruntime                  : 1033218.171422
  .se->sum_exec_runtime          : 102.938762
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 0.995367
  .se->statistics.slice_max      : 0.120110
  .se->statistics.wait_max       : 5.406959
  .se->statistics.wait_sum       : 40.946568
  .se->statistics.wait_count     : 2602
  .se->load.weight               : 2
  .se->avg.runnable_avg_sum      : 420
  .se->avg.runnable_avg_period   : 47210
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 2886067

cfs_rq[0]:/
  .exec_clock                    : 657191.072497
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1033221.896918
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_spread_over                : 368
  .nr_running                    : 0
  .load                          : 0
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_avg                   : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 9
  .tg->runnable_avg              : 9
  .avg->runnable_avg_sum         : 423
  .avg->runnable_avg_period      : 47361

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 2666.629 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 2657190
  .nr_load_updates               : 1445371
  .nr_uninterruptible            : 529
  .next_balance                  : 4297.693757
  .curr->pid                     : 5242
  .clock                         : 3026260.005972
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 128
  .cpu_load[4]                   : 64
  .yld_count                     : 53899
  .sched_count                   : 2714377
  .sched_goidle                  : 1208194
  .avg_idle                      : 1000000
  .ttwu_count                    : 1367052
  .ttwu_local                    : 763115

cfs_rq[1]:/autogroup-164
  .exec_clock                    : 143.956743
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 539.009179
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1032682.887739
  .nr_spread_over                : 64
  .nr_running                    : 1
  .load                          : 1024
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_avg                   : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg->runnable_avg              : 0
  .se->exec_start                : 3026260.001967
  .se->vruntime                  : 1178379.901934
  .se->sum_exec_runtime          : 143.956743
  .se->statistics.wait_start     : 0.000000
  .se->statistics.sleep_start    : 0.000000
  .se->statistics.block_start    : 0.000000
  .se->statistics.sleep_max      : 0.000000
  .se->statistics.block_max      : 0.000000
  .se->statistics.exec_max       : 1.007211
  .se->statistics.slice_max      : 0.376166
  .se->statistics.wait_max       : 0.549070
  .se->statistics.wait_sum       : 5.976750
  .se->statistics.wait_count     : 2170
  .se->load.weight               : 1024
  .se->avg.runnable_avg_sum      : 21
  .se->avg.runnable_avg_period   : 47917
  .se->avg.load_avg_contrib      : 0
  .se->avg.decay_count           : 0

cfs_rq[1]:/
  .exec_clock                    : 791850.093335
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 1178379.901934
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 145158.005016
  .nr_spread_over                : 626
  .nr_running                    : 1
  .load                          : 1024
  .runnable_load_avg             : 0
  .blocked_load_avg              : 0
  .tg_load_avg                   : 0
  .tg_load_contrib               : 0
  .tg_runnable_contrib           : 0
  .tg->runnable_avg              : 9
  .avg->runnable_avg_sum         : 21
  .avg->runnable_avg_period      : 48785

rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R           bash  5242       539.009179       247   120       539.009179       104.829566     54207.724940 /autogroup-164


--Boundary-00=_TQQ5RsqHYme4gU5--
