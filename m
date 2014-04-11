Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaDKWxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:53:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:5430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbaDKWxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,844,1389772800"; 
   d="scan'208";a="491599283"
Message-ID: <5348727E.3040308@intel.com>
Date: Fri, 11 Apr 2014 15:53:50 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, drepper@gmail.com,
        anatol.pomozov@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org,
        xemul@parallels.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] drivers/base/node.c: export physical address range of
 given node (Re: NUMA node information for pages)
References: <87eh1ix7g0.fsf@x240.local.i-did-not-set--mail-host-address--so-tickle-me> <533a1563.ad318c0a.6a93.182bSMTPIN_ADDED_BROKEN@mx.google.com> <CAOPLpQc8R2SfTB+=BsMa09tcQ-iBNJHg+tGnPK-9EDH1M47MJw@mail.gmail.com> <5343806c.100cc30a.0461.ffffc401SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.02.1404091734060.1857@chino.kir.corp.google.com> <5345fe27.82dab40a.0831.0af9SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.02.1404101500280.11995@chino.kir.corp.google.com> <53474709.e59ec20a.3bd5.3b91SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.02.1404110325210.30610@chino.kir.corp.google.com> <53481724.8020304@intel.com> <alpine.DEB.2.02.1404111513040.17724@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1404111513040.17724@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 03:13 PM, David Rientjes wrote:
> What additional information, in your opinion, can we export to assist 
> userspace in making this determination that $address is on $nid?

In the case of overlapping nodes, the only place we actually have *all*
of the information is in the 'struct page' itself.  Ulrich's original
patch obviously _works_, and especially if it's an interface only for
debugging purposes, it seems silly to spend virtually any time
optimizing it.  Keeping it close to pagemap's implementation lessens the
likelihood that we'll screw things up.

I assume that the original problem was trying to figure out what NUMA
affinity a given range of pages mapped in to a _process_ have, and that
/proc/$pid/numamaps is too coarse.  Is that right, Ulrich?

If you want to go the route of calculating and exporting the physical
ranges that nodes uniquely own, you've *GOT* to handle the overlaps.
Naoya had the right idea.  His idea seemed to get shot down with the
misunderstanding that node pfn ranges never overlap.

The only other question is how many of these kpage* things we're going
to put in here until we've exported the entire contents of 'struct page'
5 times over. :)

We could add some tracepoints to the pagemap to dump lots of information
in to a trace buffer that could be later read back.  If you want
detailed information  (NUMA for instance), you turn the tracepoints and
read pagemap for the range you care about.
