Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaBLG0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 01:26:17 -0500
Received: from relay.parallels.com ([195.214.232.42]:44610 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBLG0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 01:26:16 -0500
Message-ID: <52FB1405.2050301@parallels.com>
Date: Wed, 12 Feb 2014 10:26:13 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <gregkh@linuxfoundation.org>, <cl@linux-foundation.org>,
        <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 1/2] kobject: don't block for each kobject_uevent
References: <ca22d856315916d3e8c74666da7079b9ae42e646.1391942582.git.vdavydov@parallels.com> <20140211150347.17b9473bed7952baa2ed1438@linux-foundation.org>
In-Reply-To: <20140211150347.17b9473bed7952baa2ed1438@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 03:03 AM, Andrew Morton wrote:
> On Sun, 9 Feb 2014 14:56:15 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
>
>> Currently kobject_uevent has somewhat unpredictable semantics. The point
>> is, since it may call a usermode helper and wait for it to execute
>> (UMH_WAIT_EXEC), it is impossible to say for sure what lock dependencies
>> it will introduce for the caller - strictly speaking it depends on what
>> fs the binary is located on and the set of locks fork may take. There
>> are quite a few kobject_uevent's users that do not take this into
>> account and call it with various mutexes taken, e.g. rtnl_mutex,
>> net_mutex, which might potentially lead to a deadlock.
>>
>> Since there is actually no reason to wait for the usermode helper to
>> execute there, let's make kobject_uevent start the helper asynchronously
>> with the aid of the UMH_NO_WAIT flag.
>>
>> Personally, I'm interested in this, because I really want kobject_uevent
>> to be called under the slab_mutex in the slub implementation as it used
>> to be some time ago, because it greatly simplifies synchronization and
>> automatically fixes a kmemcg-related race. However, there was a deadlock
>> detected on an attempt to call kobject_uevent under the slab_mutex (see
>> https://lkml.org/lkml/2012/1/14/45), which was reported to be fixed by
>> releasing the slab_mutex for kobject_uevent. Unfortunately, there was no
>> information about who exactly blocked on the slab_mutex causing the
>> usermode helper to stall, neither have I managed to find this out or
>> reproduce the issue.
>>
>> BTW, this is not the first attempt to make kobject_uevent use
>> UMH_NO_WAIT. Previous one was made by commit f520360d93c, but it was
>> wrong (it passed arguments allocated on stack to async thread) so it was
>> reverted (commit 05f54c13cd0c). It targeted on speeding up the boot
>> process though.
> The patches look good to me.  One is kobject (Greg) and the other is
> slub (Pekka), so I grabbed them ;) Reviews-and-acks, please?
>
>
>
> btw, when referring to commits, please use the form
>
> f520360d93c ("kobject: don't block for each kobject_uevent")
>
> because the same commit can have different hashes in different trees.

Oh, sorry about that. I will take this into account.

Thank you.

>
> (Although I suspect the amount of convenience this provides others
> doesn't match the amount of time I spend fixing changelogs!)
>

