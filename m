Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaDXOcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:32:14 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:53711 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaDXOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:32:12 -0400
Date: Thu, 24 Apr 2014 10:32:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
Message-ID: <20140424143208.GB14460@htj.dyndns.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398328643.2805.102.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 24, 2014 at 04:37:23PM +0800, Li Zhong wrote:
> On Wed, 2014-04-23 at 10:39 -0400, Tejun Heo wrote:
> After thinking it harder, I still couldn't see ABBA here ... 
> 
> the active protection taken here is for "probe/release" which will not
> be waited for removing something like "online" under cpu#? Or my
> assumption that s_active for different files are different locks are
> completely wrong? Or I missed something else? 

I'm probably confused about the locking.  I was thinking a scenario
like the following.

A. CPU on/offline

   grabs s_active protection of online node
   grabs cpu subsys mutex
   perform on/offline
   releases cpu subsys mutex
   releases s_active protection of online node

B. CPU release

   grabs s_active protection of release node
   grabs cpu subsys mutex
   performs removal of the CPU
   removes the online node
   releases cpu subsys mutex
   releases s_active protection of release node

A nests cpu subsys mutex under s_active of the online node.  B nests
s_active of the online node under the cpu subsys mutex.  What am I
missing?

Thanks.

-- 
tejun
