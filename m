Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaHVXXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:23:22 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61023 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaHVXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:23:20 -0400
Message-ID: <1408749799.5604.38.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2] carl9170: Remove redundant protection check
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Fri, 22 Aug 2014 16:23:19 -0700
In-Reply-To: <1931285.KsvFbLZH2Q@debian64>
References: <20140822191431.GA5827@ada> <1679858.MgakDZE2Vr@debian64>
	 <1408741732.5604.23.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1931285.KsvFbLZH2Q@debian64>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 23:53 +0200, Christian Lamparter wrote:

> The sta_info->agg[tid] check is not needed (for reference, see [0]).
> (There is already a check in mac80211 which prevents the leak of
> sta_info->agg[tid] [1]).
> 
> Regards
> Christian
> 
> [0] <https://lkml.org/lkml/2014/8/20/725>
> [1] <http://lxr.free-electrons.com/source/net/mac80211/agg-tx.c#L583>
> 

Hmpfff... this code is quite confusing. RCU is used both in tricky way
(carl9170_ampdu_gc() is an example) and a talisman (the part you remove)

Why is rcu_assign_pointer(sta_info->agg[tid], tid_info);
done inside the spinlock protected region, I don't know.

If this code relies on external protection, a comment would help its
comprehension for sure.

For example, you could add a 
BUG_ON(rcu_access_pointer(sta_info->agg[tid]));
so that we are sure requirements are not changed in the callers one day.



