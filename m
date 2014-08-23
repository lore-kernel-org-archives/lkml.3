Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaHWShB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:37:01 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48310
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbaHWSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:36:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,387,1406584800"; 
   d="scan'208";a="76200902"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-mips@linux-mips.org
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 0/7] delete double assignment
Date: Sat, 23 Aug 2014 20:33:21 +0200
Message-Id: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where there are two adjacent assignments to the
same location.  In practice, many such occurrences appear to be
intentional, eg to initialize volatile memory, but these cases do not seem
to fall into that category.

The complete semantic match that finds these problems is as follows:

// <smpl>
@r@
expression i,f;
position p1,p2;
@@

(
 i = <+...f(...)...+>;
|
 i |= <+...f(...)...+>;
|
 i &= <+...f(...)...+>;
|
 i += <+...f(...)...+>;
|
 i -= <+...f(...)...+>;
|
 i *= <+...f(...)...+>;
|
 i /= <+...f(...)...+>;
|
 i %= <+...f(...)...+>;
|
 i ^= <+...f(...)...+>;
|
 i <<= <+...f(...)...+>;
|
 i >>= <+...f(...)...+>;
|
 i@p1 = ...;
|
 i@p1 |= ...;
|
 i@p1 &= ...;
|
 i@p1 += ...;
|
 i@p1 -= ...;
|
 i@p1 *= ...;
|
 i@p1 /= ...;
|
 i@p1 %= ...;
|
 i@p1 ^= ...;
|
 i@p1 <<= ...;
|
 i@p1 >>= ...;
|
 i@p1 ++;
|
 ++i@p1;
|
 i@p1 --;
|
 --i@p1;
)
(
 i = <+...i...+>;
|
 i = <+...f(...)...+>;
|
 i@p2 = ...;
)

@@
expression i,j,f;
position r.p1,r.p2;
@@

(
 (<+...i@p1...+>);
)
(
 (<+...\(j++\|++j\|j--\|--j\|f(...)\)...+>) = ...;
|
*i@p2 = ...;
)
// </smpl>

