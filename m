Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbaIRU2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:28:07 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:41296
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604AbaIRU2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:28:06 -0400
X-IronPort-AV: E=Sophos;i="5.04,549,1406584800"; 
   d="scan'208";a="79973359"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        HPDD-discuss@ml01.01.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH] Use kzalloc and rewrite null tests
Date: Thu, 18 Sep 2014 22:24:01 +0200
Message-Id: <1411071842-24714-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch removes some kzalloc-related macros and rewrites the
associated null tests to use !x rather than x == NULL.  The complete
semantic patch used for this transformation is as follows:

// <smpl>
@disable unlikely@
expression ptr;
statement S,S1;
@@

  \(OBD_ALLOC\|OBD_ALLOC_WAIT\|OBD_ALLOC_PTR\|OBD_ALLOC_PTR_WAIT\)(ptr,...);
  if (unlikely(
+     !
      ptr
-      == NULL
     )) S else S1

@@
expression ptr;
statement S,S1;
@@

  \(OBD_ALLOC\|OBD_ALLOC_WAIT\|OBD_ALLOC_PTR\|OBD_ALLOC_PTR_WAIT\)(ptr,...);
  if (
+     !
      ptr
-      == NULL
     ) S else S1

@disable unlikely@
expression ptr;
statement S,S1;
@@

  \(OBD_ALLOC\|OBD_ALLOC_WAIT\|OBD_ALLOC_PTR\|OBD_ALLOC_PTR_WAIT\)(ptr,...);
  if (likely(
      ptr
-      != NULL
     )) S else S1

@@
expression ptr;
statement S,S1;
@@

  \(OBD_ALLOC\|OBD_ALLOC_WAIT\|OBD_ALLOC_PTR\|OBD_ALLOC_PTR_WAIT\)(ptr,...);
  if (
      ptr
-      != NULL
     ) S else S1

// -----------------------------------------------------------------------

@@
expression ptr,size;
@@

- OBD_ALLOC(ptr,size)
+ ptr = kzalloc(size, GFP_NOFS)

@@
expression ptr,size;
@@

- OBD_ALLOC_WAIT(ptr,size)
+ ptr = kzalloc(size, GFP_KERNEL)

@@
expression ptr,size;
@@

- OBD_ALLOC_PTR(ptr)
+ ptr = kzalloc(sizeof(*ptr), GFP_NOFS)

@@
expression ptr,size;
@@

- OBD_ALLOC_PTR_WAIT(ptr,size)
+ ptr = kzalloc(sizeof(*ptr), GFP_KERNEL)
// </smpl>

