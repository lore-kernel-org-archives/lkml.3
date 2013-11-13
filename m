Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3KMOiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:38:01 -0500
Received: from m199-177.yeah.net ([123.58.177.199]:42327 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3KMOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:37:59 -0500
Message-ID: <52838E9D.7010901@ubuntukylin.com>
Date: Wed, 13 Nov 2013 22:37:17 +0800
From: Li Wang <liwang@ubuntukylin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Yan, Zheng" <ukernel@gmail.com>
CC: ceph-devel <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ceph: Avoid data inconsistency due to d-cache aliasing
 in readpage()
References: <1384327335-18812-1-git-send-email-liwang@ubuntukylin.com> <CAAM7YA=1DXyW+tr8CcAidOw_Hqmq=2o7QhcKGQO93n8jY5qAdg@mail.gmail.com>
In-Reply-To: <CAAM7YA=1DXyW+tr8CcAidOw_Hqmq=2o7QhcKGQO93n8jY5qAdg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlKVU5OQkJCQk9NTkJPSUhDSFdZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBTlVJTk1ANiMkIj4oJDI1JDM#Oj8#KUFLVUhPSUArLykkIj4oJD
	I1JDM#Oj8#KUFLVU9MTEA4NC41LykiJDg1QUtVSU1DQCk#PDI0NSQ6KDI6QUhVT09NQCspNC0yNT
	g#JDEyOjU8KC5BSlVMTUlAPyI1OjYyOCQyKyQiPigkMjUkMz46Pz4pQUtVT0xIQD8wMjYkNTQ1Pk
	FLVUtAKT46NyQyKyQyNSQpOTckMjUkMz46Pz4pQUxVS0tDQDYuNy8yJCk4Ky8kPzI9PT4pPjUvJD
	I1JDM#Oj8#KUFPVUtLSUAyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDIrJEokMzQuKSQ4NS8kSy
	RKS0tBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKyROJDYyNS4vPiQ4NS8kSyRKS0FLVU
	tAMiskLzQ*OiIkODUvJEskSktLQUtVTEpNQD01JDY6IiRPSkIkMzcxJEokS0NLSEtPQUtVSEhAPS
	skKT4kPSwkMzcxJEtDS0hLTUFWTFVOQCguOSQ#QUpVTk5APTUkKC45JD41LDQpPygkMzcxJEpLS0
	lLSkFLVUlDQD01JDY6IiRPSkIkMzcxJEkkS0NLSEtPQUtVS0A9NSQ5Mi9MJDM3MSRLTEpJS0lBSF
	VKTlkG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENP
	SE5IT0xPT0tOVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUhIS083V1kSC1lBWUpJSVVKQk9VSFVKSENZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yan,
   zero_user_segment() has invoked flush_dcache_page() for us, we donnot 
wanna flush d-cache twice.

Cheers,
Li Wang

On 11/13/2013 09:19 PM, Yan, Zheng wrote:
> On Wed, Nov 13, 2013 at 3:22 PM, Li Wang <liwang@ubuntukylin.com> wrote:
>> If the length of data to be read in readpage() is exactly
>> PAGE_CACHE_SIZE, the original code does not flush d-cache
>> for data consistency after finishing reading. This patches fixes
>> this.
>>
>> Signed-off-by: Li Wang <liwang@ubuntukylin.com>
>> ---
>>   fs/ceph/addr.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 6df8bd4..7b0000a 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -210,9 +210,13 @@ static int readpage_nounlock(struct file *filp, struct page *page)
>>          if (err < 0) {
>>                  SetPageError(page);
>>                  goto out;
>> -       } else if (err < PAGE_CACHE_SIZE) {
>> +       } else {
>> +               if (err < PAGE_CACHE_SIZE) {
>>                  /* zero fill remainder of page */
>> -               zero_user_segment(page, err, PAGE_CACHE_SIZE);
>> +                       zero_user_segment(page, err, PAGE_CACHE_SIZE);
>> +               } else {
>> +                       flush_dcache_page(page);
>> +               }
>
> this doesn't make sense for me. why not call flush_dcache_page unconditionally?
>
> Regards
> Yan, Zheng
>>          }
>>          SetPageUptodate(page);
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
