Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3J2O3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:29:47 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33313 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756968Ab3J2O3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:29:45 -0400
Date: Tue, 29 Oct 2013 10:26:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        handai.szj@taobao.com, Andrew Morton <akpm@linux-foundation.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] percpu: fix this_cpu_sub() subtrahend casting for
 unsigneds
Message-ID: <20131029142644.GB1548@cmpxchg.org>
References: <1382895017-19067-1-git-send-email-gthelen@google.com>
 <1382895017-19067-3-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382895017-19067-3-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 10:30:16AM -0700, Greg Thelen wrote:
> this_cpu_sub() is implemented as negation and addition.
> 
> This patch casts the adjustment to the counter type before negation to
> sign extend the adjustment.  This helps in cases where the counter
> type is wider than an unsigned adjustment.  An alternative to this
> patch is to declare such operations unsupported, but it seemed useful
> to avoid surprises.
> 
> This patch specifically helps the following example:
>   unsigned int delta = 1
>   preempt_disable()
>   this_cpu_write(long_counter, 0)
>   this_cpu_sub(long_counter, delta)
>   preempt_enable()
> 
> Before this change long_counter on a 64 bit machine ends with value
> 0xffffffff, rather than 0xffffffffffffffff.  This is because
> this_cpu_sub(pcp, delta) boils down to this_cpu_add(pcp, -delta),
> which is basically:
>   long_counter = 0 + 0xffffffff
> 
> Also apply the same cast to:
>   __this_cpu_sub()
>   __this_cpu_sub_return()
>   this_cpu_sub_return()
> 
> All percpu_test.ko passes, especially the following cases which
> previously failed:
> 
>   l -= ui_one;
>   __this_cpu_sub(long_counter, ui_one);
>   CHECK(l, long_counter, -1);
> 
>   l -= ui_one;
>   this_cpu_sub(long_counter, ui_one);
>   CHECK(l, long_counter, -1);
>   CHECK(l, long_counter, 0xffffffffffffffff);
> 
>   ul -= ui_one;
>   __this_cpu_sub(ulong_counter, ui_one);
>   CHECK(ul, ulong_counter, -1);
>   CHECK(ul, ulong_counter, 0xffffffffffffffff);
> 
>   ul = this_cpu_sub_return(ulong_counter, ui_one);
>   CHECK(ul, ulong_counter, 2);
> 
>   ul = __this_cpu_sub_return(ulong_counter, ui_one);
>   CHECK(ul, ulong_counter, 1);
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Acked-by: Tejun Heo <tj@kernel.org>

FWIW:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
