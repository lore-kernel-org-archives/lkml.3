Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbbAEK2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:28:07 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57097 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbbAEK2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:28:05 -0500
MIME-Version: 1.0
Date: Mon, 5 Jan 2015 10:21:10 +0000
Message-ID: <CANd1uZkn_Dk+s9vjxaA4B2oqWVoohzCQOHUuAdt3QK1ng37x6Q@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
From: Jay Foad <jay.foad@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for replying to this old email...

On Wed, 2010-08-18 at 13:30 -0700, Greg KH wrote:
> 2.6.35-stable review patch. If anyone has any objections, please let us know.
>
> ------------------
>
> From: Linus Torvalds <torvalds@xxxxxxxxxxxxxxxxxxxx>
>
> commit d7824370e26325c881b665350ce64fb0a4fde24a upstream.
>
> This commit makes the stack guard page somewhat less visible to user
> space. It does this by:
>
> - not showing the guard page in /proc/<pid>/maps

> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -210,6 +210,7 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
>   int flags = vma->vm_flags;
>   unsigned long ino = 0;
>   unsigned long long pgoff = 0;
> + unsigned long start;
>   dev_t dev = 0;
>   int len;
>
> @@ -220,8 +221,13 @@ static void show_map_vma(struct seq_file *m, struct vm_area_struct *vma)
>   pgoff = ((loff_t)vma->vm_pgoff) << PAGE_SHIFT;
>   }
>
> + /* We don't show the stack guard page in /proc/maps */
> + start = vma->vm_start;
> + if (vma->vm_flags & VM_GROWSDOWN)
> + start += PAGE_SIZE;
> +
>   seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
> - vma->vm_start,
> + start,
>   vma->vm_end,
>   flags & VM_READ ? 'r' : '-',
>   flags & VM_WRITE ? 'w' : '-',

This change seems to be causing a problem with an address sanitizer
(https://code.google.com/p/address-sanitizer/) test case. See here for
some more details: http://reviews.llvm.org/D6777

Address sanitizer tries to find the mapping for the current thread's
stack by iterating through the entries in /proc/self/maps looking for
one that contains the address of some random stack variable. This
fails if the stack mapping has already used up all of its RLIMIT_STACK
quota, because in that case check_stack_guard_page() will fail to add
a guard page, but show_map_vma() will still assume that the first page
of the stack *is* a guard page, and won't report it in /proc/maps.

Here's a small program that demonstrates the failure:

$ cat lim.c
#include <stdio.h>
int main() {
  char a[1000];
  FILE *m = fopen("/proc/self/maps", "r");
  while (fgets(a, sizeof a, m)) {
    unsigned long p = (unsigned long)a, start, end;
    if (sscanf(a, "%lx-%lx", &start, &end) == 2
        && start <= p && p < end) {
      printf("stack found at %lx-%lx\n", start, end);
      goto close;
    }
  }
  printf("stack not found\n");
close:
  fclose(m);
  main();
}

On x86-64 with a 3.16 kernel I get:

$ gcc -o lim lim.c && ulimit -Ss 16 && ./lim
stack found at 7fff389c7000-7fff389ca000
stack found at 7fff389c7000-7fff389ca000
stack found at 7fff389c7000-7fff389ca000
stack not found
stack not found
stack not found
Segmentation fault (core dumped)

This seems like a bug in /proc/maps to me, but is there any chance of
fixing it? Or is it too late to change this behaviour?

Thanks,
Jay.
