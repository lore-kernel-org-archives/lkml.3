Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3DPKhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:37:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36174 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3DPKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:37:11 -0400
Message-ID: <516D275C.8040406@linux.vnet.ibm.com>
Date: Tue, 16 Apr 2013 18:26:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi.kivity@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: mmu_notifier: re-fix freed page still mapped in secondary
 MMU
References: <516CF235.4060103@linux.vnet.ibm.com> <20130416093131.GJ3658@sgi.com>
In-Reply-To: <20130416093131.GJ3658@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041610-1618-0000-0000-000003B34D15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 05:31 PM, Robin Holt wrote:
> On Tue, Apr 16, 2013 at 02:39:49PM +0800, Xiao Guangrong wrote:
>> The commit 751efd8610d3 (mmu_notifier_unregister NULL Pointer deref
>> and multiple ->release()) breaks the fix:
>>     3ad3d901bbcfb15a5e4690e55350db0899095a68
>>     (mm: mmu_notifier: fix freed page still mapped in secondary MMU)
> 
> Can you describe how the page is still mapped?  I thought I had all
> cases covered.  Whichever call hits first, I thought we had one callout
> to the registered notifiers.  Are you saying we need multiple callouts?

No.

You patch did this:

                hlist_del_init_rcu(&mn->hlist);    1 <======
+               spin_unlock(&mm->mmu_notifier_mm->lock);
+
+               /*
+                * Clear sptes. (see 'release' description in mmu_notifier.h)
+                */
+               if (mn->ops->release)
+                       mn->ops->release(mn, mm);    2 <======
+
+               spin_lock(&mm->mmu_notifier_mm->lock);

At point 1, you delete the notify, but the page is still on LRU. Other
cpu can reclaim the page but without call ->invalid_page().

At point 2, you call ->release(), the secondary MMU make page Accessed/Dirty
but that page has already been on the free-list of page-alloctor.

> 
> Also, shouldn't you be asking for a revert commit and then supply a
> subsequent commit for the real fix?  I thought that was the process for
> doing a revert.

Can not do that pure reversion since your patch moved hlist_for_each_entry_rcu
which has been modified now.

Should i do pure-eversion + hlist_for_each_entry_rcu update first?

