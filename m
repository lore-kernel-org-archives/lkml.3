Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbaLLQFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:05:46 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:64666 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbaLLQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <1418379595-6281-6-git-send-email-laijs@cn.fujitsu.com>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-6-git-send-email-laijs@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 12 Dec 2014 11:05:24 -0500
Message-ID: <CAHGf_=ps80f47d3JdyaYt3iEEF-Ur_OxLS_R7q7cPA7yMO7Pag@mail.gmail.com>
Subject: Re: [PATCH 5/5] workqueue: retry on NUMA_NO_NODE when create_worker() fails
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 5:19 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> A pwq bound to a specified node might be last long or even forever after
> the node was offline.  Especially when this pwq has some back-to-back work
> items which requeue themselves and cause the pwq can't quit.
>
> This kinds of pwqs will cause their own pools busy and maybe create workers.
> This pools will fail on create_worker() since the node is offline.
>
> This case is extremely rare, but it is possible. And we hope create_worker()
> to be fault-tolerant in this case and other different cases when the node
> is lack of memory, for example, create_worker() can try to allocate memory
> from the whole system rather than only the target node, the most important
> thing is making some progress.
>
> So the solution is that, when the create_worker() fails on a specified node,
> it will retry with NUMA_NO_NODE for further allocation.

The code looks correct. But I don't think this issue depend on node offlining.
The allocation may also fail if node has no memory.
