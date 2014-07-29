Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaG2Paa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:30:30 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:49297 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaG2Pa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:30:27 -0400
X-Originating-IP: 50.43.15.134
Date: Tue, 29 Jul 2014 08:30:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Thomas Graf <tgraf@suug.ch>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaber@trash.net, paulmck@linux.vnet.ibm.com, challa@noironetworks.com,
        walpole@cs.pdx.edu, dev@openvswitch.org
Subject: Re: [PATCH 1/2] lib: Resizable, Scalable, Concurrent Hash Table
Message-ID: <20140729153016.GC1437@jtriplet-mobl1>
References: <cover.1406633945.git.tgraf@suug.ch>
 <1cd2f98b8362052eff24d481b7c9622eb770d091.1406633945.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cd2f98b8362052eff24d481b7c9622eb770d091.1406633945.git.tgraf@suug.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 01:41:32PM +0200, Thomas Graf wrote:
> Generic implementation of a resizable, scalable, concurrent hash table
> based on [0]. The implementation supports both, fixed size keys specified
> via an offset and length, or arbitrary keys via own hash and compare
> functions.
> 
> Lookups are lockless and protected as RCU read side critical sections.
> Automatic growing/shrinking based on user configurable watermarks is
> available while allowing concurrent lookups to take place.
> 
> Objects to be hashed must include a struct rhash_head. The reason for not
> using the existing struct hlist_head is that the expansion and shrinking
> will have two buckets point to a single entry which would lead in obscure
> reverse chaining behaviour.
> 
> Code includes a boot selftest if CONFIG_TEST_RHASHTABLE is defined.
> 
> [0] https://www.usenix.org/legacy/event/atc11/tech/final_files/Triplett.pdf
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>

Thanks for working on this!

Currently reading the algorithm implementation in more detail.  A couple
of minor issues below.

> --- /dev/null
> +++ b/include/linux/rhashtable.h
[...]
> +struct rhash_head {
> +	struct rhash_head		*next;
> +};

Arguably this could become a new singly-linked list type in list.h;
we don't currently have one.

> +/**
> + * rht_for_each_entry_safe - safely iterate over hash chain of given type
> + * @pos:	type * to use as a loop cursor.
> + * @n:		type * to use for temporary next object storage
> + * @head:	head of the hash chain (struct rhash_head *)
> + * @ht:		pointer to your struct rhashtable
> + * @member:	name of the rhash_head within the hashable struct.
> + *
> + * This hash chain list-traversal primitive allows for the looped code to
> + * remove the loop cursor from the list.
> + */
> +#define rht_for_each_entry_safe(pos, n, head, ht, member)		\
> +	for (pos = rht_entry_safe(rht_dereference(head, ht), \
> +				   typeof(*(pos)), member), \
> +	     n = rht_entry_safe(rht_dereference((pos)->member.next, ht), \
> +				 typeof(*(pos)), member); \
> +	     pos; \
> +	     pos = n, \
> +	     n = rht_entry_safe(rht_dereference((pos)->member.next, ht), \
> +				 typeof(*(pos)), member))

Given that removal requires special care, is this something actually
needed in the public interface, or only internally?  You don't
necessarily need to define a full set of list primitives.  (Unless of
course you make this a new list type in list.h.)

> --- /dev/null
> +++ b/lib/rhashtable.c
[...]
> +#define ASSERT_RHT_MUTEX(HT) BUG_ON(unlikely(!lockdep_rht_mutex_is_held(HT)))

BUG_ON and WARN_ON already include unlikely(); you don't need to add it
yourself.

> +/**
> + * rht_obj - cast hash head to outer object
> + * @ht:		hash table
> + * @he:		hashed node
> + */
> +void *rht_obj(const struct rhashtable *ht, const struct rhash_head *he)
> +{
> +	return (void *) he - ht->p.head_offset;
> +}
> +EXPORT_SYMBOL_GPL(rht_obj);

Should this be a static inline?  And, will the runtime indirection
involved in head_offset add unnecessary overhead for tables of a known
type?  (I'd expect a head_offset of 0 in common cases.)

- Josh Triplett
