Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3KFBSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 20:18:49 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39015 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3KFBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 20:18:48 -0500
Date: Tue, 5 Nov 2013 17:18:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sameer Nanda <snanda@chromium.org>
cc: akpm@linux-foundation.org, mhocko@suse.cz, hannes@cmpxchg.org,
        rusty@rustcorp.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, oom: Fix race when selecting process to kill
In-Reply-To: <1383693987-14171-1-git-send-email-snanda@chromium.org>
Message-ID: <alpine.DEB.2.02.1311051715090.29471@chino.kir.corp.google.com>
References: <1383693987-14171-1-git-send-email-snanda@chromium.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, Sameer Nanda wrote:

> The selection of the process to be killed happens in two spots -- first
> in select_bad_process and then a further refinement by looking for
> child processes in oom_kill_process. Since this is a two step process,
> it is possible that the process selected by select_bad_process may get a
> SIGKILL just before oom_kill_process executes. If this were to happen,
> __unhash_process deletes this process from the thread_group list. This
> then results in oom_kill_process getting stuck in an infinite loop when
> traversing the thread_group list of the selected process.
> 
> Fix this race by holding the tasklist_lock across the calls to both
> select_bad_process and oom_kill_process.
> 
> Change-Id: I8f96b106b3257b5c103d6497bac7f04f4dff4e60
> Signed-off-by: Sameer Nanda <snanda@chromium.org>

Nack, we had to avoid taking tasklist_lock for this duration since it 
stalls out forks and exits on other cpus trying to take the writeside with 
irqs disabled to avoid watchdog problems.

What kernel version are you patching?  If you check the latest Linus tree, 
we hold a reference to the task_struct of the chosen process before 
calling oom_kill_process() so the hypothesis would seem incorrect.
