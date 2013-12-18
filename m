Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3LRBgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:36:24 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:37616 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LRBgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:36:22 -0500
Message-ID: <52B0FC0D.8070007@ubuntukylin.com>
Date: Wed, 18 Dec 2013 09:36:13 +0800
From: Li Wang <liwang@ubuntukylin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Li Zefan <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
References: <cover.1387205337.git.liwang@ubuntukylin.com> <20131217220503.GA20579@dastard>
In-Reply-To: <20131217220503.GA20579@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpLVU9LQkJCQkNPTE9KSUpKV1kJDhceCFlBWS
	grPSQrOigoJDI1JDM#Oj8#KUFLVUtANiMkIj4oJDI1JDM#Oj8#KUFLVUtAKy8pJCI#KCQyNSQzPj
	o*PilBS1VLQDg0LjUvKSIkODVBS1VLQCk#PDI0NSQ6KDI6QUtVS0ArKTQtMjU4PiQzLjU6NUFLVU
	tAPyI1OjYyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQCk#OjckMiskMjUkKTk3JDI1JDM#Oj8#KUFKSV
	VLQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJDI1JDM#Oj8#KUFJVUtAMiskLzQ*OiIkODUvJEskSktLQU
	tVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskSiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJE
	okMzQuKSQ4NS8kSyRKS0tBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtAPTUkNjoiJE9KQi
	QzNzEkSiRLQ0tIS09BS1VISEA9NSQzNC8kMzcxJEtMS05LT0FLVUtAPSskKT4kPSwkMzcxJEtDS0
	hLTUFWTFVOQCguOSQ#QUpVTk5APTUkKC45JD41LDQpPygkMzcxJEpLS0lLSkFLVUlDQD01JD0pPj
	4kMzcxJEtMS05LT0FKVUxOWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SEhLTkxOTklIVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QU1KTUw3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both 'drop_caches' and 'vfs_cache_pressure' do coarse granularity
control. Sometimes these do not help much for those performance
sensitive applications. General and simple algorithms are good
regarding its application independence and working for normal
situations. However, since applications have the most knowledge
about the things they are doing, they can always do better if
they are given a chance. I think that is why compiler have
directives, such as __inline__,__align__, cpu cache provides
__prefetch__ etc. Similarly, I think we had better endow the
applications more abilities to manipulate the metadata/page cache.
This is potentially beneficial to avoid performance degradation
due to cache thrashing.

'drop_caches' may not be the expected way to go, since its intention
is for debugging. 'fadvise' is originally proposed at this purpose,
I think we may start with making 'fadvise' could handle directory level
page cache cleaning.

On 2013/12/18 6:05, Dave Chinner wrote:
> On Mon, Dec 16, 2013 at 07:00:04AM -0800, Li Wang wrote:
>> Currently, Linux only support file system wide VFS
>> cache (dentry cache and page cache) cleaning through
>> '/proc/sys/vm/drop_caches'. Sometimes this is less
>> flexible. The applications may know exactly whether
>> the metadata and data will be referenced or not in future,
>> a desirable mechanism is to enable applications to
>> reclaim the memory of unused cache entries at a finer
>> granularity - directory level. This enables applications
>> to keep hot metadata and data (to be referenced in the
>> future) in the cache, and kick unused out to avoid
>> cache thrashing. Another advantage is it is more flexible
>> for debugging.
>>
>> This patch extend the 'drop_caches' interface to
>> support directory level cache cleaning and has a complete
>> backward compatibility. '{1,2,3}' keeps the same semantics
>> as before. Besides, "{1,2,3}:DIRECTORY_PATH_NAME" is allowed
>> to recursively clean the caches under DIRECTORY_PATH_NAME.
>> For example, 'echo 1:/home/foo/jpg > /proc/sys/vm/drop_caches'
>> will clean the page caches of the files inside 'home/foo/jpg'.
>>
>> It is easy to demonstrate the advantage of directory level
>> cache cleaning. We use a virtual machine configured with
>> an Intel(R) Xeon(R) 8-core CPU E5506 @ 2.13GHz, and with 1GB
>> memory.  Three directories named '1', '2' and '3' are created,
>> with each containing 180000 – 280000 files. The test program
>> opens all files in a directory and then tries the next directory.
>> The order for accessing the directories is '1', '2', '3',
>> '1'.
>>
>> The time on accessing '1' on the second time is measured
>> with/without cache cleaning, under different file counts.
>> With cache cleaning, we clean all cache entries of files
>> in '2' before accessing the files in '3'. The results
>> are as follows (in seconds),
>
> This sounds like a highly contrived test case. There is no reason
> why dentry cache access time would change going from 180k to 280k
> files in 3 directories unless you're right at the memory pressure
> balance point in terms of cache sizing.
>
>> Note: by default, VFS will move those unreferenced inodes
>> into a global LRU list rather than freeing them, for this
>> experiment, we modified iput() to force to free inode as well,
>> this behavior and related codes are left for further discussion,
>> thus not reflected in this patch)
>>
>> Number of files:   180000 200000 220000 240000 260000
>> Without cleaning:  2.165  6.977  10.032 11.571 13.443
>> With cleaning:     1.949  1.906  2.336  2.918  3.651
>>
>> When the number of files is 180000 in each directory,
>> the metadata cache is large enough to buffer all entries
>> of three directories, so re-accessing '1' will hit in
>> the cache, regardless of whether '2' cleaned up or not.
>> As the number of files increases, the cache can now only
>> buffer two+ directories. Accessing '3' will result in some
>> entries of '1' to be evicted (due to LRU). When re-accessing '1',
>> some entries need be reloaded from disk, which is time-consuming.
>
> Ok, so exactly as I thought - your example working set is slightly
> larger than what the cache holds. Hence what you are describing is
> a cache reclaim threshold effect: something you can avoid with
> /proc/sys/vm/vfs_cache_pressure.
>
> Cheers,
>
> Dave.
>
