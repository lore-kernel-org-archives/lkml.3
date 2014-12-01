Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaLABSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 20:18:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60741 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaLABSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 20:18:31 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <547BC199.6070200@jp.fujitsu.com>
Date: Mon, 1 Dec 2014 10:17:13 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        <linuxppc-dev@ozlabs.org>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH] slab: Fix nodeid bounds check for non-contiguous node
 IDs
References: <20141130221606.GA25929@iris.ozlabs.ibm.com> <547BB2F0.5040708@jp.fujitsu.com> <20141201004210.GA11234@drongo>
In-Reply-To: <20141201004210.GA11234@drongo>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/01 9:42), Paul Mackerras wrote:
> On Mon, Dec 01, 2014 at 09:14:40AM +0900, Yasuaki Ishimatsu wrote:
>> (2014/12/01 7:16), Paul Mackerras wrote:
>>> The bounds check for nodeid in ____cache_alloc_node gives false
>>> positives on machines where the node IDs are not contiguous, leading
>>> to a panic at boot time.  For example, on a POWER8 machine the node
>>> IDs are typically 0, 1, 16 and 17.  This means that num_online_nodes()
>>> returns 4, so when ____cache_alloc_node is called with nodeid = 16 the
>>> VM_BUG_ON triggers.
>>
>> Do you have the call trace? If you have it, please add it in the description.
>
> I can get it easily enough.
>
>>> To fix this, we instead compare the nodeid with MAX_NUMNODES, and
>>> additionally make sure it isn't negative (since nodeid is an int).
>>> The check is there mainly to protect the array dereference in the
>>> get_node() call in the next line, and the array being dereferenced is
>>> of size MAX_NUMNODES.  If the nodeid is in range but invalid, the
>>> BUG_ON in the next line will catch that.
>>>
>>> Signed-off-by: Paul Mackerras <paulus@samba.org>
>>
>> Do you need to backport it into -stable kernels?
>
> It does need to go to stable, yes, for 3.10 and later.
>
>>> ---
>>> diff --git a/mm/slab.c b/mm/slab.c
>>> index eb2b2ea..f34e053 100644
>>> --- a/mm/slab.c
>>> +++ b/mm/slab.c
>>> @@ -3076,7 +3076,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
>>>   	void *obj;
>>>   	int x;
>>>
>>

>>> -	VM_BUG_ON(nodeid > num_online_nodes());
>>> +	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);
>>
>> How about use:
>> 	VM_BUG_ON(!node_online(nodeid));
>
> That would not be better, since node_online() doesn't bounds-check its
> argument.
>

Ah. You are right.

>> When allocating the memory, the node of the memory being allocated must be
>> online. But your code cannot check the condition.
>
> The following two lines:
>
>>>   	n = get_node(cachep, nodeid);
>>>   	BUG_ON(!n);
>
> effectively check that condition already, as I tried to explain in the
> commit message.

O.K. I understood.

Thansk,
Yasuaki Ishimatsu

>
> Regards,
> Paul.
>


