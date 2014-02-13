Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaBMXsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 18:48:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51553 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaBMXsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 18:48:15 -0500
Date: Thu, 13 Feb 2014 18:48:12 -0500 (EST)
Message-Id: <20140213.184812.213639748986818676.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, qinchuanyu@huawei.com, kvm@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Subject: Re: [PATCH net v2] vhost: fix ref cnt checking deadlock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392284448-1977-1-git-send-email-mst@redhat.com>
References: <1392284448-1977-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 15:48:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 13 Feb 2014 11:42:05 +0200

> vhost checked the counter within the refcnt before decrementing.  It
> really wanted to know that it is the one that has the last reference, as
> a way to batch freeing resources a bit more efficiently.
> 
> Note: we only let refcount go to 0 on device release.
> 
> This works well but we now access the ref counter twice so there's a
> race: all users might see a high count and decide to defer freeing
> resources.
> In the end no one initiates freeing resources until the last reference
> is gone (which is on VM shotdown so might happen after a looooong time).
> 
> Let's do what we probably should have done straight away:
> switch from kref to plain atomic, documenting the
> semantics, return the refcount value atomically after decrement,
> then use that to avoid the deadlock.
> 
> Reported-by: Qin Chuanyu <qinchuanyu@huawei.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> This patch is needed for 3.14 and -stable.

Applied and queued up for -stable.
