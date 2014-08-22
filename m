Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbaHVGt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:49:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbaHVGtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:49:25 -0400
Date: Thu, 21 Aug 2014 23:49:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tj@kernel.org,
        avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com
Subject: Re: [patch 4/4] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v3
Message-Id: <20140821234912.f007e2fb.akpm@linux-foundation.org>
In-Reply-To: <20140822063242.GI14072@moon>
References: <20140804172255.109539743@openvz.org>
	<20140804172610.965949916@openvz.org>
	<20140821155115.8433bb37bf631b8ae8340f84@linux-foundation.org>
	<20140822063242.GI14072@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 10:32:42 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > > +	error |= __prctl_check_addr_space(start_code);
> > > +	error |= __prctl_check_addr_space(end_code);
> > > +	error |= __prctl_check_addr_space(start_data);
> > > +	error |= __prctl_check_addr_space(end_data);
> > > +	error |= __prctl_check_addr_space(start_stack);
> > > +	error |= __prctl_check_addr_space(start_brk);
> > > +	error |= __prctl_check_addr_space(brk);
> > > +	error |= __prctl_check_addr_space(arg_start);
> > > +	error |= __prctl_check_addr_space(arg_end);
> > > +	error |= __prctl_check_addr_space(env_start);
> > > +	error |= __prctl_check_addr_space(env_end);
> > 
> > Boy this is verbose.  I had a little fiddle and came up with
> ...
> > 
> > +
> > +		for (i = 0; i < ARRAY_SIZE(offsets); i++) {
> > +			u64 val = ((u64 *)prctl_map)[offsets[i]];
> > +
> > +			if (val < mmap_min_addr || val >= mmap_max_addr) {
> > +				error = -EINVAL;
> > +				goto out;
> > +			}
> > +		}
> > +	}
> > 
> > and it saved 400 bytes of text.
> > 
> > But it's a bit hacky.  Can anyone think of anything smarter?
> 
> Looks good to me and not that hacky actually.

Hacky :( I guess it's pretty safe because this is a userspace-visible
structure so we'll never be changing it.

Or will we?  What happens if we later decide that some additional field
needs to be added?  Do we version the interface?  Add a new prctl()
mode?  Let's cook up a plan for that and at least add to changelog?

> Should I update on top for -mm tree?

Spose so.  Let's see what the code savings are when the other two sites
are similarly changed?

To save a bit more space offsets[] could be an array of uchar, I guess.
A BUILD_BUG_ON(sizeof(struct prctl_map) >= 256) would keep that sane.

