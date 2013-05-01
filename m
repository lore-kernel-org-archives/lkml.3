Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab3EAWa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:30:59 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:50829 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3EAWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:30:55 -0400
Date: Wed, 1 May 2013 15:30:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cody P Schafer <cody@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] memory_hotplug: use pgdat_resize_lock() when updating
 node_present_pages
In-Reply-To: <1367446635-12856-5-git-send-email-cody@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1305011530050.8804@chino.kir.corp.google.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-5-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Cody P Schafer wrote:

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a221fac..0bdca10 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -915,6 +915,7 @@ static void node_states_set_node(int node, struct memory_notify *arg)
>  
>  int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_type)
>  {
> +	unsigned long flags;
>  	unsigned long onlined_pages = 0;
>  	struct zone *zone;
>  	int need_zonelists_rebuild = 0;
> @@ -993,7 +994,11 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>  
>  	zone->managed_pages += onlined_pages;
>  	zone->present_pages += onlined_pages;
> +
> +	pgdat_resize_lock(zone->zone_pgdat, &flags);
>  	zone->zone_pgdat->node_present_pages += onlined_pages;
> +	pgdat_resize_unlock(zone->zone_pgdat, &flags);
> +
>  	if (onlined_pages) {
>  		node_states_set_node(zone_to_nid(zone), &arg);
>  		if (need_zonelists_rebuild)

Why?  You can't get a partial read of a word-sized data structure.
