Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaGQUML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:12:11 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:5546 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbaGQUMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:12:09 -0400
Date: Thu, 17 Jul 2014 22:12:04 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: "Horiguchi, Naoya" <Naoya.Horiguchi@necam.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, nao.horiguchi@gmail.com
Subject: Re: [BUG] new copy_hugetlb_page_range() causing crashes
Message-ID: <20140717201203.GA23591@bender.morinfr.org>
Mail-Followup-To: "Horiguchi, Naoya" <Naoya.Horiguchi@necam.com>,
	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, nao.horiguchi@gmail.com
References: <019768ac467043a4aaea3e455cb74db7@BPXC18GP.gisp.nec.co.jp>
 <FC3CA273EA98D94B96901B237F5F506BB61DC0@irvmail101.necam.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FC3CA273EA98D94B96901B237F5F506BB61DC0@irvmail101.necam.prv>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nayoa,

Thanks for your answer.

On 17 Jul 14:35, Horiguchi, Naoya wrote:
> I tried some simple operation (below) on 3.14.12, but not reproduced the crash,
> so some non-trivial condition seemed to trigger this.
> Could you elaborate about how you reproduced the crash?

Well, It's just a bunch of fairly random unit tests and I was not able
to make it happen on a small program.  However, I modified your program
a bit and managed to reproduce the problem:

$ cat heap.c 
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main() {
        int i;
        char *p = malloc(4096*512);
        for (i = 0; i < 512; i++)
                p[i*4096] = '1';
        printf("p %p\n", p);
        for (i = 0 ; i < 10; i++)
                if (!fork()) {
                    memset(p, '2', 4096*512);
                    p = malloc(4096*512);
                    printf("pid %d\n", getpid());
                    memset(p, '3', 4096*512);
                    free(p);

                    return 0;
                }
        pause();                                    
}

This is what happens on my 3.14.12 machine:
$ export HUGETLB_MORECORE=yes ; export HUGETLB_NO_PREFAULT= ; hugectl --heap ./h
p 0x800010
pid 7974
pid 7975
h: malloc.c:2369: sysmalloc: Assertion `(old_top == (((mbinptr) (((char *) &((av)->bins[((1) - 1) * 2])) - __builtin_offsetof (struct malloc_chunk, fd)))) && old_size == 0) || ((unsigned long) (old_size) >= (unsigned long)((((__builtin_offsetof (struct malloc_chunk, fd_nextsize))+((2 * (sizeof(size_t))) - 1)) & ~((2 * (sizeof(size_t))) - 1))) && ((old_top)->size & 0x1) && ((unsigned long)old_end & pagemask) == 0)' failed.

Sometimes the process gets stuck instead asserting out.  But I could not
make it SIGSEGV

Same result with the 3.4.98 kernel.

It works fine when I remove your patch though

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
