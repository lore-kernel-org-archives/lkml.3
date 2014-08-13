Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaHMQon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbaHMQom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:44:42 -0400
Message-ID: <53EB959B.5090003@redhat.com>
Date: Wed, 13 Aug 2014 12:43:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] fix sighand use after free
References: <20140813115000.73da6136@cuia.bos.redhat.com> <20140813155802.GA2695@redhat.com> <53EB8DAC.1040605@redhat.com> <20140813161909.GA3479@redhat.com>
In-Reply-To: <20140813161909.GA3479@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 12:19 PM, Oleg Nesterov wrote:
> On 08/13, Rik van Riel wrote:
>>
>> On 08/13/2014 11:58 AM, Oleg Nesterov wrote:
>>> On 08/13, Rik van Riel wrote:
>>>>
>>>> @@ -1017,7 +1017,7 @@ void __cleanup_sighand(struct sighand_struct *sighand)
>>>>  {
>>>>  	if (atomic_dec_and_test(&sighand->count)) {
>>>>  		signalfd_cleanup(sighand);
>>>> -		kmem_cache_free(sighand_cachep, sighand);
>>>> +		rcu_free(sighand_cachep, sighand);
>>>
>>> Please note that sighand_cachep is SLAB_DESTROY_BY_RCU.
>>
>> SLAB_DESTROY_BY_RCU means that the slab page is not given
>> back to the system until after the RCU grace period has
>> expired.
>>
>> However, the objects inside the slab can still be reused
>> immediately!
> 
> Yes. This is fine. This memory won't be returned to system before rcu
> gp pass, and this memory is still "struct sighand_struct" with the
> properly initialized ->siglock (note the sighand_ctor()).

Fair enough, you are right.

The sighand_ctor does prevent any issues.

The slub code also prevents slubs with constructor
functions from ever getting merged, so this is all
taken care of.
