Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab3JKK1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:27:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15831 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab3JKK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:27:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Oct 2013 03:27:39 -0700
Message-ID: <5257D1AD.9060000@nvidia.com>
Date: Fri, 11 Oct 2013 13:23:41 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] drm/tegra: Deliver syncpoint base to user space
References: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com> <1381319650-9799-3-git-send-email-amerilainen@nvidia.com> <20131011094352.GB8659@ulmo.nvidia.com>
In-Reply-To: <20131011094352.GB8659@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 12:43 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Oct 09, 2013 at 02:54:09PM +0300, Arto Merilainen wrote:
>> This patch makes the necessary additions to deliver syncpoint base
>> to the user space.
>>
>> This patch splits the index field in the drm_tegra_get_syncpt structure
>> into three separate fields (index, support_base, base_id). This allows
>> to keep compatibility over kernel versions:
>> - The placing of index field stays constant and therefore the interface
>>    should stay compatible with earlier userspace versions.
>> - The old index field was input-only and it was not supposed to be read
>>    afterwards. Delivering data back in the same field should not introduce
>>    regressions to any old user space applications.
>> - Old kernels left support_base and base_id fields intact (zero) and
>>    hence the new user space applications get the correct response from
>>    the kernel (=syncpoint does not have a base).
>>
>> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
>> ---
>>   drivers/gpu/host1x/drm/drm.c | 2 ++
>>   include/uapi/drm/tegra_drm.h | 4 +++-
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
>> index 8c61cee..4251563 100644
>> --- a/drivers/gpu/host1x/drm/drm.c
>> +++ b/drivers/gpu/host1x/drm/drm.c
>> @@ -468,6 +468,8 @@ static int tegra_get_syncpt(struct drm_device *drm, void *data,
>>
>>   	syncpt = context->client->syncpts[args->index];
>>   	args->id = host1x_syncpt_id(syncpt);
>> +	args->support_base = syncpt->base ? 1 : 0;
>> +	args->base_id = syncpt->base ? syncpt->base->id : 0;
>>
>>   	return 0;
>>   }
>> diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
>> index 73bde4e..7a79ca5 100644
>> --- a/include/uapi/drm/tegra_drm.h
>> +++ b/include/uapi/drm/tegra_drm.h
>> @@ -61,7 +61,9 @@ struct drm_tegra_close_channel {
>>
>>   struct drm_tegra_get_syncpt {
>>   	__u64 context;
>> -	__u32 index;
>> +	__u16 index;
>> +	__u8 support_base;
>> +	__u8 base_id;
>>   	__u32 id;
>
> I don't like this. Can't we just add a separate IOCTL? Something like:

Sure. This felt like a good idea, but I must admit I had a bit mixed 
feelings after looking my own explanation why this would be ok...

- Arto

