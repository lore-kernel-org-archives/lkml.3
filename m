Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3HBSTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:19:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab3HBSTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:19:42 -0400
Date: Fri, 2 Aug 2013 14:19:35 -0400
From: Jeremy Eder <jeder@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rafael.j.wysocki@intel.com, riel@redhat.com, youquan.song@intel.com,
        paulmck@linux.vnet.ibm.com, daniel.lezcano@linaro.org,
        arjan@linux.intel.com, len.brown@intel.com
Subject: Re: RFC:  revert request for cpuidle patches e11538d1 and 69a37bea
Message-ID: <20130802181935.GC31525@jeder.rdu.redhat.com>
References: <20130726173306.GB17985@jeder.rdu.redhat.com>
 <20130730035731.GA701@linux-youquan.bj.intel.com>
 <20130729165947.GB31525@jeder.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729165947.GB31525@jeder.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 130729 12:59:47, Jeremy Eder wrote:
> On 130729 23:57:31, Youquan Song wrote:
> > Hi Jeremy,
> > 
> > I try reproduce your result and then fix the issue, but I do not reproduce it
> >  yet.
> > 
> > I run at netperf-2.6.0 at one machine as server: netserver, other
> > machine: netperf -t TCP_RR -H $SERVER_IP -l 60. The target machine is
> > used in both client and server. I do not reproduce the performance drop
> > issue. I also notice the result is not stable, sometime it is high,
> > sometime is low. In sumarry, it is hard to make a definite result.
> > 
> > Can you try tell me how to reproduce the issue? how do you get the C0
> > data?
> > 
> > What's your config for kernel?  Do you enable CONFIG_NO_HZ_FULL=y or
> > only CONFIG_NO_HZ=y?
> > 
> > 
> > Thanks
> > -Youquan 
> 
> Hi,
> 
> To answer both your and Daniel's question, those results used only
> CONFIG_NO_HZ=y.
> 
> These network latency benchmarks are fickle creatures, and need careful
> tuning to become reproducible.  Plus there are BIOS implications and tuning
> varies by vendor.
> 
> Anyway for the most part it's probably not stable because in order to get
> any sort
> of reproducibility between runs you need to do at least these steps:
> 
> - ensure as little is running in userspace as possible
> - determine PCI affinity for the NIC
> - on both machines, isolate the socket connected to the NIC from userspace
>   tasks
> - Turn off irqbalance and bind all IRQs for that NIC to a single core on
>   the same socket as the NIC
> - run netperf with -TX,Y where X,Y are core numbers that you wish
>   netperf/netserver to run on, respectively.
> 
> For example, if your NIC is attached to socket 0 and socket 0 cores are
> enumerated 0-7, then:
> 
> - set /proc/irq/NNN/smp_affinity_list to, say, 6 for all vectors on that
>   NIC.
> - nice -20 netperf -t TCP_RR - $SERVER_IP -l 60 -T4,4 -s 2
> 
> That should get you most of the way there.  The -s 2 connects and waits 2
> seconds, I found this to help with the first few second's worth of data.
> Or
> you could just toss the first 2 seconds worth, it seems to take that long
> to stabilize.  What I mean is, if you're not using -D1,1 option to netperf,
> you might not have seen that netperf tests seem to take a few seconds to
> stabilize even
> when properly tuned.
> 
> I got the C0 data by running turbostat in parallel with each benchmark run,
> then grabbing the C-state data for the cores relevant to the test.  In my
> case that was cores 4 and 6, where core 4 was where I put netperf/netserver
> and core 6 was where I put the NIC IRQs.  Then I parsed that output into a
> format that this could interpret:
> 
> https://github.com/bitly/data_hacks/blob/master/data_hacks/histogram.py
> 
> I'm building a kernel from Rafael's tree and will try to confirm what Len
> already sent.  Thanks everyone for looking into it.


Hi, sorry for the delay.  In addition to the results I initially posted,
the below results confirm my initial data, plus what Len sent:

3.11-rc2 w/reverts
TCP_RR trans/s 54454.13

3.11-rc2 w/reverts + c0 lock
TCP_RR trans/s 55088.11
