Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaF0I6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:58:33 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:34308 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaF0I6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:58:31 -0400
Message-ID: <53AD3231.4060909@itwm.fraunhofer.de>
Date: Fri, 27 Jun 2014 10:58:25 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Thomas Knauth <thomas.knauth@gmx.de>,
        David Rientjes <rientjes@google.com>,
        Maksym Planeta <mcsim.planeta@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com> <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com> <1403677528.7903.103.camel@sauron.fi.intel.com> <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com> <20140626010606.GT4453@dastard> <1403763199.20275.39.camel@sauron.fi.intel.com> <53ABF7C4.1000906@itwm.fraunhofer.de> <1403782263.20275.59.camel@sauron.fi.intel.com> <alpine.LFD.2.00.1406261349320.2172@localhost.localdomain> <53AC0DB4.7070701@itwm.fraunhofer.de> <20140627025501.GY9508@dastard>
In-Reply-To: <20140627025501.GY9508@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 04:55 AM, Dave Chinner wrote:
> On Thu, Jun 26, 2014 at 02:10:28PM +0200, Bernd Schubert wrote:
>> On 06/26/2014 01:57 PM, Lukáš Czerner wrote:
>>> On Thu, 26 Jun 2014, Artem Bityutskiy wrote:
>>>> On Thu, 2014-06-26 at 12:36 +0200, Bernd Schubert wrote:
>>>>> On 06/26/2014 08:13 AM, Artem Bityutskiy wrote:
>>>>>> On Thu, 2014-06-26 at 11:06 +1000, Dave Chinner wrote:
>>>>>>> Your particular use case can be handled by directing your benchmark
>>>>>>> at a filesystem mount point and unmounting the filesystem in between
>>>>>>> benchmark runs. There is no ned to adding kernel functionality for
>>>>>>> somethign that can be so easily acheived by other means, especially
>>>>>>> in benchmark environments where *everything* is tightly controlled.
>>>>>>
>>>>>> If I was a benchmark writer, I would not be willing running it as root
>>>>>> to be able to mount/unmount, I would not be willing to require the
>>>>>> customer creating special dedicated partitions for the benchmark,
>>>>>> because this is too user-unfriendly. Or do I make incorrect assumptions?
>>>>>
>>>>> But why a sysctl then? And also don't see a point for that at all, why
>>>>> can't the benchmark use posix_fadvise(POSIX_FADV_DONTNEED)?
>>>>
>>>> The latter question was answered - people want a way to drop caches for
>>>> a file. They need a method which guarantees that the caches are dropped.
>>>> They do not need an advisory method which does not give any guarantees.
>>
>> I'm not sure if a benchmark really needs that so much that
>> FADV_DONTNEED isn't sufficient.
>> Personally I would also like to know if FADV_DONTNEED succeeded.
>> I.e. 'ql-fstest' is to check if the written pattern went to the
>> block device and currently it does not know if data really had been
>> dropped from the page cache. As it reads files several times this is
>> not critical, but only would be a nice to have - nothing worth to
>> add a new syscall.
>
> ql-test is not a benchmark, it's a data integrity test. The re-read
> verification problem is easily solved by using direct IO to read the
> files directly without going through the page cache. Indeed, direct
> IO will invalidate cached pages over the range it reads before it
> does the read, so the guarantee that you are after - no cached pages
> when the read is done - is also fulfilled by the direct IO read...
>
> I really don't understand why people keep trying to make cached IO
> behave like uncached IO when we already have uncached IO
> interfaces....


Firstly, direct IO has an entirely different IO pattern, usually much 
simpler than buffered through the page cache. Secondly, going through 
the page cache ensures that page cache buffering is also tested.
I'm not at all opposed to open files randomly with direct IO to also 
test that path and I'm going to add that soon, but only using direct IO 
would limit the use case of ql-fstest.


Bernd

