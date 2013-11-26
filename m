Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3KZKNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:13:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab3KZKNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:13:10 -0500
Date: Tue, 26 Nov 2013 12:12:42 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131126101242.GH959@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
 <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
 <5292EE2F.5090305@linux.vnet.ibm.com>
 <20131125181254.GB21858@amt.cnet>
 <529413C1.60302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <529413C1.60302@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:21:37AM +0800, Xiao Guangrong wrote:
> On 11/26/2013 02:12 AM, Marcelo Tosatti wrote:
> > On Mon, Nov 25, 2013 at 02:29:03PM +0800, Xiao Guangrong wrote:
> >>>> Also, there is no guarantee of termination (as long as sptes are
> >>>> deleted with the correct timing). BTW, can't see any guarantee of
> >>>> termination for rculist nulls either (a writer can race with a lockless
> >>>> reader indefinately, restarting the lockless walk every time).
> >>>
> >>> Hmm, that can be avoided by checking dirty-bitmap before rewalk,
> >>> that means, if the dirty-bitmap has been set during lockless write-protection,
> >>> it�s unnecessary to write-protect its sptes. Your idea?
> >> This idea is based on the fact that the number of rmap is limited by
> >> RMAP_RECYCLE_THRESHOLD. So, in the case of adding new spte into rmap,
> >> we can break the rewalk at once, in the case of deleting, we can only
> >> rewalk RMAP_RECYCLE_THRESHOLD times.
> > 
> > Please explain in more detail.
> 
> Okay.
> 
> My proposal is like this:
> 
> pte_list_walk_lockless()
> {
> restart:
> 
> +	if (__test_bit(slot->arch.dirty_bitmap, gfn-index))
> +		return;
> 
> 	code-doing-lockless-walking;
> 	......
> }
> 
> Before do lockless-walking, we check the dirty-bitmap first, if
> it is set we can simply skip write-protection for the gfn, that
> is the case that new spte is being added into rmap when we lockless
> access the rmap.
> 
> For the case of deleting spte from rmap, the number of entry is limited
> by RMAP_RECYCLE_THRESHOLD, that is not endlessly.
The point is that rmap entry that you are inspecting can be constantly
deleted and added to the beginning of some other list, so the code that
traverse the list will never reach the end.

--
			Gleb.
