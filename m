Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaAOBNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:13:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48763 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaAOBNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:13:42 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52D5E08E.4030309@jp.fujitsu.com>
Date: Wed, 15 Jan 2014 10:12:46 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Hedi <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hotplug, memory: move register_memory_resource out of the
 lock_memory_hotplug
References: <1389723874-32372-1-git-send-email-nzimmer@sgi.com>
In-Reply-To: <1389723874-32372-1-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/15 3:24), Nathan Zimmer wrote:
> We don't need to do register_memory_resource() since it has its own lock and
> doesn't make any callbacks.
> 
> Also register_memory_resource return NULL on failure so we don't have anything
> to cleanup at this point.
> 
> 
> The reason for this rfc is I was doing some experiments with hotplugging of
> memory on some of our larger systems.  While it seems to work, it can be quite
> slow.  With some preliminary digging I found that lock_memory_hotplug is
> clearly ripe for breakup.
> 
> It could be broken up per nid or something but it also covers the
> online_page_callback.  The online_page_callback shouldn't be very hard to break
> out.
> 
> Also there is the issue of various structures(wmarks come to mind) that are
> only updated under the lock_memory_hotplug that would need to be dealt with.
> 
> 
> cc: Andrew Morton <akpm@linux-foundation.org>
> cc: Tang Chen <tangchen@cn.fujitsu.com>
> cc: Wen Congyang <wency@cn.fujitsu.com>
> cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> cc: Hedi <hedi@sgi.com>
> cc: Mike Travis <travis@sgi.com>
> cc: linux-mm@kvack.org
> cc: linux-kernel@vger.kernel.org
> 
> 
> ---

The patch seems good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   mm/memory_hotplug.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 1ad92b4..62a0cd1 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1097,17 +1097,18 @@ int __ref add_memory(int nid, u64 start, u64 size)
>   	struct resource *res;
>   	int ret;
>   
> -	lock_memory_hotplug();
> -
>   	res = register_memory_resource(start, size);
>   	ret = -EEXIST;
>   	if (!res)
> -		goto out;
> +		return ret;
>   
>   	{	/* Stupid hack to suppress address-never-null warning */
>   		void *p = NODE_DATA(nid);
>   		new_pgdat = !p;
>   	}
> +
> +	lock_memory_hotplug();
> +
>   	new_node = !node_online(nid);
>   	if (new_node) {
>   		pgdat = hotadd_new_pgdat(nid, start);
> 


