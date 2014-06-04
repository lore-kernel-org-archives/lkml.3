Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaFDXbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbaFDXbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:31:36 -0400
Date: Wed, 4 Jun 2014 19:31:22 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: mtk.manpages@gmail.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        zohar@linux.vnet.ibm.com
Subject: ima_mmap_file returning 0 to userspace as mmap result.
Message-ID: <20140604233122.GA19838@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
	zohar@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed that trinity was freaking out in places when mmap was
returning zero.  This surprised me, because I had the mmap_min_addr
sysctl set to 64k, so it wasn't a MAP_FIXED mapping that did it.

There's no mention of this return value in the man page, so I dug
into the kernel code, and it appears that we do..

sys_mmap
vm_mmap_pgoff
security_mmap_file
ima_file_mmap <- returns 0 if not PROT_EXEC

and then the 0 gets propagated up as a retval all the way to userspace.

It smells to me like we might be violating a standard or two here, and
instead of 0 ima should be returning -Esomething

thoughts?

	Dave

