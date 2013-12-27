Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3L0Bls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 20:41:48 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:40416 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3L0Blp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 20:41:45 -0500
MIME-Version: 1.0
In-Reply-To: <CANP1eJFMZrT+GbHhg3gWqsy=whSozEiWmZj-L08EyhD8LcqzeQ@mail.gmail.com>
References: <cover.1388066937.git.liwang@ubuntukylin.com>
	<CANP1eJFMZrT+GbHhg3gWqsy=whSozEiWmZj-L08EyhD8LcqzeQ@mail.gmail.com>
Date: Fri, 27 Dec 2013 09:41:39 +0800
Message-ID: <CAAb4LOxn29vH4j5g1cgxgoXc8rHOp9zjMo+O3JJ1jzuhnJU5yw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Ceph fscache: Fix kernel panic due to a race
From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: Li Wang <liwang@ubuntukylin.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlKVU1OQkJCQkNPTE9KSUpKV1kJDhceCFlBWS
	grPSQoND0vPToyNyQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMj
	UkMz46Pz4pQUtVS0A4NC41LykiJC4oQUtVS0ApPjwyNDUkNTQpLzMkOjY#KTI4OkFLVUtAPyI1Oj
	YyOCQyKyQ1NCQyNSQzPjo*PilBS1VLQCk#OjckMiskMjUkKTk3JDI1JDM#Oj8#KUFKSVVLQDYuNy
	8yJCk4Ky8kKDI2Mjc6KSQyNSQzPjo*PilBTlVLQDIrJC80PzoiJDg1LyRLJEpLS0FLVUtAMiskTi
	Q2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyRKJDM0LikkOD
	UvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9OjY0LigkPzQ2OjI1JC
	grPSQ9OjI3QUpLVUtAPTUkNjoiJE9KQiQzNzEkSiRLQ0tIS09BS1VISEA9KyQpPiQ9LCQzNzEkS0
	NLSEtNQVZMVU5AKC45JD5BSlVOTkA9NSQoLjkkPjUsNCk*KCQzNzEkSktLSUtKQUtVSUNZBg++
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MzI6Vgw6OjowEDojHD84OjcuOhdPCzBVSlVKSEND
	SktDTktITktOVTMWGhIXVQIOFRgTDhoVDB4VOw4ZDhUPDhACFxIVVRgUFkVZV1kMHhlZQR0aFwge
	V1kIAVlBTk5PQzdXWRILWUFZSUtCVUNOVUlKT1VPSlkG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Milosz
I am not very sure about how to enable caching in write path.

I just compile the latest kernel with "Enable Ceph client caching
support", start cachefilesd, and mount cephfs with -o fsc.
Then, the kernel will panic easily when the script runs to "dd
if=cephfs/foo of=/dev/null bs=8 count=1024"


2013/12/27 Milosz Tanski <milosz@adfin.com>:
> Li,
>
> I looked at the patchset am I correct that this only happens when we
> enable caching in the write path?
>
> - Milosz
>
> On Thu, Dec 26, 2013 at 9:29 AM, Li Wang <liwang@ubuntukylin.com> wrote:
>> From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
>>
>> The following scripts could easily panic the kernel,
>>
>> #!/bin/bash
>> mount -t ceph -o fsc MONADDR:/ cephfs
>> rm -rf cephfs/foo
>> dd if=/dev/zero of=cephfs/foo bs=8 count=512
>> echo 3 > /proc/sys/vm/drop_caches
>> dd if=cephfs/foo of=/dev/null bs=8 count=1024
>>
>> This is due to when writing a page into fscache, the code will
>> assert that the write position does not exceed the
>> object->store_limit_l, which is supposed to be equal to inode->i_size.
>> However, for current implementation, after file writing, the
>> object->store_limit_l is not synchronized with new
>> inode->i_size immediately, which introduces a race that if writing
>> a new page into fscache, will reach the ASSERT that write position
>> has exceeded the object->store_limit_l, and cause kernel panic.
>> This patch fixes it.
>>
>> Yunchuan Wen (3):
>>   Ceph fscache: Add an interface to synchronize object store limit
>>   Ceph fscache: Update object store limit after writing
>>   Ceph fscache: Wait for completion of object initialization
>>
>>  fs/ceph/cache.c |    1 +
>>  fs/ceph/cache.h |   10 ++++++++++
>>  fs/ceph/file.c  |    3 +++
>>  3 files changed, 14 insertions(+)
>>
>> --
>> 1.7.9.5
>>
>
>
>
> --
> Milosz Tanski
> CTO
> 10 East 53rd Street, 37th floor
> New York, NY 10022
>
> p: 646-253-9055
> e: milosz@adfin.com
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
