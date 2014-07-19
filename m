Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbaGSLfH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 07:35:07 -0400
Received: from 8bytes.org ([81.169.241.247]:49227 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760968AbaGSLfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 07:35:05 -0400
Date: Sat, 19 Jul 2014 13:35:02 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140719113502.GJ30979@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <20140719102623.GA837@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140719102623.GA837@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 19, 2014 at 12:26:23PM +0200, Pavel Machek wrote:
> > A test on a 12TB machine showed an improvement in resume
> > time from 76s with the old implementation to 2.4s with the
> > radix tree and the improved swsusp_free function. See below
> > for details of this test.
> 
> Ok, nice.
> 
> How did space requirements change?
> 
> In particular, do we need to reserve a bit more pages for hibernation
> now?

This depends on the amount of memory in the system. On one side the
struct bm_block (32 bytes) was replaced by struct rtree_node (16 bytes).

On the other side more pages are required to build the radix tree.
For systems with up to 64GB of RAM on amd64 this is one additional page.
On a 12TB system this sums up to 193 additional pages (again, on amd64)
required for the radix tree inner nodes.

These 193 pages take around 800kb while we save ca. 1.5MB because of the
smaller struct rtree_node.

On a 4GB system the situation is different, there we need to reserve one
additional page while saving only 512 bytes with the smaller struct. The
break-even is somewhere around 32GB where the savings of struct
rtree_node outweight the additional page required for the radix tree.

Thanks,

	Joerg

