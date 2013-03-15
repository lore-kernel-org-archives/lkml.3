Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab3COQTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:19:12 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56517 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3COQTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:19:11 -0400
Message-ID: <514349EA.9070404@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 11:18:50 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Robert Jennings <rcj@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>,
        minchan@kernel.org, Nitin Gupta <nitingupta910@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: zsmalloc limitations and related topics
References: <0efe9610-1aa5-4aa9-bde9-227acfa969ca@default> <20130313151359.GA3130@linux.vnet.ibm.com> <4ab899f6-208c-4d61-833c-d1e5e8b1e761@default> <514104D5.9020700@linux.vnet.ibm.com> <5141BC5D.9050005@oracle.com> <20130314132046.GA3172@linux.vnet.ibm.com> <006139fe-542e-46f0-8b6c-b05efeb232d6@default>
In-Reply-To: <006139fe-542e-46f0-8b6c-b05efeb232d6@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031516-3864-0000-0000-0000074621D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 01:54 PM, Dan Magenheimer wrote:
>> From: Robert Jennings [mailto:rcj@linux.vnet.ibm.com]
>> Sent: Thursday, March 14, 2013 7:21 AM
>> To: Bob
>> Cc: Seth Jennings; Dan Magenheimer; minchan@kernel.org; Nitin Gupta; Konrad Wilk; linux-mm@kvack.org;
>> linux-kernel@vger.kernel.org; Bob Liu; Luigi Semenzato; Mel Gorman
>> Subject: Re: zsmalloc limitations and related topics
>>
>> * Bob (bob.liu@oracle.com) wrote:
>>> On 03/14/2013 06:59 AM, Seth Jennings wrote:
>>>> On 03/13/2013 03:02 PM, Dan Magenheimer wrote:
>>>>>> From: Robert Jennings [mailto:rcj@linux.vnet.ibm.com]
>>>>>> Subject: Re: zsmalloc limitations and related topics
>>>>>
>> <snip>
>>>>> Yes.  And add pageframe-reclaim to this list of things that
>>>>> zsmalloc should do but currently cannot do.
>>>>
>>>> The real question is why is pageframe-reclaim a requirement?  What
>>>> operation needs this feature?
>>>>
>>>> AFAICT, the pageframe-reclaim requirements is derived from the
>>>> assumption that some external control path should be able to tell
>>>> zswap/zcache to evacuate a page, like the shrinker interface.  But this
>>>> introduces a new and complex problem in designing a policy that doesn't
>>>> shrink the zpage pool so aggressively that it is useless.
>>>>
>>>> Unless there is another reason for this functionality I'm missing.
>>>>.
>>>
>>> Perhaps it's needed if the user want to enable/disable the memory
>>> compression feature dynamically.
>>> Eg, use it as a module instead of recompile the kernel or even
>>> reboot the system.
> 
> It's worth thinking about: Under what circumstances would a user want
> to turn off compression?  While unloading a compression module should
> certainly be allowed if it makes a user comfortable, in my opinion,
> if a user wants to do that, we have done our job poorly (or there
> is a bug).
> 
>> To unload zswap all that is needed is to perform writeback on the pages
>> held in the cache, this can be done by extending the existing writeback
>> code.
> 
> Actually, frontswap supports this directly.  See frontswap_shrink.

frontswap_shrink() is a best-effort attempt to fault in all the pages
stored in the backend.  However, if there is not enough RAM to hold all
the pages, then it can not completely evacuate the backend.

Module exit functions must return void, so there is no way to fail a
module unload.  If you implement an exit function for your module, you
must insure that it can always complete successfully.  For this reason
frontswap_shrink() is unsuitable for module unloading.  You'd need to
use a mechanism like writeback that could surely evacuate the backend
(baring I/O failures).

Seth

