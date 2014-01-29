Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaA2Usn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:48:43 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39751 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaA2Usl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:48:41 -0500
Date: Thu, 30 Jan 2014 00:48:30 +0400
From: Andrew Vagin <avagin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Vagin <avagin@openvz.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        criu@openvz.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>, Borislav Petkov <bp@suse.de>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH] mm: don't lose the SOFT_DIRTY flag on mprotect
Message-ID: <20140129204830.GB25429@gmail.com>
References: <1391025899-25299-1-git-send-email-avagin@openvz.org>
 <20140129121859.07da0df20daea6a1581e709a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20140129121859.07da0df20daea6a1581e709a@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 12:18:59PM -0800, Andrew Morton wrote:
> On Thu, 30 Jan 2014 00:04:59 +0400 Andrey Vagin <avagin@openvz.org> wrote:
> 
> > The SOFT_DIRTY bit shows that the content of memory was changed
> > after a defined point in the past. mprotect() doesn't change the
> > content of memory, so it must not change the SOFT_DIRTY bit.
> > 
> > This patch does nothing with _PAGE_SWP_SOFT_DIRTY, becase pte_modify()
> > is called only for present pages.
> 
> Standard complaint: when fixing a bug, please describe the end-user
> visible effects of that bug.
> 
> afaict the effects are minor: snapshotting will save/copy more pages
> than it needs to, but there will be no malfunction.  Hence a -stable
> backport is unneeded.  Agree?

There will be malfunction. On the first iteration all pages are dumped.
On other iterations only pages with the SOFT_DIRTY bit are dumped. So if
the SOFT_DIRTY bit is cleared from a page by mistake, the page is not
dumped and its content will be restored incorrectly.
This patch should be cc'ed to stable. Sorry forgot to do this in first
place.

The following program is able to detect the problem:
#include <sys/mman.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

#define PME_SOFT_DIRTY (1ULL << 55)

int main()
{
        unsigned long long v;
        void *p;
        int fd;

        p = mmap(NULL, 4096, PROT_WRITE,
				MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
        if (p == MAP_FAILED)
                return -1;

        fd = open("/proc/self/clear_refs", O_WRONLY);
        if (fd < 0)
                return 1;
        if (write(fd, "4\n", 2) < 2)
                return 1;
        close(fd);

        *((int *) p) = 5;

        fd = open("/proc/self/pagemap", O_RDONLY);
        if (fd < 0)
                return 1;
        mprotect(p, 4096, PROT_READ);
        lseek(fd, (unsigned long) p / 4096 * 8, SEEK_SET);
        read(fd, &v, sizeof(v));
        close(fd);

        printf("%8llx\n", v);

        if (v & PME_SOFT_DIRTY) {
                printf("PASS\n");
                return 0;
        }

        printf("FAIL\n");
        return 1;
}
