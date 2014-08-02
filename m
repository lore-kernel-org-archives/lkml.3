Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaHBKpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 06:45:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaHBKpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 06:45:03 -0400
Message-ID: <53DCC0FE.5010502@redhat.com>
Date: Sat, 02 Aug 2014 12:44:14 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
References: <cover.1406971567.git.tgraf@suug.ch> <a0370889bd1b1bdf097f74df7017d39ae845c12e.1406971567.git.tgraf@suug.ch>
In-Reply-To: <a0370889bd1b1bdf097f74df7017d39ae845c12e.1406971567.git.tgraf@suug.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 11:47 AM, Thomas Graf wrote:
> Heavy Netlink users such as Open vSwitch spend a considerable amount of
> time in netlink_lookup() due to the read-lock on nl_table_lock. Use of
> RCU relieves the lock contention.
> 
> Makes use of the new resizable hash table to avoid locking on the
> lookup.
> 
> The hash table will grow if entries exceeds 75% of table size up to a
> total table size of 64K. It will automatically shrink if usage falls
> below 30%.
> 
> Also splits nl_table_lock into a separate mutex to protect hash table
> mutations and allow synchronize_rcu() to sleep while waiting for readers
> during expansion and shrinking.
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
>  net/netlink/af_netlink.c | 285 ++++++++++++++++++-----------------------------
>  net/netlink/af_netlink.h |  18 +--
>  net/netlink/diag.c       |  11 +-
>  3 files changed, 119 insertions(+), 195 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@redhat.com>


