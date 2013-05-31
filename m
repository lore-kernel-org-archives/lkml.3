Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3EaVqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:46:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3EaVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:46:38 -0400
Date: Fri, 31 May 2013 14:46:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
Message-Id: <20130531144636.6b34c6ba48105482d1241a40@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1305291817280.520@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 18:18:10 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Completely disabling the oom killer for a memcg is problematic if
> userspace is unable to address the condition itself, usually because it
> is unresponsive.  This scenario creates a memcg deadlock: tasks are
> sitting in TASK_KILLABLE waiting for the limit to be increased, a task to
> exit or move, or the oom killer reenabled and userspace is unable to do
> so.
> 
> An additional possible use case is to defer oom killing within a memcg
> for a set period of time, probably to prevent unnecessary kills due to
> temporary memory spikes, before allowing the kernel to handle the
> condition.
> 
> This patch adds an oom killer delay so that a memcg may be configured to
> wait at least a pre-defined number of milliseconds before calling the oom
> killer.  If the oom condition persists for this number of milliseconds,
> the oom killer will be called the next time the memory controller
> attempts to charge a page (and memory.oom_control is set to 0).  This
> allows userspace to have a short period of time to respond to the
> condition before deferring to the kernel to kill a task.
> 
> Admins may set the oom killer delay using the new interface:
> 
> 	# echo 60000 > memory.oom_delay_millisecs
> 
> This will defer oom killing to the kernel only after 60 seconds has
> elapsed by putting the task to sleep for 60 seconds.

How often is that delay actually useful, in the real world?

IOW, in what proportion of cases does the system just remain stuck for
60 seconds and then get an oom-killing?

