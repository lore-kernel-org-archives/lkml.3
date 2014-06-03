Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbaFCN5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:57:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52308 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaFCN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:57:45 -0400
Message-ID: <1401803863.3645.208.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PULL 2/2] vhost: replace rcu with mutex
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Miller <davem@davemloft.net>
Date: Tue, 03 Jun 2014 06:57:43 -0700
In-Reply-To: <538DC422.1050303@redhat.com>
References: <1401744482-17764-1-git-send-email-mst@redhat.com>
		<1401744482-17764-3-git-send-email-mst@redhat.com>
	 <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com>
	 <538DC422.1050303@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-03 at 14:48 +0200, Paolo Bonzini wrote:
> Il 02/06/2014 23:58, Eric Dumazet ha scritto:
> > This looks dubious
> >
> > What about using kfree_rcu() instead ?
> 
> It would lead to unbound allocation from userspace.

Look at how we did this in commit
c3059477fce2d956a0bb3e04357324780c5d8eeb

> 
> > translate_desc() still uses rcu_read_lock(), its not clear if the mutex
> > is really held.
> 
> Yes, vhost_get_vq_desc must be called with the vq mutex held.
> 
> The rcu_read_lock/unlock in translate_desc is unnecessary.

Yep, this is what I pointed out. This is not only necessary, but
confusing and might be incorrectly copy/pasted in the future.

This patch is a partial one and leaves confusion.

Some places uses the proper 

mp = rcu_dereference_protected(dev->memory,
		 lockdep_is_held(&dev->mutex));

others use the now incorrect :

rcu_read_lock();
mp = rcu_dereference(dev->memory);
...



