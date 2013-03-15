Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3COP0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:26:46 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:38699 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab3COP0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:26:44 -0400
Message-ID: <51433D98.4050605@linux.vnet.ibm.com>
Date: Fri, 15 Mar 2013 23:26:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 0/5] KVM: MMU: fast invalid all mmio sptes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031515-2000-0000-0000-00000B577976
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current way is holding hot mmu-lock and walking all shadow pages, this
is not scale. This patchset tries to introduce a very simple and scale way
to fast invalid all mmio sptes - it need not walk any shadow pages and hold
any locks.

The idea is simple:
KVM maintains a global mmio invalid generation-number which is stored in
kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
generation-number into his available bits when it is created.

When KVM need zap all mmio sptes, it just simply increase the global
generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
then it walks the shadow page table and get the mmio spte. If the
generation-number on the spte does not equal the global generation-number,
it will go to the normal #PF handler to update the mmio spte.

Since 19 bits are used to store generation-number on mmio spte, the
generation-number can be round after 33554432 times. It is large enough
for nearly all most cases, but making the code be more strong, we zap all
shadow pages when the number is round.

Note: after my patchset that fast zap all shadow pages, kvm_mmu_zap_all is
not a problem any more. The scalability is the same as zap mmio shadow page


