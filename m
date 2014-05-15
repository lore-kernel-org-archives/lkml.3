Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaEOPI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:08:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6303 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752823AbaEOPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:08:57 -0400
Date: Thu, 15 May 2014 11:08:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [tracing] b1169cc69ba: +10060.4% proc-vmstat.numa_pte_updates
Message-ID: <20140515110855.72d04020@gandalf.local.home>
In-Reply-To: <53743D42.3070309@intel.com>
References: <53743D42.3070309@intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 12:06:26 +0800
Jet Chen <jet.chen@intel.com> wrote:

> Hi Steven,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/core
> commit b1169cc69ba96b124df820904a6d3eb775491d7f ("tracing: Remove mock up poll wait function")

I have to apologize as I'm not familiar with this benchmark.

> 
> f4874261049e3ab  b1169cc69ba96b124df820904
> ---------------  -------------------------
>        191 ~15%  +10060.4%      19487 ~ 8%  lkp-ne04/dd-write/1HDD-ext4-2dd.4k
>        191 ~15%  +10060.4%      19487 ~ 8%  TOTAL proc-vmstat.numa_pte_updates
> 
> f4874261049e3ab  b1169cc69ba96b124df820904
> ---------------  -------------------------
>    2419721 ~ 0%     +88.0%    4549654 ~ 2%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
>    2419721 ~ 0%     +88.0%    4549654 ~ 2%  TOTAL perf-stat.context-switches
> 
> f4874261049e3ab  b1169cc69ba96b124df820904
> ---------------  -------------------------
>        954 ~ 0%     +52.7%       1457 ~ 0%  lkp-ne04/dd-write/1HDD-ext4-2dd.4k
>       3932 ~ 0%     +89.1%       7438 ~ 2%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
>       4887 ~ 0%     +82.0%       8895 ~ 2%  TOTAL vmstat.system.cs
> 
> f4874261049e3ab  b1169cc69ba96b124df820904
> ---------------  -------------------------
>     163477 ~ 0%     +60.1%     261769 ~ 0%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
>     163477 ~ 0%     +60.1%     261769 ~ 0%  TOTAL perf-stat.cpu-migrations
> 
> f4874261049e3ab  b1169cc69ba96b124df820904
> ---------------  -------------------------
>      28742 ~ 0%      +6.4%      30574 ~ 0%  lkp-ws02/dd-write/11HDD-JBOD-cfq-xfs-1dd
>      28742 ~ 0%      +6.4%      30574 ~ 0%  TOTAL vmstat.system.in

What exactly is being measured here? What tool is running?

The change removed a brain dead way of blocking on the ring buffer,
which, if there was no data, it would sleep for 100ms and try again,
even if no event happened.

The new way is to act more like a real pipe. That is, if there's no
data, you will block but as soon as data comes in, you are woken and
can read the data. If data is coming in at a steady pace, every read
will wake up more often to get that data. More will happen which is a
good thing as the old way was to wait 100ms and by then, the tracing
could easily overflow the ring buffer.

Perhaps we could add water marks, that is, only wake up if the ring
buffer is partially full.

-- Steve


> 
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> 	
> Thanks,
> Jet
> 
> 

