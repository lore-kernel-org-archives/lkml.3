Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaFEEks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:40:48 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41395 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaFEEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:40:45 -0400
Message-ID: <538FF4C4.5090300@gmail.com>
Date: Thu, 05 Jun 2014 06:40:36 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        zohar@linux.vnet.ibm.com
CC: mtk.manpages@gmail.com
Subject: Re: ima_mmap_file returning 0 to userspace as mmap result.
References: <20140604233122.GA19838@redhat.com>
In-Reply-To: <20140604233122.GA19838@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 01:31 AM, Dave Jones wrote:
> I just noticed that trinity was freaking out in places when mmap was
> returning zero.  This surprised me, because I had the mmap_min_addr
> sysctl set to 64k, so it wasn't a MAP_FIXED mapping that did it.
> 
> There's no mention of this return value in the man page, so I dug
> into the kernel code, and it appears that we do..
> 
> sys_mmap
> vm_mmap_pgoff
> security_mmap_file
> ima_file_mmap <- returns 0 if not PROT_EXEC
> 
> and then the 0 gets propagated up as a retval all the way to userspace.
> 
> It smells to me like we might be violating a standard or two here, and
> instead of 0 ima should be returning -Esomething
> 
> thoughts?

Seems like either EACCESS or ENOTSUP is appropriate; here's the pieces 
from POSIX:

       EACCES The  fildes argument is not open for read, regardless of
              the protection specified, or  fildes  is  not  open  for
              write and PROT_WRITE was specified for a MAP_SHARED type
              mapping.

       ENOTSUP
                   The implementation does not support the combination
                   of accesses requested in the prot argument.

ENOTSUP seems to be more appropriate in my reading of the above, though
I'd somehow more have expected EACCES.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
