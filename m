Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3KSODr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:03:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54020 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab3KSODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:03:43 -0500
Message-ID: <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Date: Tue, 19 Nov 2013 06:03:48 -0800
In-Reply-To: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 16:05 +0800, Jason Wang wrote:
> We need to drop the refcnt of page when we fail to allocate an skb for frag
> list, otherwise it will be leaked. The bug was introduced by commit
> 2613af0ed18a11d5c566a81f9a6510b73180660a ("virtio_net: migrate mergeable rx
> buffers to page frag allocators").
> 
> Cc: Michael Dalton <mwdalton@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch was needed for 3.12 stable.

Good catch, but if we return from receive_mergeable() in the 'middle'
of the frags we would need for the current skb, who will
call the virtqueue_get_buf() to flush the remaining frags ?

Don't we also need to call virtqueue_get_buf() like 

while (--num_buf) {
    buf = virtqueue_get_buf(rq->vq, &len);
    if (!buf)
        break;
    put_page(virt_to_head_page(buf));
}

?




