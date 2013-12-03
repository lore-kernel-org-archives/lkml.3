Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3LCWix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:38:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39939 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3LCWiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:38:46 -0500
MIME-Version: 1.0
In-Reply-To: <529D9100.4070207@parallels.com>
References: <1385989693-28788-1-git-send-email-vdavydov@parallels.com>
	<20131202181501.GA5524@dhcp22.suse.cz>
	<CAA6-i6rWsZNQmFY5L-=yc6TaTGyg4hP4qn9gMZVsu8wWJ=1ywg@mail.gmail.com>
	<529CDDB3.3090301@parallels.com>
	<CAA6-i6q+WooWMSbJwLS=ByVu=fgAQuep99iP7tAXiuLABu2gVA@mail.gmail.com>
	<529D9100.4070207@parallels.com>
Date: Wed, 4 Dec 2013 02:38:46 +0400
Message-ID: <CAA6-i6q2viRkbjYOHcoiCHgvdfbfo-4j0k9gj9AA4SH1YToqVg@mail.gmail.com>
Subject: Re: [PATCH] memcg: remove KMEM_ACCOUNTED_ACTIVATED
From: Glauber Costa <glommer@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, devel@openvz.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Hi, Glauber

Hi.

>
> In memcg_update_kmem_limit() we do the whole process of limit
> initialization under a mutex so the situation we need protection from in
> tcp_update_limit() is impossible. BTW once set, the 'activated' flag is
> never cleared and never checked alone, only along with the 'active'
> flag, that's why I doubt we need it at all.

The updates are protected by a mutex, but the readers are not, and should not.
So we can still be patching the readers, and the double-flag was
initially used so
we can make sure that both flags are only set after the static branches are in.

Note that one of the flags is set inside memcg_update_cache_sizes(). After that,
we call static_key_slow_inc(). At this point, someone whose code is
patched in could
start accounting, but it shouldn't - because not all sites are patched in.

So after the update is done, we set the other flag, and now everybody
will start going
through.

Could you do something clever with just one flag? Probably yes. But I
doubt it would
be that much cleaner, this is just the way that patching sites work.

-- 
E Mare, Libertas
