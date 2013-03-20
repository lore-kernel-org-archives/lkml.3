Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177Ab3CTIam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:30:42 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42741 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3CTIak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:30:40 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 0/7] KVM: MMU: fast zap all shadow pages
Date: Wed, 20 Mar 2013 16:30:20 +0800
Message-Id: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-4790-0000-0000-000007785C73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changlog:
V2:
  - do not reset n_requested_mmu_pages and n_max_mmu_pages
  - batch free root shadow pages to reduce vcpu notification and mmu-lock
    contention
  - remove the first patch that introduce kvm->arch.mmu_cache since we only
    'memset zero' on hashtable rather than all mmu cache members in this
    version
  - remove unnecessary kvm_reload_remote_mmus after kvm_mmu_zap_all

* Issue
The current kvm_mmu_zap_all is really slow - it is holding mmu-lock to
walk and zap all shadow pages one by one, also it need to zap all guest
page's rmap and all shadow page's parent spte list. Particularly, things
become worse if guest uses more memory or vcpus. It is not good for
scalability.

* Idea
Since all shadow page will be zapped, we can directly zap the mmu-cache
and rmap so that vcpu will fault on the new mmu-cache, after that, we can
directly free the memory used by old mmu-cache.

The root shadow page is little especial since they are currently used by
vcpus, we can not directly free them. So, we zap the root shadow pages and
re-add them into the new mmu-cache.

* TODO
(1): free root shadow pages by using generation-number
(2): drop unnecessary @npages from kvm_arch_create_memslot

* Performance
The testcase can be found at:
http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=54896;list=linux
is used to measure the time of delete / add memslot. At that time, all vcpus
are waiting, that means, no mmu-lock contention. I believe the result be more
beautiful if other vcpus and mmu notification need to hold the mmu-lock.

Guest VCPU:6, Mem:2048M

before: Run 10 times, Avg time:46078825 ns.

after: Run 10 times, Avg time:21558774 ns. (+ 113%)

Xiao Guangrong (7):
  KVM: MMU: introduce mmu_cache->pte_list_descs
  KVM: x86: introduce memslot_set_lpage_disallowed
  KVM: x86: introduce kvm_clear_all_gfn_page_info
  KVM: MMU: delete shadow page from hash list in
    kvm_mmu_prepare_zap_page
  KVM: MMU: split kvm_mmu_prepare_zap_page
  KVM: MMU: fast zap all shadow pages
  KVM: MMU: drop unnecessary kvm_reload_remote_mmus after
    kvm_mmu_zap_all

 arch/x86/include/asm/kvm_host.h |    7 ++-
 arch/x86/kvm/mmu.c              |  105 ++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu.h              |    1 +
 arch/x86/kvm/x86.c              |   87 +++++++++++++++++++++++++-------
 include/linux/kvm_host.h        |    1 +
 5 files changed, 166 insertions(+), 35 deletions(-)

-- 
1.7.7.6

