Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaANOg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:36:58 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61675 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaANOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:36:41 -0500
Message-ID: <1389710201.31367.255.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get (v3)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Florian Westphal <fw@strlen.de>, Andrey Vagin <avagin@openvz.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vvs@openvz.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Date: Tue, 14 Jan 2014 06:36:41 -0800
In-Reply-To: <20140114105147.GA14538@paralelels.com>
References: <1389188841.26646.87.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1389549033-23523-1-git-send-email-avagin@openvz.org>
	 <1389558074.31367.187.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140114105147.GA14538@paralelels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 14:51 +0400, Andrew Vagin wrote:

> I think __nf_conntrack_alloc must use atomic_inc instead of
> atomic_set. And we must be sure, that the first object from a new page is
> zeroized.

No you can not do that, and we do not need.

If a new page is allocated, then you have the guarantee nobody can ever
uses it, its content can be totally random.

Only 'living' objects, the ones that were previously inserted in the
hash table, can be found, and their refcnt must be accurate.

A freed object has refcnt == 0, thats the golden rule.

When the page is freed (after RCU grace period), nobody cares of refcnt
anymore.



