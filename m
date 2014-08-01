Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaHAPPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:15:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:53203 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHAPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:15:31 -0400
Date: Fri, 1 Aug 2014 16:15:27 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Nikolay Aleksandrov <nikolay@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
Message-ID: <20140801151527.GF7331@casper.infradead.org>
References: <cover.1406891028.git.tgraf@suug.ch>
 <72a64dfee4f20f2ca596df26f3e4ae543cf4c068.1406891028.git.tgraf@suug.ch>
 <53DBA976.8030103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DBA976.8030103@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 at 04:51pm, Nikolay Aleksandrov wrote:
> Hmm, in both the rhashtable_insert() and rhashtable_remove() calls in the
> netlink code you're using GFP_ATOMIC flags but if rhashtable_expand/shring gets
> called even though the allocation will be with GFP_ATOMIC, they still call
> synchronize_rcu() which may block. Now I'm not familiar with the netlink code,
> but I think that in general the flags are useless for GFP_ATOMIC because of the
> calls to synchronize_rcu() in expand/shrink which can block anyway.
> Just a thought, I may be missing something of course.

I don't think you are missing anything. The GFP_ATOMIC flag was
inherited from how the bucket table was allocated prior to the
convertion to the new hash table but you are right, it can't be
needed since the table protection was converted to a mutex.
Using GFP_KERNEL will have a better chance of succeeding.
