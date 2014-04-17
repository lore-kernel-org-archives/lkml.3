Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaDQTQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:16:32 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46580 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaDQTQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:16:25 -0400
Message-ID: <53502886.6020107@lwfinger.net>
Date: Thu, 17 Apr 2014 14:16:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Bug in 3.15-rc1: Scheduling while atomic splats filling log
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On kernel 3.15-rc1, I get log entries for scheduling while atomic. These BUG 
splats are repeated many times, and start early in the boot. I tried to bisect 
this problem, but the bug does not always show on every boot, and I must have 
had a faulty kernel boot without error. In any case, I ended up at a merge pull. 
What I can definitively report is that a kernel generated from commit fd1df00 is 
bad.

Fortunately, I have retained the kernels from the bisection onward, and I will 
retry them to see if I reported any of them incorrectly. As far as I know, the 
configuration was unchanged during the bisection.

The logged messages are as follows:

2014-04-16T10:51:25.205576-05:00 larrylap systemd[1]: Starting Name Service 
Cache Daemon...
2014-04-16T10:51:25.197425-05:00 larrylap kernel: [   27.176133] Call Trace:
2014-04-16T10:51:25.205599-05:00 larrylap kernel: [   27.176139] 
[<ffffffff81607386>] dump_stack+0x4e/0x71
2014-04-16T10:51:25.205605-05:00 larrylap kernel: [   27.176144] 
[<ffffffff816009e2>] __schedule_bug+0x5d/0x6d
2014-04-16T10:51:25.205615-05:00 larrylap kernel: [   27.176149] 
[<ffffffff8160a8d5>] __schedule+0x775/0x810
2014-04-16T10:51:25.205618-05:00 larrylap kernel: [   27.176154] 
[<ffffffff8160aa34>] schedule+0x24/0x70
2014-04-16T10:51:25.205620-05:00 larrylap kernel: [   27.176159] 
[<ffffffff8160adc1>] schedule_preempt_disabled+0x11/0x20
2014-04-16T10:51:25.205623-05:00 larrylap kernel: [   27.176164] 
[<ffffffff810941a3>] cpu_startup_entry+0x123/0x430
2014-04-16T10:51:25.205625-05:00 larrylap kernel: [   27.176170] 
[<ffffffff8102dcb3>] start_secondary+0x1d3/0x290
2014-04-16T10:51:25.205627-05:00 larrylap kernel: [   27.176175] 
[<ffffffff813aa118>] ? acpi_ps_parse_aml+0x186/0x476
2014-04-16T10:51:25.205629-05:00 larrylap kernel: [   27.177033] BUG: scheduling 
while atomic: swapper/1/0/0x00000004
2014-04-16T10:51:25.205638-05:00 larrylap kernel: [   27.177037] no locks held 
by swapper/1/0.
2014-04-16T10:51:25.205641-05:00 larrylap kernel: [   27.177039] Modules linked 
in: arc4 b43 mac80211 cfg80211 snd_hda_codec_generic snd_hda_intel snd_hda_co
ntroller snd_hda_codec snd_hwdep snd_pcm snd_seq powernow_k8 kvm_amd kvm rfkill 
bcma snd_timer snd_seq_device snd r852 pcspkr ssb serio_raw sdhci_pci sm_comm
on sdhci nand forcedeth mmc_core sg mtd r592 nand_ids nand_bch memstick bch 
nand_ecc sr_mod cdrom soundcore battery ac autofs4 nouveau ttm drm_kms_helper drm
  i2c_algo_bit i2c_core thermal wmi video processor button thermal_sys hwmon 
ata_generic pata_amd

