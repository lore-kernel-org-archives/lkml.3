Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaENLkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:40:22 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59296 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaENLkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:40:20 -0400
Message-ID: <1400067618.7973.72.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Multitude of dst obsolescense race conditions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: dormando <dormando@rydia.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 14 May 2014 04:40:18 -0700
In-Reply-To: <alpine.DEB.2.02.1405140233210.16893@dtop>
References: <alpine.DEB.2.02.1405140233210.16893@dtop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 02:57 -0700, dormando wrote:
> Hi,
> 
> Given a machine with frequently changing routes (ie; a router with an
> active internet BGP table and multiple interfaces), there're at least
> several places where obsolete dst's are handled improperly. If I pause the
> route changes, the crashes appear to stop. This first one has a crash
> utility we've made, so I was able to more quickly find a patch and test
> it. The others take time to reproduce.
> 
> I'm testing against 3.10.39, but I think if these were fixed they'd be
> backported to stable? I've also had recent 3.12's running that have
> crashed in the same spots. Anyway correct me if I'm wrong...

Is this a vanilla kernel ? I never had any issues like that.

I wonder if you have some RCU issues.

static inline struct dst_entry *
sk_dst_get(struct sock *sk)
{
        struct dst_entry *dst;

        rcu_read_lock();
        dst = rcu_dereference(sk->sk_dst_cache);
        if (dst)
                dst_hold(dst);
        rcu_read_unlock();
        return dst;
}

static inline void
__sk_dst_set(struct sock *sk, struct dst_entry *dst)
{
        struct dst_entry *old_dst;

        sk_tx_queue_clear(sk);
        /*
         * This can be called while sk is owned by the caller only,
         * with no state that can be checked in a rcu_dereference_check() cond
         */
        old_dst = rcu_dereference_raw(sk->sk_dst_cache);
        rcu_assign_pointer(sk->sk_dst_cache, dst);
        dst_release(old_dst);
}

static inline void
sk_dst_set(struct sock *sk, struct dst_entry *dst)
{
        spin_lock(&sk->sk_dst_lock);
        __sk_dst_set(sk, dst);
        spin_unlock(&sk->sk_dst_lock);
}



