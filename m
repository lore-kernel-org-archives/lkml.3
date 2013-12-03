Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3LCNiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:38:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3LCNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:38:17 -0500
Date: Tue, 3 Dec 2013 13:37:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Dave Chinner <david@fromorbit.com>, hannes@cmpxchg.org, mhocko@suse.cz,
        dchinner@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, devel@openvz.org, glommer@openvz.org
Subject: Re: [PATCH v12 05/18] fs: do not use destroy_super() in
 alloc_super() fail path
Message-ID: <20131203133755.GJ10323@ZenIV.linux.org.uk>
References: <cover.1385974612.git.vdavydov@parallels.com>
 <af90b79aebe9cd9f6e1d35513f2618f4e9888e9b.1385974612.git.vdavydov@parallels.com>
 <20131203090041.GB8803@dastard>
 <529DA2F5.1040602@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529DA2F5.1040602@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 01:23:01PM +0400, Vladimir Davydov wrote:

> Actually, I'm not going to modify the list_lru structure, because I
> think it's good as it is. I'd like to substitute it with a new
> structure, memcg_list_lru, only in those places where this functionality
> (per-memcg scanning) is really needed. This new structure would look
> like this:
> 
> struct memcg_list_lru {
>     struct list_lru global_lru;
>     struct list_lru **memcg_lrus;
>     struct list_head list;
>     void *old_lrus;
> }
> 
> Since old_lrus and memcg_lrus can be NULL under normal operation, in
> memcg_list_lru_destroy() I'd have to check either the list or the
> global_lru field, i.e. it would look like:
> 
> if (!list.next)
>     /* has not been initialized */
>     return;
> 
> or

... or just use hlist_head.
