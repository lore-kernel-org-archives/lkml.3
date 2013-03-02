Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3CBA6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:58:17 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:42614 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3CBA6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:58:15 -0500
Message-ID: <51314ea5.c4cde00a.482f.2419@mx.google.com>
Date: Fri, 01 Mar 2013 16:58:13 -0800 (PST)
From: animelovin@gmail.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [pata] [critical]: ide_sr_mod and id_scsi: unable to read/write dvd
 since 2.6.24 to 3.4.11!
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since a kernel upgrade to 2.6.33 on debian and now 3.4.11 i cannot longer
use (read, write) dvds medias as the /dev/sr0 symlink appears ignoring the dvd
drive (incorrectly dentified as /dev/hda). 

I read intensively on this issue over google and found many users looking
for clues how to read/write dvds having apparently the same issue with Optiarc
based dvds. Is generic dvd/udf support has thus evaporated in the miss of merging udev in
systemd or did it vanished to enforce cdrom only media in Linux? 

So far my debugging seem to identify this problem on Optiarc based drives as they are 
possibly incorrectly detected by the libata/atapi
abstraction layer (kernel part) as the hal server is being replaced with the newer
systemd architecture. 

Moreover, i'm uncertain about the current state of the PATA api so my assumption was
that generic dvd/udf support was provided using the ide_cd and ide_sr modules.

Hence is there any reasons to worry about the current state of dvdrw drives in the 3.4.x
kernel or was this issue reported already on a more recent development release?

Etienne

erob@nguns:~/src/OpenZilla/1.0.032$ dmesg | grep -e scsi
[    5.017936] scsi0 : ahci
[    5.020923] scsi1 : ahci
[    5.025594] scsi2 : ahci
[    5.026919] scsi3 : ahci
[    5.374169] scsi 0:0:0:0: Direct-Access     ATA      ST9100827AS      3.BH PQ: 0 ANSI: 5
[    5.564078] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.013476] scsi4 : usb-storage 1-4:1.0
[   19.010738] scsi 4:0:0:0: Direct-Access     Kingston DataTraveler 2.0 1.00 PQ: 0 ANSI: 2
[   19.012171] sd 4:0:0:0: Attached scsi generic sg1 type 0

erob@nguns:~/src/OpenZilla/1.0.032$ dmesg | grep -e Opti
[    4.290430] hda: Optiarc DVD RW AD-7530A, ATAPI CD/DVD-ROM drive

erob@nguns:~/src/OpenZilla/tags/1.0.032$ ls -l /dev/disk/by-id/ata-*
lrwxrwxrwx 1 root root  9 Feb 26 15:00 /dev/disk/by-id/ata-Optiarc_DVD_RW_AD-7530A_30644560_1143769Q111 -> ../../hda

erob@nguns:~/src/OpenZilla/1.0.032$ sudo lshw -C disk
  *-cdrom                 
       description: DVD-RAM writer
       product: Optiarc DVD RW AD-7530A
       physical id: 0
       bus info: ide@0.0
       logical name: /dev/hda
       version: EH31
       serial: 30644560 1143769Q111
       capabilities: packet atapi cdrom removable nonmagnetic dma lba iordy audio cd-r cd-rw dvd dvd-r dvd-ram
       configuration: status=ready
     *-medium
          physical id: 0
          logical name: /dev/hda

erob@nguns:~/src/OpenZilla/1.0.032$ lsmod
Module                  Size  Used by
msr                     1792  0 
cpufreq_stats           1990  0 
isofs                  23775  0 
nf_conntrack_ipv4       4401  1 
nf_defrag_ipv4           807  1 nf_conntrack_ipv4
xt_conntrack            2349  1 
nf_conntrack           31746  2 xt_conntrack,nf_conntrack_ipv4
xt_tcpudp               1611  11 
ipt_REJECT              1513  1 
iptable_filter           936  1 
ip_tables               7698  1 iptable_filter
x_tables                8861  5 ip_tables,xt_tcpudp,xt_conntrack,iptable_filter,ipt_REJECT
i915                  312876  3 
drm_kms_helper         17996  1 i915
iTCO_wdt                9877  0 
coretemp                4170  0 
microcode               5472  0 
psmouse                35050  0 
acpi_cpufreq            4405  0 
mperf                    843  1 acpi_cpufreq
intel_agp               7976  1 i915
serio_raw               3049  0 
evdev                   6282  7 
drm                   141864  4 i915,drm_kms_helper
i2c_i801                6305  0 
intel_gtt               9417  3 i915,intel_agp
rng_core                2234  0 
battery                 8351  0 
ac                      2387  0 
video                   9543  1 i915
processor              22835  3 acpi_cpufreq
button                  3378  1 i915
wmi                     5875  0 
agpgart                17805  3 drm,intel_agp,intel_gtt
i2c_algo_bit            3783  1 i915
i2c_core               12639  5 drm,i915,i2c_i801,drm_kms_helper,i2c_algo_bit
snd_hda_codec_conexant    32084  1 
snd_hda_intel          16845  3 
snd_hda_codec          53103  2 snd_hda_codec_conexant,snd_hda_intel
snd_pcm_oss            26773  0 
snd_mixer_oss           9774  1 snd_pcm_oss
snd_pcm                47757  4 snd_pcm_oss,snd_hda_codec,snd_hda_intel
snd_page_alloc          4769  2 snd_pcm,snd_hda_intel
snd_seq_dummy            939  0 
snd_seq_oss            18939  0 
snd_seq_midi            3256  0 
snd_rawmidi            11969  1 snd_seq_midi
snd_seq_midi_event      3620  2 snd_seq_oss,snd_seq_midi
snd_seq                32432  6 snd_seq_midi_event,snd_seq_oss,snd_seq_dummy,snd_seq_midi
snd_seq_device          3548  5 snd_seq,snd_rawmidi,snd_seq_oss,snd_seq_dummy,snd_seq_midi
snd_timer              11781  3 snd_pcm,snd_seq
snd                    34062  15 snd_pcm_oss,snd_timer,snd_hda_codec_conexant,snd_pcm,snd_seq,snd_rawmidi,snd_hda_codec,snd_hda_intel,snd_seq_oss,snd_seq_device,snd_mixer_oss
soundcore               3270  1 snd
sr_mod                 10588  0 
loop                   10879  0 
ipv6                  185889  10 
autofs4                15653  2 
ext3                  132465  6 
jbd                    40538  1 ext3
usbhid                 25216  0 
hid                    57500  1 usbhid
usb_storage            30877  0 
uhci_hcd               15949  0 
ehci_hcd               29482  0 
sg                     19105  0 
sd_mod                 22316  11 
ide_cd_mod             20259  0 
ata_generic             2259  0 
ata_piix               17903  0 
ide_pci_generic         1972  0 
thermal                 6151  0 
thermal_sys             9638  3 video,thermal,processor
8139too                15223  0 
8139cp                 12931  0 
mii                     2791  2 8139cp,8139too
ahci                   16821  10 
libahci                13335  1 ahci
libata                115151  4 ahci,libahci,ata_generic,ata_piix
scsi_mod              131421  5 sg,usb_storage,libata,sd_mod,sr_mod
usbcore                93181  5 uhci_hcd,usb_storage,ehci_hcd,usbhid
piix                    3624  0 
ide_core               62515  3 piix,ide_cd_mod,ide_pci_generic
usb_common               590  1 usbcore
erob@nguns:~/src/OpenZilla/1.0.032$ 
