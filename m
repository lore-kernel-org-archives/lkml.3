Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab3AONex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:34:53 -0500
Received: from smtp-fw-31001.amazon.com ([207.171.178.25]:6905 "EHLO
	smtp-fw-31001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab3AONet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:34:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,474,1355097600"; 
   d="scan'208";a="375307900"
Date: Tue, 15 Jan 2013 14:24:32 +0100
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <stable@vger.kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        Annie Li <annie.li@oracle.com>, <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xen/grant-table: correctly initialize grant table
 version 1
Message-ID: <20130115132431.GB2592@u109add4315675089e695.ant.amazon.com>
References: <20130114153157.GF1156@phenom.dumpdata.com>
 <1358256087-27959-1-git-send-email-msw@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1358256087-27959-1-git-send-email-msw@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 01:21:27PM +0000, Matt Wilson wrote:
> Commit 85ff6acb075a484780b3d763fdf41596d8fc0970 (xen/granttable: Grant
> tables V2 implementation) changed the GREFS_PER_GRANT_FRAME macro from
> a constant to a conditional expression. The expression depends on
> grant_table_version being appropriately set. Unfortunately, at init
> time grant_table_version will be 0. The GREFS_PER_GRANT_FRAME
> conditional expression checks for "grant_table_version == 1", and
> therefore returns the number of grant references per frame for v2.
> 
> This causes gnttab_init() to allocate fewer pages for gnttab_list, as
> a frame can old half the number of v2 entries than v1 entries. After
> gnttab_resume() is called, grant_table_version is appropriately
> set. nr_init_grefs will then be miscalculated and gnttab_free_count
> will hold a value larger than the actual number of free gref entries.
> 
> If a guest is heavily utilizing improperly initialized v1 grant
> tables, memory corruption can occur. One common manifestation is
> corruption of the vmalloc list, resulting in a poisoned pointer
> derefrence when accessing /proc/meminfo or /proc/vmallocinfo:
> 
> [   40.770064] BUG: unable to handle kernel paging request at 0000200200001407
> [   40.770083] IP: [<ffffffff811a6fb0>] get_vmalloc_info+0x70/0x110
> [   40.770102] PGD 0
> [   40.770107] Oops: 0000 [#1] SMP
> [   40.770114] CPU 10
> 
> This patch introduces a static variable, grefs_per_grant_frame, to
> cache the calculated value. gnttab_init() now calls
> gnttab_request_version() early so that grant_table_version and
> grefs_per_grant_frame can be appropriately set. A few BUG_ON()s have
> been added to prevent this type of bug from reoccurring in the future.
> 
> Signed-off-by: Matt Wilson <msw@amazon.com>
> Reviewed-and-Tested-by: Steven Noonan <snoonan@amazon.com>
> Signed-off-by: Ian Campbell <Ian.Campbell@citrix.com>

Correction, that should have been "Acked-by: Ian Campbell
<Ian.Campbell@citrix.com>". My apologies.

Matt

> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Annie Li <annie.li@oracle.com>
> Cc: xen-devel@lists.xen.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # v3.3 and newer
