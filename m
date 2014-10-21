Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaJUAyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 20:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbaJUAyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 20:54:14 -0400
Message-ID: <5445AEAB.6080200@redhat.com>
Date: Mon, 20 Oct 2014 20:54:03 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] kernel, add bug_on_warn
References: <1413806420-31828-1-git-send-email-prarit@redhat.com> <20141020152448.c50fa1855d451f4bba0f6f92@linux-foundation.org>
In-Reply-To: <20141020152448.c50fa1855d451f4bba0f6f92@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/20/2014 06:24 PM, Andrew Morton wrote:
> On Mon, 20 Oct 2014 08:00:20 -0400 Prarit Bhargava <prarit@redhat.com> wrote:
> 
>> There have been several times where I have had to rebuild a kernel to
>> cause a panic when hitting a WARN() in the code in order to get a crash
>> dump from a system.  Sometimes this is easy to do, other times (such as
>> in the case of a remote admin) it is not trivial to send new images to the
>> user.
>>
>> A much easier method would be a switch to change the WARN() over to a
>> BUG().  This makes debugging easier in that I can now test the actual
>> image the WARN() was seen on and I do not have to engage in remote
>> debugging.
>>
>> This patch adds a bug_on_warn kernel parameter, which calls BUG() in the
>> warn_slowpath_common() path.  The function will still print out the
>> location of the warning.
>>
>> Successfully tested by me.
> 
> Looks nice and simple and useful.  However I suspect you're exclusively
> focussed on "I want a crash dump" and things haven't been fully thought
> through.
> 
> - Do you have any example WARN->BUG console output at hand?  I'd like
>   to check for missing or duplicated info.

Yep, here you go, with some additional annotation notes from me.  The first
line below is from the WARN_ON() to output the WARN_ON()'s location.  After
that, we hit the new BUG() call.

 WARNING: CPU: 27 PID: 3204 at
/home/rhel7/redhat/debug/dummy-module/dummy-module.c:25 init_dummy+0x28/0x30
[dummy_module]()
 bug_on_warn set, calling BUG()...
 ------------[ cut here ]------------
 kernel BUG at kernel/panic.c:434!
 invalid opcode: 0000 [#1] SMP
 Modules linked in: dummy_module(OE+) sg nfsv3 rpcsec_gss_krb5 nfsv4
dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel
ghash_clmulni_intel igb iTCO_wdt aesni_intel iTCO_vendor_support lrw gf128mul
sb_edac ptp edac_core glue_helper lpc_ich ioatdma pcspkr ablk_helper pps_core
i2c_i801 mfd_core cryptd dca shpchp ipmi_si wmi ipmi_msghandler acpi_cpufreq
nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs libcrc32c sr_mod cdrom sd_mod
mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper isci ttm
drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror
dm_region_hash dm_log dm_mod
 CPU: 27 PID: 3204 Comm: insmod Tainted: G           OE  3.17.0+ #19
 Hardware name: Intel Corporation S2600CP/S2600CP, BIOS
RMLSDP.86I.00.29.D696.1311111329 11/11/2013
 task: ffff880034e75160 ti: ffff8807fc5ac000 task.ti: ffff8807fc5ac000
 RIP: 0010:[<ffffffff81076b81>]  [<ffffffff81076b81>] warn_slowpath_common+0xc1/0xd0
 RSP: 0018:ffff8807fc5afc68  EFLAGS: 00010246
 RAX: 0000000000000021 RBX: ffff8807fc5afcb0 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff88081efee5f8 RDI: ffff88081efee5f8
 RBP: ffff8807fc5afc98 R08: 0000000000000096 R09: 0000000000000000
 R10: 0000000000000711 R11: ffff8807fc5af93e R12: ffffffffa0424070
 R13: 0000000000000019 R14: ffffffffa0423068 R15: 0000000000000009
 FS:  00007f2d4b034740(0000) GS:ffff88081efe0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f2d4a99f3c0 CR3: 00000007fd88b000 CR4: 00000000001407e0
 Stack:
  ffff8807fc5afcb8 ffffffff8199f020 ffff88080e396160 0000000000000000
  ffffffffa0423040 ffffffffa0425000 ffff8807fc5afd08 ffffffff81076be5
  0000000000000008 ffffffffa0424053 ffff880700000018 ffff8807fc5afd18
 Call Trace:
  [<ffffffffa0423040>] ? dummy_greetings+0x40/0x40 [dummy_module]
  [<ffffffff81076be5>] warn_slowpath_fmt+0x55/0x70
  [<ffffffffa0423068>] init_dummy+0x28/0x30 [dummy_module]
  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
  [<ffffffff811b52c2>] ? __vunmap+0xc2/0x110
  [<ffffffff810f8889>] load_module+0x16a9/0x1b30
  [<ffffffff810f3d30>] ? store_uevent+0x70/0x70
  [<ffffffff810f49b9>] ? copy_module_from_fd.isra.44+0x129/0x180
  [<ffffffff810f8ec6>] SyS_finit_module+0xa6/0xd0
  [<ffffffff8166ce29>] system_call_fastpath+0x12/0x17
 Code: c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 c7 c7 20 42 8a 81 31 c0 e8 fc
80 5e 00 eb 80 48 c7 c7 78 42 8a 81 31 c0 e8 ec 80 5e 00 <0f> 0b 66 66 66 66 2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
 RIP  [<ffffffff81076b81>] warn_slowpath_common+0xc1/0xd0
  RSP <ffff8807fc5afc68>
 ---[ end trace 428218934a12088b ]---
> 
> - Did you consider permitting this to be tweaked at runtime via
>   /proc?  Sometimes we get pesky WARNs at boot time and having runtime
>   alteration would permit the user to prevent those from tripping a
>   BUG.
> 

I did actually, but I was wondering how people liked the idea before I looked
at the /proc implementation.  It's pretty much the same as panic_on_oops, so
it's not difficult to do.

> - Also, perhaps bug_on_warn should be single-shot: clear itself after
>   it has triggered one BUG.  Because once the kernel has gone
>   WARN->BUG, it's probably messed up and is likely to trigger more
>   WARNs.  Also, the kernel might generate many WARNs for the same
>   issue.

Okay, I'll add that.

> 
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -553,6 +553,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
>>  	bttv.tuner=
>>  
>> +	bug_on_warn	BUG() instead of WARN()
> 
> There's no mention here that this feature is mainly aimed at generating
> a crash dump.  How do we tell the people who aren't reading this email
> thread (ie: all of humanity except you and me ;)) that this feature
> even exists?  Is there crash dump documentation that we can update?
>

I'll look into this too.

P.
> 
