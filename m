Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3ARAuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:50:46 -0500
Received: from mx2.parallels.com ([64.131.90.16]:55601 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab3ARAup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:50:45 -0500
Message-ID: <50F89C77.4010101@parallels.com>
Date: Thu, 17 Jan 2013 16:51:03 -0800
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/19] list_lru: per-node list infrastructure
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <1354058086-27937-10-git-send-email-david@fromorbit.com> <50F6FDC8.5020909@parallels.com> <20130116225521.GF2498@dastard> <50F7475F.90609@parallels.com> <20130117042245.GG2498@dastard> <50F84118.7030608@parallels.com> <20130118001029.GK2498@dastard>
In-Reply-To: <20130118001029.GK2498@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.239.55.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 04:10 PM, Dave Chinner wrote:
> and we end up with:
> 
> lru_add(struct lru_list *lru, struct lru_item *item)
> {
> 	node_id = min(object_to_nid(item), lru->numnodes);
> 	
> 	__lru_add(lru, node_id, &item->global_list);
> 	if (memcg) {
> 		memcg_lru = find_memcg_lru(lru->memcg_lists, memcg_id)
> 		__lru_add_(memcg_lru, node_id, &item->memcg_list);
> 	}
> }

A follow up thought: If we have multiple memcgs, and global pressure
kicks in (meaning none of them are particularly under pressure),
shouldn't we try to maintain fairness among them and reclaim equal
proportions from them all the same way we do with sb's these days, for
instance?

I would argue that if your memcg is small, the list of dentries is
small: scan it all for the nodes you want shouldn't hurt.

if the memcg is big, it will have per-node lists anyway.

Given that, do we really want to pay the price of two list_heads in the
objects?


