Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161561AbaKNRKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:10:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161537AbaKNRKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:10:49 -0500
Message-ID: <54663797.1060106@suse.cz>
Date: Fri, 14 Nov 2014 18:10:47 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>,
        Andrea Argangeli <andrea@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: anon_vma accumulating for certain load still not addressed
References: <20141114130822.GC22857@dhcp22.suse.cz> <54661A8C.5050806@redhat.com>
In-Reply-To: <54661A8C.5050806@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 04:06 PM, Rik van Riel wrote:
> On 11/14/2014 08:08 AM, Michal Hocko wrote:
>> Hi,
>> back in 2012 [1] there was a discussion about a forking load which
>> accumulates anon_vmas. There was a trivial test case which triggers this
>> and can potentially deplete the memory by local user.
>>
>> We have a report for an older enterprise distribution where nsd is
>> suffering from this issue most probably (I haven't debugged it throughly
>> but accumulating anon_vma structs over time sounds like a good enough
>> fit) and has to be restarted after some time to release the accumulated
>> anon_vma objects.
>>
>> There was a patch which tried to work around the issue [2] but I do not
>> see any follow ups nor any indication that the issue would be addressed
>> in other way.
>>
>> The test program from [1] was running for around 39 mins on my laptop
>> and here is the result:
>>
>> $ date +%s; grep anon_vma /proc/slabinfo
>> 1415960225
>> anon_vma           11664  11900    160   25    1 : tunables    0    0    0 : slabdata    476    476      0
>>
>> $ ./a # The reproducer
>>
>> $ date +%s; grep anon_vma /proc/slabinfo
>> 1415962592
>> anon_vma           34875  34875    160   25    1 : tunables    0    0    0 : slabdata   1395   1395      0
>>
>> $ killall a
>> $ date +%s; grep anon_vma /proc/slabinfo
>> 1415962607
>> anon_vma           11277  12175    160   25    1 : tunables    0    0    0 : slabdata    487    487      0
>>
>> So we have accumulated 23211 objects over that time period before the
>> offender was killed which released all of them.
>>
>> The proposed workaround is kind of ugly but do people have a better idea
>> than reference counting? If not should we merge it?
>
> I believe we should just merge that patch.
>
> I have not seen any better ideas come by.

I have some very vague idea that if we could distinguish (with a flag?) 
anon_vma_chain (avc) pointing to parent's anon_vma, from avc's created 
for new anon_vma's in the child, we could maybe detect at "child-type" 
avc removal time, that the only avc's left for a non-root anon_vma are 
those of "parent-type" pointing from children. Then we could go through 
all pages that map the anon_vma, and change their mapping to the root 
anon_vma. The root would have to stay, orphaned or not, because of the 
lock there.

That would remove the need for determining a magic constant and the 
possibility that we still leave non-useful "orphaned" anon_vma's on the 
top levels of the fork hierarchy, while all the bottom levels have to 
share the last anon_vma's that were allowed to be created. I'm not sure 
if that's the case of nsd - if besides the "orphaned parent" forks it 
also forks some workers that would no longer benefit from having their 
private anon_vma's.

Of course the downside is that the idea would be too complicated wrt 
locking and incur overhead on some fast paths (process exit?). And I 
admit I'm not very familiar with the code (which is perhaps euphemism :)
Still, what do you think, Rik?

Vlastimil

> The comment should probably be fixed to reflect the
> chain length of 5 though :)
>

