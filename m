Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbbAJUQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:16:12 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51230 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbAJUQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:16:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc3
Date: Sat, 10 Jan 2015 21:16:02 +0100
Message-ID: <4665410.x9Uu42bKmJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+55aFz74hjhCcdz5J4r-xK4KW7oqNDA3i=jXHW0prGMMwgMvw@mail.gmail.com>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com> <20150110003540.GA32037@node.dhcp.inet.fi> <CA+55aFz74hjhCcdz5J4r-xK4KW7oqNDA3i=jXHW0prGMMwgMvw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:KYYvNpa2QvY1UFzTIOpjsAdd8k9wMTtLQiEN2RMIwQC095Q0Bop
 9x5Aywzg4ffDQ55a9jkDVH+DHNj7nJYlOx3QD1nL0zUup5hIRrVIbFIeHos7F3xjyfKvjSH
 y+ia06ARn+yWvSo5foj1pIR1L2SxeK3DIWZ5xeU6HRkLGv8oMMwNOPPkCkIqmAnNFbN4shn
 HiIZbJ8IAYe6r2N8Iqesg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 18:27:38 Linus Torvalds wrote:
> On Fri, Jan 9, 2015 at 4:35 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > With bigger page size there's also reduction in number of entities to
> > handle by kernel: less memory occupied by struct pages, fewer pages on
> > lru, etc.
> 
> Really, do the math. [...]
>
> With a 64kB page, that means that for caching the kernel tree (what,
> closer to 50k files by now), you are basically wasting 60kB for most
> source files. Say, 60kB * 30k files, or 1.8GB.

On a recent kernel, I get 628 MB for storing all files of the
kernel tree in 4KB pages, and 3141 MB for storing the same data
in 64KB pages, almost exactly factor 5, or 2.45 GiB wasted.

> Maybe things have changed, and maybe I did my math wrong, and people
> can give a more exact number. But it's an example of why 64kB
> granularity is completely unacceptable in any kind of general-purpose
> load.

I'd say it's unacceptable for any file backed mappings in general, but
usually an improvement for anonymous maps, for the same reasons that
transparent huge pages are great. IIRC, AIX works great with 64k
pages, but only because of two reasons that don't apply on Linux:

a) The PowerPC MMU can mix 4KB and 64KB pages in a single process.
   Linux doesn't use this feature except for very special cases,
   although it could be done on PowerPC but not most other architectures.

b) Linux has a unified page cache page size that is used for both
   anonymous and file backed mappings. It's a great feature of the
   Linux MM code (it avoids having two copies of each mapped file
   in memory), but other OSs can just use 4KB blocks in the file
   system cache independent of the page size.

> 4kB works well. 8kB is perfectly acceptable. 16kB is already wasting a
> lot of memory. 32kB and up is complete garbage for general-purpose
> computing.

I was expecting 16KB pages to work better, but you are right:

arnd:~/linux$ for i in 1 2 4 8 16 32 64 128 256 ; do echo -n "$i KiB pages: " ; total=0 ; git ls-files | xargs ls -ld | while read a b c d e f ; do echo $[((e + $i*1024 - 1) / (1024 * $i))  ]  ; done | sort -n | uniq -c | while read num size ; do total=$[$total + ($num * $size) * $i] ; echo $[total / 1024] MiB ; done  | tail -n 1 ; done
1 KiB pages: 544 MiB
2 KiB pages: 571 MiB
4 KiB pages: 628 MiB
8 KiB pages: 759 MiB
16 KiB pages: 1055 MiB
32 KiB pages: 1717 MiB
64 KiB pages: 3141 MiB
128 KiB pages: 6103 MiB
256 KiB pages: 12125 MiB

Regarding ARM64 in particular, I think it would be nice to investigate
how to extend the THP code to cover 64KB TLBs when running with the 4KB
page size. There is a hint bit in the page table to tell the CPU that
a set of 16 aligned pages can share one TLB, and it would be nice to
use that bit in Linux, and to make this case more common for anonymous
mappings, and possible large file based mappings.

	Arnd
