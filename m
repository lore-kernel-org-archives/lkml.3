Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbaEMHar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:30:47 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:37522 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaEMHap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:30:45 -0400
Message-ID: <1399966237.4137.4.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by
 ether_addr_copy
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 13 May 2014 09:30:37 +0200
In-Reply-To: <1399922277.9240.50.camel@joe-AO725>
References: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
	 <1399917025.9240.16.camel@joe-AO725>
	 <20140512200033.87712053add71ca2cf35fe79@skynet.be>
	 <1399918029.9240.19.camel@joe-AO725>
	 <1399920710.4337.26.camel@jlt4.sipsolutions.net>
	 <1399922277.9240.50.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 12:17 -0700, Joe Perches wrote:

> > I certainly don't see the benefit in changing all those other files,
> > particularly since it's not just that we have to verify alignment *now*,
> > we also have to add alignment attributes so that we don't break
> > alignment in the future.
> 
> The same alignment requirements exist in quite a
> lot of the code so I don't see that as much of a
> continuing problem.

I disagree. This may be true for some of the cases we're discussing,
e.g. the change in net/wireless/util.c which has the assumption based on
frame alignment assumptions etc.

However, for things like the mac80211/mlme.c change we're operating
entirely on internal structures that are purely in software and don't
belong to any network frames or similar structs that already have
alignment guarantees.

As a consequence, something like this simple patch:

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5c7169b0ac57..fccbba2f4fe1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1529,7 +1529,7 @@ struct cfg80211_bss {
 
 	u16 beacon_interval;
 	u16 capability;
-
+	u8 my_new_field;
 	u8 bssid[ETH_ALEN];
 
 	u8 priv[0] __aligned(sizeof(void *));

would already break at least one of the patches. The change looks
innocent enough, and is modifying a purely internal struct that doesn't
get used anywhere but the wireless stack (neither wire frame nor
userspace) so this is a perfectly valid change.

Therefore, the patch should mark the bssid with __aligned(2) or such, to
avoid having simple patches like that introduce problems.



> > Additionally doesn't even really save much typing:
> > 
> > memcpy(x, y, ETH_ALEN);
> > ether_addr_copy(x, y);
> 
> To me the general benefit isn't in the reduced
> source code size, but small improvements for
> ARM both in code size and execution speed.

Well, yes, but if it's in a configuration path, which you invoke maybe a
few times an hour, it doesn't seem worth it at all.

If it's in a frame/data hotpath, like the util.c change that already has
other alignment guarantees, it does seem somewhat worthwhile, but beyond
that I'm not so sure.

johannes

