Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaGIPGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:06:09 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:46228 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaGIPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:06:07 -0400
Date: Wed, 9 Jul 2014 19:06:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140709150604.GN17860@moon.sw.swsoft.com>
References: <20140703143318.568554771@openvz.org>
 <20140703151102.842945837@openvz.org>
 <20140708190849.GC17860@moon.sw.swsoft.com>
 <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
 <20140708221336.GL17860@moon.sw.swsoft.com>
 <20140709141318.GM17860@moon.sw.swsoft.com>
 <CAGXu5jKmTSb0YmNFDtr-jymrhy_s_PXUuvj3WKYffSU98gwyqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKmTSb0YmNFDtr-jymrhy_s_PXUuvj3WKYffSU98gwyqg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:53:10AM -0700, Kees Cook wrote:
...
> > +
> > +       /*
> > +        * Make sure the pairs are ordered.
> > +        */
> > +#define __prctl_check_order(__map, __m1, __m2)                                 \
> > +       (unsigned long)__map->__m2 <= (unsigned long)__map->__m1
> > +       if (__prctl_check_order(prctl_map, start_code, end_code)        ||
> > +           __prctl_check_order(prctl_map, start_data, end_data)        ||
> > +           __prctl_check_order(prctl_map, arg_start, arg_end)          ||
> > +           __prctl_check_order(prctl_map, env_start, env_end))
> > +               goto out;
> > +#undef __prctl_check_order
> 
> This approach seems like a good solution given the security concerns
> with the earlier approach. I'm still pondering the implications, but
> as a minor style note, these macros are locally defined, but also all
> take at least a single identical argument in every usage. I would
> think it might be easier to read if they just used what they needed to
> directly.
> 
> #define __prctl_check_addr_space(__member)     \
>       ((unsigned long)prctl_map->__member < mmap_max_addr &&           \
>        (unsigned long)prctl_map->__member >= mmap_min_addr) ? 0 : -EINVAL
> 
> #define __prctl_check_vma(__member) \
>            find_vma(mm, (unsigned long)prctl_map->__member) ? 0 : -EINVAL
> 
> Also, why change the symantics of the final macro? Seems like that one
> can use the same "error |=" style:
> 
> #define __prctl_check_order(__m1, __m2)         \
>       prctl_map->__m1 < prctl_map->__m2 ? 0 : -EINVAL

Thanks a lot for comments, Kees! I tend to agre, leaving off the @prctl_map
variable out of macros should make code also shorter, I'll update that's
not the problem. Could you please re-check if I'm not missing something
in security aspects when time permits.
