Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992Ab3BMVsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:48:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52949 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3BMVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:47:58 -0500
Date: Wed, 13 Feb 2013 13:47:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] mm: Limit pgd range freeing to mm->task_size
Message-Id: <20130213134756.b90f8e1b.akpm@linux-foundation.org>
In-Reply-To: <1360755569-27282-1-git-send-email-catalin.marinas@arm.com>
References: <1360755569-27282-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 11:39:29 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> ARM processors with LPAE enabled use 3 levels of page tables, with an
> entry in the top level (pgd) covering 1GB of virtual space. Because of
> the branch relocation limitations on ARM, the loadable modules are
> mapped 16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared
> between kernel modules and user space.
> 
> Since free_pgtables() is called with ceiling == 0, free_pgd_range() (and
> subsequently called functions) also frees the page table
> shared between user space and kernel modules (which is normally handled
> by the ARM-specific pgd_free() function).
> 
> This patch changes the ceiling argument to mm->task_size for the
> free_pgtables() and free_pgd_range() function calls. We cannot use
> TASK_SIZE since this macro may not be a run-time constant on 64-bit
> systems supporting compat applications.

I'm trying to work out why we're using 0 in there at all, rather than
->task_size.  But that's lost in the mists of time.

As you've discovered, handling of task_size and TASK_SIZE is somewhat
inconsistent across architectures and with compat tasks.  I guess we
toss it in there and see if anything breaks...
