Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaFZI3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:29:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaFZI3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:29:42 -0400
Date: Thu, 26 Jun 2014 10:29:40 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140626082940.GE27687@wotan.suse.de>
References: <20140626162257.45f8e2aa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626162257.45f8e2aa@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 04:22:57PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> kernel/printk/printk.c: In function 'log_buf_add_cpu':
> kernel/printk/printk.c:269:37: error: 'CONFIG_LOG_CPU_MAX_BUF_SHIFT' undeclared (first use in this function)
>  #define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
>                                      ^
> kernel/printk/printk.c:864:42: note: in expansion of macro '__LOG_CPU_MAX_BUF_LEN'
>   cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
>                                           ^
> kernel/printk/printk.c:269:37: note: each undeclared identifier is reported only once for each function it appears in
>  #define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
>                                      ^
> kernel/printk/printk.c:864:42: note: in expansion of macro '__LOG_CPU_MAX_BUF_LEN'
>   cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
>                                           ^
> 
> Caused by commit 58209adf633e ("printk: allow increasing the ring
> buffer depending on the number of CPUs").  CONFIG_LOG_CPU_MAX_BUF_SHIFT
> is not defined for this configuration.

diff --git a/init/Kconfig b/init/Kconfig
index 573d3f6..2339118 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -822,10 +822,9 @@ config LOG_BUF_SHIFT
 
 config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
-	range 0 21
-	default 12
-	depends on SMP
-	depends on !BASE_SMALL
+	range 0 21 if SMP && !BASE_SMALL
+	default 12 if SMP && !BASE_SMALL
+	default 0 if !SMP || BASE_SMALL
 	help
 	  The kernel ring buffer will get additional data logged onto it
 	  when multiple CPUs are supported. Typically the contributions are
