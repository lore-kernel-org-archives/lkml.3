Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaAVGGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:06:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23433 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAVGGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:06:41 -0500
Message-ID: <52DF5FE9.9020508@oracle.com>
Date: Wed, 22 Jan 2014 01:06:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, Steven Whitehouse <swhiteho@redhat.com>
CC: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Abhijith Das <adas@redhat.com>
Subject: Re: [PATCH 17/24] GFS2: Use RCU/hlist_bl based hash for quotas
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com> <1390220627-1571-18-git-send-email-swhiteho@redhat.com> <20140122053248.GX10038@linux.vnet.ibm.com>
In-Reply-To: <20140122053248.GX10038@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 12:32 AM, Paul E. McKenney wrote:
> On Mon, Jan 20, 2014 at 12:23:40PM +0000, Steven Whitehouse wrote:
>> >Prior to this patch, GFS2 kept all the quotas for each
>> >super block in a single linked list. This is rather slow
>> >when there are large numbers of quotas.
>> >
>> >This patch introduces a hlist_bl based hash table, similar
>> >to the one used for glocks. The initial look up of the quota
>> >is now lockless in the case where it is already cached,
>> >although we still have to take the per quota spinlock in
>> >order to bump the ref count. Either way though, this is a
>> >big improvement on what was there before.
>> >
>> >The qd_lock and the per super block list is preserved, for
>> >the time being. However it is intended that since this is no
>> >longer used for its original role, it should be possible to
>> >shrink the number of items on that list in due course and
>> >remove the requirement to take qd_lock in qd_get.
>> >
>> >Signed-off-by: Steven Whitehouse<swhiteho@redhat.com>
>> >Cc: Abhijith Das<adas@redhat.com>
>> >Cc: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
> Interesting!  I thought that Sasha Levin had a hash table in the works,
> but I don't see it, so CCing him.

Indeed, there is a hlist based hashtable at include/linux/hashtable.h for couple kernel
versions now. However, there's no hlist_bl one.

If there is a plan on adding a hlist_bl hashtable for whatever reason, it should probably
be done by expanding hashtable.h so that more places that use hlist_bl would benefit from it (yes,
there are couple more places that do hlist_bl hashtable).

Also, do we really want to use hlist_bl here? It doesn't seem like it's being done to conserve on
memory, and that's the only reason it should be used for. Doing a single spinlock per bucket is
much more efficient than using the bit locking scheme that hlist_bl does.


Thanks,
Sasha
