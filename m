Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3FYG4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 02:56:17 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35717 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3FYG4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 02:56:15 -0400
MIME-Version: 1.0
In-Reply-To: <51C87ADC.4070409@canonical.com>
References: <51C87ADC.4070409@canonical.com>
Date: Tue, 25 Jun 2013 12:26:14 +0530
Message-ID: <CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tim Gardner <tim.gardner@canonical.com>, Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 June 2013 22:29, Tim Gardner <tim.gardner@canonical.com> wrote:
> This is from Ubuntu Saucy based on 3.10-rc7:
>
> [   12.911676] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000070
> [   12.911691] IP: [<ffffffff8156e572>] od_set_powersave_bias+0x92/0xc0
>
> For completeness I added the attached debug patch and built a vanilla
> 3.10-rc7 with the following result:
>
> [   13.222262] od_set_powersave_bias !policy, cpu 0
> [   13.222843] od_set_powersave_bias !policy, cpu 1
> [   13.223380] od_set_powersave_bias !policy, cpu 2
> [   13.223922] od_set_powersave_bias !policy, cpu 3
>
> Attachments:
> dmesg.txt - ubuntu kernel rebased on 3.10-rc7
> dmesg_dbg.txt - vanilla 3.10-rc7 with debug patch
> 0001-cpufreq_ondemand.c-Added-debug.patch - debug patch
> config - 3.10-rc7 config

Can you please look into this bug? It occurred after your
patch... This is the boot log crash we have:

I believe this is somehow called before ondemand is initialized.
Also, I see one problem in your original patch:

commit fb30809efa3edeb692a6b29125a07c9eceb322dc
Author: Jacob Shin <jacob.shin@amd.com>
Date:   Tue Apr 2 09:56:56 2013 -0500

    cpufreq: ondemand: allow custom powersave_bias_target handler to
be registered

You are doing:

+       for_each_online_cpu(cpu) {
+               if (cpumask_test_cpu(cpu, &done))
+                       continue;
+
+               policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
+               dbs_data = policy->governor_data;
+               od_tuners = dbs_data->tuners;
+               od_tuners->powersave_bias = powersave_bias;
+
+               cpumask_or(&done, &done, policy->cpus);
+       }

How can we do this for each online cpu? There might be two
clusters each using a separate governor and so this looks wrong.
Can you please send a fixup for this?


[   12.911719] Modules linked in: amd_freq_sensitivity(+) kvm_amd kvm
snd_hda_intel(+) snd_hda_codec crc32_pclmul ghash_clmulni_intel
snd_hwdep snd_pcm aesni_intel ablk_helper snd_seq_midi cryptd lrw
snd_rawmidi snd_seq_midi_event gf128mul snd_seq glue_helper aes_x86_64
snd_timer snd_seq_device psmouse edac_core snd joydev microcode
i2c_piix4 soundcore snd_page_alloc video edac_mce_amd bcma mac_hid
fam15h_power serio_raw lp parport hid_generic usbhid hid sdhci_pci
sdhci ahci libahci alx mdio
[   12.911782] CPU: 0 PID: 605 Comm: modprobe Not tainted 3.10.0-0-generic #6
[   12.911789] Hardware name: AMD Larne/Larne, BIOS
WLR3206X_Weekly_13_02_0 02/06/2013
[   12.911795] task: ffff880115cd2ee0 ti: ffff880118140000 task.ti:
ffff880118140000
[   12.911800] RIP: 0010:[<ffffffff8156e572>]  [<ffffffff8156e572>]
od_set_powersave_bias+0x92/0xc0
[   12.911809] RSP: 0018:ffff880118141d00  EFLAGS: 00010246
[   12.911814] RAX: ffff88011ec00000 RBX: 0000000000000000 RCX: 0000000000000100
[   12.911819] RDX: 0000000000000000 RSI: ffff880118141d00 RDI: ffff880118141d00
[   12.911824] RBP: ffff880118141d40 R08: ffffffff81cf2ee0 R09: 0000000000000004
[   12.911829] R10: ffff88011ec14fc8 R11: 0000000000014480 R12: ffffffff81cf2ee0
[   12.911835] R13: 0000000000010c80 R14: 0000000000000190 R15: ffff880118141ef0
[   12.911842] FS:  00007f0688e8d700(0000) GS:ffff88011ec00000(0000)
knlGS:0000000000000000
[   12.911849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.911854] CR2: 0000000000000070 CR3: 0000000115cc4000 CR4: 00000000000407f0
[   12.911860] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   12.911866] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   12.911871] Stack:
[   12.911875]  0000000000000000 0000000000000000 0000000000000000
0000000000000000
[   12.911885]  0000000000000000 0000000000000000 ffffffffa0280000
ffffffffa0280018
[   12.911894]  ffff880118141d50 ffffffff8156e5b7 ffff880118141d70
ffffffffa001e046
[   12.911904] Call Trace:
[   12.911914]  [<ffffffff8156e5b7>]
od_register_powersave_bias_handler+0x17/0x20
[   12.911925]  [<ffffffffa001e046>]
amd_freq_sensitivity_init+0x46/0x1000 [amd_freq_sensitivity]
[   12.911935]  [<ffffffffa001e000>] ? 0xffffffffa001dfff
[   12.911945]  [<ffffffff81002102>] do_one_initcall+0x102/0x160
[   12.911955]  [<ffffffff810bee8c>] load_module+0x101c/0x1400
[   12.911964]  [<ffffffff810baa40>] ? store_uevent+0x40/0x40
[   12.911973]  [<ffffffff810bf31d>] SyS_init_module+0xad/0xd0
[   12.911983]  [<ffffffff816defef>] tracesys+0xe1/0xe6
[   12.911988] Code: 78 00 89 c3 76 3b 0f a3 45 c0 19 d2 85 d2 75 d9
89 c0 48 8d 75 c0 b9 00 01 00 00 48 8b 04 c5 80 21 cf 81 48 89 f7 49
8b 54 05 20 <48> 8b 42 70 48 8b 40 10 44 89 70 14 e8 bd d5 dd ff eb ab
0f 1f
[   12.912054] RIP  [<ffffffff8156e572>] od_set_powersave_bias+0x92/0xc0
[   12.912062]  RSP <ffff880118141d00>
[   12.912066] CR2: 0000000000000070
[   12.912073] ---[ end trace 98b1cd8b10d00b40 ]---
[   13.025093] input: HD-Audio Generic HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:01.1/sound/card0/input9
[   13.025267] input: HD-Audio Generic HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:01.1/sound/card0/input10
[   13.025892] hda-intel 0000:00:14.2: Using LPIB position fix
[   13.030414] hda-intel 0000:00:14.2: Enable sync_write for stable
communication
[   13.055253] hda_codec: CX20751/2: BIOS auto-probing.
[   13.055499] autoconfig: line_outs=1 (0x17/0x0/0x0/0x0/0x0) type:speaker
[   13.055506]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.055512]    hp_outs=1 (0x16/0x0/0x0/0x0/0x0)
[   13.055516]    mono: mono_out=0x0
[   13.055520]    inputs:
[   13.055525]      Internal Mic=0x1a
[   13.055530]      Mic=0x18
