Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678Ab3JQUXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:23:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3JQUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:23:50 -0400
Date: Thu, 17 Oct 2013 13:23:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Damien Ramonda <damien.ramonda@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, pierre.tardy@intel.com,
        fengguang.wu@intel.com, david.a.cohen@intel.com
Subject: Re: [PATCH] readahead: fix sequential read cache miss detection
Message-Id: <20131017132348.a89c6cb5222eda83fb0ce079@linux-foundation.org>
In-Reply-To: <1382033352-21225-1-git-send-email-damien.ramonda@intel.com>
References: <1382033352-21225-1-git-send-email-damien.ramonda@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 20:09:12 +0200 Damien Ramonda <damien.ramonda@intel.com> wrote:

> The kernel's readahead algorithm sometimes interprets random read
> accesses as sequential and triggers unnecessary data prefecthing
> from storage device (impacting random read average latency).
> 
> In order to identify sequential cache read misses, the readahead
> algorithm intends to check whether offset - previous offset == 1
> (trivial sequential reads) or offset - previous offset == 0
> (sequential reads not aligned on page boundary):
> 
> if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
> 
> The current offset is stored in the "offset" variable of type
> "pgoff_t" (unsigned long), while previous offset is stored in
> "ra->prev_pos" of type "loff_t" (long long). Therefore,
> operands of the if statement are implicitly converted to type
> long long. Consequently, when previous offset > current offset
> (which happens on random pattern), the if condition is true
> and access is wrongly interpeted as sequential. An unnecessary
> data prefetching is triggered, impacting the average
> random read latency.
> 
> Storing the previous offset value in a "pgoff_t" variable
> (unsigned long) fixes the sequential read detection logic.

Do you have any performance testing results which would permit
people to understand the significance of this change?

Thanks.
