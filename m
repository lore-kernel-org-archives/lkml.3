Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3LCNtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:49:00 -0500
Received: from relay.parallels.com ([195.214.232.42]:48502 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3LCNs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:48:58 -0500
Message-ID: <529DE144.8020005@parallels.com>
Date: Tue, 3 Dec 2013 17:48:52 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Dave Chinner <david@fromorbit.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <dchinner@redhat.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>, <glommer@openvz.org>
Subject: Re: [PATCH v12 05/18] fs: do not use destroy_super() in alloc_super()
 fail path
References: <cover.1385974612.git.vdavydov@parallels.com> <af90b79aebe9cd9f6e1d35513f2618f4e9888e9b.1385974612.git.vdavydov@parallels.com> <20131203090041.GB8803@dastard> <529DA2F5.1040602@parallels.com> <20131203133755.GJ10323@ZenIV.linux.org.uk>
In-Reply-To: <20131203133755.GJ10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 05:37 PM, Al Viro wrote:
> On Tue, Dec 03, 2013 at 01:23:01PM +0400, Vladimir Davydov wrote:
>
>> Actually, I'm not going to modify the list_lru structure, because I
>> think it's good as it is. I'd like to substitute it with a new
>> structure, memcg_list_lru, only in those places where this functionality
>> (per-memcg scanning) is really needed. This new structure would look
>> like this:
>>
>> struct memcg_list_lru {
>>     struct list_lru global_lru;
>>     struct list_lru **memcg_lrus;
>>     struct list_head list;
>>     void *old_lrus;
>> }
>>
>> Since old_lrus and memcg_lrus can be NULL under normal operation, in
>> memcg_list_lru_destroy() I'd have to check either the list or the
>> global_lru field, i.e. it would look like:
>>
>> if (!list.next)
>>     /* has not been initialized */
>>     return;
>>
>> or
> ... or just use hlist_head.

list_head serves as a list node here (those structures are organized in
a linked list) and I have to remove it from the list upon destruction so
hlist_head is not relevant here.

Thanks.
