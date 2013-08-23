Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3HWIz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:55:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab3HWIz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:55:56 -0400
Message-ID: <52172395.9000400@redhat.com>
Date: Fri, 23 Aug 2013 16:55:49 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] vhost_net: remove the max pending check
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com> <1376630190-5912-7-git-send-email-jasowang@redhat.com> <20130816100225.GD21821@redhat.com> <5212D8F2.10307@redhat.com>
In-Reply-To: <5212D8F2.10307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:48 AM, Jason Wang wrote:
> On 08/16/2013 06:02 PM, Michael S. Tsirkin wrote:
>> > On Fri, Aug 16, 2013 at 01:16:30PM +0800, Jason Wang wrote:
>>> >> We used to limit the max pending DMAs to prevent guest from pinning too many
>>> >> pages. But this could be removed since:
>>> >>
>>> >> - We have the sk_wmem_alloc check in both tun/macvtap to do the same work
>>> >> - This max pending check were almost useless since it was one done when there's
>>> >>   no new buffers coming from guest. Guest can easily exceeds the limitation.
>>> >> - We've already check upend_idx != done_idx and switch to non zerocopy then. So
>>> >>   even if all vq->heads were used, we can still does the packet transmission.
>> > We can but performance will suffer.
> The check were in fact only done when no new buffers submitted from
> guest. So if guest keep sending, the check won't be done.
>
> If we really want to do this, we should do it unconditionally. Anyway, I
> will do test to see the result.

There's a bug in PATCH 5/6, the check:

nvq->upend_idx != nvq->done_idx

makes the zerocopy always been disabled since we initialize both
upend_idx and done_idx to zero. So I change it to:

(nvq->upend_idx + 1) % UIO_MAXIOV != nvq->done_idx.

With this change on top, I didn't see performance difference w/ and w/o
this patch.
