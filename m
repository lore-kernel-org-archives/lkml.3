Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3K3QG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:06:27 -0500
Received: from 0106ds1-hvi.0.fullrate.dk ([90.184.84.98]:15462 "EHLO
	mail.knielsen-hq.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3K3QGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:06:10 -0500
X-Greylist: delayed 2243 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Nov 2013 11:06:09 EST
From: Kristian Nielsen <knielsen@knielsen-hq.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
References: <20131126032645.GA32301@redhat.com>
	<20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel>
	<20131126152337.GL15489@kvack.org>
Date: Sat, 30 Nov 2013 16:28:41 +0100
In-Reply-To: <20131126152337.GL15489@kvack.org> (Benjamin LaHaise's message of
	"Tue, 26 Nov 2013 10:23:37 -0500")
Message-ID: <87d2lh6h92.fsf@frigg.knielsen-hq.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> For Dave: what line is this bug on?  Is it the dereference of ctx when 
> doing spin_lock_irqsave(&ctx->completion_lock, flags); or is the 
> ctx->ring_pages[idx] = new; ?  From the 64 bit splat, I'm thinking the 
> former, which is quite strange given that the clearing of 
> mapping->private_data is protected by mapping->private_lock.  If it's 
> the latter, we might well need to check if ctx->ring_pages is NULL during 
> setup. 

I think I got the same BUG (at least it looks very similar, full details
below).

The bug is on this line:

    ctx->ring_pages[idx] = new;

Disassembly:

    af7:   48 89 2c d1    mov    %rbp,(%rcx,%rdx,8)

ctx->ring_pages is 0xffffffffffffffff (this is x86_64). idx is 13.

  RCX: ffffffffffffffff  RDX: 000000000000000d
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000067

So we are de-referencing a pointer that is (page **)-1, causing the crash.

If you look closer at the 32-bit dump that Dave gave, you can see that it is
similar:

     7a2:       89 34 82                mov    %esi,(%edx,%eax,4)

  RAX: 6b6b6b6b6b6b6b6b  RDX: 0000000000000000

Though in this case ctx->ring_pages seems to be NULL and idx=old->index seems
to be 6b6b6b6b6b6b6b6b, so not completely the same (or maybe I read his dump
incorrectly).

This is 3.13-rc1. Unfortunately, I do not have a way to reproduce (so far I
only saw it this once). But I can see if it turns up again, or should I
install -rc2 and see if it goes away?

I was not doing anything special at the time, normal desktop load (I was using
the evince pdf viewer).

Let me know if there is anything else I can do to help track this down?

 - Kristian.

Full details:

I put my .config here:

    http://knielsen-hq.org/config-3.13-rc1-gpf-in-aio-migratepage.txt

BUG output:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000067
IP: [<ffffffff8113d73f>] aio_migratepage+0xb3/0xe4
PGD 0 
Oops: 0002 [#1] SMP 
Modules linked in: tun parport_pc ppdev lp parport bnep rfcomm bluetooth cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative binfmt_misc uinput fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc ext3 jbd loop snd_hda_codec_hdmi hid_generic usbhid hid joydev ums_realtek usb_storage snd_hda_codec_realtek iTCO_wdt iTCO_vendor_support arc4 brcmsmac cordic brcmutil b43 mac80211 cfg80211 ssb mmc_core rfkill rng_core pcmcia pcmcia_core nouveau mxm_wmi wmi x86_pkg_temp_thermal coretemp snd_hda_intel kvm_intel snd_hda_codec snd_hwdep snd_pcm_oss kvm snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_pcm crc32c_intel snd_rawmidi snd_page_alloc snd_seq ghash_clmulni_intel snd_timer snd_seq_device lpc_ich aesni_intel mfd_core ttm battery aes_x86_64 ablk_helper drm_kms_helper cryptd lrw gf128mul drm glue_helper psmouse snd pcspkr serio_raw i2c_i801 evdev ehci_pci soundcore ehci_hcd bcma ac acpi_cpufreq video button processor ext4 crc16 jbd2 mbc
r_mod cdrom crc_t10dif crct10dif_common microcode ahci libahci xhci_hcd libata usbcore scsi_mod usb_common fan thermal thermal_sys r8169 mii
CPU: 2 PID: 15596 Comm: evince Not tainted 3.13.0-rc1-kn #1
Hardware name: Compal PBL2021/Base Board Product Name, BIOS 2.40 08/26/2011
task: ffff88010322f7c0 ti: ffff880102b48000 task.ti: ffff880102b48000
RIP: 0010:[<ffffffff8113d73f>]  [<ffffffff8113d73f>] aio_migratepage+0xb3/0xe4
RSP: 0018:ffff880102b49798  EFLAGS: 00010213
RAX: 0000000000000286 RBX: ffffea00038f1640 RCX: ffffffffffffffff
RDX: 000000000000000d RSI: ffffea00038f1640 RDI: ffffea00038f1640
RBP: ffffea0007b6a800 R08: 0000000000000000 R09: 000000000000000d
R10: 0000000000000038 R11: ffffea0007b6a800 R12: ffff880144a30d00
R13: 0000000000000000 R14: ffff88014ba5b1f8 R15: ffff880144a30ec4
FS:  00007f68ecfe8960(0000) GS:ffff88024f480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000067 CR3: 0000000051ee8000 CR4: 00000000000407e0
Stack:
 000000000000000e 0000000000000286 ffff88024f7f6d80 ffffea00038f1640
 ffffea0007b6a800 0000000000000000 ffff88014ba5b170 0000000000000001
 0000000000000001 ffffffff810ffc68 ffff88014ba5b1a8 0000000000000000
Call Trace:
 [<ffffffff810ffc68>] ? move_to_new_page+0x84/0x1ab
 [<ffffffff810cbcbd>] ? get_page+0x9/0x25
 [<ffffffff8110019e>] ? migrate_pages+0x330/0x524
 [<ffffffff810dac77>] ? isolate_freepages_block+0x237/0x237
 [<ffffffff810db651>] ? compact_zone+0x13a/0x301
 [<ffffffff810dba3e>] ? compact_zone_order+0x94/0xa7
 [<ffffffff810dbae9>] ? try_to_compact_pages+0x98/0xec
 [<ffffffff8138ef42>] ? __alloc_pages_direct_compact+0xa9/0x19a
 [<ffffffff810c8567>] ? __alloc_pages_nodemask+0x46f/0x7f3
 [<ffffffff812cf2bc>] ? __kmalloc_reserve.isra.42+0x2a/0x6d
 [<ffffffff810f64df>] ? alloc_pages_current+0xac/0xc6
 [<ffffffff812cbd47>] ? sock_alloc_send_pskb+0x1fc/0x345
 [<ffffffff812d2625>] ? memcpy_fromiovecend+0x48/0x6f
 [<ffffffff812d2ac5>] ? skb_copy_datagram_from_iovec+0x128/0x1f2
 [<ffffffff812ca529>] ? sk_wake_async+0x19/0x3c
 [<ffffffff8134c605>] ? unix_stream_sendmsg+0x12e/0x2e9
 [<ffffffff812c8001>] ? sock_aio_write+0xc0/0xd5
 [<ffffffff81115581>] ? set_restore_sigmask+0x2d/0x2d
 [<ffffffff81106da4>] ? do_sync_readv_writev+0x48/0x6b
 [<ffffffff812c7f41>] ? sock_alloc_file+0x119/0x119
 [<ffffffff81107e9c>] ? do_readv_writev+0xb4/0x121
 [<ffffffff812c7f41>] ? sock_alloc_file+0x119/0x119
 [<ffffffff810015d7>] ? __switch_to+0x1b1/0x3de
 [<ffffffff8111c1ce>] ? fget_light+0x6b/0x7c
 [<ffffffff81106d10>] ? fdget+0xe/0x17
 [<ffffffff8110807d>] ? SyS_writev+0x51/0xaa
 [<ffffffff813997e2>] ? system_call_fastpath+0x16/0x1b
Code: 48 89 de 48 89 ef 48 89 44 24 08 e8 03 22 fc ff 48 8b 53 10 49 3b 94 24 a0 00 00 00 48 8b 44 24 08 73 0c 49 8b 8c 24 98 00 00 00 <48> 89 2c d1 48 89 c6 4c 89 ff e8 74 6e 25 00 eb 06 41 bd f0 ff 
RIP  [<ffffffff8113d73f>] aio_migratepage+0xb3/0xe4
 RSP <ffff880102b49798>
CR2: 0000000000000067
---[ end trace be5b4877a98efec5 ]---
------------[ cut here ]------------


After this I got lots of stuff like

  WARNING: CPU: 4 PID: 15642 at kernel/watchdog.c:245 watchdog_overflow_callback+0x80/0xa3()
  Watchdog detected hard LOCKUP on cpu 4
  BUG: soft lockup - CPU#3 stuck for 22s! [EvJobScheduler:15653]

But I assume that is just due to crashing with two spinlocks held.


Disassembly of aio_migratepage():

0000000000000a44 <aio_migratepage>:
     a44:       41 57                   push   %r15
     a46:       41 56                   push   %r14
     a48:       41 55                   push   %r13
     a4a:       41 54                   push   %r12
     a4c:       55                      push   %rbp
     a4d:       53                      push   %rbx
     a4e:       48 89 d3                mov    %rdx,%rbx
     a51:       48 83 ec 18             sub    $0x18,%rsp
     a55:       48 8b 02                mov    (%rdx),%rax
     a58:       f6 c4 20                test   $0x20,%ah
     a5b:       74 02                   je     a5f <aio_migratepage+0x1b>
     a5d:       0f 0b                   ud2    
     a5f:       49 89 fc                mov    %rdi,%r12
     a62:       48 89 d7                mov    %rdx,%rdi
     a65:       48 89 f5                mov    %rsi,%rbp
     a68:       89 4c 24 08             mov    %ecx,0x8(%rsp)
     a6c:       e8 00 00 00 00          callq  a71 <aio_migratepage+0x2d>
     a71:       44 8b 44 24 08          mov    0x8(%rsp),%r8d
     a76:       31 c9                   xor    %ecx,%ecx
     a78:       48 89 da                mov    %rbx,%rdx
     a7b:       48 89 ee                mov    %rbp,%rsi
     a7e:       4c 89 e7                mov    %r12,%rdi
     a81:       e8 00 00 00 00          callq  a86 <aio_migratepage+0x42>
     a86:       85 c0                   test   %eax,%eax
     a88:       41 89 c5                mov    %eax,%r13d
     a8b:       74 0a                   je     a97 <aio_migratepage+0x53>
     a8d:       48 89 df                mov    %rbx,%rdi
     a90:       e8 92 ff ff ff          callq  a27 <get_page>
     a95:       eb 7f                   jmp    b16 <aio_migratepage+0xd2>
     a97:       4d 8d b4 24 88 00 00    lea    0x88(%r12),%r14
     a9e:       00 
     a9f:       48 89 ef                mov    %rbp,%rdi
     aa2:       e8 80 ff ff ff          callq  a27 <get_page>
     aa7:       4c 89 f7                mov    %r14,%rdi
     aaa:       e8 00 00 00 00          callq  aaf <aio_migratepage+0x6b>
     aaf:       4d 8b a4 24 a0 00 00    mov    0xa0(%r12),%r12
     ab6:       00 
     ab7:       4d 85 e4                test   %r12,%r12
     aba:       74 4c                   je     b08 <aio_migratepage+0xc4>
     abc:       4d 8d bc 24 c4 01 00    lea    0x1c4(%r12),%r15
     ac3:       00 
     ac4:       4c 89 ff                mov    %r15,%rdi
     ac7:       e8 00 00 00 00          callq  acc <aio_migratepage+0x88>
     acc:       48 89 de                mov    %rbx,%rsi
     acf:       48 89 ef                mov    %rbp,%rdi
     ad2:       48 89 44 24 08          mov    %rax,0x8(%rsp)
     ad7:       e8 00 00 00 00          callq  adc <aio_migratepage+0x98>
     adc:       48 8b 53 10             mov    0x10(%rbx),%rdx
     ae0:       49 3b 94 24 a0 00 00    cmp    0xa0(%r12),%rdx
     ae7:       00 
     ae8:       48 8b 44 24 08          mov    0x8(%rsp),%rax
     aed:       73 0c                   jae    afb <aio_migratepage+0xb7>
     aef:       49 8b 8c 24 98 00 00    mov    0x98(%r12),%rcx
     af6:       00 
# We get the crash on this next instruction, %rcx is 0xffffffffffffffff
     af7:       48 89 2c d1             mov    %rbp,(%rcx,%rdx,8)
     afb:       48 89 c6                mov    %rax,%rsi
     afe:       4c 89 ff                mov    %r15,%rdi
     b01:       e8 00 00 00 00          callq  b06 <aio_migratepage+0xc2>
     b06:       eb 06                   jmp    b0e <aio_migratepage+0xca>
     b08:       41 bd f0 ff ff ff       mov    $0xfffffff0,%r13d
     b0e:       4c 89 f7                mov    %r14,%rdi
     b11:       e8 b7 fa ff ff          callq  5cd <spin_unlock>
     b16:       48 83 c4 18             add    $0x18,%rsp
     b1a:       44 89 e8                mov    %r13d,%eax
     b1d:       5b                      pop    %rbx
     b1e:       5d                      pop    %rbp
     b1f:       41 5c                   pop    %r12
     b21:       41 5d                   pop    %r13
     b23:       41 5e                   pop    %r14
     b25:       41 5f                   pop    %r15
     b27:       c3                      retq   
