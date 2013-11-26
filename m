Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3KZDVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:21:49 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46190 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3KZDVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:21:47 -0500
Message-ID: <529413C1.60302@linux.vnet.ibm.com>
Date: Tue, 26 Nov 2013 11:21:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, avi.kivity@gmail.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131122191429.GA13308@amt.cnet> <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com> <5292EE2F.5090305@linux.vnet.ibm.com> <20131125181254.GB21858@amt.cnet>
In-Reply-To: <20131125181254.GB21858@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112603-9264-0000-0000-0000050079E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 02:12 AM, Marcelo Tosatti wrote:
> On Mon, Nov 25, 2013 at 02:29:03PM +0800, Xiao Guangrong wrote:
>>>> Also, there is no guarantee of termination (as long as sptes are
>>>> deleted with the correct timing). BTW, can't see any guarantee of
>>>> termination for rculist nulls either (a writer can race with a lockless
>>>> reader indefinately, restarting the lockless walk every time).
>>>
>>> Hmm, that can be avoided by checking dirty-bitmap before rewalk,
>>> that means, if the dirty-bitmap has been set during lockless write-protection,
>>> it�s unnecessary to write-protect its sptes. Your idea?
>> This idea is based on the fact that the number of rmap is limited by
>> RMAP_RECYCLE_THRESHOLD. So, in the case of adding new spte into rmap,
>> we can break the rewalk at once, in the case of deleting, we can only
>> rewalk RMAP_RECYCLE_THRESHOLD times.
> 
> Please explain in more detail.

Okay.

My proposal is like this:

pte_list_walk_lockless()
{
restart:

+	if (__test_bit(slot->arch.dirty_bitmap, gfn-index))
+		return;

	code-doing-lockless-walking;
	......
}

Before do lockless-walking, we check the dirty-bitmap first, if
it is set we can simply skip write-protection for the gfn, that
is the case that new spte is being added into rmap when we lockless
access the rmap.

For the case of deleting spte from rmap, the number of entry is limited
by RMAP_RECYCLE_THRESHOLD, that is not endlessly.

