Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbbAWJrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 04:47:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbbAWJrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 04:47:33 -0500
Date: Fri, 23 Jan 2015 10:46:51 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 1/7] perf: provide sysfs_show for struct
 perf_pmu_events_attr
Message-ID: <20150123094651.GB4654@krava.brq.redhat.com>
References: <1419234532-22657-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234532-22657-2-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419234532-22657-2-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:48:46PM -0800, Sukadev Bhattiprolu wrote:
> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> (struct perf_pmu_events_attr) is defined in include/linux/perf_event.h,
> but the only "show" for it is in x86 and contains x86 specific stuff.
> 
> Make a generic one for those of us who are just using the event_str.
> 
> CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> CC: Haren Myneni <hbabu@us.ibm.com>
> CC: Cody P Schafer <dev@codyps.com>
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/perf_event.h | 3 +++
>  kernel/events/core.c       | 8 ++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 486e84c..58f59bd 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -897,6 +897,9 @@ struct perf_pmu_events_attr {
>  	const char *event_str;
>  };
>  
> +ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
> +			      char *page);
> +
>  #define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
>  static struct perf_pmu_events_attr _var = {				\
>  	.attr = __ATTR(_name, 0444, _show, NULL),			\
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index af0a5ba..1808d0e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -8276,6 +8276,14 @@ void __init perf_event_init(void)
>  		     != 1024);
>  }
>  
> +ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
> +			      char *page)
> +{
> +	struct perf_pmu_events_attr *pmu_attr =
> +		container_of(attr, struct perf_pmu_events_attr, attr);
> +	return sprintf(page, "%s\n", pmu_attr->event_str);
> +}
> +

Stephane just added same local one for RAPL pmu:
  433678bdc6ed perf/rapl: Fix sysfs_show() initialization for RAPL PMU

with additional pmu_attr->event_str check

same for PMU_EVENT_ATTR_STRING macro

if you could add this additional check plus the id initialization
in the PMU_EVENT_ATTR_STRING macro, we could use the generic
version in RAPL object as well

thanks,
jirka
