Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaGDIMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:12:00 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45708 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaGDILz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:11:55 -0400
Date: Fri, 4 Jul 2014 12:11:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140704081151.GM12440@moon>
References: <20140703143318.568554771@openvz.org>
 <20140703151102.842945837@openvz.org>
 <20140704075256.GA5105@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704075256.GA5105@paralelels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 11:52:56AM +0400, Andrew Vagin wrote:
> > +
> > +struct prctl_mm_map {
> > +	unsigned long	start_code;
> 
> "unsigned long" has different sizes on x86_64 and x86, so a compat
> is required for x32 processes on x64 kernel.

Yes, good point. I think we can use u64/32 types instead to make
a code shared. I'll update once I collect all comments about
aproach.

> > +
> > +	/*
> > +	 * Stack, brk, command line arguments and environment must exist.
> > +	 */
> > +	stack_vma = find_vma(mm, prctl_map->start_stack);
> 
> Why do we not use __prctl_check_vma here?

Well __prctl_check_vma does return error or zero while I need this
vma reference for stack rlim check which is done below in code.
> 
> > +	if (!stack_vma) {
> > +		error = -EINVAL;
> > +		goto out;
> > +	}
> > +#define __prctl_check_vma(mm, addr) find_vma(mm, addr) ? 0 : -EINVAL
> > +	error |= __prctl_check_vma(mm, prctl_map->start_brk);
> > +	error |= __prctl_check_vma(mm, prctl_map->brk);

	Cyrill
