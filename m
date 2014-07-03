Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaGCUfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:35:45 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:45381 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaGCUfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:35:44 -0400
Message-ID: <53B5BE99.1090008@hp.com>
Date: Thu, 03 Jul 2014 16:35:37 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Davidlohr Bueso <davidlohr@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>  <20140702162749.GP19379@twins.programming.kicks-ass.net>  <1404320356.3170.12.camel@j-VirtualBox>  <20140702172333.GQ19379@twins.programming.kicks-ass.net>  <1404322203.3170.17.camel@j-VirtualBox>  <20140703073107.GS19379@twins.programming.kicks-ass.net>  <1404407389.2498.3.camel@buesod1.americas.hpqcorp.net> <1404412485.8764.33.camel@j-VirtualBox>
In-Reply-To: <1404412485.8764.33.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 02:34 PM, Jason Low wrote:
> On Thu, 2014-07-03 at 10:09 -0700, Davidlohr Bueso wrote:
>> On Thu, 2014-07-03 at 09:31 +0200, Peter Zijlstra wrote:
>>> On Wed, Jul 02, 2014 at 10:30:03AM -0700, Jason Low wrote:
>>>> Would potentially reducing the size of the rw semaphore structure by 32
>>>> bits (for all architectures using optimistic spinning) be a nice
>>>> benefit?
>>> Possibly, although I had a look at the mutex structure and we didn't
>>> have a hole to place it in, unlike what you found with the rwsem.
>> Yeah, and currently struct rw_semaphore is the largest lock we have in
>> the kernel. Shaving off space is definitely welcome.
> Right, especially if it could help things like xfs inode.
>

I do see a point in reducing the size of the rwsem structure. However, I 
don't quite understand the point of converting pointers in the 
optimistic_spin_queue structure to atomic_t. The structure is cacheline 
aligned and there is no saving in size. Converting them to atomic_t does 
have a bit of additional overhead of converting the encoded cpu number 
back to the actual pointer.

So my suggestion is to just change what is stored in the mutex and rwsem 
structure to atomic_t, but keep the pointers in the 
optimistic_spin_queue structure.

-Longman
