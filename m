Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaJRR7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 13:59:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaJRR7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 13:59:09 -0400
Date: Sat, 18 Oct 2014 13:59:07 -0400 (EDT)
Message-Id: <20141018.135907.356113264227709132.davem@davemloft.net>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.11.1410171410210.25429@adalberg.ut.ee>
References: <20141016.162001.599580415052560455.davem@redhat.com>
	<20141016.165017.1151349565275102498.davem@davemloft.net>
	<alpine.LRH.2.11.1410171410210.25429@adalberg.ut.ee>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Oct 2014 10:59:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Fri, 17 Oct 2014 14:12:09 +0300 (EEST)

> However, on top of mainline HEAD 3.17.0-09670-g0429fbc it explodes with 
> scheduler BUG - just reported to LKML + sched maintainers.

task_stack_end_corrupted() cannot work properly on sparc64.

It stores the magic value at "task_thread_info(p) + 1", but on
sparc64 that's where we store the nested array of FPU register
saves.

In fact this facility could be corrupting FPU register state in
certain circumstances.

The current sparc64 design is intentional, the CPU stack grows down
toward the thread_info, and the FPU stack saving area grows up from
the end of thread_info.

I don't want to define the array size of the fpregs save area
explicitly and thereby placing an artificial limit there.
