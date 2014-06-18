Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaFRWFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:05:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:34749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaFRWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:05:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,503,1400050800"; 
   d="scan'208";a="559792584"
Message-ID: <53A20CBA.9020109@intel.com>
Date: Wed, 18 Jun 2014 15:03:38 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
References: <539B594C.8070004@intel.com> <20140618214800.GA7445@linux.vnet.ibm.com>
In-Reply-To: <20140618214800.GA7445@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:48 PM, Paul E. McKenney wrote:
> On Fri, Jun 13, 2014 at 01:04:28PM -0700, Dave Hansen wrote:
>> Hi Paul,
>>
>> I'm seeing a regression when comparing 3.15 to Linus's current tree.
>> I'm using Anton Blanchard's will-it-scale "open1" test which creates a
>> bunch of processes and does open()/close() in a tight loop:
>>
>>> https://github.com/antonblanchard/will-it-scale/blob/master/tests/open1.c
>>
>> At about 50 cores worth of processes, 3.15 and the pre-3.16 code start
>> to diverge, with 3.15 scaling better:
>>
>> 	http://sr71.net/~dave/intel/3.16-open1regression-0.png
>>
>> Some profiles point to a big increase in contention inside slub.c's
>> get_partial_node() (the allocation side of the slub code) causing the
>> regression.  That particular open() test is known to do a lot of slab
>> operations.  But, the odd part is that the slub code hasn't been touched
>> much.
> 
> Coming back to this...  If the original was stalling RCU grace periods
> for the duration of the test, then it would also be deferring any
> freeing until after the end of the test.

I run the test for pretty long periods of time, and I don't see any
consistent growth in the memory used.  I'd expect if we were fully
stalling RCU grace periods that we'd see memory usage grow too.

Looking at rcu_sched/rcugp at 1-second intervals, we can see the gpnum
going up consistently (incrementing at a rate of about 15/second).

Does that rule out the possibility of stalling them until after the test?

> Wed Jun 18 14:46:32 PDT 2014: completed=7707 gpnum=7708 age=14 max=123, 7
> Wed Jun 18 14:46:33 PDT 2014: completed=7723 gpnum=7724 age=14 max=123, 7
> Wed Jun 18 14:46:34 PDT 2014: completed=7739 gpnum=7740 age=19 max=123, 7
> Wed Jun 18 14:46:35 PDT 2014: completed=7756 gpnum=7757 age=3 max=123, 6
> Wed Jun 18 14:46:36 PDT 2014: completed=7771 gpnum=7772 age=12 max=123, 5
> Wed Jun 18 14:46:37 PDT 2014: completed=7787 gpnum=7788 age=7 max=123, 5
> Wed Jun 18 14:46:39 PDT 2014: completed=7802 gpnum=7803 age=14 max=123, 5
> Wed Jun 18 14:46:40 PDT 2014: completed=7816 gpnum=7817 age=15 max=123, 5
> Wed Jun 18 14:46:41 PDT 2014: completed=7831 gpnum=7832 age=15 max=123, 6
> Wed Jun 18 14:46:42 PDT 2014: completed=7847 gpnum=7848 age=15 max=123, 6
> Wed Jun 18 14:46:43 PDT 2014: completed=7860 gpnum=7861 age=15 max=123, 6
> Wed Jun 18 14:46:44 PDT 2014: completed=7877 gpnum=7878 age=15 max=123, 6
> Wed Jun 18 14:46:45 PDT 2014: completed=7892 gpnum=7893 age=17 max=123, 6
> Wed Jun 18 14:46:46 PDT 2014: completed=7906 gpnum=7907 age=17 max=123, 7
> Wed Jun 18 14:46:47 PDT 2014: completed=7920 gpnum=7921 age=19 max=123, 7
> Wed Jun 18 14:46:48 PDT 2014: completed=7936 gpnum=7937 age=19 max=123, 7
> Wed Jun 18 14:46:49 PDT 2014: completed=7954 gpnum=7955 age=2 max=123, 7
> Wed Jun 18 14:46:50 PDT 2014: completed=7970 gpnum=7971 age=0 max=123, 7
> Wed Jun 18 14:46:51 PDT 2014: completed=7985 gpnum=7986 age=6 max=123, 7
> Wed Jun 18 14:46:52 PDT 2014: completed=8000 gpnum=8001 age=7 max=123, 8
> Wed Jun 18 14:46:53 PDT 2014: completed=8015 gpnum=8016 age=8 max=123, 8
> Wed Jun 18 14:46:54 PDT 2014: completed=8031 gpnum=8032 age=10 max=123, 7

