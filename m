Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3JRRL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:11:29 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48962 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab3JRRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <1382115973.2041.3.camel@joe-AO722>
References: <1381296747.2040.17.camel@joe-AO722>
	<20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
	<CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
	<1382115973.2041.3.camel@joe-AO722>
Date: Fri, 18 Oct 2013 10:11:27 -0700
Message-ID: <CAGa+x87cDqigMAGb+7+46Ea1dRMWDi1O_84JZsmOKRb=1dSfTQ@mail.gmail.com>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Kevin Hilman <khilman@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:06 AM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-10-18 at 09:57 -0700, Kevin Hilman wrote:
> []
>> A handful of boot panics on ARM platforms were bisected to point at
>> the version of this commit that's in linux-next (commit
>> 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
>> makes things happy again.
>>
>> Upon further digging, it seems that users of devres_alloc() are
>> relying on the previous behavior of having the memory zero'd which is
>> no longer the case after $SUBJECT patch.  The change below on top of
>> -next makes these ARM boards happy again.
> []
>> commit 64c862a8 (devres: add kernel standard devm_k.alloc functions) changed
>> the default behavior of alloc_dr() to no longer zero the allocated
>> memory.  However,
>> only the devm.k.alloc() function were modified to pass in __GFP_ZERO
>> which leaves
>> any users of devres_alloc() or __devres_alloc() with potentially wrong
>> assumptions
>> about memory being zero'd upon allocation.
>>
>> To fix, add __GFP_ZERO to devres_alloc() calls to preserve previous
>> behavior of zero'ing memory upon allocation.
> []
>> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> []
>> @@ -136,7 +136,7 @@ void * devres_alloc(dr_release_t release, size_t
>> size, gfp_t gfp)
>>  {
>>   struct devres *dr;
>>
>> - dr = alloc_dr(release, size, gfp);
>> + dr = alloc_dr(release, size, gfp | __GFP_ZERO);
>>   if (unlikely(!dr))
>>   return NULL;
>>   return dr->data;
>
> Wouldn't the __devres_alloc need that too?

Yeah,  I had mentioned __devres_alloc() in the changelog, but missed
it in the actual patch. :(
Anyways, I had quickly sent an updated patch, but our mails must've
crossed paths.

Kevin
