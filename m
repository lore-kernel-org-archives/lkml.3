Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab3KLUA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:00:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab3KLUAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:00:50 -0500
Date: Tue, 12 Nov 2013 21:01:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sameer Nanda <snanda@chromium.org>
Cc: akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com,
        hannes@cmpxchg.org, rusty@rustcorp.com.au, semenzato@google.com,
        murzin.v@gmail.com, dserrg@gmail.com, msb@chromium.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm, oom: Fix race when selecting process to kill
Message-ID: <20131112200156.GA9820@redhat.com>
References: <20131109151639.GB14249@redhat.com> <1384215717-2389-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384215717-2389-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Sameer Nanda wrote:
>
> The selection of the process to be killed happens in two spots:
> first in select_bad_process and then a further refinement by
> looking for child processes in oom_kill_process. Since this is
> a two step process, it is possible that the process selected by
> select_bad_process may get a SIGKILL just before oom_kill_process
> executes. If this were to happen, __unhash_process deletes this
> process from the thread_group list. This results in oom_kill_process
> getting stuck in an infinite loop when traversing the thread_group
> list of the selected process.
>
> Fix this race by adding a pid_alive check for the selected process
> with tasklist_lock held in oom_kill_process.

OK, looks correct to me. Thanks.


Yes, this is a step backwards, hopefully we will revert this patch soon.
I am starting to think something like while_each_thread_lame_but_safe()
makes sense before we really fix this nasty (and afaics not simple)
problem with with while_each_thread() (which should die).

Oleg.

