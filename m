Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab3IBJy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:54:28 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:11964
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754946Ab3IBJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:54:26 -0400
X-IronPort-AV: E=Sophos;i="4.89,1006,1367964000"; 
   d="scan'208";a="25430802"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-spi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 0/2] delete premature free_irq
Date: Mon,  2 Sep 2013 11:54:19 +0200
Message-Id: <1378115661-5371-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_get_request, or its wrapper platform_get_irq, doesn't allocate
anything, so there is nothing to free.  Free_irq matches up with
request_irq and related functions.

The complete semantic patch used is as follows
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier l;
statement S1;
expression e,e1;
@@

*e = platform_get_irq(...);
... when != request_irq(e,...)
    when != request_threaded_irq(e,...)
    when != request_any_context_irq(e,...)
    when != if (...) { <+... request_irq(e,...) ...+> } else S1
    when != if (...) { <+... request_threaded_irq(e,...) ...+> } else S1
    when != if (...) { <+... request_any_context_irq(e,...) ...+> } else S1
    when != e1 = e
*goto l;
...
*free_irq(e,...)

@@
identifier l;
statement S,S1;
expression e,e1;
@@

*e = platform_get_irq(...);
... when != request_irq(e,...)
    when != request_threaded_irq(e,...)
    when != request_any_context_irq(e,...)
    when != if (...) { <+... request_irq(e,...) ...+> } else S1
    when != if (...) { <+... request_threaded_irq(e,...) ...+> } else S1
    when != if (...) { <+... request_any_context_irq(e,...) ...+> } else S1
*e1 = e;
... when != request_irq(\(e\|e1\),...)
    when != request_threaded_irq(\(e\|e1\),...)
    when != request_any_context_irq(\(e\|e1\),...)
    when != if (...) { <+... request_irq(\(e\|e1\),...) ...+> } else S
    when != if (...) { <+... request_threaded_irq(\(e\|e1\),...) ...+> } else S
    when != if (...) { <+... request_any_context_irq(\(e\|e1\),...) ...+> } else S
*goto l;
...
*free_irq(\(e\|e1\),...)

@@
identifier l;
statement S;
expression e,e1;
@@

*e1 = e = platform_get_irq(...);
... when != request_irq(\(e\|e1\),...)
    when != request_threaded_irq(\(e\|e1\),...)
    when != request_any_context_irq(\(e\|e1\),...)
    when != if (...) { <+... request_irq(\(e\|e1\),...) ...+> } else S
    when != if (...) { <+... request_threaded_irq(\(e\|e1\),...) ...+> } else S
    when != if (...) { <+... request_any_context_irq(\(e\|e1\),...) ...+> } else S
*goto l;
...
*free_irq(\(e\|e1\),...)

// -------------------------------------------------------------------------

@@
identifier l;
statement S,S1;
expression e,e2,e3;
@@

*e = platform_get_resource(e2,IORESOURCE_IRQ,e3);
... when != request_irq(e->start,...)
    when != request_threaded_irq(e->start,...)
    when != request_any_context_irq(e->start,...)
    when != if (...) { <+... request_irq(e->start,...) ...+> } else S1
    when != if (...) { <+... request_threaded_irq(e->start,...) ...+> } else S1
    when != if (...) { <+... request_any_context_irq(e->start,...) ...+> } else S1
*goto l;
...
*free_irq(e->start,...)

@@
identifier l;
statement S,S1;
expression e,e1,e2,e3;
@@

*e = platform_get_resource(e2,IORESOURCE_IRQ,e3);
... when != request_irq(e->start,...)
    when != request_threaded_irq(e->start,...)
    when != request_any_context_irq(e->start,...)
    when != if (...) { <+... request_irq(e->start,...) ...+> } else S1
    when != if (...) { <+... request_threaded_irq(e->start,...) ...+> } else S1
    when != if (...) { <+... request_any_context_irq(e->start,...) ...+> } else S1
e1 = e->start;
... when != request_irq(\(e->start\|e1\),...)
    when != request_threaded_irq(\(e->start\|e1\),...)
    when != request_any_context_irq(\(e->start\|e1\),...)
    when != if (...) { <+... request_irq(\(e->start\|e1\),...) ...+> } else S
    when != if (...) { <+... request_threaded_irq(\(e->start\|e1\),...) ...+> } else S
    when != if (...) { <+... request_any_context_irq(\(e->start\|e1\),...) ...+> } else S
*goto l;
...
*free_irq(\(e->start\|e1\),...)
// </smpl>

