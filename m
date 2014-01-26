Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaAZIPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 03:15:45 -0500
Received: from relay.parallels.com ([195.214.232.42]:54456 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaAZIPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 03:15:44 -0500
Message-ID: <52E4C420.8020800@parallels.com>
Date: Sun, 26 Jan 2014 12:15:28 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: fix wrong retval on kmem_cache_create_memcg error
 path
References: <1390598126-4332-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.02.1401252036410.10325@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401252036410.10325@chino.kir.corp.google.com>
Content-Type: multipart/mixed;
	boundary="------------010306060909040309010806"
X-Originating-IP: [10.24.25.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010306060909040309010806
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 01/26/2014 08:39 AM, David Rientjes wrote:
> On Sat, 25 Jan 2014, Vladimir Davydov wrote:
>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 8e40321..499b53c 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -249,7 +249,6 @@ out_unlock:
>>  				name, err);
>>  			dump_stack();
>>  		}
>> -		return NULL;
>>  	}
>>  	return s;
>>  
>> @@ -257,6 +256,7 @@ out_free_cache:
>>  	memcg_free_cache_params(s);
>>  	kfree(s->name);
>>  	kmem_cache_free(kmem_cache, s);
>> +	s = NULL;
>>  	goto out_unlock;
>>  }
>>  
> I thought I left spaghetti code back in my BASIC 2.0 days.  It should be 
> much more readable to just do
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -233,14 +233,15 @@ out_unlock:
>  	mutex_unlock(&slab_mutex);
>  	put_online_cpus();
>  
> -	/*
> -	 * There is no point in flooding logs with warnings or especially
> -	 * crashing the system if we fail to create a cache for a memcg. In
> -	 * this case we will be accounting the memcg allocation to the root
> -	 * cgroup until we succeed to create its own cache, but it isn't that
> -	 * critical.
> -	 */
> -	if (err && !memcg) {
> +	if (err) {
> +		/*
> +		 * There is no point in flooding logs with warnings or
> +		 * especially crashing the system if we fail to create a cache
> +		 * for a memcg.
> +		 */
> +		if (memcg)
> +			return NULL;
> +
>  		if (flags & SLAB_PANIC)
>  			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
>  				name, err);
>
> and stop trying to remember what err, memcg, and s are in all possible 
> contexts.  Sheesh.

Hi, David,

Although it's rather a matter of personal preference, I tend to agree
with you.

Andrew,

The fix by David Rientjes is attached. It's up to you to decide, which
one looks better.

Thank you and sorry about the noise.

--------------010306060909040309010806
Content-Type: text/x-patch;
	name="0001-slab-fix-wrong-retval-on-kmem_cache_create_memcg-err.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-slab-fix-wrong-retval-on-kmem_cache_create_memcg-err.pa";
	filename*1="tch"

>From 371649294d90b65a2e86d0873f79bab454285d1a Mon Sep 17 00:00:00 2001
From: David Rientjes <rientjes@google.com>
Date: Sun, 26 Jan 2014 11:49:39 +0400
Subject: [PATCH] slab: fix wrong retval on kmem_cache_create_memcg error path

On kmem_cache_create_memcg() error path we set 'err', but leave 's' (the
new cache ptr) undefined. The latter can be NULL if we could not
allocate the cache, or pointing to a freed area if we failed somewhere
later while trying to initialize it. Initially we checked 'err'
immediately before exiting the function and returned NULL if it was set
ignoring the value of 's':

    out_unlock:
        ...
        if (err) {
            /* report error */
            return NULL;
        }
        return s;

Recently this check was, in fact, broken by commit f717eb3abb5e ("slab:
do not panic if we fail to create memcg cache"), which turned it to:

    out_unlock:
        ...
        if (err && !memcg) {
            /* report error */
            return NULL;
        }
        return s;

As a result, if we are failing creating a cache for a memcg, we will
skip the check and return 's' that can contain crap. Obviously, commit
f717eb3abb5e intended not to return crap on error allocating a cache for
a memcg, but only to remove the error reporting in this case, so the
check should look like this:

    out_unlock:
        ...
        if (err) {
            if (!memcg)
                return NULL;
            /* report error */
            return NULL;
        }
        return s;

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
---
 mm/slab_common.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8e40321..1ec3c61 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -233,14 +233,17 @@ out_unlock:
 	mutex_unlock(&slab_mutex);
 	put_online_cpus();
 
-	/*
-	 * There is no point in flooding logs with warnings or especially
-	 * crashing the system if we fail to create a cache for a memcg. In
-	 * this case we will be accounting the memcg allocation to the root
-	 * cgroup until we succeed to create its own cache, but it isn't that
-	 * critical.
-	 */
-	if (err && !memcg) {
+	if (err) {
+		/*
+		 * There is no point in flooding logs with warnings or
+		 * especially crashing the system if we fail to create a cache
+		 * for a memcg. In this case we will be accounting the memcg
+		 * allocation to the root cgroup until we succeed to create its
+		 * own cache, but it isn't that critical.
+		 */
+		if (!memcg)
+			return NULL;
+
 		if (flags & SLAB_PANIC)
 			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
 				name, err);
-- 
1.7.10.4


--------------010306060909040309010806--
