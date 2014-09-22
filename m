Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaIVQKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:10:30 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:11153
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753591AbaIVQKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:10:13 -0400
X-WSS-ID: 0NCB86O-07-6JA-02
X-M-MSG: 
Message-ID: <54204630.4050104@amd.com>
Date: Mon, 22 Sep 2014 10:54:24 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <dave@sr71.net>, Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, <hpa@linux.intel.com>,
        <brice.goglin@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/6] fix topology for multi-NUMA-node CPUs
References: <20140917223310.026BCC2C@viggo.jf.intel.com>
 <CAOjmkp8EGO0jicmdO=p6ATHz-hUJmWb+xoBLjOdLBUwwGzyhhg@mail.gmail.com>
In-Reply-To: <CAOjmkp8EGO0jicmdO=p6ATHz-hUJmWb+xoBLjOdLBUwwGzyhhg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(479174003)(377454003)(199003)(164054003)(24454002)(51704005)(90102001)(50466002)(99396002)(64706001)(50986999)(85852003)(92726001)(92566001)(84676001)(87936001)(95666004)(102836001)(21056001)(4396001)(65956001)(20776003)(120886001)(575784001)(65806001)(15202345003)(54356999)(101416001)(99136001)(87266999)(36756003)(76176999)(65816999)(86362001)(15975445006)(74502003)(81542003)(81342003)(44976005)(77982003)(83322001)(46102003)(107046002)(74662003)(106466001)(76482002)(80022003)(19580395003)(68736004)(19580405001)(79102003)(105586002)(117636001)(15395725005)(64126003)(23676002)(83072002)(59896002)(31966008)(230783001)(85306004)(83506001)(97736003)(120916001)(62816006);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/2014 9:33 AM, Aravind Gopalakrishnan wrote:
>
> This is a big fat RFC.  It takes quite a few liberties with the
> multi-core topology level that I'm not completely comfortable
> with.
>
> It has only been tested lightly.
>
> Full dmesg for a Cluster-on-Die system with this set applied,
> and sched_debug on the command-line is here:
>
> http://sr71.net/~dave/intel/full-dmesg-hswep-20140917.txt 
> <http://sr71.net/%7Edave/intel/full-dmesg-hswep-20140917.txt>
>
> ---
>
> I'm getting the spew below when booting with Haswell (Xeon
> E5-2699 v3) CPUs and the "Cluster-on-Die" (CoD) feature enabled
> in the BIOS.  It seems similar to the issue that some folks from
> AMD ran in to on their systems and addressed in this commit:
>
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=161270fc1f9ddfc17154e0d49291472a9cdef7db
>
> Both these Intel and AMD systems break an assumption which is
> being enforced by topology_sane(): a socket may not contain more
> than one NUMA node.
>
> AMD special-cased their system by looking for a cpuid flag. The
> Intel mode is dependent on BIOS options and I do not know of a
> way which it is enumerated other than the tables being parsed
> during the CPU bringup process.
>
> This also fixes sysfs because CPUs with the same 'physical_package_id'
> in /sys/devices/system/cpu/cpu*/topology/ are not listed together
> in the same 'core_siblings_list'.  This violates a statement from
> Documentation/ABI/testing/sysfs-devices-system-cpu:
>
>         core_siblings: internal kernel map of cpu#'s hardware threads
>         within the same physical_package_id.
>
>         core_siblings_list: human-readable list of the logical CPU
>         numbers within the same physical_package_id as cpu#.
>
> The sysfs effects here cause an issue with the hwloc tool where
> it gets confused and thinks there are more sockets than are
> physically present.
>
> Before this set, there are two packages:
>
> # cd /sys/devices/system/cpu/
> # cat cpu*/topology/physical_package_id | sort | uniq -c
>      18 0
>      18 1
>
> But 4 _sets_ of core siblings:
>
> # cat cpu*/topology/core_siblings_list | sort | uniq -c
>       9 0-8
>       9 18-26
>       9 27-35
>       9 9-17
>
> After this set, there are only 2 sets of core siblings, which
> is what we expect for a 2-socket system.
>
> # cat cpu*/topology/physical_package_id | sort | uniq -c
>      18 0
>      18 1
> # cat cpu*/topology/core_siblings_list | sort | uniq -c
>      18 0-17
>      18 18-35
>
>
> Example spew:
> ...
>         NMI watchdog: enabled on all CPUs, permanently consumes one 
> hw-PMU counter.
>          #2  #3  #4  #5  #6  #7  #8
>         .... node  #1, CPUs:    #9
>         ------------[ cut here ]------------
>         WARNING: CPU: 9 PID: 0 at 
> /home/ak/hle/linux-hle-2.6/arch/x86/kernel/smpboot.c:306 
> topology_sane.isra.2+0x74/0x90()
>         sched: CPU #9's mc-sibling CPU #0 is not on the same node! 
> [node: 1 != 0]. Ignoring dependency.
>         Modules linked in:
>         CPU: 9 PID: 0 Comm: swapper/9 Not tainted 
> 3.17.0-rc1-00293-g8e01c4d-dirty #631
>         Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS 
> GRNDSDP1.86B.0036.R05.1407140519 07/14/2014
>         0000000000000009 ffff88046ddabe00 ffffffff8172e485 
> ffff88046ddabe48
>         ffff88046ddabe38 ffffffff8109691d 000000000000b001 
> 0000000000000009
>         ffff88086fc12580 000000000000b020 0000000000000009 
> ffff88046ddabe98
>         Call Trace:
>         [<ffffffff8172e485>] dump_stack+0x45/0x56
>         [<ffffffff8109691d>] warn_slowpath_common+0x7d/0xa0
>         [<ffffffff8109698c>] warn_slowpath_fmt+0x4c/0x50
>         [<ffffffff81074f94>] topology_sane.isra.2+0x74/0x90
>         [<ffffffff8107530e>] set_cpu_sibling_map+0x31e/0x4f0
>         [<ffffffff8107568d>] start_secondary+0x1ad/0x240
>         ---[ end trace 3fe5f587a9fcde61 ]---
>         #10 #11 #12 #13 #14 #15 #16 #17
>         .... node  #2, CPUs:   #18 #19 #20 #21 #22 #23 #24 #25 #26
>         .... node  #3, CPUs:   #27 #28 #29 #30 #31 #32 #33 #34 #35


Hi,
I looked at the topology info from sysfs both w/ and w/o the patch 
series and they are identical.
So, the patches seem to work fine on an AMD MCM part.

Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Thanks,
-Aravind.
