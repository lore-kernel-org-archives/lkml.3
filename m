Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaDYB4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:56:20 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:50146 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaDYB4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:56:18 -0400
Message-ID: <1398390970.2805.136.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Fri, 25 Apr 2014 09:56:10 +0800
In-Reply-To: <20140424143208.GB14460@htj.dyndns.org>
References: <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421223804.GD22730@htj.dyndns.org>
	 <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204006.GA3615@mtj.dyndns.org>
	 <1398218426.2805.42.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140423143940.GD4781@htj.dyndns.org>
	 <1398328643.2805.102.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140424143208.GB14460@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042501-5024-0000-0000-00000997F8B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 10:32 -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Apr 24, 2014 at 04:37:23PM +0800, Li Zhong wrote:
> > On Wed, 2014-04-23 at 10:39 -0400, Tejun Heo wrote:
> > After thinking it harder, I still couldn't see ABBA here ... 
> > 
> > the active protection taken here is for "probe/release" which will not
> > be waited for removing something like "online" under cpu#? Or my
> > assumption that s_active for different files are different locks are
> > completely wrong? Or I missed something else? 
> 
> I'm probably confused about the locking.  I was thinking a scenario
> like the following.
> 
> A. CPU on/offline
> 
>    grabs s_active protection of online node
>    grabs cpu subsys mutex
>    perform on/offline
>    releases cpu subsys mutex
>    releases s_active protection of online node

so the chain here is s_active(online) -> cpu_subsys_mutex

> 
> B. CPU release
> 
>    grabs s_active protection of release node
>    grabs cpu subsys mutex
>    performs removal of the CPU
>    removes the online node
>    releases cpu subsys mutex
>    releases s_active protection of release node

and the chain here is s_active(release) -> cpu_subsys_mutex ->
s_active(online)

> 
> A nests cpu subsys mutex under s_active of the online node.  B nests
> s_active of the online node under the cpu subsys mutex.  What am I
> missing?

>From the above two chain, I think the problem is cpu_subsys_mutex and
s_active(online), which is the deadlock we are trying to solve in patch
#2. I seems to me s_active(release) here doesn't have lock issues? 

Thanks, Zhong

> 
> Thanks.
> 


