Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab3DGLyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:54:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab3DGLyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:54:10 -0400
Date: Sun, 7 Apr 2013 14:54:07 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix MMIO/PIO collision misdetection
Message-ID: <20130407115407.GS17919@redhat.com>
References: <20130404102720.GA5707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404102720.GA5707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 01:27:21PM +0300, Michael S. Tsirkin wrote:
> PIO and MMIO are separate address spaces, but
> ioeventfd registration code mistakenly detected
> two eventfds as duplicate if they use the same address,
> even if one is PIO and another one MMIO.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Applied, thanks.

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
> -- 
> MST

--
			Gleb.
