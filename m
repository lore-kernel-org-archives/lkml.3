Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaGIQg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:36:56 -0400
Received: from mx2.parallels.com ([199.115.105.18]:53581 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaGIQgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:36:54 -0400
Date: Wed, 9 Jul 2014 20:36:31 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Tim Hockin <thockin@hockin.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH RFC 0/5] Virtual Memory Resource Controller for cgroups
Message-ID: <20140709163631.GG6685@esperanza>
References: <cover.1404383187.git.vdavydov@parallels.com>
 <20140709075252.GB31067@esperanza>
 <CAAAKZwsRDb6a062SFZYv-1SDYyD12uTzVMpdZt0CtdDjoddNVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAAKZwsRDb6a062SFZYv-1SDYyD12uTzVMpdZt0CtdDjoddNVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Wed, Jul 09, 2014 at 08:08:07AM -0700, Tim Hockin wrote:
> How is this different from RLIMIT_AS?  You specifically mentioned it
> earlier but you don't explain how this is different.

The main difference is that RLIMIT_AS is per process while this
controller is per cgroup. RLIMIT_AS doesn't allow us to limit VSIZE for
a group of unrelated or cooperating through shmem processes.

Also RLIMIT_AS accounts for total VM usage (including file mappings),
while this only charges private writable and shared mappings, whose
faulted-in pages always occupy mem+swap and therefore cannot be just
synced and dropped like file pages. In other words, this controller
works exactly as the global overcommit control.

> From my perspective, this is pointless.  There's plenty of perfectly
> correct software that mmaps files without concern for VSIZE, because
> they never fault most of those pages in.

But there's also software that correctly handles ENOMEM returned by
mmap. For example, mongodb keeps growing its buffers until mmap fails.
Therefore, if there's no overcommit control, it will be OOM-killed
sooner or later, which may be pretty annoying. And we did have customers
complaining about that.

> From my observations it is not generally possible to predict an
> average VSIZE limit that would satisfy your concerns *and* not kill
> lots of valid apps.

Yes, it's difficult. Actually, we can only guess. Nevertheless, we
predict and set the VSIZE limit system-wide by default.

> It sounds like what you want is to limit or even disable swap usage.

I want to avoid OOM kill if it's possible to return ENOMEM. OOM can be
painful. It can kill lots of innocent processes. Of course, the user can
protect some processes by setting oom_score_adj, but this is difficult
and requires time and expertise, so an average user won't do that.

> Given your example, your hypothetical user would probably be better of
> getting an OOM kill early so she can fix her job spec to request more
> memory.

In my example the user won't get OOM kill *early*...

Thanks.
