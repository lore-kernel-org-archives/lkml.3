Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3KTFjj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:39:39 -0500
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:62870 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3KTFjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:39:36 -0500
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "chaowang@redhat.com" <chaowang@redhat.com>
Subject: Re: /proc/vmcore mmap() failure issue
Thread-Topic: /proc/vmcore mmap() failure issue
Thread-Index: AQHO4SSy18hsX/7760SqeZbh92xDy5okPyCAgAE1igCAAE93gIAFRXRpgAKRRhA=
Date: Wed, 20 Nov 2013 05:29:16 +0000
Message-ID: <0910DD04CBD6DE4193FCF86B9C00BE971C3862@BPXM01GP.gisp.nec.co.jp>
References: <20131113204130.GD7613@redhat.com>
 <5284A689.70903@jp.fujitsu.com> <20131114151359.GA3913@redhat.com>
 <5285EC60.1060906@jp.fujitsu.com> <20131115142617.GC6637@redhat.com>
 <0910DD04CBD6DE4193FCF86B9C00BE971BF592@BPXM01GP.gisp.nec.co.jp>
 <20131118135511.GA30637@redhat.com>
In-Reply-To: <20131118135511.GA30637@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.40.240]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/18 22:56:10, kexec <kexec-bounces@lists.infradead.org> wrote:
> On Mon, Nov 18, 2013 at 12:51:39AM +0000, Atsushi Kumagai wrote:
> 
> [..]
> > > Is there any chance that you could look into fixing this. I have no 
> > > experience writing code for makedumpfile.
> > 
> > I'll send a patch to fix this soon.
> 
> Thanks Atsushi.
> 
> Vivek

Vivek, could you test this patch ?

Thanks
Atsushi Kumagai


From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Date: Wed, 20 Nov 2013 10:05:03 +0900
Subject: [PATCH] Disable mmap() for reading fractional pages.

Since mmap() was introduced on /proc/vmcore, it fails
for fractional pages which don't start or end at page boundary
due to kernel issue.
This patch disables mmap() temporarily for fractional pages
to avoid this issue, so mmap() will be used only for aligned pages.

Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
---
 makedumpfile.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/makedumpfile.c b/makedumpfile.c
index 3746cf6..ca03440 100644
--- a/makedumpfile.c
+++ b/makedumpfile.c
@@ -368,6 +368,7 @@ readpage_elf(unsigned long long paddr, void *bufptr)
 	off_t offset1, offset2;
 	size_t size1, size2;
 	unsigned long long phys_start, phys_end, frac_head = 0;
+	int original_usemmap = info->flag_usemmap;
 
 	offset1 = paddr_to_offset(paddr);
 	offset2 = paddr_to_offset(paddr + info->page_size);
@@ -392,6 +393,7 @@ readpage_elf(unsigned long long paddr, void *bufptr)
 		offset1 = paddr_to_offset(phys_start);
 		frac_head = phys_start - paddr;
 		memset(bufptr, 0, frac_head);
+		info->flag_usemmap = FALSE;
 	}
 
 	/*
@@ -402,6 +404,7 @@ readpage_elf(unsigned long long paddr, void *bufptr)
 		phys_end = page_head_to_phys_end(paddr);
 		offset2 = paddr_to_offset(phys_end);
 		memset(bufptr + (phys_end - paddr), 0, info->page_size - (phys_end - paddr));
+		info->flag_usemmap = FALSE;
 	}
 
 	/*
@@ -420,7 +423,7 @@ readpage_elf(unsigned long long paddr, void *bufptr)
 	if(!read_from_vmcore(offset1, bufptr + frac_head, size1)) {
 		ERRMSG("Can't read the dump memory(%s).\n",
 		       info->name_memory);
-		return FALSE;
+		goto error;
 	}
 
 	if (size1 + frac_head != info->page_size) {
@@ -429,11 +432,16 @@ readpage_elf(unsigned long long paddr, void *bufptr)
 		if(!read_from_vmcore(offset2, bufptr + frac_head + size1, size2)) {
 			ERRMSG("Can't read the dump memory(%s).\n",
 			       info->name_memory);
-			return FALSE;
+			goto error;
 		}
 	}
 
+	info->flag_usemmap = original_usemmap;
 	return TRUE;
+
+error:
+	info->flag_usemmap = original_usemmap;
+	return FALSE;
 }
 
 static int
-- 
1.8.0.2
