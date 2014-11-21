Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaKUMoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:44:25 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56678 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaKUMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:44:23 -0500
MIME-Version: 1.0
From: Dmitry Chernenkov <dmitryc@google.com>
Date: Fri, 21 Nov 2014 16:44:02 +0400
Message-ID: <CAA6XgkE7vDmYn+QCMVkr39D_3V_bcF66P9G0v5=na-aOYq8RcA@mail.gmail.com>
Subject: PROBLEM: apparent out-of-bounds memory write in fs/ecryptfs/crypto.c
To: tyhicks@canonical.com, ecryptfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kasan-dev@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(switched to plain text)

Hi!

The following issue was discovered using Kernel Address Sanitizer
we're developing
(https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel,
https://github.com/google/kasan/blob/kasan/Documentation/kasan.txt)

The apparent problem is here (fs/ecryptfs/crypto.c:1866 ..  I tested
on kernel 3.14, but looks like the issue is still there upstream):

static size_t ecryptfs_max_decoded_size(size_t encoded_size)
{
/* Not exact; conservatively long. Every block of 4
* encoded characters decodes into a block of 3
* decoded characters. This segment of code provides
* the caller with the maximum amount of allocated
* space that @dst will need to point to in a
* subsequent call. */
return ((encoded_size + 1) * 3) / 4;
}

/**
 * ecryptfs_decode_from_filename
 * @dst: If NULL, this function only sets @dst_size and returns. If
 *       non-NULL, this function decodes the encoded octets in @src
 *       into the memory that @dst points to.
 * @dst_size: Set to the size of the decoded string.
 * @src: The encoded set of octets to decode.
 * @src_size: The size of the encoded set of octets to decode.
 */
static void
ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
     const unsigned char *src, size_t src_size)
{
u8 current_bit_offset = 0;
size_t src_byte_offset = 0;
size_t dst_byte_offset = 0;

if (dst == NULL) {
(*dst_size) = ecryptfs_max_decoded_size(src_size);
goto out;
}
while (src_byte_offset < src_size) {
unsigned char src_byte =
filename_rev_map[(int)src[src_byte_offset]];

switch (current_bit_offset) {
case 0:
dst[dst_byte_offset] = (src_byte << 2);
current_bit_offset = 6;
break;
case 6:
dst[dst_byte_offset++] |= (src_byte >> 4);
dst[dst_byte_offset] = ((src_byte & 0xF)
<< 4);
current_bit_offset = 4;
break;
case 4:
dst[dst_byte_offset++] |= (src_byte >> 2);
dst[dst_byte_offset] = (src_byte << 6);
current_bit_offset = 2;
break;
case 2:
dst[dst_byte_offset++] |= (src_byte);
dst[dst_byte_offset] = 0;
current_bit_offset = 0;
break;
}
src_byte_offset++;
}
(*dst_size) = dst_byte_offset;
out:
return;
}
For src_size multiple of 4 (which I assume is usually the case), the
line "dst[dst_byte_offset] = 0;" writes  at dst[dst_size] reported in
the ecryptfs_max_decoded_size. The caller mallocs exactly dst_size
bytes for dst, so the write is outside the allocated space. Depending
on allocator, this can be exploited to overwrite the next object's
first byte. I didn't exactly understand whether dst should be a
0-terminated string, so we either need to skip writing the trailing
zero or allocate 1 more byte.



Address Sanitizer report below (I'm getting such reports continously
when accessing disk on the system):

==================================================================
BUG: AddressSanitizer: out of bounds access in
ecryptfs_decode_and_decrypt_filename+0x215/0x2c9 at addr
ffff8800593a47d5
(Shadow address ffffda000b2748fa)
=============================================================================
BUG kmalloc-64 (Tainted: G    B       ): kasan error
-----------------------------------------------------------------------------

INFO: Allocated in ecryptfs_decode_and_decrypt_filename+0xa6/0x2c9
age=0 cpu=2 pid=1131
 [<ffffffff8116a194>] __slab_alloc.constprop.65+0x21c/0x408
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:2402
 [<     inlined    >] __kmalloc+0x8f/0x111 slab_alloc_node
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:2461
 [<     inlined    >] __kmalloc+0x8f/0x111 slab_alloc
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:2503
 [<ffffffff8116a40f>] __kmalloc+0x8f/0x111
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:3340
 [<     inlined    >] ecryptfs_decode_and_decrypt_filename+0xa6/0x2c9
kmalloc /mnt/host/source/src/third_party/kernel/3.14/include/linux/slab.h:466
 [<ffffffff8126f82c>] ecryptfs_decode_and_decrypt_filename+0xa6/0x2c9
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/crypto.c:2084
 [<ffffffff812679ac>] ecryptfs_filldir+0x61/0x142
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:89
 [<     inlined    >] call_filldir+0x1e5/0x230 dir_emit
/mnt/host/source/src/third_party/kernel/3.14/include/linux/fs.h:2790
 [<ffffffff811f6e6d>] call_filldir+0x1e5/0x230
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:468
 [<     inlined    >] ext4_readdir+0x408/0xc1f ext4_dx_readdir
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:544
 [<ffffffff811f74a9>] ext4_readdir+0x408/0xc1f
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:116
 [<ffffffff8118821d>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<ffffffff812678c1>] ecryptfs_readdir+0xc0/0x14a
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:124
 [<ffffffff8118821d>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<     inlined    >] SyS_getdents+0xa7/0x110 SYSC_getdents
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:211
 [<ffffffff811887e8>] SyS_getdents+0xa7/0x110
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:192
 [<ffffffff8186a8d1>] system_call_fastpath+0x16/0x1b
/mnt/host/source/src/third_party/kernel/3.14/arch/x86/kernel/entry_64.S:629
INFO: Freed in ecryptfs_decode_and_decrypt_filename+0x2a3/0x2c9 age=0
cpu=2 pid=1131
 [<ffffffff8116ac49>] __slab_free+0x56/0x308
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:2578
(discriminator 1)
 [<     inlined    >] kfree+0xc2/0xf7 slab_free
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:2724
 [<ffffffff8116b0c4>] kfree+0xc2/0xf7
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:3440
 [<ffffffff8126fa29>] ecryptfs_decode_and_decrypt_filename+0x2a3/0x2c9
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/crypto.c:2118
 [<ffffffff812679ac>] ecryptfs_filldir+0x61/0x142
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:89
 [<     inlined    >] call_filldir+0x1e5/0x230 dir_emit
/mnt/host/source/src/third_party/kernel/3.14/include/linux/fs.h:2790
 [<ffffffff811f6e6d>] call_filldir+0x1e5/0x230
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:468
 [<     inlined    >] ext4_readdir+0x408/0xc1f ext4_dx_readdir
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:544
 [<ffffffff811f74a9>] ext4_readdir+0x408/0xc1f
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:116
 [<ffffffff8118821d>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<ffffffff812678c1>] ecryptfs_readdir+0xc0/0x14a
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:124
 [<ffffffff8118821d>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<     inlined    >] SyS_getdents+0xa7/0x110 SYSC_getdents
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:211
 [<ffffffff811887e8>] SyS_getdents+0xa7/0x110
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:192
 [<ffffffff8186a8d1>] system_call_fastpath+0x16/0x1b
/mnt/host/source/src/third_party/kernel/3.14/arch/x86/kernel/entry_64.S:629
INFO: Slab 0xffffea000164e900 objects=20 used=13 fp=0xffff8800593a4188
flags=0x4000000000004080
INFO: Object 0xffff8800593a47a8 @offset=1960 fp=0xffff8800593a53e8

Bytes b4 ffff8800593a4798: 57 96 5f 00 01 00 00 00 5a 5a 5a 5a 5a 5a
5a 5a  W._.....ZZZZZZZZ
Object ffff8800593a47a8: 46 29 63 f1 c5 22 bb dd 80 dd 07 84 da 19 66
93  F)c.."........f.
Object ffff8800593a47b8: 7a 4c fc 90 60 e8 0d 13 7a f7 bb e6 2c 5b 4b
40  zL..`...z...,[K@
Object ffff8800593a47c8: f5 df 93 c3 db 2a bf c3 bc 4a ca 00 00 6b 6b
6b  .....*...J...kkk
Object ffff8800593a47d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
a5  kkkkkkkkkkkkkkk.
Redzone ffff8800593a47e8: cc cc cc cc cc cc cc cc
    ........
Padding ffff8800593a4928: 5a 5a 5a 5a 5a 5a 5a 5a
    ZZZZZZZZ
CPU: 2 PID: 1131 Comm: BrowserBlocking Tainted: G    B        3.14.0 #27
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 ffff8800593a4000 0000000093f98c69 ffff8800590a5ad0 ffffffffaae64195
 ffff88006d007840 ffff8800590a5b00 ffffffffaa769209 ffff88006d007840
 ffffea000164e900 ffff8800593a47a8 ffff88004e608000 ffff8800590a5b28
Call Trace:
 [<     inlined    >] dump_stack+0x45/0x56 __dump_stack
/mnt/host/source/src/third_party/kernel/3.14/lib/dump_stack.c:15
 [<ffffffffaae64195>] dump_stack+0x45/0x56
/mnt/host/source/src/third_party/kernel/3.14/lib/dump_stack.c:50
 [<ffffffffaa769209>] print_trailer+0x12b/0x134
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:655
 [<ffffffffaa76941c>] object_err+0x36/0x3d
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:662
 [<     inlined    >] kasan_report_error+0x223/0x3c2
print_address_description
/mnt/host/source/src/third_party/kernel/3.14/mm/kasan/report.c:158
 [<ffffffffaa76ed96>] kasan_report_error+0x223/0x3c2
/mnt/host/source/src/third_party/kernel/3.14/mm/kasan/report.c:235
 [<ffffffffaa76e6f8>] kasan_unpoison_shadow+0x19/0x3a
/mnt/host/source/src/third_party/kernel/3.14/mm/kasan/kasan.c:54
 [<     inlined    >] __asan_store1+0x9e/0xb9 kasan_report
/mnt/host/source/src/third_party/kernel/3.14/mm/kasan/kasan.h:50
 [<     inlined    >] __asan_store1+0x9e/0xb9 check_memory_region
/mnt/host/source/src/third_party/kernel/3.14/mm/kasan/kasan.c:250
 [<ffffffffaa76e1cd>] __asan_store1+0x9e/0xb9
/mnt/host/source/src/third_party/kernel/3.14/mm/kasan/kasan.c:399
 [<     inlined    >] ecryptfs_decode_and_decrypt_filename+0x215/0x2c9
ecryptfs_decode_from_filename
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/crypto.c:1920
 [<ffffffffaa86f99c>] ecryptfs_decode_and_decrypt_filename+0x215/0x2c9
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/crypto.c:2093
 [<     inlined    >] ecryptfs_decode_and_decrypt_filename+0x215/0x2c9
ecryptfs_decode_from_filename
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/crypto.c:1920
 [<ffffffffaa86f99c>] ecryptfs_decode_and_decrypt_filename+0x215/0x2c9
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/crypto.c:2093
 [<     inlined    >] kfree+0xc2/0xf7 slab_free
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:2724
 [<ffffffffaa76b0c5>] kfree+0xc2/0xf7
/mnt/host/source/src/third_party/kernel/3.14/mm/slub.c:3440
 [<ffffffffaa8679ad>] ecryptfs_filldir+0x61/0x142
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:89
 [<     inlined    >] call_filldir+0x1e5/0x230 dir_emit
/mnt/host/source/src/third_party/kernel/3.14/include/linux/fs.h:2790
 [<ffffffffaa7f6e6e>] call_filldir+0x1e5/0x230
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:468
 [<ffffffffaa86794c>] ecryptfs_readdir+0x14a/0x14a
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:135
 [<     inlined    >] ext4_readdir+0x408/0xc1f ext4_dx_readdir
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:544
 [<ffffffffaa7f74aa>] ext4_readdir+0x408/0xc1f
/mnt/host/source/src/third_party/kernel/3.14/fs/ext4/dir.c:116
 [<ffffffffaa88f314>] fsnotify_perm+0x88/0x95
/mnt/host/source/src/third_party/kernel/3.14/include/linux/fsnotify.h:60
 [<ffffffffaa78821e>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<ffffffffaa8678c2>] ecryptfs_readdir+0xc0/0x14a
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:124
 [<ffffffffaa86794c>] ecryptfs_readdir+0x14a/0x14a
/mnt/host/source/src/third_party/kernel/3.14/fs/ecryptfs/file.c:135
 [<ffffffffaa78821e>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<ffffffffaa78821e>] iterate_dir+0xea/0x146
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:41
 [<     inlined    >] SyS_getdents+0xa7/0x110 SYSC_getdents
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:211
 [<ffffffffaa7887e9>] SyS_getdents+0xa7/0x110
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:192
 [<ffffffffaa7883a2>] fillonedir+0x128/0x128
/mnt/host/source/src/third_party/kernel/3.14/fs/readdir.c:105
 [<ffffffffaa6479c0>] do_page_fault+0xc/0xe
/mnt/host/source/src/third_party/kernel/3.14/arch/x86/mm/fault.c:1267
 [<ffffffffaae6a8d2>] system_call_fastpath+0x16/0x1b
/mnt/host/source/src/third_party/kernel/3.14/arch/x86/kernel/entry_64.S:629
 [<ffffffffaae6a8d2>] system_call_fastpath+0x16/0x1b
/mnt/host/source/src/third_party/kernel/3.14/arch/x86/kernel/entry_64.S:629
Write of size 1 by task BrowserBlocking:
Memory state around the buggy address:
 ffff8800593a4500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800593a4580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800593a4600: fc fc fc fc 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff8800593a4680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800593a4700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8800593a4780: fc fc fc fc fc 00 00 00 00 00 05 fc fc fc fc fc
                                                 ^
 ffff8800593a4800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800593a4880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8800593a4900: fc fc fc fc fc fc fb fb fb fb fb fb fb fb fb fb
 ffff8800593a4980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8800593a4a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Other relevant info:

localhost ~ # cat /proc/version
Linux version 3.14.0 (dmitryc@dmitryc-z620.msk.corp.google.com) (gcc
version 4.9.2 (_cos_gg_9999) ) #27 SMP Thu Nov 20 17:58:36 MSK 2014
localhost ~ # cat /proc/cpuinfo
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 6
model name : QEMU Virtual CPU version 2.0.0
stepping : 3
microcode : 0x1
cpu MHz : 2893.030
cache size : 4096 KB
physical id : 0
siblings : 1
core id : 0
cpu cores : 1
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 4
wp : yes
flags : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni vmx
cx16 x2apic popcnt hypervisor lahf_lm vnmi ept
bogomips : 5786.06
clflush size : 64
cache_alignment : 64
address sizes : 40 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 6
model name : QEMU Virtual CPU version 2.0.0
stepping : 3
microcode : 0x1
cpu MHz : 2893.030
cache size : 4096 KB
physical id : 1
siblings : 1
core id : 0
cpu cores : 1
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 4
wp : yes
flags : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni vmx
cx16 x2apic popcnt hypervisor lahf_lm vnmi ept
bogomips : 5785.57
clflush size : 64
cache_alignment : 64
address sizes : 40 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 6
model name : QEMU Virtual CPU version 2.0.0
stepping : 3
microcode : 0x1
cpu MHz : 2893.030
cache size : 4096 KB
physical id : 2
siblings : 1
core id : 0
cpu cores : 1
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 4
wp : yes
flags : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni vmx
cx16 x2apic popcnt hypervisor lahf_lm vnmi ept
bogomips : 5785.50
clflush size : 64
cache_alignment : 64
address sizes : 40 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 6
model name : QEMU Virtual CPU version 2.0.0
stepping : 3
microcode : 0x1
cpu MHz : 2893.030
cache size : 4096 KB
physical id : 3
siblings : 1
core id : 0
cpu cores : 1
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 4
wp : yes
flags : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni vmx
cx16 x2apic popcnt hypervisor lahf_lm vnmi ept
bogomips : 5784.90
clflush size : 64
cache_alignment : 64
address sizes : 40 bits physical, 48 bits virtual
power management:

localhost ~ # cat /proc/modules
i2c_dev 12352 0 - Live 0xffffffffc0156000
uinput 16448 0 - Live 0xffffffffc0102000
bluetooth 313958 6 - Live 0xffffffffc0108000
fuse 96991 0 - Live 0xffffffffc00e9000
sr_mod 25171 0 - Live 0xffffffffc00e1000
cdrom 41565 1 sr_mod, Live 0xffffffffc00d5000
zram 16448 1 - Live 0xffffffffc00cf000
i2c_piix4 12352 0 - Live 0xffffffffc00ca000
cfg80211 465383 0 - Live 0xffffffffc0057000
nf_conntrack_ipv6 16448 2 - Live 0xffffffffc0051000
nf_defrag_ipv6 49439 1 nf_conntrack_ipv6, Live 0xffffffffc0043000
ip6table_filter 12352 1 - Live 0xffffffffc003e000
ip6_tables 28913 1 ip6table_filter, Live 0xffffffffc0035000
virtio_net 28736 0 - Live 0xffffffffc0028000
ppp_async 16448 0 - Live 0xffffffffc0022000
ppp_generic 29210 1 ppp_async, Live 0xffffffffc0015000
slhc 16627 1 ppp_generic, Live 0xffffffffc000d000
tun 28775 0 - Live 0xffffffffc0000000
localhost ~ # cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0064-0064 : keyboard
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0170-0177 : 0000:00:01.1
    0170-0177 : ata_piix
  01f0-01f7 : 0000:00:01.1
    01f0-01f7 : ata_piix
  0376-0376 : 0000:00:01.1
    0376-0376 : ata_piix
  03c0-03df : vga+
  03f6-03f6 : 0000:00:01.1
    03f6-03f6 : ata_piix
0cf8-0cff : PCI conf1
0d00-adff : PCI Bus 0000:00
ae0f-aeff : PCI Bus 0000:00
af20-afdf : PCI Bus 0000:00
afe0-afe3 : ACPI GPE0_BLK
afe4-ffff : PCI Bus 0000:00
  b000-b03f : 0000:00:01.3
    b000-b003 : ACPI PM1a_EVT_BLK
    b004-b005 : ACPI PM1a_CNT_BLK
    b008-b00b : ACPI PM_TMR
  b100-b10f : 0000:00:01.3
    b100-b107 : piix4_smbus
  c000-c01f : 0000:00:03.0
    c000-c01f : virtio-pci
  c020-c02f : 0000:00:01.1
    c020-c02f : ata_piix
localhost ~ # cat /proc/iomem
00000000-00000fff : reserved
00001000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c8fff : Video ROM
000c9000-000c99ff : Adapter ROM
000ca000-000cc3ff : Adapter ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7fffdfff : System RAM
  22800000-2306eb7a : Kernel code
  2306eb7b-236dbfff : Kernel data
  23806000-238fbfff : Kernel bss
7fffe000-7fffffff : reserved
80000000-febfffff : PCI Bus 0000:00
  fc000000-fdffffff : 0000:00:02.0
    fc000000-fc3fffff : cirrusdrmfb_vram
  feb80000-febbffff : 0000:00:03.0
  febc0000-febcffff : 0000:00:02.0
  febd0000-febd0fff : 0000:00:02.0
    febd0000-febd0fff : cirrusdrmfb_mmio
  febd1000-febd1fff : 0000:00:03.0
    febd1000-febd1fff : virtio-pci
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fee00000-fee00fff : Local APIC
feffc000-feffffff : reserved
fffc0000-ffffffff : reserved

localhost ~ # cat /proc/filesystems
nodev sysfs
nodev rootfs
nodev ramfs
nodev bdev
nodev proc
nodev cgroup
nodev tmpfs
nodev devtmpfs
nodev debugfs
nodev securityfs
nodev sockfs
nodev pipefs
nodev devpts
ext3
ext2
ext4
nodev ecryptfs
nodev pstore
fuseblk
nodev fuse
nodev fusectl
