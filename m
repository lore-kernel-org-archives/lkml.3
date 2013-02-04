Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab3BDE7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:59:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33904 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3BDE7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:59:42 -0500
From: "Hatayama, Daisuke" <d.hatayama@jp.fujitsu.com>
To: "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>, "cpw@sgi.com" <cpw@sgi.com>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "lisa.mitchell@hp.com" <lisa.mitchell@hp.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kdump, oldmem: support mmap on /dev/oldmem
Thread-Topic: [PATCH] kdump, oldmem: support mmap on /dev/oldmem
Thread-Index: Ac4ClGsOL11EzwL1RDqu1EeC+4dtFg==
Date: Mon, 4 Feb 2013 04:59:35 +0000
Message-ID: <33710E6CAA200E4583255F4FB666C4E20AC36B01@G01JPEXMBYT03>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.124.101.76]
Content-Type: multipart/mixed;
	boundary="_002_33710E6CAA200E4583255F4FB666C4E20AC36B01G01JPEXMBYT03_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_33710E6CAA200E4583255F4FB666C4E20AC36B01G01JPEXMBYT03_
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

Support mmap() on /dev/oldmem to improve performance of reading
/proc/vmcore. Currently, read to /proc/vmcore is done by read_oldmem()
that uses ioremap and iounmap per a single page; for example, if
memory is 1GB, ioremap/iounmap is called (1GB / 4KB)-times, that is,
262144 times. This causes big performance degradation.

By this patch, we saw improvement on simple benchmark from

  200 [MiB/sec] to over 100.00 [GiB/sec].

Benchmark
=3D=3D=3D=3D=3D=3D=3D=3D=3D

=3D Machine spec
  - CPU: Intel(R) Xeon(R) CPU E7- 4820 @ 2.00GHz (4 sockets, 8 cores) (*)
  - memory: 32GB
  - kernel: 3.8-rc5 with this patch
  - vmcore size: 31.7GB

  (*) only 1 cpu is used in the 2nd kernel now.

=3D Benchmark Case

1) copy /proc/vmcore with mmap() on /dev/oldmem

  I ran the next command and recorded real time:

  $ for n in $(seq 1 15) ; do \
  >   time copyvmcore --blocksize=3D$((4096 * (1 << (n - 1)))) /proc/vmcore=
 /dev/null \
  > done

  where copyvmcore is an ad-hoc test tool that parses ELF headers
  and copies them sequentially using mmap() on /dev/oldmem.
  See attached file.

|  n | map size |  time | page table | performance |
|    |          | (sec) |            |   [GiB/sec] |
|----+----------+-------+------------+-------------|
|  1 | 4 KiB    | 41.86 | 8 iB       |        0.76 |
|  2 | 8 KiB    | 25.43 | 16 iB      |        1.25 |
|  3 | 16 KiB   | 13.28 | 32 iB      |        2.39 |
|  4 | 32 KiB   |  7.20 | 64 iB      |        4.40 |
|  5 | 64 KiB   |  3.45 | 128 iB     |        9.19 |
|  6 | 128 KiB  |  1.82 | 256 iB     |       17.42 |
|  7 | 256 KiB  |  1.03 | 512 iB     |       30.78 |
|  8 | 512 KiB  |  0.61 | 1K iB      |       51.97 |
|  9 | 1 MiB    |  0.41 | 2K iB      |       77.32 |
| 10 | 2 MiB    |  0.32 | 4K iB      |       99.06 |
| 11 | 4 MiB    |  0.27 | 8K iB      |      117.41 |
| 12 | 8 MiB    |  0.24 | 16 KiB     |      132.08 |
| 13 | 16 MiB   |  0.23 | 32 KiB     |      137.83 |
| 14 | 32 MiB   |  0.22 | 64 KiB     |      144.09 |
| 15 | 64 MiB   |  0.22 | 128 KiB    |      144.09 |

2) copy /proc/vmcore without mmap() on /dev/oldmem

$ time dd bs=3D4096 if=3D/proc/vmcore of=3D/dev/null
8307246+1 records in
8307246+1 records out
real    2m 31.50s
user    0m 1.06s
sys     2m 27.60s

So performance is 214.26 [MiB/sec].

3) The benchmark on previous patch

  See:

  http://lists.infradead.org/pipermail/kexec/2013-January/007758.html

  where more than 2.5 [GiB/sec] improvement was shown.

=3D Discussion

When map size is small, there are many mmap() calls and we can see the
same situation as ioremap() case. When map size is large enough, we
can see drastic improvement. This is because the number of mmap() is
as small enough as page table modification and TLB flush doesn't
matter. Another reason why performance is drastically better than the
previous patch's is that memory copy from kernel-space to user-space
is no longer performed now.

Performance improvement is saturated in relatively small map size and
so page table is relatively small. I guess we don't need to support
large pages on remap_pfn_range() for now or for ever.

Design Concern
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The previous patch mapped a whole memory range targeted by kdump at
the same time on linear direct-mapping region. But doing that way is,
on the worst case, difficult to estimate amount of memory used for
page table to map the range.

Although I then once tried to investigate how to improve the issue by
mapping all the DIMM ranges that are all expected to be 1GB-aligned
and so 1GB pages are effective for small memory, I didn't choose this
way due to one memory hot-plugging issue related to undefined
behaviour of reading physical memory hole typically resulting in
system hang and another issue complicating the address to the 1st
issue, that there's no reliable source of actually present DIMM ranges
for use of kernel; SMBIOS is not sufficient since not all the
firmwares exports them.

On the other hand, /dev/oldmem is a simple interface whose offset
value corresponds to physical address of a whole system memory, and
even by this, there's room for userland tool to improve performance in
enough quality. For example, makedumpfile causes the performance in
reading huge consequtive memory sequentially, such as huge mem_map
array or each chunk corresponding to PT_LOAD map. We can improve the
performance even by using mmap() only there.

For design decision, I didn't support mmap() on /proc/vmcore because
it abstracts old memory as ELF format, so there's range consequtive on
/proc/vmcore but not consequtive on the actual old memory. For
example, consider ELF headers on the 2nd kernel and the note objects,
memory chunks corresponding to PT_LOAD entries on the first kernel.
They are not consequtive on the old memory. So reampping them so
/proc/vmcore appears consequtive using existing remap_pfn_range() needs
some complicated work.

TODO
=3D=3D=3D=3D

- fix makedumpfile to use mmap() on /dev/oldmem and benchmark it to
  confirm whether we can see enough performance improvement.

Test
=3D=3D=3D=3D

Tested and built on x86_64.

Thanks.
HATAYAMA, Daisuke

>From cf89aace87c8e7192909eb35334a139143a806e8 Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Wed, 30 Jan 2013 13:02:02 +0900
Subject: [PATCH] kdump, oldmem: support mmap on /dev/oldmem

Support mmap() on /dev/oldmem to improve performance of reading
/proc/vmcore. Currently, read to /proc/vmcore is done by read_oldmem()
that uses ioremap and iounmap per a single page; for example, if
memory is 1GB, ioremap/iounmap is called (1GB / 4KB)-times, that is,
262144 times. This causes big performance degradation.

By this patch, we saw improvement on simple benchmark from

  200 [MiB/sec] to over 100.00 [GiB/sec].

We don't permit mapping over saved_max_pfn as is done in read_oldmem()
and mapping memory as neither writable nor executable.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 drivers/char/mem.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index c6fa3bc..e9046634 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -388,6 +388,32 @@ static ssize_t read_oldmem(struct file *file, char __u=
ser *buf,
 	}
 	return read;
 }
+
+/*
+ * Mmap memory corresponding to the old kernel.
+ */
+static int mmap_oldmem(struct file *file, struct vm_area_struct *vma)
+{
+	size_t size =3D vma->vm_end - vma->vm_start;
+	unsigned long pfn =3D vma->vm_pgoff;
+
+	if (pfn + (size >> PAGE_SHIFT) > saved_max_pfn + 1)
+		return -EINVAL;
+
+	if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+		return -EPERM;
+
+	vma->vm_flags &=3D ~(VM_MAYWRITE | VM_MAYEXEC);
+
+	if (remap_pfn_range(vma,
+			    vma->vm_start,
+			    pfn,
+			    size,
+			    vma->vm_page_prot))
+		return -EAGAIN;
+
+	return 0;
+}
 #endif
=20
 #ifdef CONFIG_DEVKMEM
@@ -806,6 +832,7 @@ static const struct file_operations oldmem_fops =3D {
 	.read	=3D read_oldmem,
 	.open	=3D open_oldmem,
 	.llseek =3D default_llseek,
+	.mmap	=3D mmap_oldmem,
 };
 #endif
=20
--=20
1.7.7.6


--_002_33710E6CAA200E4583255F4FB666C4E20AC36B01G01JPEXMBYT03_
Content-Type: application/x-gzip; name="tool.tar.gz"
Content-Description: tool.tar.gz
Content-Disposition: attachment; filename="tool.tar.gz"; size=2173;
	creation-date="Mon, 04 Feb 2013 04:47:09 GMT";
	modification-date="Mon, 04 Feb 2013 04:47:09 GMT"
Content-Transfer-Encoding: base64

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
ApZHACgAAA==

--_002_33710E6CAA200E4583255F4FB666C4E20AC36B01G01JPEXMBYT03_--
