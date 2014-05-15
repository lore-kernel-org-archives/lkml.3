Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaEOR7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:59:36 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33861 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbaEOR7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:59:33 -0400
Date: Thu, 15 May 2014 10:58:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
In-Reply-To: <5374FCC0.8010809@oracle.com>
Message-ID: <alpine.LSU.2.11.1405151048250.4797@eggly.anvils>
References: <51559150.3040407@oracle.com> <515D882E.6040001@oracle.com> <533F09F0.1050206@oracle.com> <20140407144835.GA17774@node.dhcp.inet.fi> <5342FF3E.6030306@oracle.com> <20140407201106.GA21633@node.dhcp.inet.fi> <5374FA04.5@oracle.com>
 <alpine.LSU.2.11.1405151034160.4721@eggly.anvils> <5374FCC0.8010809@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Sasha Levin wrote:
> On 05/15/2014 01:37 PM, Hugh Dickins wrote:
> > On Thu, 15 May 2014, Sasha Levin wrote:
> >> On 04/07/2014 04:11 PM, Kirill A. Shutemov wrote:
> >>> On Mon, Apr 07, 2014 at 03:40:46PM -0400, Sasha Levin wrote:
> >>>>> It also breaks fairly quickly under testing because:
> >>>>>
> >>>>> On 04/07/2014 10:48 AM, Kirill A. Shutemov wrote:
> >>>>>>> +	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
> >>>>>>> +		spin_lock(ptl);
> >>>>>
> >>>>> ^ We go into atomic
> >>>>>
> >>>>>>> +		if (unlikely(!pmd_same(*pmd, orig_pmd)))
> >>>>>>> +			goto out_race;
> >>>>>>> +	}
> >>>>>>> +
> >>>>>>>  	if (!page)
> >>>>>>>  		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
> >>>>>>>  	else
> >>>>>>>  		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
> >>>>>
> >>>>> copy_user_huge_page() doesn't like running in atomic state,
> >>>>> and asserts might_sleep().
> >>> Okay, I'll try something else.
> >>
> >> I've Cc'ed Josh Boyer to this since it just occurred to me that Fedora
> >> is running with CONFIG_DEBUG_VM set, where this bug is rather easy to
> >> trigger.
> >>
> >> This issue was neglected because it triggers only on CONFIG_DEBUG_VM builds,
> >> but with Fedora running that, maybe it shouldn't be?
> > 
> > But it triggers only on CONFIG_DEBUG_PAGEALLOC builds, doesn't it?
> > I hope Fedora doesn't go out with that enabled.
> 
> Ow, it needs DEBUG_PAGEALLOC too? I forgot about that one.

Yes.  And furthermore, whereas many DEBUG_PAGEALLOC reports are early
warnings of real problems in non-DEBUG_PAGEALLOC kernels, this one is
not.  It's a case where the non-DEBUG_PAGEALLOC kernel is correct, and
the DEBUG_PAGEALLOC kernel too strict.  Fixable, but not yet in a way
that satisfied Kirill or me.

> 
> No problem for Fedora then, sorry for the noise :(

Oh, this is much more welcome noise than your usual bug reports :)

Hugh
