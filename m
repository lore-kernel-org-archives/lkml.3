Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaHAP1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaHAP1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:27:07 -0400
Message-ID: <53DBB049.30902@redhat.com>
Date: Fri, 01 Aug 2014 17:20:41 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        tklauser@distanz.ch, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
References: <cover.1406891028.git.tgraf@suug.ch> <72a64dfee4f20f2ca596df26f3e4ae543cf4c068.1406891028.git.tgraf@suug.ch> <53DBA976.8030103@redhat.com> <20140801151527.GF7331@casper.infradead.org>
In-Reply-To: <20140801151527.GF7331@casper.infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 05:15 PM, Thomas Graf wrote:
> On 08/01/14 at 04:51pm, Nikolay Aleksandrov wrote:
>> Hmm, in both the rhashtable_insert() and rhashtable_remove() calls in the
>> netlink code you're using GFP_ATOMIC flags but if rhashtable_expand/shring gets
>> called even though the allocation will be with GFP_ATOMIC, they still call
>> synchronize_rcu() which may block. Now I'm not familiar with the netlink code,
>> but I think that in general the flags are useless for GFP_ATOMIC because of the
>> calls to synchronize_rcu() in expand/shrink which can block anyway.
>> Just a thought, I may be missing something of course.
> 
> I don't think you are missing anything. The GFP_ATOMIC flag was
> inherited from how the bucket table was allocated prior to the
> convertion to the new hash table but you are right, it can't be
> needed since the table protection was converted to a mutex.
> Using GFP_KERNEL will have a better chance of succeeding.
> 
Right, I was wondering why it was atomic in the first place and couldn't find a
good reason from the code :-)
But that explains it.

Cheers,
 Nik
