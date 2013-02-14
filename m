Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3BNKMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:12:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943Ab3BNKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:12:03 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 03/13] vmcore: fill unused part of buffer for ELF headers with
 0
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:11:59 +0900
Message-ID: <20130214101159.22466.38580.stgit@localhost6.localdomain6>
In-Reply-To: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Via mmap() we export the range [elfcorebuf_sz, roundup(elfcorebuf_sz,
PAGE_SIZE)] to user-space. We need to fill this range with 0.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 5010ead..43d338a 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -328,6 +328,11 @@ static int __init merge_note_headers_elf64(char *elfptr, size_t *elfsz,
 	*elfsz = *elfsz - i;
 	memmove(tmp, tmp+i, ((*elfsz)-sizeof(Elf64_Ehdr)-sizeof(Elf64_Phdr)));
 
+	/* Fill unused part with zero */
+	memset(elfptr + sizeof(Elf64_Ehdr) +
+	       (ehdr_ptr->e_phnum - nr_ptnote + 1) * sizeof(Elf64_Phdr), 0,
+	       (nr_ptnote - 1) * sizeof(Elf64_Phdr));
+
 	/* Modify e_phnum to reflect merged headers. */
 	ehdr_ptr->e_phnum = ehdr_ptr->e_phnum - nr_ptnote + 1;
 

