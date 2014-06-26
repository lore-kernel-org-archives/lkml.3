Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaFZLpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:45:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039AbaFZLpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:45:16 -0400
Date: Thu, 26 Jun 2014 13:45:13 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140626114512.GO8769@pathway.suse.cz>
References: <20140626162257.45f8e2aa@canb.auug.org.au>
 <20140626082940.GE27687@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626082940.GE27687@wotan.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-26 10:29:40, Luis R. Rodriguez wrote:
> On Thu, Jun 26, 2014 at 04:22:57PM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc44x_defconfig) failed like this:
> > 
> > kernel/printk/printk.c: In function 'log_buf_add_cpu':
> > kernel/printk/printk.c:269:37: error: 'CONFIG_LOG_CPU_MAX_BUF_SHIFT' undeclared (first use in this function)
> >  #define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
> >                                      ^
> > kernel/printk/printk.c:864:42: note: in expansion of macro '__LOG_CPU_MAX_BUF_LEN'
> >   cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
> >                                           ^
> > kernel/printk/printk.c:269:37: note: each undeclared identifier is reported only once for each function it appears in
> >  #define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
> >                                      ^
> > kernel/printk/printk.c:864:42: note: in expansion of macro '__LOG_CPU_MAX_BUF_LEN'
> >   cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
> >                                           ^
> > 
> > Caused by commit 58209adf633e ("printk: allow increasing the ring
> > buffer depending on the number of CPUs").  CONFIG_LOG_CPU_MAX_BUF_SHIFT
> > is not defined for this configuration.
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 573d3f6..2339118 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -822,10 +822,9 @@ config LOG_BUF_SHIFT
>  
>  config LOG_CPU_MAX_BUF_SHIFT
>  	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
> -	range 0 21
> -	default 12
> -	depends on SMP
> -	depends on !BASE_SMALL
> +	range 0 21 if SMP && !BASE_SMALL
> +	default 12 if SMP && !BASE_SMALL
> +	default 0 if !SMP || BASE_SMALL

There are situations when the default value is not defined, for
example, when both SMP and BASE_SMALL are set.

I would ignore SMP. It is handled in the code. If SMP is not defined,
num_possible_cpus() returns 1 and "cpu_extra" is always 0. Then we
could have:

       range 0 21
       default 12 if !BASE_SMALL
       default 0 if BASE_SMALL


What about the following patch? It does the above change. Plus
it tries to make the help text better readable. It says the basic
details first. Then it says other useful information in
separate paragraphs. Also I removed the computation example. It was
not easy to parse. Interested people might want to look into sources.

It could be merged into
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch

diff --git a/init/Kconfig b/init/Kconfig
index 7ec22f19df29..b0b2e95641e2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -813,47 +813,34 @@ config LOG_BUF_SHIFT
 	  by "log_buf_len" boot parameter.
 
 	  Examples:
-	  	     17 => 128 KB
+		     17 => 128 KB
 		     16 => 64 KB
-	             15 => 32 KB
-	             14 => 16 KB
+		     15 => 32 KB
+		     14 => 16 KB
 		     13 =>  8 KB
 		     12 =>  4 KB
 
 config LOG_CPU_MAX_BUF_SHIFT
 	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
 	range 0 21
-	default 12
-	depends on SMP
-	depends on !BASE_SMALL
-	help
-	  The kernel ring buffer will get additional data logged onto it
-	  when multiple CPUs are supported. Typically the contributions are
-	  only a few lines when idle however under under load this can vary
-	  and in the worst case it can mean losing logging information. You
-	  can use this to set the maximum expected amount of logging
-	  contribution under load by each CPU in the worst case scenario, as
-	  a power of 2. The total sum amount of contributions made by all CPUs
-	  must be greater than half of the default kernel ring buffer size
-	  ((1 << LOG_BUF_SHIFT / 2 bytes)) in order to trigger an increase upon
-	  bootup. If an increase is required the ring buffer is increased to
-	  the next power of 2 that can fit both the minimum kernel ring buffer
-	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
-	  For example if LOG_BUF_SHIFT is 18 (256 KB) you'd require at laest
-	  128 KB contributions by other CPUs in order to trigger an increase.
-	  With a LOG_CPU_BUF_SHIFT of 12 (4 KB) you'd require at least anything
-	  over > 64 possible CPUs to trigger an increase. If you had 128
-	  possible CPUs the new minimum required kernel ring buffer size
-	  would be:
-
-	     ((1 << 18) + ((128 - 1) * (1 << 12))) / 1024 = 764 KB
-
-	  Since we only allow powers of two for the kernel ring buffer size the
-	  new kernel ring buffer size would be 1024 KB.
-
-	  CPU contributions are ignored when "log_buf_len" kernel parameter is
-	  used as it forces an exact (power of two) size of the ring buffer to
-	  an expected value.
+	default 12 if !BASE_SMALL
+	default 0 if BASE_SMALL
+	help
+	  This option allows to increase the default ring buffer size
+	  according to the number of CPUs. The value defines the contribution
+	  of each CPU as a power of 2. The used space is typically only few
+	  lines however it might be much more when problems are reported,
+	  e.g. backtraces.
+
+	  The increased size means that a new buffer has to be allocated and
+	  the original static one is unused. It makes sense only on systems
+	  with more CPUs. Therefore this value is used only when the sum of
+	  contributions is greater than the half of the default kernel ring
+	  buffer as defined by LOG_BUF_SHIFT. The default values are set
+	  so that more than 64 CPUs are needed to trigger the allocation.
+
+	  Also this option is ignored when "log_buf_len" kernel parameter is
+	  used as it forces an exact (power of two) size of the ring buffer.
 
 	  The number of possible CPUs is used for this computation ignoring
 	  hotplugging making the compuation optimal for the the worst case
-- 
1.8.4

