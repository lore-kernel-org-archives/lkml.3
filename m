Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3A3RMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:12:24 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41751 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab3A3RLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <20130130164614.GC30559@balto.lan>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
	<1359550803-18577-3-git-send-email-fabio.baltieri@linaro.org>
	<CAKohpok0iDffNM31W2r97Wtq4DR+TdPwYWTAdJH7AyLqHm0UPA@mail.gmail.com>
	<20130130164614.GC30559@balto.lan>
Date: Wed, 30 Jan 2013 22:41:08 +0530
Message-ID: <CAKohponMezzus0tRW+CdC7wLq1U1pRio5q=g6F845x7iveFCAA@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] cpufreq: ondemand: call dbs_check_cpu only when necessary
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 22:16, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Isn't that how it works now?  The current cpu ktime is not checked
> against its own, but against the "leader" cpu (dbs_info_local->cdbs.cpu),
> that's why it's initialized only for the first.
>
> Maybe I should have used dbs_info_leader/dbs_info instead of
> dbs_info_local/dbs_info.

This routine is called as wq handler. Which will recover dbs_info from work
using container_of. Which would give dbs_info_local for the cpu j.

Then we will execute below code.

+       /* use leader CPU's dbs_info */
+       dbs_info = &per_cpu(od_cpu_dbs_info, dbs_info_local->cdbs.cpu);

dbs_info_local->cdbs.cpu was uninitialized for all cpus except policy->cpu.
And so, might be initialized with 0 as its a global variable... But if you
offline cpu 0 and online it back, then policy->cpu would be 1 and this logic,
which worked by mistake will fail.

+       mutex_lock(&dbs_info->cdbs.timer_mutex);
+
+       time_now = ktime_get();
+       delta_us = ktime_us_delta(time_now, dbs_info->cdbs.time_stamp);

and so as this.

Correct?
