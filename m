Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3ISQiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:38:02 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33968 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751157Ab3ISQiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:38:00 -0400
Message-ID: <523B2867.7000209@sgi.com>
Date: Thu, 19 Sep 2013 11:37:59 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jason Baron <jbaron@akamai.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
References: <1379087642-131349-1-git-send-email-nzimmer@sgi.com> <5239FA69.8030202@akamai.com>
In-Reply-To: <5239FA69.8030202@akamai.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 02:09 PM, Jason Baron wrote:
> On 09/13/2013 11:54 AM, Nathan Zimmer wrote:
>> We noticed some scaling issue in the SPECjbb benchmark.  Running perf
>> we found that the it was spending lots of time in SYS_epoll_ctl.
>> In particular it is holding the epmutex.
>> This patch helps by moving out the kmem_cache_alloc and kmem_cache_free out
>> from under the lock.  It improves throughput by around 15% on 16 sockets.
>>
>> While this patch should be fine as it is there are probably is more things
>> that can be done out side the lock, like wakeup_source_unregister, but I am
>> not familar with the area and I don't know of many tests.  I did find the
>> one posted by Jason Baron at https://lkml.org/lkml/2011/2/25/297.
>>
>> Any thoughts?
>>
> Hi,
>
> Intersting - I think its also possible to completely drop taking the
> 'epmutex' for EPOLL_CTL_DEL by using rcu, and restricting it on add
> to more 'complex' topologies. That is when we have an epoll descriptor
> that doesn't nest with other epoll descriptors, we don't need the
> global 'epmutex' either. Any chance you can re-run with this? Its a bit
> hacky, but we can clean it up if it makes sense.
>
> Thanks,
>
> -Jason
>
That is working GREAT.  It is scaling to 16 jobs quite well.
I will have to grab a larger machine( to see what the new scaling curve 
will be.
