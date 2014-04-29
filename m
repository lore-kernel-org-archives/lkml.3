Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaD2Hzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:55:48 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37534 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaD2Hzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:55:46 -0400
Message-ID: <535F5AFE.2050008@de.ibm.com>
Date: Tue, 29 Apr 2014 09:55:42 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] kvm/irqchip: Speed up KVM_SET_GSI_ROUTING
References: <1398703176-17812-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1398703176-17812-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042907-0342-0000-0000-00000898CFF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/14 18:39, Paolo Bonzini wrote:
> From: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> When starting lots of dataplane devices the bootup takes very long on
> Christian's s390 with irqfd patches. With larger setups he is even
> able to trigger some timeouts in some components.  Turns out that the
> KVM_SET_GSI_ROUTING ioctl takes very long (strace claims up to 0.1 sec)
> when having multiple CPUs.  This is caused by the  synchronize_rcu and
> the HZ=100 of s390.  By changing the code to use a private srcu we can
> speed things up.  This patch reduces the boot time till mounting root
> from 8 to 2 seconds on my s390 guest with 100 disks.
> 
> Uses of hlist_for_each_entry_rcu, hlist_add_head_rcu, hlist_del_init_rcu
> are fine because they do not have lockdep checks (hlist_for_each_entry_rcu
> uses rcu_dereference_raw rather than rcu_dereference, and write-sides
> do not do rcu lockdep at all).
> 
> Note that we're hardly relying on the "sleepable" part of srcu.  We just
> want SRCU's faster detection of grace periods.
> 
> Testing was done by Andrew Theurer using NETPERF.  The difference between
> results "before" and "after" the patch has mean -0.2% and standard deviation
> 0.6%.  Using a paired t-test on the data points says that there is a 2.5%
> probability that the patch is the cause of the performance difference
> (rather than a random fluctuation).
> 
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks for moving that patch forward to the latest kernel version 
(plus your fixes)

I can confirm that it still fixes the performance issue on s390.

