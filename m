Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3CDSEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:04:37 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:57338 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab3CDSEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:04:35 -0500
Date: Mon, 4 Mar 2013 10:04:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: avoid accessing modular cgroup subsys
 structure without locking
Message-ID: <20130304180430.GE30413@htj.dyndns.org>
References: <5130535F.7060201@huawei.com>
 <5130537C.5010608@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5130537C.5010608@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Fri, Mar 01, 2013 at 03:06:36PM +0800, Li Zefan wrote:
>  /* Define the enumeration of all builtin cgroup subsystems */
>  #define SUBSYS(_x) _x ## _subsys_id,
> -#define IS_SUBSYS_ENABLED(option) IS_ENABLED(option)
>  enum cgroup_subsys_id {
> +#define IS_SUBSYS_ENABLED(option) IS_BUILTIN(option)
>  #include <linux/cgroup_subsys.h>
> +#undef IS_SUBSYS_ENABLED
> +	CGROUP_BUILTIN_SUBSYS_COUNT,
> +
> +	__CGROUP_SUBSYS_TEMP_PLACEHOLDER = CGROUP_BUILTIN_SUBSYS_COUNT - 1,
> +
> +#define IS_SUBSYS_ENABLED(option) IS_MODULE(option)
> +#include <linux/cgroup_subsys.h>
> +#undef IS_SUBSYS_ENABLED
>  	CGROUP_SUBSYS_COUNT,
>  };
> -#undef IS_SUBSYS_ENABLED
>  #undef SUBSYS

Arghh.... can we at least have a comment explaining what we're doing
here?  It's ugly and confusing.

> @@ -5019,13 +5019,17 @@ void cgroup_exit(struct task_struct *tsk, int run_callbacks)
>  	tsk->cgroups = &init_css_set;
>  
>  	if (run_callbacks && need_forkexit_callback) {
> -		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> +		/*
> +		 * fork/exit callbacks are supported only for builtin
> +		 * subsystems, and the builtin section of the subsys
> +		 * array is immutable, so we don't need to lock the
> +		 * subsys array here. On the other hand, modular section
> +		 * of the array can be freed at module unload, so we
> +		 * can't touch that.
> +		 */
> +		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {

Probably enough to say "for/exit callback are supported only for
builtin subsys, see cgroup_for() for details"?

Thanks.

-- 
tejun
