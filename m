Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaCNTub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:50:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbaCNTua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:50:30 -0400
Date: Fri, 14 Mar 2014 20:50:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Or Gerlitz <ogerlitz@mellanox.com>
cc: Roland Dreier <roland@kernel.org>, Sagi Grimberg <sagig@mellanox.com>,
        Amir Vadai <amirv@mellanox.com>, Eli Cohen <eli@dev.mellanox.co.il>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, Mel Gorman <mgorman@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Shlomo Pongratz <shlomop@mellanox.com>
Subject: Re: [PATCH] mlx4: Use GFP_NOFS calls during the ipoib TX path when
 creating the QP
In-Reply-To: <531F1550.3080401@mellanox.com>
Message-ID: <alpine.LNX.2.00.1403142045240.3690@pobox.suse.cz>
References: <CAJZOPZKLcFC5Wqv7VS7AyovaeHw3PYSWEz9t9sZ4AMhG+dS1+A@mail.gmail.com> <alpine.LNX.2.00.1402271042240.21399@pobox.suse.cz> <530F0C4F.9030200@mellanox.com> <alpine.LNX.2.00.1402271123410.21399@pobox.suse.cz> <CAG4TOxMw4siOqtjXrgUDaw8yWqYgSG4d8PqGuJ62AZBrC2O2AA@mail.gmail.com>
 <531F1550.3080401@mellanox.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014, Or Gerlitz wrote:

> > It does seem that only using GFP_NOIO when we really need to would be
> > a very difficult problem--how can we carry information about whether a
> > particular packet is involved in freeing memory through all the layers
> > of, say, NFS, TCP, IPSEC, bonding, &c?
> 
> Agree with all the above... next,
> 
> If we don't have away to nicely overcome the layer violations here, 
> let's change IPoIB so they always ask the IB driver to allocate QPs used 
> for Connected Mode in a GFP_NOIO manner, to be practical I suggest the 
> following:
> 
> 1. Add new QP creation flag IB_QP_CREATE_USE_GFP to the existing 
> creation flags of struct ib_qp_init_attr and a new "gfp_t gfp" field to 
> that structure too
> 
> 2. in the IPoIB CM code, do the vzalloc allocation for new connection in 
> GFP_NOIO manner and issue the call to create QP with setting the 
> IB_QP_CREATE_USE_GFP flag and GFO_NOIO to the gfp field
> 
> 3. If the QP creation fails, with -EINVAL, issue a warning and retry the 
> QP creation attempt without the GFP setting
> 
> 4. implement in the mlx4 driver the support for GFP directives on QP 
> creation

1-4 make perfect sense to me.

> 5. for the rest of the IB drivers, return -EINVAL if 
> IB_QP_CREATE_USE_GFP is set

Umm, why this?

> This will allow to provide working solution for mlx4 users and gradually 
> add support for the rest of the IB drivers.

Oh, I see, so that's just a temporary measure.

> as for proper patch planning
> 
> patch #1 / items 1 and 5
> patch #2 / item 4
> patch #3 / item 3
> 
> Re item 5 -- I made a check and the ehca, ipath and mthca driver already
> return -EINVAL if provided with any creation flag, so you only need to patch
> the qib driver in qib_create_qp() to do that as well which is trivial.
> 
> As for the rest of the code, you practically have it all by now, just need to
> port the mlx4 changes you did to the suggested framework, remove the module
> param (which you don't like either) and add the new gfp_t field to
> ib_qp_init_attr
> 
> So sounds like a plan that makes sense?

Sounds fine by me.

Thanks,

-- 
Jiri Kosina
SUSE Labs
