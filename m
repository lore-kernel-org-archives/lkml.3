Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab3GPQDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:03:37 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:56193 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab3GPQDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <201307161028.03315.pmhahn@pmhahn.de>
References: <20130715182010.GA4853@pmhahn.de> <87ppujysbk.fsf@rustcorp.com.au>
 <s5h38rfngx3.wl%tiwai@suse.de> <201307161028.03315.pmhahn@pmhahn.de>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 16 Jul 2013 13:03:13 -0300
Message-ID: <CAKi4VA+XKh5YGV2DJtmZrU-p4gfeQ3XiLW135Sq0Le+k5jLGAg@mail.gmail.com>
Subject: Re: [alsa-devel] [BUG] 3.10.[01] modprobe snd-... hangs
To: Philipp Hahn <pmhahn@pmhahn.de>
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        alsa-devel@alsa-project.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 5:28 AM, Philipp Hahn <pmhahn@pmhahn.de> wrote:
> Hello,
>
> Am Dienstag 16 Juli 2013, 08:43:36 schrieb Takashi Iwai:
>> At Tue, 16 Jul 2013 15:11:51 +0930, Rusty Russell wrote:
>> > Philipp Matthias Hahn <pmhahn@pmhahn.de> writes:
>> > > My x86_64 systems has some trouble loading some ALSA snd-* modules since
>> > > the upgrade to 3.10.[01]: Several automatic modprobe calls hang, but
>> > > loading snd-intel-hda and snd-audio-usb by hand still works.
>> >
>> > Not a known problem to me, at least.  Perhaps it's a dep loop somehow.
>>
>> I remember that someone reported it being Debian specific snd-seq-oss
>> loading stuff.
>
> FYI: "oss-compat" is installed.
>
>> > > ...
>> > >  1071 ?        S      0:00 sh -c /sbin/modprobe --ignore-install snd && { /sbin/modprobe --quiet snd
>> > >  1080 ?        D      0:00  \_ /sbin/modprobe --quiet snd-seq
>> >
>> > This was first, and it's waiting.  Which means it must be doing
>> > something weird, because snd_seq_oss is loading now:
>> >
>> > > snd_seq_oss 33717 1 - Loading 0xffffffffa041b000
>> >
>> > Perhaps in the tangle of modprobe install commands somewhere this gets
>> > invoked?
>>
>> Likely, but I wonder what triggered a bug suddenly on 3.10.
>> There is absolutely no change in sound/core/seq/*, and through a quick
>> look, I couldn't find any suspicious change in kernel/module.c that
>> may lead to this problem between 3.9 and 3.10.
>>
>> Philipp, can you get a sysrq-T trace while the stall?
>
> I've finally been able to reducte the number of processes to get a full trace; see attached file.
>
> Please note that in this case the proprietary "nvidia" module was loaded, since I currently onyl have remove access to the machine.
> The original trace from yesterday happend without the nvidia module ever being loaded.
>
> Am Dienstag 16 Juli 2013, 08:42:35 schrieb Lucas De Marchi:
>> On Tue, Jul 16, 2013 at 2:41 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> First thing to check is the /etc/modprobe.d/*.conf file that contains
>> these install commands. Did they change besides the kernel upgrade?
>
> Not that I know of: Booting 3.9.9 works fine, 3.10.x shows the problem.

Then one possible explanation is that in 3.9.9 you don't have some of
the modules causing this problem

>
> ...
>> Philipp, which kernel are you upgrading from?
> I just upgraded from 3.9.9 to 3.10.0; also tried 3.10.1 which did not improve the situation.
>
>> I don't see anything to
>> blame in the changes for the past releases. Any chance a bad entry in
>> your .conf was added too? You may want to paste the output of modprobe
>> -c, at least until "# End of configuration files. Dumping indexes
>> now:"
>
> blacklist snd_pcsp
> blacklist arkfb
> blacklist aty128fb
> blacklist atyfb
> blacklist radeonfb
> blacklist cirrusfb
> blacklist cyber2000fb
> blacklist gx1fb
> blacklist gxfb
> blacklist kyrofb
> blacklist matroxfb_base
> blacklist mb862xxfb
> blacklist neofb
> blacklist nvidiafb
> blacklist pm2fb
> blacklist pm3fb
> blacklist s3fb
> blacklist savagefb
> blacklist sisfb
> blacklist tdfxfb
> blacklist tridentfb
> blacklist viafb
> blacklist vt8623fb
> blacklist garmin_gps
> blacklist nouveau
> install binfmt_0000 /bin/true
> install sound_slot_0 /sbin/modprobe snd-card-0
> install sound_slot_1 /sbin/modprobe snd-card-1
> install sound_slot_2 /sbin/modprobe snd-card-2
> install sound_slot_3 /sbin/modprobe snd-card-3
> install sound_slot_4 /sbin/modprobe snd-card-4
> install sound_slot_5 /sbin/modprobe snd-card-5
> install sound_slot_6 /sbin/modprobe snd-card-6
> install sound_slot_7 /sbin/modprobe snd-card-7
> install snd /sbin/modprobe --ignore-install snd && { /sbin/modprobe --quiet snd-ioctl32 ; /sbin/modprobe --quiet snd-seq ; : ; }
> install snd_rawmidi /sbin/modprobe --ignore-install snd-rawmidi && { /sbin/modprobe --quiet snd-seq-midi ; : ; }
> install snd_emu10k1 /sbin/modprobe --ignore-install snd-emu10k1 && { /sbin/modprobe --quiet snd-emu10k1-synth ; : ; }
> alias net_pf_16_proto_1 wire
> alias net_pf_16_proto_3 ip_queue
> alias net_pf_16_proto_8 scsi_transport_iscsi
> alias net_pf_16_proto_9 audit
> alias net_pf_16_proto_11 cn
> alias net_pf_16_proto_13 ip6_queue
> alias binfmt_204 binfmt_aout
> alias binfmt_263 binfmt_aout
> alias binfmt_264 binfmt_aout
> alias binfmt_267 binfmt_aout
> alias binfmt_387 binfmt_aout
> alias block_major_3_* ide_generic
> alias block_major_22_* ide_generic
> alias block_major_33_* ide_generic
> alias block_major_34_* ide_generic
> alias block_major_37_* ide_tape
> alias block_major_44_* ftl
> alias block_major_46_* pcd
> alias block_major_47_* pf
> alias block_major_56_* ide_generic
> alias block_major_57_* ide_generic
> alias block_major_58_* lvm_mod
> alias block_major_88_* ide_generic
> alias block_major_89_* ide_generic
> alias block_major_90_* ide_generic
> alias block_major_91_* ide_generic
> alias block_major_93_* nftl
> alias block_major_97_* pg
> alias char_major_10_1 psmouse
> alias char_major_10_139 openprom
> alias char_major_10_157 applicom
> alias char_major_10_181 toshiba
> alias char_major_10_183 hw_random
> alias char_major_10_187 irnet
> alias char_major_10_189 ussp
> alias char_major_10_250 hci_vhci
> alias char_major_13_0 joydev
> alias char_major_13_1 joydev
> alias char_major_13_2 joydev
> alias char_major_13_3 joydev
> alias char_major_13_32 mousedev
> alias char_major_13_33 mousedev
> alias char_major_13_34 mousedev
> alias char_major_13_35 mousedev
> alias char_major_13_63 mousedev
> alias char_major_13_64 evdev
> alias char_major_13_65 evdev
> alias char_major_13_66 evdev
> alias char_major_13_67 evdev
> alias char_major_19_* cyclades
> alias char_major_20_* cyclades
> alias char_major_22_* pcxx
> alias char_major_23_* pcxx
> alias char_major_27_* ftape
> alias char_major_34_* scc
> alias char_major_35_* tclmidi
> alias char_major_48_* riscom8
> alias char_major_49_* riscom8
> alias char_major_57_* esp
> alias char_major_58_* esp
> alias char_major_63_* kdebug
> alias char_major_67_* coda
> alias char_major_75_* specialix
> alias char_major_76_* specialix
> alias char_major_81_* videodev
> alias char_major_83_* vtx
> alias char_major_89_* i2c_dev
> alias char_major_90_* mtdchar
> alias char_major_96_* pt
> alias char_major_97_* pg
> alias char_major_107_* 3dfx
> alias char_major_109_* lvm_mod
> alias char_major_166_* cdc_acm
> alias char_major_171_0 raw1394
> alias char_major_171_1 video1394
> alias char_major_171_2 dv1394
> alias char_major_171_3 amdtp
> alias char_major_180_* usbcore
> alias char_major_195_* nvidia
> alias char_major_200_* vxspec
> alias char_major_202_* msr
> alias char_major_203_* cpuid
> alias char_major_206_* osst
> alias char_major_208_* ussp
> alias char_major_227_* tub3270
> alias bt_proto_7 avdtp
> alias cipcb0 cipcb
> alias cipcb1 cipcb
> alias cipcb2 cipcb
> alias cipcb3 cipcb
> alias dummy0 dummy
> alias dummy1 dummy
> alias plip0 plip
> alias plip1 plip
> alias slip0 slip
> alias slip1 slip
> alias tunl0 ipip
> alias gre0 ip_gre
> alias usbdevfs usbcore
> alias char_major_195* nvidia
> options snd_pcsp index=-2
> options snd_usb_audio index=-2
> options bt87x index=-2
> options cx88_alsa index=-2
> options snd_atiixp_modem index=-2
> options snd_intel8x0m index=-2
> options snd_via82xx_modem index=-2
> options snd_hda_intel model=6stack-dig index=0
> options snd_usb_audio index=1
> options dvb_ttpci adapter_nr=1
> options budget_ci adapter_nr=0
> options nbd max_part=15
> options nvidia NVreg_DeviceFileUID=0 NVreg_DeviceFileGID=44 NVreg_DeviceFileMode=0660
> options libata force=noncq
> options systemd log_target=kmsg
> softdep uhci_hcd pre: ehci-hcd
> softdep ohci_hcd pre: ehci-hcd
> softdep snd_pcm post: snd-pcm-oss
> softdep snd_mixer post: snd-mixer-oss
> softdep snd_seq post: snd-seq-midi snd-seq-oss


hum... it looks like a loop between the modprobe calls and the
request_module(), done in snd_seq's init. The request_module() call
will end up trying to load snd_seq again and it will remain waiting on
kernel/module.c:add_unformed_module().

In kmod we don't trust a COMING state on sysfs to avoid calling
(f)init_module() because a) the previous call may fail and b) it's
racy.

Changing the request_module() in the module to be async would solve
the problem (what Takashi Iwai did)... but this has been a
little controversial in the past.  Rusty, what do you think? Maybe in
kmod we can take the COMING state into consideration for
*dependencies*? Or is moving that call to a worker acceptable?


Lucas De Marchi
