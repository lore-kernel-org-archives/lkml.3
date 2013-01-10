Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3AJWSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:18:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18263 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3AJWSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:18:17 -0500
MIME-Version: 1.0
Message-ID: <880965bb-90af-4a0f-9971-6bb8eb9ba2b7@default>
Date: Thu, 10 Jan 2013 14:16:58 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCHv2 8/9] zswap: add to mm/
References: <<1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>>
 <<1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: [PATCHv2 8/9] zswap: add to mm/
> 
> zswap is a thin compression backend for frontswap. It receives
> pages from frontswap and attempts to store them in a compressed
> memory pool, resulting in an effective partial memory reclaim and
> dramatically reduced swap device I/O.
> 
> Additional, in most cases, pages can be retrieved from this
> compressed store much more quickly than reading from tradition
> swap devices resulting in faster performance for many workloads.
> 
> This patch adds the zswap driver to mm/
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

I've implemented the equivalent of zswap_flush_*
in zcache.  It looks much better than my earlier
attempt at similar code to move zpages to swap.
Nice work and thanks!

But... (isn't there always a "but";-)...

> +/*
> + * This limits is arbitrary for now until a better
> + * policy can be implemented. This is so we don't
> + * eat all of RAM decompressing pages for writeback.
> + */
> +#define ZSWAP_MAX_OUTSTANDING_FLUSHES 64
> +	if (atomic_read(&zswap_outstanding_flushes) >
> +		ZSWAP_MAX_OUTSTANDING_FLUSHES)
> +		return;

>From what I can see, zcache is in some ways more aggressive in
some circumstances in "flushing" (zcache calls it "unuse"),
and in some ways less aggressive.  But with significant exercise,
I can always cause the kernel to OOM when it is under heavy
memory pressure and the flush/unuse code is being used.

Have you given any further thought to "a better policy"
(see the comment in the snippet above)?  I'm going
to try a smaller number than 64 to see if the OOMs
go away, but choosing a random number for this throttling
doesn't seem like a good plan for moving forward.

Thanks,
Dan

P.S. I know you, like I, often use something kernbench-ish to
exercise your code.  I've found that compiling a kernel,
then switching to another kernel directory, doing a git pull,
and compiling that kernel, causes a lot of flushes/unuses
and the OOMs.  (This with 1GB RAM booting RHEL6 with a full GUI.)
