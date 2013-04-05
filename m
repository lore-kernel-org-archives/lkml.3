Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765219Ab3DEH6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:58:54 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59202 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3DEH6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:58:53 -0400
Message-ID: <515E8435.9090701@redhat.com>
Date: Fri, 05 Apr 2013 09:58:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix MMIO/PIO collision misdetection
References: <20130404102720.GA5707@redhat.com>
In-Reply-To: <20130404102720.GA5707@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/04/2013 12:27, Michael S. Tsirkin ha scritto:
> PIO and MMIO are separate address spaces, but
> ioeventfd registration code mistakenly detected
> two eventfds as duplicate if they use the same address,
> even if one is PIO and another one MMIO.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>  virt/kvm/eventfd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index adb17f2..93e5b05 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -577,6 +577,7 @@ struct _ioeventfd {
>  	struct eventfd_ctx  *eventfd;
>  	u64                  datamatch;
>  	struct kvm_io_device dev;
> +	u8                   bus_idx;
>  	bool                 wildcard;
>  };
>  
> @@ -669,7 +670,8 @@ ioeventfd_check_collision(struct kvm *kvm, struct _ioeventfd *p)
>  	struct _ioeventfd *_p;
>  
>  	list_for_each_entry(_p, &kvm->ioeventfds, list)
> -		if (_p->addr == p->addr && _p->length == p->length &&
> +		if (_p->bus_idx == p->bus_idx &&
> +		    _p->addr == p->addr && _p->length == p->length &&
>  		    (_p->wildcard || p->wildcard ||
>  		     _p->datamatch == p->datamatch))
>  			return true;
> @@ -717,6 +719,7 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  
>  	INIT_LIST_HEAD(&p->list);
>  	p->addr    = args->addr;
> +	p->bus_idx = bus_idx;
>  	p->length  = args->len;
>  	p->eventfd = eventfd;
>  
> @@ -775,7 +778,8 @@ kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  	list_for_each_entry_safe(p, tmp, &kvm->ioeventfds, list) {
>  		bool wildcard = !(args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH);
>  
> -		if (p->eventfd != eventfd  ||
> +		if (p->bus_idx != bus_idx ||
> +		    p->eventfd != eventfd  ||
>  		    p->addr != args->addr  ||
>  		    p->length != args->len ||
>  		    p->wildcard != wildcard)
> 

