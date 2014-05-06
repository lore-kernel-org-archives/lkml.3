Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaEFRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:06:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14157 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750830AbaEFRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:06:25 -0400
Date: Tue, 6 May 2014 18:05:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] mm: Postpone the disabling of kmemleak early logging
Message-ID: <20140506170549.GM23957@arm.com>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
 <1399038070-1540-7-git-send-email-catalin.marinas@arm.com>
 <5368FDBB.8070106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5368FDBB.8070106@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:20:27PM +0100, Sasha Levin wrote:
> On 05/02/2014 09:41 AM, Catalin Marinas wrote:
> > Currently, kmemleak_early_log is disabled at the beginning of the
> > kmemleak_init() function, before the full kmemleak tracing is actually
> > enabled. In this small window, kmem_cache_create() is called by kmemleak
> > which triggers additional memory allocation that are not traced. This
> > patch moves the kmemleak_early_log disabling further down and at the
> > same time with full kmemleak enabling.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> This patch makes the kernel die during the boot process:
> 
> [   24.471801] BUG: unable to handle kernel paging request at ffffffff922f2b93
> [   24.472496] IP: [<ffffffff922f2b93>] log_early+0x0/0xcd

Thanks for reporting this. I assume you run with
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF enabled and kmemleak_early_log remains
set even though kmemleak is not in use.

Does the patch below fix it?

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 0cd6aabd45a0..e7f74091c024 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1811,6 +1811,7 @@ void __init kmemleak_init(void)
 
 #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 	if (!kmemleak_skip_disable) {
+		kmemleak_early_log = 0;
 		kmemleak_disable();
 		return;
 	}

Thanks.

-- 
Catalin
