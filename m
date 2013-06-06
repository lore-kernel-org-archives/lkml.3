Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3FFPnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:43:18 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62583 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3FFPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:43:17 -0400
Date: Thu, 6 Jun 2013 17:43:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>, paulmck@linux.vnet.ibm.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: rcu_preempt running flat out on idle desktop.
Message-ID: <20130606154311.GA5688@somewhere>
References: <20130508203042.GA18895@redhat.com>
 <CAFTL4hwB3XZG+C9pQ0JD4h=n_ObNH6mCBRfLW3JaxohwwRDWRA@mail.gmail.com>
 <20130509211026.GA22723@redhat.com>
 <20130514012105.GB12749@somewhere>
 <20130606153136.GA12823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606153136.GA12823@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:31:36AM -0400, Dave Jones wrote:
> On Tue, May 14, 2013 at 03:21:07AM +0200, Frederic Weisbecker wrote:
>  > On Thu, May 09, 2013 at 05:10:26PM -0400, Dave Jones wrote:
>  > > On Thu, May 09, 2013 at 11:02:08PM +0200, Frederic Weisbecker wrote:
>  > > 
>  > >  > > RCU options for this build are..
>  > >  > >
>  > >  > I can't reproduce that issue even with the above setting. Could you
>  > >  > please send me your whole config?
>  > > 
>  > > http://paste.fedoraproject.org/11363/36813375/raw/
>  > 
>  > Sorry it took me some time to get that config booting, I ran into
>  > other unrelated crashes.
>  > 
>  > So I'm observing the exact opposite than you: the processes appear to
>  > have no load nor to consume cputime. Even if I use some dumb user loop.
>  > Top don't even show it.
>  > 
>  > I'm digging further and will tell you when I get more info.
> 
> So I'm still seeing this on rc4.
> 
> Here's my 'idle' firewall, just routing packets:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND                                                                                                          
>  4405 root      20   0     0    0    0 S 400.0  0.0  52336:27 kworker/2:0                                                                                                      
> 20968 davej     20   0  115m 1840 1092 R 400.0  0.1   2297:48 top                                                                                                              
>   964 named     20   0  383m  32m 2896 S 400.0  1.7  81384:54 named                                                                                                            
>    10 root      20   0     0    0    0 S 400.0  0.0 195403:05 rcu_preempt                                                                                                      
> 20830 davej     20   0  125m 2172 1024 S 400.0  0.1 939:36.10 sshd                                                                                                             
>    11 root      20   0     0    0    0 S 400.0  0.0  42644:33 rcuop/0                                                                                                          
>    13 root      20   0     0    0    0 S 400.0  0.0  34729:04 rcuop/2                                                                                                          
>   754 lighttpd  20   0 54640 2692 1732 S 400.0  0.1  35286:11 lighttpd                                                                                                         
>   756 root      20   0  216m  10m 6116 S 400.0  0.5  34143:41 snmpd                                                                                                            
>    35 root      20   0     0    0    0 S 400.0  0.0  12790:56 ksoftirqd/2                                                                                                      
> 19893 root      20   0     0    0    0 S 400.0  0.0  12570:49 kworker/0:1                                                                                                      
> 20059 root      20   0     0    0    0 S 400.0  0.0   4666:30 kworker/1:1                                                                                                      
>    32 root      rt   0     0    0    0 S 400.0  0.0   8780:22 watchdog/2                                                                                                       
>   792 root      20   0 92220 2516  632 S 400.0  0.1   7821:28 sendmail                                                                                                         
>    25 root      rt   0     0    0    0 S 400.0  0.0   8780:21 watchdog/0                                                                                                       
>    26 root      rt   0     0    0    0 S 400.0  0.0   8780:22 watchdog/1                                                                                                       
>    38 root      rt   0     0    0    0 S 400.0  0.0   8780:22 watchdog/3                                                                                                       
> 19167 root      20   0     0    0    0 S 400.0  0.0   7804:04 kworker/3:2     
> 
> 
> Every process is either 400%, or 0%.
> 
> Here's my desktop box, just writing this email:
> 
>   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND                                                                                                          
>    10 root      20   0     0    0    0 S 200.0  0.0  35134:00 rcu_preempt                                                                                                      
>    12 root      20   0     0    0    0 S 200.0  0.0  14059:47 rcuop/1                                                                                                          
> 12528 root      20   0     0    0    0 S 200.0  0.0   1012:56 kworker/0:1                                                                                                      
> 12999 davej     20   0  115m 1700  956 R 200.0  0.1   1:09.10 top                                                                                                              
>  4799 root      20   0     0    0    0 S 200.0  0.0   3510:40 kworker/1:1                                                                                                      
>     1 root      20   0 50760 5092 1648 S   0.0  0.2   3:14.96 systemd                                                                                                          
>     2 root      20   0     0    0    0 S   0.0  0.0   1:40.55 kthreadd      
> 
> Every process 200% or 0%.

I see, would you mind testing this branch?

git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
	timers/urgent

It might help, I specially think about 45eacc692771bd2b1ea3d384e6345cab3da10861
("vtime: Use consistent clocks among nohz accounting") which fixes an issue
with cputime accounting that resulted in similar symptoms.

Thanks.
