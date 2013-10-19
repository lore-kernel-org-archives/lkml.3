Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab3JSFwu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 01:52:50 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51467 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3JSFwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 01:52:49 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
References: <1381296747.2040.17.camel@joe-AO722>
	<20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
	<CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
	<CAGa+x86aS+C8iEb1P4ZYxPBix=Anjh4JZoAof=R-i9fGw=bq6w@mail.gmail.com>
	<20131018225702.GA13090@kroah.com>
Date: Fri, 18 Oct 2013 22:52:46 -0700
In-Reply-To: <20131018225702.GA13090@kroah.com> (Greg KH's message of "Fri, 18
	Oct 2013 15:57:02 -0700")
Message-ID: <8761stu7rl.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Fri, Oct 18, 2013 at 10:04:11AM -0700, Kevin Hilman wrote:
>> > A handful of boot panics on ARM platforms were bisected to point at
>> > the version of this commit that's in linux-next (commit
>> > 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
>> > makes things happy again.
>> >
>> > Upon further digging, it seems that users of devres_alloc() are
>> > relying on the previous behavior of having the memory zero'd which is
>> > no longer the case after $SUBJECT patch.  The change below on top of
>> > -next makes these ARM boards happy again.
>> 
>> Oops, it should've fixed __devres_alloc() also.  Updated patch below.
>
> Can you send this in a format that I can apply it in?  It was whitespace
> damaged.

hmm, sorry about that.  This one should work, though I wonder if Andrew
should pick this up since I think the patch that causes the breakage
came through his tree.

Kevin

---------------8<----------------------------------------------------
>From a1962ed4a999fb630a48f75a5ecaf84401d5dbfc Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Fri, 18 Oct 2013 09:41:39 -0700
Subject: [PATCH] devres: restore zeroing behavior of devres_alloc()

commit 64c862a8 (devres: add kernel standard devm_k.alloc functions) changed
the default behavior of alloc_dr() to no longer zero the allocated memory.  However,
only the devm.k.alloc() function were modified to pass in __GFP_ZERO which leaves
any users of devres_alloc() or __devres_alloc() with potentially wrong assumptions
about memory being zero'd upon allocation.

To fix, add __GFP_ZERO to devres_alloc() calls to preserve previous
behavior of zero'ing memory upon allocation.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/base/devres.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 37e67a2..545c4de 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -111,7 +111,7 @@ void * __devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
 {
 	struct devres *dr;
 
-	dr = alloc_dr(release, size, gfp);
+	dr = alloc_dr(release, size, gfp | __GFP_ZERO);
 	if (unlikely(!dr))
 		return NULL;
 	set_node_dbginfo(&dr->node, name, size);
@@ -136,7 +136,7 @@ void * devres_alloc(dr_release_t release, size_t size, gfp_t gfp)
 {
 	struct devres *dr;
 
-	dr = alloc_dr(release, size, gfp);
+	dr = alloc_dr(release, size, gfp | __GFP_ZERO);
 	if (unlikely(!dr))
 		return NULL;
 	return dr->data;
-- 
1.8.3

