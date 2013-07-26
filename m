Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3GZCJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:09:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab3GZCJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:09:36 -0400
X-IronPort-AV: E=Sophos;i="4.89,747,1367942400"; 
   d="scan'208";a="8028919"
Message-ID: <51F1DB45.90905@cn.fujitsu.com>
Date: Fri, 26 Jul 2013 10:13:25 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear workers of a pool after the CPU is offline
References: <1374749531-16423-1-git-send-email-laijs@cn.fujitsu.com> <20130725153121.GF26107@mtj.dyndns.org>
In-Reply-To: <20130725153121.GF26107@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 10:07:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 10:07:29,
	Serialize complete at 2013/07/26 10:07:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:31 PM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Thu, Jul 25, 2013 at 06:52:02PM +0800, Lai Jiangshan wrote:
>> The unbound pools and their workers can be destroyed/cleared
>> when their refcnt become zero. But the cpu pool can't be destroyed
>> due to they are always referenced, their refcnt are always > 0.
>>
>> We don't want to destroy the cpu pools, but we want to destroy
>> the workers of the pool when the pool is full idle after the cpu
>> is offline. This is the default behavior in old days until
>> we removed the trustee_thread().
>>
>> We need to find a new way to restore this behavior,
>> We add offline_pool() and POOL_OFFLINE flag to do so.
> 
> Hmmm... if I'm not confused, now the cpu pools just behave like a
> normal unbound pool when the cpu goes down,

cpu pools are always referenced, they don't behave like unbound pool.

> which means that the idle
> cpu workers will exit once idle timeout is reached, right? 

No, no code to force the cpu workers quit currently.
you can just offline a cpu to see what happened to the workers.

> I really
> don't think it'd be worthwhile to add extra logic to accelerate the
> process.
> 
> Note that there actually are benefits to doing it asynchronously as
> CPUs go up and down very frequently on mobile platforms and destroying
> idle workers as soon as possible would just mean that we'd be doing a
> lot of work which isn't necessary.  I mean, we even grew an explicit
> mechanism to park kthreads to avoid repeatedly creating and destroying
> per-cpu kthreads as cpus go up and down.  I don't see any point in
> adding code to go the other direction.
> 
> Thanks.
> 

