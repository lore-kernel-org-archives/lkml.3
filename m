Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3JRQ5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:57:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63372 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3JRQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:57:44 -0400
MIME-Version: 1.0
In-Reply-To: <20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
References: <1381296747.2040.17.camel@joe-AO722>
	<20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
Date: Fri, 18 Oct 2013 09:57:43 -0700
Message-ID: <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
From: Kevin Hilman <khilman@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
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

On Fri, Oct 11, 2013 at 1:11 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 08 Oct 2013 22:32:27 -0700 Joe Perches <joe@perches.com> wrote:
>
>> Currently, devm_ managed memory only supports kzalloc.
>>
>> Convert the devm_kzalloc implementation to devm_kmalloc
>> and remove the complete memset to 0 but still set the
>> initial struct devres header and whatever padding before
>> data to 0.
>>
>> Add the other normal alloc variants as static inlines with
>> __GFP_ZERO added to the gfp flag where appropriate:
>>
>>       devm_kzalloc
>>       devm_kcalloc
>>       devm_kmalloc_array
>>
>> Add gfp.h to device.h for the newly added static inlines.
>>
>> ...
>>
>> --- a/drivers/base/devres.c
>> +++ b/drivers/base/devres.c
>> @@ -91,7 +91,8 @@ static __always_inline struct devres * alloc_dr(dr_release_t release,
>>       if (unlikely(!dr))
>>               return NULL;
>>
>> -     memset(dr, 0, tot_size);
>> +     memset(dr, 0, offsetof(struct devres, data));
>
> Well, this does make some assumptions about devres layout.  It would
> have been cleaner to do
>
>         memset(&dr.node, 0, sizeof(dr.node));
>
> but whatever.
>
> I made some changelog changes.
>
> I agree that including devm_kmalloc_array() might be going a bit far
> (it's the lack of devm_kmalloc which matters most).  But
> devm_kmalloc_array() is inlined and is hence basically cost-free until
> someone actually uses it.

A handful of boot panics on ARM platforms were bisected to point at
the version of this commit that's in linux-next (commit
64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
makes things happy again.

Upon further digging, it seems that users of devres_alloc() are
relying on the previous behavior of having the memory zero'd which is
no longer the case after $SUBJECT patch.  The change below on top of
-next makes these ARM boards happy again.

Kevin

[1]
>From 16489e16c8efdda791e96bd591e455e7c7739f98 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Fri, 18 Oct 2013 09:41:39 -0700
Subject: [PATCH] devres: restore zeroing behavior of devres_alloc()

commit 64c862a8 (devres: add kernel standard devm_k.alloc functions) changed
the default behavior of alloc_dr() to no longer zero the allocated
memory.  However,
only the devm.k.alloc() function were modified to pass in __GFP_ZERO
which leaves
any users of devres_alloc() or __devres_alloc() with potentially wrong
assumptions
about memory being zero'd upon allocation.

To fix, add __GFP_ZERO to devres_alloc() calls to preserve previous
behavior of zero'ing memory upon allocation.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/base/devres.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 37e67a2..e3fe8be 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -136,7 +136,7 @@ void * devres_alloc(dr_release_t release, size_t
size, gfp_t gfp)
 {
  struct devres *dr;

- dr = alloc_dr(release, size, gfp);
+ dr = alloc_dr(release, size, gfp | __GFP_ZERO);
  if (unlikely(!dr))
  return NULL;
  return dr->data;
-- 
1.8.3
