Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaFSPVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:21:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30404 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbaFSPV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:21:29 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-b7-53a2fff66233
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 0/3] ima: use asynchronous hash API for hash calculation
Date: Thu, 19 Jun 2014 18:20:37 +0300
Message-id: <cover.1403191191.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xa7rf/i8KNtiyisfi1t+9zBZfltZZ
	3L/3k8ni5Yx57BaXd81hs/jQ84jN4tOKScwO7B47Z91l93hwaDOLx+4Fn5k8+rasYvT4vEku
	gDWKyyYlNSezLLVI3y6BK+PtpTssBQv4Kjp2vGRrYLzP3cXIySEhYCLx98JyZghbTOLCvfVs
	XYxcHEICSxklpnRPYIVwOpkkehY2M4JUsQnoSWxo/sEOYosIdDFKXHymDGIzC6RLfJrUCxYX
	FvCWOLNgG1g9i4CqxOPfG8E28ApYSuyZcIYFYpucxMljk1knMHIvYGRYxSiaWppcUJyUnmuk
	V5yYW1yal66XnJ+7iRESJF93MC49ZnWIUYCDUYmHt+HagmAh1sSy4srcQ4wSHMxKIry7vy4K
	FuJNSaysSi3Kjy8qzUktPsTIxMEp1cC4crOSV4tDa9X7KbufBV//bnHfbPnHGrNdSvG3rY9a
	qySYF/8/uzvrop5l0KUp1k3ZNz907NSJV61QX/HidWL0bc4JBVfO7lY82pIzNcxaZ9Yyc+Yl
	r/pWNJzZe1HsnuuHY8EHbbYs3d2ocdpuw9T4HyV8e6NPlRu/XXklUNovhGXiBe2nFm+FlViK
	MxINtZiLihMBgagKGfABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the IMA policy, it might require to measure huge amount of files.
It may be very important to speedup hash calculation or to reduce (bettery)
energy required to do it. Currently IMA uses synchronous hash API (shash)
which is CPU based. CPU based hash calculation is very CPU intensive and on the
battery powered device will be also high energy consuming.

Many platforms provide cryptographic acceleration modules which allow speedup
and/or reduce energy consumption, and provide ansyhchronous way to calculate
hashes. Defacto way to implement drivers for such accelerators is using
asynchronous hash API (ahash).

The first patch adds use of ahash API to IMA. Performance of using HW
acceleration depends very much on amount of data to hash and it depends
on particular HW. It is usually inefficient for small data due to HW
initialization overhead. In order to make it possible to optimize performance
for particular system, the patch provides kernel parameter 'ima_ahash_size=size'
which allows to specify optimal data size when start using ahash. By default
ahash is dsiabled until non-zero value to 'ima_ahash_size' is provided.

Second patch introduces multi-page buffers which makes HW acceleration more
efficient. It adds kernel parameter to specify buffer size to use.

Third patch introduces double-buffering which allows to readahead next portion
of data for hashing while calculating the hash.

- Dmitry

Dmitry Kasatkin (3):
  ima: use ahash API for file hash calculation
  ima: introduce multi-page collect buffers
  ima: provide double buffering for hash calculation

 Documentation/kernel-parameters.txt |   6 +
 security/integrity/ima/ima_crypto.c | 282 +++++++++++++++++++++++++++++++++++-
 2 files changed, 285 insertions(+), 3 deletions(-)

-- 
1.9.1

