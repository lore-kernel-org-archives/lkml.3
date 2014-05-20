Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaETSOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:14:36 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:59989 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaETSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:14:35 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.045
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de 2A6D952A40C
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de EE000E5758
Message-ID: <537B9B79.8030104@vodafone.de>
Date: Tue, 20 May 2014 20:14:17 +0200
From: =?windows-1252?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?windows-1252?Q?Marek_Ol=9A=E1k?= <maraeo@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
CC: "Deucher, Alexander" <alexander.deucher@amd.com>,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 7/8] radeon: Out of line radeon_get_ib_value
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org> <1400276595-6965-8-git-send-email-andi@firstfloor.org> <CAAxE2A4YvKRNMu6ogYOX2zE2=N1Q6hd1c0niB3jf9f3P8rwoRw@mail.gmail.com>
In-Reply-To: <CAAxE2A4YvKRNMu6ogYOX2zE2=N1Q6hd1c0niB3jf9f3P8rwoRw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, agree. That function is quite critical for command stream parsing 
and patching.

Christian.

Am 20.05.2014 18:16, schrieb Marek Olšák:
> I think the function should stay in the header file. It's used in
> performance-critical code, so we want it to be inlined.
>
> Marek
>
> On Fri, May 16, 2014 at 11:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> Saves about 5k of text
>>
>>     text    data     bss     dec     hex filename
>> 14080360        2008168 1507328 17595856        10c7dd0 vmlinux-before-radeon
>> 14074978        2008168 1507328 17590474        10c68ca vmlinux-radeon
>>
>> Cc: alexander.deucher@amd.com
>> Cc: dri-devel@lists.freedesktop.org
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>   drivers/gpu/drm/radeon/radeon.h        | 10 +---------
>>   drivers/gpu/drm/radeon/radeon_device.c |  9 +++++++++
>>   2 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
>> index 6852861..8cae409 100644
>> --- a/drivers/gpu/drm/radeon/radeon.h
>> +++ b/drivers/gpu/drm/radeon/radeon.h
>> @@ -1032,15 +1032,7 @@ struct radeon_cs_parser {
>>          struct ww_acquire_ctx   ticket;
>>   };
>>
>> -static inline u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
>> -{
>> -       struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
>> -
>> -       if (ibc->kdata)
>> -               return ibc->kdata[idx];
>> -       return p->ib.ptr[idx];
>> -}
>> -
>> +u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx);
>>
>>   struct radeon_cs_packet {
>>          unsigned        idx;
>> diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
>> index 0e770bb..1cbd171 100644
>> --- a/drivers/gpu/drm/radeon/radeon_device.c
>> +++ b/drivers/gpu/drm/radeon/radeon_device.c
>> @@ -112,6 +112,15 @@ bool radeon_is_px(struct drm_device *dev)
>>          return false;
>>   }
>>
>> +u32 radeon_get_ib_value(struct radeon_cs_parser *p, int idx)
>> +{
>> +       struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
>> +
>> +       if (ibc->kdata)
>> +               return ibc->kdata[idx];
>> +       return p->ib.ptr[idx];
>> +}
>> +
>>   /**
>>    * radeon_program_register_sequence - program an array of registers.
>>    *
>> --
>> 1.9.0
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

