Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaFGTBb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 15:01:31 -0400
Received: from mout.gmx.net ([212.227.17.21]:63411 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbaFGTBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 15:01:30 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: davem@davemloft.net
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH v2] dns_resolver: assure that dns_query() result is null-terminated
Date: Sat,  7 Jun 2014 21:01:21 +0200
Message-Id: <1402167681-24676-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com>
References: <CAHQdGtTtwS_DAXx-nhVjjO3D1wksuV+5br10gX0DheHzWDD+sw@mail.gmail.com>
X-Provags-ID: V03:K0:g9PlE3l8OYRDyqF0bb+hKwEqb5htwLyUsEK6pZbkffMM4OzXhGJ
 pUyQWPQWSeJC1UA5uGFE4NTIV4Dlc97SK5W3ZTVKKaXljii49gjAtqbsKZbhLazm2cKkPmw
 Ud1NRHHBQs7MhotHUxV/wreHjlO03meg88B5AH51up+JG0Vo5gEOHtoml1JiPkkDTu1hDCH
 tbeK3p/j7cK5MvJtTxzkw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dns_query() credulously assumes that keys are null-terminated and
returns a copy of a memory block that is off by one.
---
 net/dns_resolver/dns_query.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index e7b6d53..84871a2 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -145,11 +145,11 @@ int dns_query(const char *type, const char *name, size_t namelen,
 	len = upayload->datalen;
 
 	ret = -ENOMEM;
-	*_result = kmalloc(len + 1, GFP_KERNEL);
+	*_result = kzalloc(len + 1, GFP_KERNEL);
 	if (!*_result)
 		goto put;
 
-	memcpy(*_result, upayload->data, len + 1);
+	memcpy(*_result, upayload->data, len);
 	if (_expiry)
 		*_expiry = rkey->expiry;
 
-- 
1.7.10.4

