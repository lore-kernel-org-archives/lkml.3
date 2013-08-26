Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab3HZMRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:17:42 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:37611 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3HZMRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:17:40 -0400
Message-ID: <521B4761.9010706@linux.vnet.ibm.com>
Date: Mon, 26 Aug 2013 14:17:37 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 1/4] gcov: move gcov structs definitions to a gcc
 version specific file
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com> <1377247176-13537-2-git-send-email-fhrbata@redhat.com> <52177B46.6070404@linux.vnet.ibm.com> <20130823165045.GB2336@localhost.localdomain>
In-Reply-To: <20130823165045.GB2336@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082612-5024-0000-0000-000007035B88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.2013 18:50, Frantisek Hrbata wrote:
> On Fri, Aug 23, 2013 at 05:09:58PM +0200, Peter Oberparleiter wrote:
>> On 23.08.2013 10:39, Frantisek Hrbata wrote:
>>> Since also the gcov structures(gcov_info, gcov_fn_info, gcov_ctr_info) can
>>> change between gcc releases, as shown in gcc 4.7, they cannot be defined in a
>>> common header and need to be moved to a specific gcc implemention file. This
>>> also requires to make the gcov_info structure opaque for the common code and to
>>> introduce simple helpers for accessing data inside gcov_info.
>>
>> I've taken a similar approach in my version, although I stopped at isolating
>> the code that handles the linked list. I like your version better since it's
>> more consistent.
> 
> :) I also have doubts with the list "abstraction", it isn't very nice. I tried
> to keep the changes as simple as possible in the generic code. I'm not sayint it
> is the right approach, but your design is pretty good, so I had no urges to
> change it more deeper. I'm of course open to any suggestions.

I'd say go for this approach while it works and consider a replacement when it
becomes necessary (because only then do we know what the requirements will be).

>>> diff --git a/kernel/gcov/gcc_3_4.c b/kernel/gcov/gcc_3_4.c
>>> index ae5bb42..27bc88a 100644
>>> --- a/kernel/gcov/gcc_3_4.c
>>> +++ b/kernel/gcov/gcc_3_4.c
>>> @@ -21,6 +21,121 @@
>>>  #include <linux/vmalloc.h>
>>>  #include "gcov.h"
>>>
>>> +#define GCOV_COUNTERS		5
>>
>> The value for GCOV_COUNTERS has been changed with GCC 4.3. Before it was 5,
>> starting with GCC 4.3 the value is 8. While this is not strictly necessary, I'm
>> wondering if this should be added here to prevent any unwanted side-effects.
> 
> Yes I was thinking about this two. My first idea was to use some define, maybe
> in the Makefile during the gcc version check and set the number of counters
> properly later based on this define. Something like
> 
> #if GCOV_GCC_VERIONS >= 0430
> #define GCOV_COUNTERS 8
> #elif ...
> 
> for the gcc_3_4.c implementation.
> 
> But I'm not sure what the new counters are good for and if they are really
> needed for the coverage info. This would require deeper understanding what
> and how the types of counters are used. At this point a simply did not change the
> value for the format before gcc 4.7, because each counter type has a tag and
> this should be backward compatible. We only miss the new counters. Again this is
> something that probably deserves more attention. Thanks for pointing this out!

Starting with GCC 4.7 support, GCOV_COUNTERS will have a direct effect on the
size of gcov_info, so an incorrect value will break the format code. The change
I commented on was pre-4.7 code though, so its not that important there. On the
other hand it could help to have a corresponding mechanism in place once
GCOV_COUNTERS changes again. Maybe something like a macro to determine if GCC
is below a certain level.


Regards,
  Peter

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

