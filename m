Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3KFTQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:16:36 -0500
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:47874 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495Ab3KFTQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:16:35 -0500
Date: Wed, 6 Nov 2013 19:16:33 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andreas Herrmann <andreas.herrmann@calxeda.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Switch slub_debug kernel option to early_param
 to avoid boot panic
In-Reply-To: <20131106184529.GB5661@alberich>
Message-ID: <000001422ed8406b-14bef091-eee0-4e0e-bcdd-a8909c605910-000000@email.amazonses.com>
References: <20131106184529.GB5661@alberich>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.06-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Andreas Herrmann wrote:

> When I've used slub_debug kernel option (e.g.
> "slub_debug=,skbuff_fclone_cache" or similar) on a debug session I've
> seen a panic like:

Hmmm.. That looks like its due to some slabs not having names
during early boot. kmem_cache_flags is called with NULL as a parameter.

Are you sure that this fixes the issue? Looks like the
kmem_cache_flag function should fail regardless of how early you set it.

AFAICT the right fix would be:


Subject: slub: Handle NULL parameter in kmem_cache_flags

kmem_cache_flags may be called with NULL parameter during early boot.
Skip the test in that case.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2013-10-15 13:55:44.000000000 -0500
+++ linux/mm/slub.c	2013-11-06 13:09:21.810583134 -0600
@@ -1217,7 +1217,7 @@ static unsigned long kmem_cache_flags(un
 	/*
 	 * Enable debugging if selected on the kernel commandline.
 	 */
-	if (slub_debug && (!slub_debug_slabs ||
+	if (slub_debug && name && (!slub_debug_slabs ||
 		!strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs))))
 		flags |= slub_debug;



