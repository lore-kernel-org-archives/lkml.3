Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3EUGfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:35:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40494 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab3EUGfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:35:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,712,1363104000"; 
   d="scan'208";a="7321085"
Message-ID: <519B1641.1020906@cn.fujitsu.com>
Date: Tue, 21 May 2013 14:37:53 +0800
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
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <1583356.7oqZ7gBy2q@vostro.rjw.lan> <2376818.CRj1BTLk0Y@vostro.rjw.lan> <19540491.PRsM4lKIYM@vostro.rjw.lan>
In-Reply-To: <19540491.PRsM4lKIYM@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 14:33:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 14:33:45,
	Serialize complete at 2013/05/21 14:33:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Please see below.

On 05/04/2013 07:21 PM, Rafael J. Wysocki wrote:
......
>   static BLOCKING_NOTIFIER_HEAD(memory_chain);
> @@ -278,33 +283,64 @@ static int __memory_block_change_state(s
>   {
>   	int ret = 0;
>
> -	if (mem->state != from_state_req) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> +	if (mem->state != from_state_req)
> +		return -EINVAL;
>
>   	if (to_state == MEM_OFFLINE)
>   		mem->state = MEM_GOING_OFFLINE;
>
>   	ret = memory_block_action(mem->start_section_nr, to_state, online_type);
> -
>   	if (ret) {
>   		mem->state = from_state_req;
> -		goto out;
> +	} else {
> +		mem->state = to_state;
> +		if (to_state == MEM_ONLINE)
> +			mem->last_online = online_type;

Why do we need to remember last online type ?

And as far as I know, we can obtain which zone a page was in last time it
was onlined by check page->flags, just like online_pages() does. If we
use online_kernel or online_movable, the zone boundary will be 
recalculated.
So we don't need to remember the last online type.

Seeing from your patch, I guess memory_subsys_online() can only handle
online and offline. So mem->last_online is used to remember what user has
done through the original way to trigger memory hot-remove, right ? And 
when
user does it in this new way, it just does the same thing as user does last
time.

But I still think we don't need to remember it because if finally you call
online_pages(), it just does the same thing as last time by default.

online_pages()
{
	......
	if (online_type == ONLINE_KERNEL ......

	if (online_type == ONLINE_MOVABLE......

	zone = page_zone(pfn_to_page(pfn));

	/* Here, the page will be put into the zone which it belong to last 
time. */

	......
}

I just thought of it. Maybe I missed something in your design. Please tell
me if I'm wrong.

Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>

Thanks. :)


