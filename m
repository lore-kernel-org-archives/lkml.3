Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3JHOkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:40:35 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:34154 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3JHOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:40:32 -0400
Date: Tue, 8 Oct 2013 18:40:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [patch 1/3] [PATCH] mm: migration -- Do not loose soft dirty bit
 if page is in migration state
Message-ID: <20131008144030.GA19040@moon>
References: <20131008090019.527108154@gmail.com>
 <20131008090236.951114091@gmail.com>
 <1381241500-bfdgpu61-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381241500-bfdgpu61-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:11:40AM -0400, Naoya Horiguchi wrote:
> > Index: linux-2.6.git/mm/memory.c
> > ===================================================================
> > --- linux-2.6.git.orig/mm/memory.c
> > +++ linux-2.6.git/mm/memory.c
> > @@ -837,6 +837,8 @@ copy_one_pte(struct mm_struct *dst_mm, s
> >  					 */
> >  					make_migration_entry_read(&entry);
> >  					pte = swp_entry_to_pte(entry);
> > +					if (pte_swp_soft_dirty(*src_pte))
> > +						pte = pte_swp_mksoft_dirty(pte);
> >  					set_pte_at(src_mm, addr, src_pte, pte);
> >  				}
> >  			}
> 
> When we convert pte to swap_entry, we convert soft-dirty bit in
> pte_to_swp_entry(). So I think that it's better to convert it back
> in swp_entry_to_pte() when we do swap_entry-to-pte conversion.

No, soft dirty bit lays _only_ inside pte entry in memory, iow
swp_entry_t never has this bit, thus to be able to find soft dirty
status in swp_entry_to_pte you need to extend this function and
pass pte entry itself as an argument, which eventually will bring
more massive patch and will be a way more confusing I think.

Or I misunderstood you?
