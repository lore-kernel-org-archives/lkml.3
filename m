Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3HaAYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:24:52 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38337 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3HaAYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:24:51 -0400
Message-ID: <1377908599.10300.901.camel@misato.fc.hp.com>
Subject: Re: [PATCH 3/3] PM / hibernate / memory hotplug: Rework mutual
 exclusion
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, linux-mm@kvack.org
Date: Fri, 30 Aug 2013 18:23:19 -0600
In-Reply-To: <1562298.ZjRvhqQzT7@vostro.rjw.lan>
References: <9589253.Co8jZpnWdd@vostro.rjw.lan>
	 <1562298.ZjRvhqQzT7@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-29 at 23:18 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since all of the memory hotplug operations have to be carried out
> under device_hotplug_lock, they won't need to acquire pm_mutex if
> device_hotplug_lock is held around hibernation.
> 
> For this reason, make the hibernation code acquire
> device_hotplug_lock after freezing user space processes and
> release it before thawing them.  At the same tim drop the
> lock_system_sleep() and unlock_system_sleep() calls from
> lock_memory_hotplug() and unlock_memory_hotplug(), respectively.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  kernel/power/hibernate.c |    4 ++++
>  kernel/power/user.c      |    2 ++
>  mm/memory_hotplug.c      |    4 ----
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> Index: linux-pm/kernel/power/hibernate.c
> ===================================================================
> --- linux-pm.orig/kernel/power/hibernate.c
> +++ linux-pm/kernel/power/hibernate.c
> @@ -652,6 +652,7 @@ int hibernate(void)
>  	if (error)
>  		goto Exit;
>  
> +	lock_device_hotplug();

Since hibernate() can be called from sysfs, do you think the tool may
see this as a circular dependency with p_active again?  This shouldn't
be a problem in practice, though.

Thanks,
-Toshi

