Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668Ab3BTARq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:17:46 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47344 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461Ab3BTARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:17:45 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-31-512416266abc
Date: Wed, 20 Feb 2013 09:17:43 +0900
From: Minchan Kim <minchan@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH v2] memcg: Add memory.pressure_level events
Message-ID: <20130220001743.GE16950@blaptop>
References: <20130219044012.GA23356@lizard.sbx00618.mountca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219044012.GA23356@lizard.sbx00618.mountca.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Mon, Feb 18, 2013 at 08:40:12PM -0800, Anton Vorontsov wrote:
> With this patch userland applications that want to maintain the
> interactivity/memory allocation cost can use the pressure level
> notifications. The levels are defined like this:
> 
> The "low" level means that the system is reclaiming memory for new
> allocations. Monitoring this reclaiming activity might be useful for
> maintaining cache level. Upon notification, the program (typically
> "Activity Manager") might analyze vmstat and act in advance (i.e.
> prematurely shutdown unimportant services).
> 
> The "medium" level means that the system is experiencing medium memory
> pressure, the system might be making swap, paging out active file caches,
> etc. Upon this event applications may decide to further analyze
> vmstat/zoneinfo/memcg or internal memory usage statistics and free any
> resources that can be easily reconstructed or re-read from a disk.
> 
> The "critical" level means that the system is actively thrashing, it is
> about to out of memory (OOM) or even the in-kernel OOM killer is on its
> way to trigger. Applications should do whatever they can to help the
> system. It might be too late to consult with vmstat or any other
> statistics, so it's advisable to take an immediate action.
> 
> The events are propagated upward until the event is handled, i.e. the
> events are not pass-through. Here is what this means: for example you have
> three cgroups: A->B->C. Now you set up an event listener on cgroups A, B
> and C, and suppose group C experiences some pressure. In this situation,
> only group C will receive the notification, i.e. groups A and B will not
> receive it. This is done to avoid excessive "broadcasting" of messages,
> which disturbs the system and which is especially bad if we are low on
> memory or thrashing. So, organize the cgroups wisely, or propagate the
> events manually (or, ask us to implement the pass-through events,
> explaining why would you need them.)
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
> 
> Hi all,
> 
> Many thanks for the previous reviews! In this revision:
> 
> - Addressed Glauber Costa's comments:
>   o Use parent_mem_cgroup() instead of own parent function (also suggested
>     by Kamezawa). This change also affected events distribution logic, so
>     it became more like memory thresholds notifications, i.e. we deliver
>     the event to the cgroup where the event originated, not to the parent
>     cgroup; (This also addreses Kamezawa's remark regarding which cgroup
>     receives which event.)
>   o Register vmpressure cgroup file directly in memcontrol.c.
> 
> - Addressed Greg Thelen's comments:
>   o Fixed bool/int inconsistency in the code;
>   o Fixed nr_scanned accounting;
>   o Don't use cryptic 's', 'r' abbreviations; get rid of confusing
>     'window' argument.
> 
> - Addressed Kamezawa Hiroyuki's comments:
>   o Moved declarations from mm/internal.h into linux/vmpressue.h;
>   o Removed Kconfig symbol. Vmpressure is pretty lightweight (especially
>     comparing to the memcg accounting). If it ever causes any measurable
>     performance effect, we want to fix it, not paper it over with a
>     Kconfig option. :-)
>   o Removed read operation on pressure_level cgroup file. In apps, we only
>     use notifications, we don't need the content of the file, so let's
>     keep things simple for now. Plus this resolves questions like what
>     should we return there when the system is not reclaiming;
>   o Reworded documentation;
>   o Improved comments for vmpressure_prio().

Should we really enable memcg for just pressure notificaion in embedded side?
I didn't check the size(cgroup + memcg) and performance penalty but I don't want
to add unnecessary overhead if it is possible.
Do you have a plan to support it via global knob(ie, /proc/mempressure), NOT memcg?

-- 
Kind regards,
Minchan Kim
