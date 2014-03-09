Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaCIP5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 11:57:21 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:48055 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaCIP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 11:57:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140309125710.GA1829@redhat.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	<20140308184040.GA29602@redhat.com>
	<CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
	<20140308194405.GA32403@redhat.com>
	<CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
	<20140309125710.GA1829@redhat.com>
Date: Sun, 9 Mar 2014 08:57:19 -0700
X-Google-Sender-Auth: Qkso9Hf51uw_EnIVMaEWneBwhIA
Message-ID: <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 5:57 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> No, dup_task_struct() is obviously lockless. And the new child is not yet
> visible to for_each_process_thread().

Ok, then the siimple approach is to just do

    /* Did we miss an invalidate event? *
    if (mm->seqcount < tsk->seqcount)
        clear_vma_cache();

after making the new thread visible.

Then the "race" becomes one of "we cannot have 4 billion mmap/munmap
events in other threads while we're setting up a new thread", which I
think is fine.

               Linus
