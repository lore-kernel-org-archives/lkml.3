Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3HGNJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:09:36 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54061 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab3HGNJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:09:33 -0400
Date: Wed, 7 Aug 2013 22:09:27 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 10/12] KVM: MMU: allow locklessly access shadow page
 table out of vcpu thread
Message-Id: <20130807220927.bc16decbc7171f6fa5be8f84@gmail.com>
In-Reply-To: <1375189330-24066-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
	<1375189330-24066-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 21:02:08 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> @@ -2342,6 +2358,13 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  	 */
>  	kvm_flush_remote_tlbs(kvm);
>  
> +	if (kvm->arch.rcu_free_shadow_page) {
> +		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> +		list_del_init(invalid_list);
> +		call_rcu(&sp->rcu, free_pages_rcu);
> +		return;
> +	}
> +
>  	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
>  		WARN_ON(!sp->role.invalid || sp->root_count);
>  		kvm_mmu_free_page(sp);

Shouldn't we avoid calling call_rcu() when we are holding mmu_lock?

	Takuya
