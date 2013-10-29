Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3J2Tlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:41:49 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58837 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab3J2Tls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:41:48 -0400
Message-ID: <1383075705.22833.18.camel@x220.thuisdomein>
Subject: Revert 9745cdb36da83aeec198650b410ca06304cf792 ("select: use
 freezable blocking call")?
From: Paul Bolle <pebolle@tiscali.nl>
To: Colin Cross <ccross@android.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Oct 2013 20:41:45 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2013 19:41:46.0124 (UTC) FILETIME=[E6DAA4C0:01CED4DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Summary: ever since I tried running (release candidates of) v3.11 on
the two working i686s I still have lying around I ran into issues on
resuming from suspend. Reverting 9745cdb36da83aeec198650b410ca06304cf792
("select: use freezable blocking call") resolves those issues.

1) Resuming from suspend on i686 on (release candidates of) v3.11 and
later triggers issues like:
    traps: systemd[1] general protection ip:b738e490 sp:bf882fc0 error:0 in libc-2.16.so[b731c000+1b0000]

and
    traps: rtkit-daemon[552] general protection ip:804d6e5 sp:b6cb32f0 error:0 in rtkit-daemon[8048000+d000]

Once I hit the systemd error I can only get out of the mess that the
system is at that point by power cycling it.

2) I bisected that issue to commit
9745cdb36da83aeec198650b410ca06304cf792 ("select: use freezable blocking
call"). The, rather impressive, bisect log is pasted at the end of this
message. It took 23 builds to pinpoint this issue in the v3.10..v3.11
range! Sadly, I have no clue why that commit triggers this issue. 

3) Reverting that commit on top of v3.12-rc7 gets me a system that
resumes without issues. (That revert needed one trivial context change.
Note that I haven't actually tried v3.12-rc7 plain. But v3.12-rc6 and
earlier also had this issue, so I'm sure the revert did the trick for
v3.12-rc7.)

4) Should this commit be reverted? Or is there a better fix?


Paul Bolle

# bad: [6e4664525b1db28f8c4e1130957f70a94c19213e] Linux 3.11
# good: [8bb495e3f02401ee6f76d1b1d77f3ac9f079e376] Linux 3.10
git bisect start 'v3.11' 'v3.10'
# bad: [8b70a90cabafb6a6e1a0d3f838b38355fe48337e] Merge branch 'for-v3.11' of git://git.linaro.org/people/mszyprowski/linux-dma-mapping
git bisect bad 8b70a90cabafb6a6e1a0d3f838b38355fe48337e
# good: [ab3d681e9d41816f90836ea8fe235168d973207f] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good ab3d681e9d41816f90836ea8fe235168d973207f
# bad: [862f0012549110d6f2586bf54b52ed4540cbff3a] Merge tag 'pci-v3.11-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
git bisect bad 862f0012549110d6f2586bf54b52ed4540cbff3a
# good: [60b5adffb4f3e4b4c1978959f24e8e531b2ef3cb] Merge tag 'gpio-for-v3.11-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
git bisect good 60b5adffb4f3e4b4c1978959f24e8e531b2ef3cb
# good: [fe489bf4505ae26d3c6d6a1f1d3064c2a9c5cd85] Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect good fe489bf4505ae26d3c6d6a1f1d3064c2a9c5cd85
# skip: [405a1086bdd091d2d55db0ac905cd6332b35cec1] Merge branch 'pm-cpufreq'
git bisect skip 405a1086bdd091d2d55db0ac905cd6332b35cec1
# good: [f4fd3797848aa04e72e942c855fd279840a47fe4] acpi-cpufreq: Add new sysfs attribute freqdomain_cpus
git bisect good f4fd3797848aa04e72e942c855fd279840a47fe4
# bad: [2c843bd92ec276ecb68504b3b5ffa7066183f032] Merge branch 'pm-cpufreq'
git bisect bad 2c843bd92ec276ecb68504b3b5ffa7066183f032
# skip: [e8b6cb3947430d62538d88f615c007a51aeb23fe] Merge branch 'acpi-doc'
git bisect skip e8b6cb3947430d62538d88f615c007a51aeb23fe
# good: [1d1ea1b723d9f239f736b8cf284327cbbf9d15d1] ACPICA: Standardize all switch() blocks
git bisect good 1d1ea1b723d9f239f736b8cf284327cbbf9d15d1
# skip: [e52cff8bdd4a30c40a7f65c7ea8f1f425f8a15eb] Merge branch 'pm-assorted'
git bisect skip e52cff8bdd4a30c40a7f65c7ea8f1f425f8a15eb
# good: [39688ce6facd63de796def41a0b9012882b5cc14] PM / devfreq: account suspend/resume for stats
git bisect good 39688ce6facd63de796def41a0b9012882b5cc14
# good: [173a5a4c909789fcd57d00355d2237618a3824a4] ACPI / processor: Fix potential NULL pointer dereference in acpi_processor_add()
git bisect good 173a5a4c909789fcd57d00355d2237618a3824a4
# skip: [207bc1181b1c03ab6ecb55bca5b307606dd1d6bc] Merge branch 'freezer'
git bisect skip 207bc1181b1c03ab6ecb55bca5b307606dd1d6bc
# good: [613f5d13b569859171f0896fbc73ee0bfa811fda] freezer: skip waking up tasks with PF_FREEZER_SKIP set
git bisect good 613f5d13b569859171f0896fbc73ee0bfa811fda
# good: [9b5c7a5a977a330ffaf83c4d383ba247c74c800f] ACPI / PM: Fix possible NULL pointer deref in acpi_pm_device_sleep_state()
git bisect good 9b5c7a5a977a330ffaf83c4d383ba247c74c800f
# good: [45f0a85c8258741d11bda25c0a5669c06267204a] PM / Runtime: Rework the "runtime idle" helper routine
git bisect good 45f0a85c8258741d11bda25c0a5669c06267204a
# bad: [2cc6ced132f472b2bdb619960a650b9a85cdd34f] Merge branch 'pm-cpufreq'
git bisect bad 2cc6ced132f472b2bdb619960a650b9a85cdd34f
# good: [d24c2a4f919d17bd1ae4f4010a38ab07ece99cf7] PM / QoS: correct the valid range of pm_qos_class
git bisect good d24c2a4f919d17bd1ae4f4010a38ab07ece99cf7
# bad: [2b15af6f953012aac49984ead3f8ec744d941540] af_unix: use freezable blocking calls in read
git bisect bad 2b15af6f953012aac49984ead3f8ec744d941540
# good: [1c441e921201d523b5a6036aea22b0b426bf1af2] epoll: use freezable blocking call
git bisect good 1c441e921201d523b5a6036aea22b0b426bf1af2
# bad: [56467c7697f5aef6974501fbe2c3e63674583549] futex: use freezable blocking call
git bisect bad 56467c7697f5aef6974501fbe2c3e63674583549
# bad: [9745cdb36da83aeec198650b410ca06304cf7928] select: use freezable blocking call
git bisect bad 9745cdb36da83aeec198650b410ca06304cf7928

