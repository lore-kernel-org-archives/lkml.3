Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935767Ab3DKVYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:24:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935434Ab3DKVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:24:18 -0400
Date: Thu, 11 Apr 2013 14:24:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] mm: Soft-dirty bits for user memory changes
 tracking
Message-Id: <20130411142417.bb58d519b860d06ab84333c2@linux-foundation.org>
In-Reply-To: <51669EB8.2020102@parallels.com>
References: <51669E5F.4000801@parallels.com>
	<51669EB8.2020102@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013 15:30:00 +0400 Pavel Emelyanov <xemul@parallels.com> wrote:

> The soft-dirty is a bit on a PTE which helps to track which pages a task
> writes to. In order to do this tracking one should
> 
>   1. Clear soft-dirty bits from PTEs ("echo 4 > /proc/PID/clear_refs)
>   2. Wait some time.
>   3. Read soft-dirty bits (55'th in /proc/PID/pagemap2 entries)
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
> ...
>
> +config MEM_SOFT_DIRTY
> +	bool "Track memory changes"
> +	depends on CHECKPOINT_RESTORE && X86

I guess we can add the CHECKPOINT_RESTORE dependency for now, but it is
a general facility and I expect others will want to get their hands on
it for unrelated things.

>From that perspective, the dependency on X86 is awful.  What's the
problem here and what do other architectures need to do to be able to
support the feature?


You have a test application, I assume.  It would be helpful if we could
get that into tools/testing/selftests.
