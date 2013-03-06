Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3CFAJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:09:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50972 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3CFAJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:09:33 -0500
Date: Wed, 06 Mar 2013 09:07:53 +0900 (JST)
Message-Id: <20130306.090753.332720289.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/20] vmcore, sysfs: export ELF note segment size
 instead of vmcoreinfo data size
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130302083605.31252.26646.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083605.31252.26646.stgit@localhost6.localdomain6>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 03/20] vmcore, sysfs: export ELF note segment size instead of vmcoreinfo data size
Date: Sat, 2 Mar 2013 17:36:05 +0900

> p_memsz member of program header entry with PT_NOTE type needs to have
> size of the corresponding ELF note segment. Currently, vmcoreinfo
> exports data part only. If vmcoreinfo reachs vmcoreinfo_max_size, then
> in merge_note_headers_elf{32,64}, empty ELF note header cannot be
> found or buffer overrun can happen.

Sorry, I noticed this "buffer overrun can happen" was completely
wrong. In merge_note_headers_elf{32,64}, the size is being checked to
avoid buffer overrun.

                int j;
                void *notes_section;
                struct vmcore *new;
                u64 offset, max_sz, sz, real_sz = 0;
...
                for (j = 0; j < max_sz; j += sz) {
                        if (nhdr_ptr->n_namesz == 0)
                                break;
                        sz = sizeof(Elf32_Nhdr) +
                                ((nhdr_ptr->n_namesz + 3) & ~3) +
                                ((nhdr_ptr->n_descsz + 3) & ~3);
                        real_sz += sz;
                        nhdr_ptr = (Elf32_Nhdr*)((char*)nhdr_ptr + sz);
                }

But later patch changes teminator of ELF note segments from the null
not header to NT_VMCORE_PAD note type. It's important to export a
whole buffer for ELF note segments, not data part only. This patch
description doesn't explain this, and I'll add this explanation in the
next version.

Also, here j has int type but the other variables compared with the j
have u64 type. This is strange, and in fact verbose because for the
purpose of the j, real_sz seems exact. I'll replace the for statement
by while statement in additional clean-up patch as:

  while (real_sz < max_sz) {
    ..
  }

Thanks.
HATAYAMA, Daisuke

