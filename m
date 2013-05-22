Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3EVEmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 00:42:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5003 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3EVEmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 00:42:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,719,1363104000"; 
   d="scan'208";a="7330463"
Message-ID: <519C4D6E.6080902@cn.fujitsu.com>
Date: Wed, 22 May 2013 12:45:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2 v2, RFC] Driver core: Introduce offline/online callbacks
 for memory blocks
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <19540491.PRsM4lKIYM@vostro.rjw.lan> <519B1641.1020906@cn.fujitsu.com> <1824290.fKsAJTo9gA@vostro.rjw.lan>
In-Reply-To: <1824290.fKsAJTo9gA@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 12:41:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 12:41:23,
	Serialize complete at 2013/05/22 12:41:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 05/21/2013 07:15 PM, Rafael J. Wysocki wrote:
......
>>> +		mem->state = to_state;
>>> +		if (to_state == MEM_ONLINE)
>>> +			mem->last_online = online_type;
>>
>> Why do we need to remember last online type ?
>>
>> And as far as I know, we can obtain which zone a page was in last time it
>> was onlined by check page->flags, just like online_pages() does. If we
>> use online_kernel or online_movable, the zone boundary will be
>> recalculated.
>> So we don't need to remember the last online type.
>>
>> Seeing from your patch, I guess memory_subsys_online() can only handle
>> online and offline. So mem->last_online is used to remember what user has
>> done through the original way to trigger memory hot-remove, right ? And
>> when
>> user does it in this new way, it just does the same thing as user does last
>> time.
>>
>> But I still think we don't need to remember it because if finally you call
>> online_pages(), it just does the same thing as last time by default.
>>
>> online_pages()
>> {
>> 	......
>> 	if (online_type == ONLINE_KERNEL ......
>>
>> 	if (online_type == ONLINE_MOVABLE......
>>
>> 	zone = page_zone(pfn_to_page(pfn));
>>
>> 	/* Here, the page will be put into the zone which it belong to last
>> time. */
>
> To be honest, it wasn't entirely clear to me that online_pages() would do the
> same thing as last time by default.  Suppose, for example, that the previous
> online_type was ONLINE_MOVABLE.  How online_pages() is supposed to know that
> it should do the move_pfn_zone_right() if we don't tell it to do that?  Or
> is that unnecessary, because it's already been done previously?

Yes, it is unnecessary. move_pfn_zone_right/left() will modify the zone 
related
bits in page->flags. But when the page is offline, the zone related bits in
page->flags will not change. So when it is online again, by dafault, it 
will
be in the zone which it was in last time.

......

>>
>> I just thought of it. Maybe I missed something in your design. Please tell
>> me if I'm wrong.
>
> Well, so what should be passed to __memory_block_change_state() in
> memory_subsys_online()?  -1?

If you want to keep the last time status, you can pass ONLINE_KEEP.
Or -1 is all right.

Thanks. :)

>
>> Reviewed-by: Tang Chen<tangchen@cn.fujitsu.com>
>>
>> Thanks. :)
>
> Thanks for your comments,
> Rafael
>
>

