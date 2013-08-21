Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3HUNoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:44:09 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:46951 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab3HUNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:44:06 -0400
Date: Wed, 21 Aug 2013 09:44:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 05/11] cpuset: inherite ancestor's masks if
 real_{cpus,mems}_allowed become empty
Message-ID: <20130821134402.GE19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F90.7070809@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148F90.7070809@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

s/inherite/inherit/ in the subject.

On Wed, Aug 21, 2013 at 05:59:44PM +0800, Li Zefan wrote:
> We're going to have separate user-configured masks and effective ones.
> 
> At last configured masks can only be changed by writing cpuset.cpus
> and cpuset.mems, and they won't be restricted by parent cpuset. While
> effective masks reflect cpu/memory hotplug and hierachical restriction.
> 
> This is a preparation to make real_{cpus,mems}_allowed to be effective
> masks of the cpuset:
> 
> - change the effective masks at hotplug: done
> - change the effective masks at config change: done
> - take on ancestor's mask when the effective mask is empty: done

The above description doesn't really work well.  It looks like this
patch does all three changes.  Can you please update the patch
descriptions so that it's clear what each patch does?

>  		/*
> +		 * If it becomes empty, inherite the effective mask of the
                                        ^
					inherit

> +		 * parent, which is guarantted to have some CPUs.
>  		 */
> -		if (cpumask_equal(new_cpus, cp->real_cpus_allowed) &&
> -		    ((cp == cs) || !cpumask_empty(new_cpus))) {
> +		if (cpumask_empty(new_cpus))
> +			cpumask_copy(new_cpus, parent->real_cpus_allowed);
> +
> +		/* Skip the whole subtree if the cpumask is not changed. */
> +		if (cpumask_equal(new_cpus, cp->real_cpus_allowed)) {
>  			pos_css = css_rightmost_descendant(pos_css);
>  			continue;
>  		}

Ooh, I like how this looks now.  Makes a lot more sense than the logic
before.

Thanks.

-- 
tejun
