Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338AbaH0Xyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:54:36 -0400
Received: from relay1.sgi.com ([192.48.180.66]:35099 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbaH0Xyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:54:35 -0400
Message-ID: <53FE6FAA.6010806@sgi.com>
Date: Wed, 27 Aug 2014 16:54:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH 1/2] x86: Optimize resource lookups for ioremap
References: <20140827225927.364537333@asylum.americas.sgi.com>	<20140827225927.602319674@asylum.americas.sgi.com>	<20140827160515.c59f1c191fde5f788a7c42f6@linux-foundation.org>	<53FE6515.6050102@sgi.com>	<20140827161854.0619a04653b336d3adc755f3@linux-foundation.org>	<53FE68E4.4090902@sgi.com> <20140827163745.774e9b5c591e8f9cf7542a4d@linux-foundation.org>
In-Reply-To: <20140827163745.774e9b5c591e8f9cf7542a4d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/27/2014 4:37 PM, Andrew Morton wrote:
> On Wed, 27 Aug 2014 16:25:24 -0700 Mike Travis <travis@sgi.com> wrote:
> 
>>>
>>> <looks at the code>
>>>
>>> Doing strcmp("System RAM") is rather a hack.  Is there nothing in
>>> resource.flags which can be used?  Or added otherwise?
>>
>> I agree except this mimics the page_is_ram function:
>>
>>         while ((res.start < res.end) &&
>>                 (find_next_iomem_res(&res, "System RAM", true) >= 0)) {
> 
> Yeah.  Sigh.
> 
>> So it passes the same literal string which then find_next does the
>> same strcmp on it:
>>
>>                 if (p->flags != res->flags)
>>                         continue;
>>                 if (name && strcmp(p->name, name))
>>                         continue;
>>
>> I should add back in the check to insure name is not NULL.
> 
> If we're still at 1+ hours then little bodges like this are nowhere
> near sufficient and sterner stuff will be needed.
> 
> Do we actually need the test?  My googling turns up zero instances of
> anyone reporting the "ioremap on RAM pfn" warning.

We get them more than we like, mostly from 3rd party vendors, and
esp. those that merely port their windows drivers to linux.
> 
> Where's the rest of the time being spent?

This device has a huge internal memory and  many processing devices.
So it loads up an operating system and starts a bunch of pseudo network
connections through the PCI-e/driver interface.  It was hard to
determine what percentage the ioremap played in the overall starting
time (based on what info we were able to collect).  But the ioremap
was definitely the largest part of the 'modprobe' operation.  I think
realistically that's all we have control over.

(But as I mentioned, we are encouraging the vendor to look into starting
the devices in parallel.  The overlap will cut down the overall time by
quite a bit, being there are 31 devices.)
