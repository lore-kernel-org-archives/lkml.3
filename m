Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab3BHEM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:12:26 -0500
Received: from ozlabs.org ([203.10.76.45]:57040 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab3BHEMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:12:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Jens Axboe" <axboe@kernel.dk>
Subject: Re: [RFC PATCH 0/8] virtio: new API for addition of buffers, scatterlist changes
In-Reply-To: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
References: <1360239752-2470-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 08 Feb 2013 14:35:55 +1030
Message-ID: <8738x7ih5o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> The virtqueue_add_buf function has two limitations:
>
> 1) it requires the caller to provide all the buffers in a single call;
>
> 2) it does not support chained scatterlists: the buffers must be
> provided as an array of struct scatterlist.
>
> Because of these limitations, virtio-scsi has to copy each request into
> a scatterlist internal to the driver.  It cannot just use the one that
> was prepared by the upper SCSI layers.

Hi Paulo,

        Note that you've defined your problem in terms of your solution
here.  For clarity:

The problem: we want to prepend and append to a scatterlist.  We can't
        append, because the chained scatterlist implementation requires
        an element to be appended to join two scatterlists together.

The solution: fix scatterlists by introducing struct sg_ring:
        struct sg_ring {
                struct list_head ring;
        	unsigned int nents;
        	unsigned int orig_nents; /* do we want to replace sg_table? */
                struct scatterlist *sg;
        };

The workaround: make virtio accept multiple scatterlists for a single
        buffer.

There's nothing wrong with your workaround, but if other subsystems have
the same problem we do, perhaps we should consider a broader solution?

Cheers,
Rusty.
