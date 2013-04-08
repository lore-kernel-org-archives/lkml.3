Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3DHHlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:41:53 -0400
Received: from a2s31.a2hosting.com ([216.119.140.66]:58495 "EHLO
	a2s31.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab3DHHls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:41:48 -0400
Message-ID: <516274B7.4050002@biovista.com>
Date: Mon, 08 Apr 2013 10:41:43 +0300
From: Vassilis Virvilis <v.virvilis@biovista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Debugging COW (copy on write) memory after fork: Is it possible
 to dump only the private anonymous memory of a process?
References: <515E9F0C.1000204@biovista.com> <20130406201114.6477d1e4@neptune.home>
In-Reply-To: <20130406201114.6477d1e4@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s31.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - biovista.com
X-Get-Message-Sender-Via: a2s31.a2hosting.com: authenticated_id: v.virvilis@biovista.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 09:11 PM, Bruno Prémont wrote:
> On Fri, 05 April 2013 Vassilis Virvilis<v.virvilis@biovista.com>  wrote:
>>
>> Question
>> --------
>>
>> Is it possible to dump only the private anonymous memory of a process?
>
> I don't know if that's possible, but from your background you could
> probably work around it be mmap()ing the memory you need and once
> initialized mark all of that memory read-only (if you mmap very large
> chunks you can even benefit from huge-pages).
>
> Any of the forked processes that tried to access the memory would then
> get a signal if they ever tried to write to the data (and thus unsharing it)
>

I can't do that. We are talking about an existing system (in perl with C 
modules) that has been parallelized in a second step.

> If you allocate and initialize all of your memory in little malloc()'ed
> chunks it's possibly glibc's memory housekeeping that unshares all those
> pages over time.

Yes I suppose it is a series of mallocs. I could easily verify that with 
strace. However if glibc's memory housekeeping undermines the COW 
behaviour that would be very bad.

I have unit tests that I was able to work around the usual perl problems 
that cause memory unsharing such as the reference counting and hash 
accessing. Garbage collector shouldn't be a problem because there is 
nothing to collect from the shared memory, only private local variables 
that go out of scope. The problem is when I am employing these 
workarounds in the live system (with considerable IO) I am getting 
massive unsharing. So I thought to have a look and see what's going in 
two or three consecutive private memory dumps.

The point is I need to locate the source of the memory unsharing. Any 
ideas how this can be done?

At this point I could try in house compiled kernels if I can enable some 
logging to track this behavior. Does any knob like this exist? Even as 
an #ifdef?

	Vassilis
