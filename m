Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654AbaDHTxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:53:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52294 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbaDHTxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:53:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1404080914280.8782@nuc>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
	<5343A494.9070707@suse.cz>
	<alpine.DEB.2.10.1404080914280.8782@nuc>
Date: Tue, 8 Apr 2014 15:53:02 -0400
Message-ID: <CA+TgmoY=vUdtdnJUEK1h-UcaNoqqLUctt44S8vj2B7EVUXUOyA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
From: Robert Haas <robertmhaas@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, sivanich@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 10:17 AM, Christoph Lameter <cl@linux.com> wrote:
> Another solution here would be to increase the threshhold so that
> 4 socket machines do not enable zone reclaim by default. The larger the
> NUMA system is the more memory is off node from the perspective of a
> processor and the larger the hit from remote memory.

Well, as Josh quite rightly said, the hit from accessing remote memory
is never going to be as large as the hit from disk.  If and when there
is a machine where remote memory is more expensive to access than
disk, that's a good argument for zone_reclaim_mode.  But I don't
believe that's anywhere close to being true today, even on an 8-socket
machine with an SSD.

Now, perhaps the fear is that if we access that remote memory
*repeatedly* the aggregate cost will exceed what it would have cost to
fault that page into the local node just once.  But it takes a lot of
accesses for that to be true, and most of the time you won't get them.
 Even if you do, I bet many workloads will prefer even performance
across all the accesses over a very slow first access followed by
slightly faster subsequent accesses.

In an ideal world, the kernel would put the hottest pages on the local
node and the less-hot pages on remote nodes, moving pages around as
the workload shifts.  In practice, that's probably pretty hard.
Fortunately, it's not nearly as important as making sure we don't
unnecessarily hit the disk, which is infinitely slower than any memory
bank.

-- 
Robert Haas
EnterpriseDB: http://www.enterprisedb.com
The Enterprise PostgreSQL Company
