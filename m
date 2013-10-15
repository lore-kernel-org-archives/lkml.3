Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3JOHxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:53:48 -0400
Received: from mailout09.t-online.de ([194.25.134.84]:52182 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3JOHxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:53:47 -0400
Message-ID: <525CF483.1020908@t-online.de>
Date: Tue, 15 Oct 2013 09:53:39 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request during
 shutdown
References: <525BD08C.2080101@t-online.de> <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com> <20131014212830.GD5790@linux.vnet.ibm.com> <20131014215117.GE13538@localhost.localdomain> <20131015064025.GA22672@gmail.com>
In-Reply-To: <20131015064025.GA22672@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: bLwLB6ZXZhkl7xJunZwK+N7JqrKHguneb-jmvx4fT8WDBHLVlmJWPzj3UfJQexnQn9
X-TOI-MSGID: 5ff5e3f6-24c0-467d-9e59-c5d6771c8af2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.2013 08:40, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> I've been thinking that CONFIG_DEBUG_LIST could help. Unfortunately it's
>> good to spot list APIs misuse but, if Linus is right, the problem may be
>> that the list belongs to an object that has been freed, and I believe
>> that won't detect such a thing.
> Use-after free should be reliably detectable via CONFIG_DEBUG_PAGEALLOC=y.

Enabled.

Hmm ... I think i spotted a KConfig bug.  In mm/Kconfig.debug I read:

config DEBUG_PAGEALLOC
         bool "Debug page memory allocations"
         depends on DEBUG_KERNEL
         depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
         depends on !KMEMCHECK
         select PAGE_POISONING if !ARCH_SUPPORTS_DEBUG_PAGEALLOC
         select PAGE_GUARD if ARCH_SUPPORTS_DEBUG_PAGEALLOC
         ---help---
           Unmap pages from the kernel linear mapping after free_pages().
           This results in a large slowdown, but helps to find certain types
           of memory corruption.

           For architectures which don't enable ARCH_SUPPORTS_DEBUG_PAGEALLOC,
           fill the pages with poison patterns after free_pages() and verify
           the patterns before alloc_pages().  Additionally,
           this option cannot be enabled in combination with hibernation as
           that would result in incorrect warnings of memory corruption after
           a resume because free pages are not saved to the suspend image.


Either the description or the "depends" line that includes !HIBERNATION is wrong. Maybe

         depends on DEBUG_KERNEL
-        depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
+        depends on !HIBERNATION && ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SPARC
         depends on !KMEMCHECK

is correct, at least does not allow HIBERNATION and DEBUG_PAGEALLOC to be enabled simultaneously.

>
> A couple of years ago I wrote a list debugging beast that would catch
> use-after-free mishaps (sent it to lkml too IIRC), but it was a bit
> complex and I never found the time to nurse it upstream.
>
> Thanks,
>
> 	Ingo
>

