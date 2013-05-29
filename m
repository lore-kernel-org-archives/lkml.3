Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966215Ab3E2NjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935145Ab3E2NjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:39:20 -0400
Date: Wed, 29 May 2013 10:32:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
Message-ID: <20130529133243.GG5931@amt.cnet>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130524203432.GB4525@amt.cnet>
 <51A2C2DC.6080403@linux.vnet.ibm.com>
 <20130528001802.GB1359@amt.cnet>
 <51A4C6F1.9000607@linux.vnet.ibm.com>
 <20130529111132.GA5931@amt.cnet>
 <51A5FDF5.8020003@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A5FDF5.8020003@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 09:09:09PM +0800, Xiao Guangrong wrote:
> This information is I replied Gleb in his mail where he raced a question that
> why "collapse tlb flush is needed":
> 
> ======
> It seems no.
> Since we have reloaded mmu before zapping the obsolete pages, the mmu-lock
> is easily contended. I did the simple track:
> 
> +       int num = 0;
>  restart:
>         list_for_each_entry_safe_reverse(sp, node,
>               &kvm->arch.active_mmu_pages, link) {
> @@ -4265,6 +4265,7 @@ restart:
>                 if (batch >= BATCH_ZAP_PAGES &&
>                       cond_resched_lock(&kvm->mmu_lock)) {
>                         batch = 0;
> +                       num++;
>                         goto restart;
>                 }
> 
> @@ -4277,6 +4278,7 @@ restart:
>          * may use the pages.
>          */
>         kvm_mmu_commit_zap_page(kvm, &invalid_list);
> +       printk("lock-break: %d.\n", num);
>  }
> 
> I do read pci rom when doing kernel building in the guest which
> has 1G memory and 4vcpus with ept enabled, this is the normal
> workload and normal configuration.
> 
> # dmesg
> [ 2338.759099] lock-break: 8.
> [ 2339.732442] lock-break: 5.
> [ 2340.904446] lock-break: 3.
> [ 2342.513514] lock-break: 3.
> [ 2343.452229] lock-break: 3.
> [ 2344.981599] lock-break: 4.
> 
> Basically, we need to break many times.

Should measure kvm_mmu_zap_all latency.

> ======
> 
> You can see we should break 3 times to zap all pages even if we have zapoed
> 10 pages in batch. It is obviously that it need break more times without
> batch-zapping.

Again, breaking should be no problem, what matters is latency. Please
measure kvm_mmu_zap_all latency after all optimizations to justify 
this minimum batching.

