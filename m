Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3GKSrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:47:03 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58853 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3GKSq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:46:57 -0400
Message-ID: <51DEFD9E.7010703@mit.edu>
Date: Thu, 11 Jul 2013 11:46:54 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mm: soft-dirty bits for user memory changes tracking
References: <517FED13.8090806@parallels.com> <517FED64.4020400@parallels.com>
In-Reply-To: <517FED64.4020400@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 09:12 AM, Pavel Emelyanov wrote:
> The soft-dirty is a bit on a PTE which helps to track which pages a task
> writes to. In order to do this tracking one should
> 
>   1. Clear soft-dirty bits from PTEs ("echo 4 > /proc/PID/clear_refs)
>   2. Wait some time.
>   3. Read soft-dirty bits (55'th in /proc/PID/pagemap entries)
> 
> To do this tracking, the writable bit is cleared from PTEs when the
> soft-dirty bit is. Thus, after this, when the task tries to modify a page
> at some virtual address the #PF occurs and the kernel sets the soft-dirty
> bit on the respective PTE.
> 
> Note, that although all the task's address space is marked as r/o after the
> soft-dirty bits clear, the #PF-s that occur after that are processed fast.
> This is so, since the pages are still mapped to physical memory, and thus
> all the kernel does is finds this fact out and puts back writable, dirty
> and soft-dirty bits on the PTE.
> 
> Another thing to note, is that when mremap moves PTEs they are marked with
> soft-dirty as well, since from the user perspective mremap modifies the
> virtual memory at mremap's new address.
> 
> 

Sorry I'm late to the party -- I didn't notice this until the lwn
article this week.

How does this get munmap + mmap right?  mremap marks things soft-dirty,
but unmapping and remapping seems like it will result in the soft-dirty
bit being cleared.  For that matter, won't this sequence also end up wrong:

 - clear_refs
 - Write to mapping
 - Page and pte evicted due to memory pressure
 - Read from mapping -- clean page faulted back in
 - pte soft-dirty is now clear ?!?

--Andy
