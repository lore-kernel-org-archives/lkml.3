Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbbAGJLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:11:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbbAGJLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:11:49 -0500
Message-ID: <54ACF851.3040002@suse.cz>
Date: Wed, 07 Jan 2015 10:11:45 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 3/4] mm: reduce try_to_compact_pages parameters
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz> <1420478263-25207-4-git-send-email-vbabka@suse.cz> <20150106145710.GD20860@dhcp22.suse.cz>
In-Reply-To: <20150106145710.GD20860@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 03:57 PM, Michal Hocko wrote:
> Hmm, wait a minute
> 
> On Mon 05-01-15 18:17:42, Vlastimil Babka wrote:
> [...]
>> -unsigned long try_to_compact_pages(struct zonelist *zonelist,
>> -			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>> -			enum migrate_mode mode, int *contended,
>> -			int alloc_flags, int classzone_idx)
>> +unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
>> +			int alloc_flags, const struct alloc_context *ac,
>> +			enum migrate_mode mode, int *contended)
>>  {
>> -	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>>  	int may_enter_fs = gfp_mask & __GFP_FS;
>>  	int may_perform_io = gfp_mask & __GFP_IO;
>>  	struct zoneref *z;
> 
> gfp_mask might change since the high_zoneidx was set up in the call
> chain. I guess this shouldn't change to the gfp_zone output but it is
> worth double checking.

Yeah I checked that. gfp_zone() operates just on GFP_ZONEMASK part of the flags,
and we don't change that.

>> @@ -1365,8 +1363,8 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>  		return COMPACT_SKIPPED;
>>  
>>  	/* Compact each zone in the list */
>> -	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
>> -								nodemask) {
>> +	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
>> +								ac->nodemask) {
>>  		int status;
>>  		int zone_contended;
>>  
> 

