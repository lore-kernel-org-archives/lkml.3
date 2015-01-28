Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbbA2Fg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 00:36:57 -0500
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:37726 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117AbbA2Fgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 00:36:54 -0500
Date: Wed, 28 Jan 2015 09:03:06 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: mmotm 2015-01-22-15-04: qemu failure due to 'mm: memcontrol:
 remove unnecessary soft limit tree node test'
In-Reply-To: <20150127172439.GA8623@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.11.1501280900000.31753@gentwo.org>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org> <20150123050802.GB22751@roeck-us.net> <20150123141817.GA22926@phnom.home.cmpxchg.org> <alpine.DEB.2.11.1501230908560.15325@gentwo.org> <20150127172439.GA8623@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Michal Hocko wrote:

> Admittedly, I was checking only SLAB allocator when reviewing and
> assuming SLUB would behave in the same way :/
> But maybe I have misinterpreted the slab code as well and
> get_node(struct kmem_cache *, int node) returns non-NULL for !online
> nodes.

Oh. Just allocate from node 12345 in SLAB and you will also have a strange
failure.

> I have briefly checked the code and it seems that many users are aware
> of this and use the same construct Johannes used in the end or they use
> cpu_to_node. But then there are other users doing:
> net/openvswitch/flow_table.c:
>         /* Initialize the default stat node. */
>         stats = kmem_cache_alloc_node(flow_stats_cache,
>                                       GFP_KERNEL | __GFP_ZERO, 0);
>
> and this can blow up if Node0 is not online. I haven't checked other

Node 0 is special in many architectures and is guaranteed to exist.
PowerPC is a notable exception which causes frequent issues with NUMA
changes.

> That being said I have no problem with checking node_online in the memcg
> code which was reported to blow up here. I am just thinking whether it
> is safe to simply blow up like that.

Node numbers must be legitimate in order to be used. Same thing with
processor numbers. We cannot always check if they are online. The numbers
in use must be sane. We have notifier subsystems that do callbacks to
allow subsystems to add and remove new nodes and processors. Those should
be used to ensure that only legitimate node and processor numbers are
used.


