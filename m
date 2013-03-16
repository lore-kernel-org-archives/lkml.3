Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3CSCbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:31:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46301 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab3CSCbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:31:36 -0400
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v3 17/21] vmcore: check NT_VMCORE_PAD as a mark indicating the
 end of ELF note buffer
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
Date: Sat, 16 Mar 2013 13:02:23 +0900
Message-ID: <20130316040223.15064.77472.stgit@localhost6.localdomain6>
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern kernel marks the end of ELF note buffer with NT_VMCORE_PAD type
note in order to make the buffer satisfy mmap()'s page-size boundary
requirement. This patch makes finishing reading each buffer if the
note type now being read is NT_VMCORE_PAD type.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index b252d17..2a0f885 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -258,12 +258,24 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 		}
 		nhdr_ptr = notes_section;
 		while (real_sz < max_sz) {
+			char *name;
+
+			/* Old kernel marks the end of ELF note buffer
+			 * with empty header. */
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf64_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
 			real_sz += sz;
+
+			/* Modern kernel marks the end of ELF note
+			 * buffer with NT_VMCORE_PAD type note. */
+			name = (char *)(nhdr_ptr + 1);
+			if (strncmp(name, VMCOREINFO_NOTE_NAME,
+				    sizeof(VMCOREINFO_NOTE_NAME)) == 0
+			    && nhdr_ptr->n_type == NT_VMCORE_PAD)
+				break;
 			nhdr_ptr = (Elf64_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 
@@ -367,12 +379,24 @@ static int __init merge_note_headers_elf32(char *elfptr, size_t *elfsz,
 		}
 		nhdr_ptr = notes_section;
 		while (real_sz < max_sz) {
+			char *name;
+
+			/* Old kernel marks the end of ELF note buffer
+			 * with empty header. */
 			if (nhdr_ptr->n_namesz == 0)
 				break;
 			sz = sizeof(Elf32_Nhdr) +
 				((nhdr_ptr->n_namesz + 3) & ~3) +
 				((nhdr_ptr->n_descsz + 3) & ~3);
 			real_sz += sz;
+
+			/* Modern kernel marks the end of ELF note
+			 * buffer with NT_VMCORE_PAD type note. */
+			name = (char *)(nhdr_ptr + 1);
+			if (strncmp(name, VMCOREINFO_NOTE_NAME,
+				    sizeof(VMCOREINFO_NOTE_NAME)) == 0
+			    && nhdr_ptr->n_type == NT_VMCORE_PAD)
+				break;
 			nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
 		}
 

