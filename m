Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaH2Uoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:44:44 -0400
Received: from relay2.sgi.com ([192.48.180.65]:42667 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbaH2Uon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:44:43 -0400
Message-ID: <5400E62F.8000405@sgi.com>
Date: Fri, 29 Aug 2014 13:44:31 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, Alex Thorlton <athorlton@sgi.com>,
        Cliff Wickman <cpw@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 0/2] x86: Speed up ioremap operations
References: <20140829195328.511550688@asylum.americas.sgi.com> <20140829131602.72c422ebd2fd3fba426379e8@linux-foundation.org>
In-Reply-To: <20140829131602.72c422ebd2fd3fba426379e8@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/29/2014 1:16 PM, Andrew Morton wrote:
> On Fri, 29 Aug 2014 14:53:28 -0500 Mike Travis <travis@sgi.com> wrote:
> 
>>
>> We have a large university system in the UK that is experiencing
>> very long delays modprobing the driver for a specific I/O device.
>> The delay is from 8-10 minutes per device and there are 31 devices
>> in the system.  This 4 to 5 hour delay in starting up those I/O
>> devices is very much a burden on the customer.
>>
>> There are two causes for requiring a restart/reload of the drivers.
>> First is periodic preventive maintenance (PM) and the second is if
>> any of the devices experience a fatal error.  Both of these trigger
>> this excessively long delay in bringing the system back up to full
>> capability.
>>
>> The problem was tracked down to a very slow IOREMAP operation and
>> the excessively long ioresource lookup to insure that the user is
>> not attempting to ioremap RAM.  These patches provide a speed up
>> to that function.
>>
> 
> Really would prefer to have some quantitative testing results in here,
> as that is the entire point of the patchset.  And it leaves the reader
> wondering "how much of this severe problem remains?".

Okay, I have some results from testing.  The modprobe time appears to
be affected quite a bit by previous activity on the ioresource list,
which I suspect is due to cache preloading.  While the overall
improvement is impacted by other overhead of starting the devices,
this drastically improves the modprobe time.

Also our system is considerably smaller so the percentages gained
will not be the same.  Best case improvement with the modprobe
on our 20 device smallish system was from 'real    5m51.913s' to
'real    0m18.275s'.

> Also, the -stable backport is a big ask, isn't it?  It's arguably
> notabug and the affected number of machines is small.
> 

Ingo had suggested this.  We are definitely pushing it to our distro
suppliers for our customers.  Whether it's a big deal for smaller
systems is up in the air.  Note that the customer system has 31 devices
on an SSI that includes a large number of other IB and SAS devices
as well as a number of nodes which all which have discontiguous memory
segments.  I'm envisioning an ioresource list that numbers at least
several hundred entries.  While that's somewhat indicative of typical
UV systems it is generally not that common otherwise.

So I guess the -stable is merely a suggestion, not a request.
