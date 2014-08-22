Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaHVGcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:32:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:46776 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaHVGcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:32:48 -0400
Date: Fri, 22 Aug 2014 10:32:42 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-ID: <20140822063242.GI14072@moon>
References: <20140804172255.109539743@openvz.org>
 <20140804172610.965949916@openvz.org>
 <20140821155115.8433bb37bf631b8ae8340f84@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821155115.8433bb37bf631b8ae8340f84@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 03:51:15PM -0700, Andrew Morton wrote:
...
> > 
> > Still note that updating exe-file link now doesn't require sys-resource
> > capability anymore, after all there is no much profit in preventing setup
> > own file link (there are a number of ways to execute own code -- ptrace,
> > ld-preload, so that the only reliable way to find which exactly code
> > is executed is to inspect running program memory). Still we require
> > the caller to be at least user-namespace root user.
> > 
> > I believe the old interface should be deprecated and ripped off
> > in a couple of kernel releases if no one against.
> > 
> > To test if new interface is implemented in the kernel one
> > can pass PR_SET_MM_MAP_SIZE opcode and the kernel returns
> > the size of currently supported struct prctl_mm_map.
> 
> Please convince me that we're not adding any security holes.

I've commented all the fields and their purpose and triple-checked them all,
so I don't see any sec. problems, but for same purpose I've CC'ed a number
of people just to be on safe side. Again, if we want this feature to be
somehow more controlled -- we can add some sysctl variable which would
enable/disable this interface globally.

> > +	error |= __prctl_check_addr_space(start_code);
> > +	error |= __prctl_check_addr_space(end_code);
> > +	error |= __prctl_check_addr_space(start_data);
> > +	error |= __prctl_check_addr_space(end_data);
> > +	error |= __prctl_check_addr_space(start_stack);
> > +	error |= __prctl_check_addr_space(start_brk);
> > +	error |= __prctl_check_addr_space(brk);
> > +	error |= __prctl_check_addr_space(arg_start);
> > +	error |= __prctl_check_addr_space(arg_end);
> > +	error |= __prctl_check_addr_space(env_start);
> > +	error |= __prctl_check_addr_space(env_end);
> 
> Boy this is verbose.  I had a little fiddle and came up with
...
> 
> +
> +		for (i = 0; i < ARRAY_SIZE(offsets); i++) {
> +			u64 val = ((u64 *)prctl_map)[offsets[i]];
> +
> +			if (val < mmap_min_addr || val >= mmap_max_addr) {
> +				error = -EINVAL;
> +				goto out;
> +			}
> +		}
> +	}
> 
> and it saved 400 bytes of text.
> 
> But it's a bit hacky.  Can anyone think of anything smarter?

Looks good to me and not that hacky actually. Should I update on top
for -mm tree?
