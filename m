Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaHEC6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:58:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48387 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaHEC6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:58:44 -0400
Date: Mon, 04 Aug 2014 19:58:41 -0700 (PDT)
Message-Id: <20140804.195841.536725238366145203.davem@davemloft.net>
To: sasha.levin@oracle.com
Cc: tgraf@suug.ch, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org, nikolay@redhat.com
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
From: David Miller <davem@davemloft.net>
In-Reply-To: <53E03D0B.3000208@oracle.com>
References: <cover.1406971567.git.tgraf@suug.ch>
	<a0370889bd1b1bdf097f74df7017d39ae845c12e.1406971567.git.tgraf@suug.ch>
	<53E03D0B.3000208@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Aug 2014 19:58:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>
Date: Mon, 04 Aug 2014 22:10:19 -0400

> On 08/02/2014 05:47 AM, Thomas Graf wrote:
>>  static void *netlink_seq_start(struct seq_file *seq, loff_t *pos)
>> -	__acquires(nl_table_lock)
>>  {
>> -	read_lock(&nl_table_lock);
>> +	rcu_read_lock();
>>  	return *pos ? netlink_seq_socket_idx(seq, *pos - 1) : SEQ_START_TOKEN;
>>  }
> 
> I'm not sure how you expect this code to work. You're replacing a local lock
> with a RCU critical section. Imagine you're doing spin_lock() and just going
> back to userspace.
> 
> It's quite easy to trigger this issue:

I think he expected the end of the seq sequence to drop the RCU lock,
via netlink_seq_stop().
