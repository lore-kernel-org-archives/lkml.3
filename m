Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3EVBmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 21:42:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3EVBmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 21:42:32 -0400
Date: Tue, 21 May 2013 22:33:30 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/7] KVM: MMU: fast invalidate all pages
Message-ID: <20130522013330.GA8583@amt.cnet>
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1368738782-18649-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130520194624.GA21392@amt.cnet>
 <20130520201545.GC14287@redhat.com>
 <20130520204047.GA23364@amt.cnet>
 <20130521083902.GW4725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521083902.GW4725@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:39:03AM +0300, Gleb Natapov wrote:
> > Any pages with stale information will be zapped by kvm_mmu_zap_all().
> > When that happens, page faults will take place which will automatically 
> > use the new generation number.
> > 
> > So still not clear why is this necessary.
> > 
> This is not, strictly speaking, necessary, but it is the sane thing to do.
> You cannot update page's generation number to prevent it from been
> destroyed since after kvm_mmu_zap_all() completes stale ptes in the
> shadow page may point to now deleted memslot. So why build shadow page
> table with a page that is in a process of been destroyed?

OK, can this be introduced separately, in a later patch, with separate
justification, then?

Xiao please have the first patches of the patchset focus on the problem
at hand: fix long mmu_lock hold times.

> Not sure what you mean again. We flush TLB once before entering this function.
> kvm_reload_remote_mmus() does this for us, no?

kvm_reload_remote_mmus() is used as an optimization, its separate from the
problem solution.

> > 
> > What was suggested was... go to phrase which starts with "The only purpose
> > of the generation number should be to".
> > 
> > The comment quoted here does not match that description.
> > 
> The comment describes what code does and in this it is correct.
> 
> You propose to not reload roots right away and do it only when root sp
> is encountered, right? So my question is what's the point? There are,
> obviously, root sps with invalid generation number at this point, so
> reload will happen regardless in kvm_mmu_prepare_zap_page(). So why not
> do it here right away and avoid it in kvm_mmu_prepare_zap_page() for
> invalid and obsolete sps as I proposed in one of my email?

Sure. But Xiao please introduce that TLB collapsing optimization as a
later patch, so we can reason about it in a more organized fashion.

