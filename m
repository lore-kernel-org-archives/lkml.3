Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab3FXSts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:49:48 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:46499 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972Ab3FXStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:49:47 -0400
Message-ID: <51C894C3.4040407@hurleysoftware.com>
Date: Mon, 24 Jun 2013 14:49:39 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, Alex Shi <alex.shi@intel.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] rwsem: do optimistic spinning for writer lock acquisition
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>  <1371858700.22432.5.camel@schen9-DESK>  <51C558E2.1040108@hurleysoftware.com>  <1372017836.1797.14.camel@buesod1.americas.hpqcorp.net> <1372093876.22432.34.camel@schen9-DESK>
In-Reply-To: <1372093876.22432.34.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 01:11 PM, Tim Chen wrote:
> On Sun, 2013-06-23 at 13:03 -0700, Davidlohr Bueso wrote:
>> On Sat, 2013-06-22 at 03:57 -0400, Peter Hurley wrote:
>>> On 06/21/2013 07:51 PM, Tim Chen wrote:
>>>>
>>>> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
>>>> +{
>>>> +	int retval = true;
>>>> +
>>>> +	/* Spin only if active writer running */
>>>> +	if (!sem->owner)
>>>> +		return false;
>>>> +
>>>> +	rcu_read_lock();
>>>> +	if (sem->owner)
>>>> +		retval = sem->owner->on_cpu;
>>>                            ^^^^^^^^^^^^^^^^^^
>>>
>>> Why is this a safe dereference? Could not another cpu have just
>>> dropped the sem (and thus set sem->owner to NULL and oops)?
>>>
>
> The rcu read lock should protect against sem->owner being NULL.

It doesn't.

Here's the comment from mutex_spin_on_owner():

   /*
    * Look out! "owner" is an entirely speculative pointer
    * access and not reliable.
    */

Regards,
Peter Hurley

