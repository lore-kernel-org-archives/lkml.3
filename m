Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaFCNzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:55:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903AbaFCNzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:55:53 -0400
Message-ID: <538DD3E1.8000805@redhat.com>
Date: Tue, 03 Jun 2014 15:55:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vlad Yasevich <vyasevich@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PULL 2/2] vhost: replace rcu with mutex
References: <1401744482-17764-1-git-send-email-mst@redhat.com>	<1401744482-17764-3-git-send-email-mst@redhat.com> <1401746280.3645.187.camel@edumazet-glaptop2.roam.corp.google.com> <538DC422.1050303@redhat.com> <538DCF15.4080904@gmail.com>
In-Reply-To: <538DCF15.4080904@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2014 15:35, Vlad Yasevich ha scritto:
> > Yes, vhost_get_vq_desc must be called with the vq mutex held.
> >
> > The rcu_read_lock/unlock in translate_desc is unnecessary.
>
> If that's true, then does dev->memory really needs to be rcu protected?
> It appears to always be read under mutex.

It's always read under one of many mutexes, yes.

However, it's still RCU-like in the sense that you separate the removal 
and reclamation phases so you still need rcu_dereference/rcu_assign_pointer.

With this mechanism, readers do not contend the mutexes with the 
VHOST_SET_MEMORY ioctl, except for the very short lock-and-unlock 
sequence at the end of it.  They also never contend the mutexes between 
themselves (which would be the case if VHOST_SET_MEMORY locked all the 
mutexes).

You could also wrap all virtqueue processing with a rwsem and take the 
rwsem for write in VHOST_SET_MEMORY.  That simplifies some things however:

- unnecessarily complicates the code for all users of vhost_get_vq_desc

- suppose the reader-writer lock is fair, and VHOST_SET_MEMORY places a 
writer in the queue.  Then a long-running reader R1 could still block 
another reader R2, because the writer would be served before R2.


The RCU-like approach avoids all this, which is important because of the 
generally simpler code and because VHOST_SET_MEMORY is the only vhost 
ioctl that can happen in the hot path.

Paolo
