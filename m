Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab3FSAB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:01:28 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:62331 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSAB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:01:26 -0400
Date: Tue, 18 Jun 2013 17:01:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Thorlton <athorlton@sgi.com>
cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH v2] Make transparent hugepages cpuset aware
In-Reply-To: <20130618164537.GJ16067@sgi.com>
Message-ID: <alpine.DEB.2.02.1306181654350.4503@chino.kir.corp.google.com>
References: <1370967244-5610-1-git-send-email-athorlton@sgi.com> <alpine.DEB.2.02.1306111517200.6141@chino.kir.corp.google.com> <20130618164537.GJ16067@sgi.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013, Alex Thorlton wrote:

> Thanks for your input, however, I believe the method of using a malloc
> hook falls apart when it comes to static binaries, since we wont' have
> any shared libraries to hook into.  Although using a malloc hook is a
> perfectly suitable solution for most cases, we're looking to implement a
> solution that can be used in all situations.
> 

I guess the question would be why you don't want your malloc memory backed 
by thp pages for certain static binaries and not others?  Is it because of 
an increased rss due to khugepaged collapsing memory because of its 
default max_ptes_none value?

> Aside from that particular shortcoming of the malloc hook solution,
> there are some other situations having a cpuset-based option is a
> much simpler and more efficient solution than the alternatives.

Sure, but why should this be a cpuset based solution?  What is special 
about cpusets that make certain statically allocated binaries not want 
memory backed by thp while others do?  This still seems based solely on 
convenience instead of any hard requirement.

> One
> such situation that comes to mind would be an environment where a batch
> scheduler is in use to ration system resources.  If an administrator
> determines that a users jobs run more efficiently with thp always on,
> the administrator can simply set the users jobs to always run with that
> setting, instead of having to coordinate with that user to get them to
> run their jobs in a different way.  I feel that, for cases such as this,
> the this additional flag is in line with the other capabilities that
> cgroups and cpusets provide.
> 

That sounds like a memcg, i.e. container, type of an issue, not a cpuset 
issue which is more geared toward NUMA optimizations.  User jobs should 
always run more efficiently with thp always on, the worst-case scenario 
should be if they run with the same performance as thp set to never.  In 
other words, there shouldn't be any regression that requires certain 
cpusets to disable thp because of a performance regression.  If there are 
any, we'd like to investigate that separately from this patch.
