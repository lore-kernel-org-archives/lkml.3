Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaHAO6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:58:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbaHAO6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:58:05 -0400
Message-ID: <53DBA976.8030103@redhat.com>
Date: Fri, 01 Aug 2014 16:51:34 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, tklauser@distanz.ch,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
References: <cover.1406891028.git.tgraf@suug.ch> <72a64dfee4f20f2ca596df26f3e4ae543cf4c068.1406891028.git.tgraf@suug.ch>
In-Reply-To: <72a64dfee4f20f2ca596df26f3e4ae543cf4c068.1406891028.git.tgraf@suug.ch>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 01:58 PM, Thomas Graf wrote:
> Heavy Netlink users such as Open vSwitch spend a considerable amount of
> time in netlink_lookup() due to the read-lock on nl_table_lock. Use of
> RCU relieves the lock contention.
> 
> Makes use of the new resizable hash table to avoid locking on the
> lookup.
> 
> The hash table will grow if entries exceeds 75% of table size up to a
> total table size of 64K. It will automatically shrink if usage falls
> below 50%.
> 
> Also splits nl_table_lock into a separate spinlock to protect hash table
> mutations. This avoids a possible deadlock when the hash table growing
> waits on RCU readers to complete via synchronize_rcu() while readers
> holding RCU read lock are waiting on the nl_table_lock() to be released
> to lock the table for broadcasting.
> 
> Before:
>    9.16%  kpktgend_0  [openvswitch]      [k] masked_flow_lookup
>    6.42%  kpktgend_0  [pktgen]           [k] mod_cur_headers
>    6.26%  kpktgend_0  [pktgen]           [k] pktgen_thread_worker
>    6.23%  kpktgend_0  [kernel.kallsyms]  [k] memset
>    4.79%  kpktgend_0  [kernel.kallsyms]  [k] netlink_lookup
>    4.37%  kpktgend_0  [kernel.kallsyms]  [k] memcpy
>    3.60%  kpktgend_0  [openvswitch]      [k] ovs_flow_extract
>    2.69%  kpktgend_0  [kernel.kallsyms]  [k] jhash2
> 
> After:
>   15.26%  kpktgend_0  [openvswitch]      [k] masked_flow_lookup
>    8.12%  kpktgend_0  [pktgen]           [k] pktgen_thread_worker
>    7.92%  kpktgend_0  [pktgen]           [k] mod_cur_headers
>    5.11%  kpktgend_0  [kernel.kallsyms]  [k] memset
>    4.11%  kpktgend_0  [openvswitch]      [k] ovs_flow_extract
>    4.06%  kpktgend_0  [kernel.kallsyms]  [k] _raw_spin_lock
>    3.90%  kpktgend_0  [kernel.kallsyms]  [k] jhash2
>    [...]
>    0.67%  kpktgend_0  [kernel.kallsyms]  [k] netlink_lookup
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> ---

Hmm, in both the rhashtable_insert() and rhashtable_remove() calls in the
netlink code you're using GFP_ATOMIC flags but if rhashtable_expand/shring gets
called even though the allocation will be with GFP_ATOMIC, they still call
synchronize_rcu() which may block. Now I'm not familiar with the netlink code,
but I think that in general the flags are useless for GFP_ATOMIC because of the
calls to synchronize_rcu() in expand/shrink which can block anyway.
Just a thought, I may be missing something of course.

Nik
