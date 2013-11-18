Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3KRKbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:31:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17949 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab3KRKa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:30:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,722,1378828800"; 
   d="scan'208";a="9064860"
Message-ID: <5289E796.1030506@cn.fujitsu.com>
Date: Mon, 18 Nov 2013 18:10:30 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: Chao Yu <chao2.yu@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support
 for merging contiguous read
References: <000001cee293$3b6e3030$b24a9090$@samsung.com> <1384734560.26319.10.camel@kjgkr> <000901cee3fe$edfa8660$c9ef9320$@samsung.com> <1384765870.26319.16.camel@kjgkr>
In-Reply-To: <1384765870.26319.16.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 18:14:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 18:15:08
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 05:11 PM, Jaegeuk Kim wrote:

> Hi,
> 
> 2013-11-18 (월), 09:37 +0800, Chao Yu:
>> Hi Kim,
>>
>>> -----Original Message-----
>>> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
>>> Sent: Monday, November 18, 2013 8:29 AM
>>> To: Chao Yu
>>> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
>>> Subject: Re: [f2fs-dev] [PATCH V2 1/2] f2fs: add a new function to support for merging contiguous read
>>>
>>> Hi Chao,
>>>
>>> 2013-11-16 (토), 14:14 +0800, Chao Yu:
>>>> For better read performance, we add a new function to support for merging contiguous read as the one for write.
>>>
>>> Please consider 80 columns for the description.
>>> I cannot fix this at every time though. :(
>>
>> Got it, sorry about my carelessness in previous patch.
>>
>>>
>>>>
>>>> v1-->v2:
>>>>  o add declarations here as Gu Zheng suggested.
>>>>
>>>> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
>>>> Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>>> ---
>>>>  fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>>>>  fs/f2fs/f2fs.h |    4 ++++
>>>>  2 files changed, 49 insertions(+)
>>>>
>>>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>>>> index aa3438c..18107cb 100644
>>>> --- a/fs/f2fs/data.c
>>>> +++ b/fs/f2fs/data.c
>>>> @@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>>>>  	return 0;
>>>>  }
>>>>
>>>> +void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
>>>> +{
>>>> +	down_read(&sbi->bio_sem);
>>>
>>> Is there any reason to use down_read()?
>>
>> Isn't that we use bio_sem to let w/r or w/w submitting be mutex?
> 
> As I examined the bio_sem, I think we don't need to use a semaphore for
> read and write IOs.
> Just it is enough to use a mutex for writes only.

Agree. Mutex is more suitable here, we just want to protect the write bio
related fields in the write patch, no relations to read.

> 
>>
>>> It seems that we need to declare sbi->bio_read and sbi->bio_write
>>> instead of sbi->bio_sem.
>>> In addition to that, we need to use down_write(&sbi->bio_read) here.
>>
>> If so, it looks similar between (struct rw_semaphore) sbi->bio_read 
>> and (struct bio *) sbi->read_bio.
>> How about using read_bio_sem/rbio_sem to differentiate 
>> from sbi->read_bio?
> 
> I think sbi->write_mutex and sbi->read_mutex are much better.

It's more reasonable and readable.

Thanks,
Gu

> 
> Could you refer the following patches?
> Thanks,
> 


