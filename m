Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3I3Opi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:45:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32763 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab3I3Ope (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:45:34 -0400
Date: Mon, 30 Sep 2013 10:45:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Julien Grall <julien.grall@linaro.org>
Cc: ian.campbell@citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc-console: Make it work with HVM
 guests.
Message-ID: <20130930144513.GM3106@phenom.dumpdata.com>
References: <1380317117-21719-1-git-send-email-konrad.wilk@oracle.com>
 <5245FD71.3080408@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5245FD71.3080408@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 10:49:37PM +0100, Julien Grall wrote:
> On 09/27/2013 10:25 PM, Konrad Rzeszutek Wilk wrote:
> 
> >@@ -641,7 +641,20 @@ struct console xenboot_console = {
> >
> >  void xen_raw_console_write(const char *str)
> >  {
> >-	dom0_write_console(0, str, strlen(str));
> >+	ssize_t len = strlen(str);
> >+	int rc = 0;
> >+
> >+	if (xen_domain()) {
> >+		dom0_write_console(0, str, len);
> >+		if (rc == -ENOSYS && xen_hvm_domain())
> >+			goto outb_print;
> >+
> >+	} else if (xen_cpuid_base()) {
> >+		int i;
> >+outb_print:
> >+		for (i = 0; i < len; i++)
> >+			outb(str[i], 0xe9);
> >+	}
> >  }
> 
> xen_cpuid_base and outb(0xe9) is x86 specific and won't compile on ARM.

Odd, I see outb defined in arch/arm and arch/arm64 ?(arch/arm[|64]/include/asm.io.h)

You are of course right about xen_cpuid_base.

How about this:

>From 04b772d2b819f0dda2163e3193fa7cd447a6245c Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 27 Sep 2013 17:18:13 -0400
Subject: [PATCH] xen/hvc: If we use xen_raw_printk let it also work on HVM
 guests.

The xen_raw_printk works great for debugging purposes. We use
for PV guests and we can also use it for HVM guests.

However, for HVM guests we have a fallback of using the 0xe9
port in case the hypervisor does not support an HVM guest of
using the console_io hypercall. As such lets use 0xe9 during
early bootup, and once the hyper-page is setup and if the
console_io hypercall is supported - use that. Otherwise we
will fallback to using the 0xe9 after early bootup.

We also alter the return value for dom0_write_console to return
an error value instead of zero. The HVC API has been supporting
returning error values for quite some time.

P.S.
To use (and to see the output in the Xen ring buffer) one has to build
the hypervisor with 'debug=y'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v1: ifdef xen_cpuid_base as it is X86 specific]
---
 drivers/tty/hvc/hvc_xen.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index e61c36c..6458c9f 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -183,7 +183,7 @@ static int dom0_write_console(uint32_t vtermno, const char *str, int len)
 {
 	int rc = HYPERVISOR_console_io(CONSOLEIO_write, len, (char *)str);
 	if (rc < 0)
-		return 0;
+		return rc;
 
 	return len;
 }
@@ -641,7 +641,22 @@ struct console xenboot_console = {
 
 void xen_raw_console_write(const char *str)
 {
-	dom0_write_console(0, str, strlen(str));
+	ssize_t len = strlen(str);
+	int rc = 0;
+
+	if (xen_domain()) {
+		rc = dom0_write_console(0, str, len);
+#ifdef CONFIG_X86
+		if (rc == -ENOSYS && xen_hvm_domain())
+			goto outb_print;
+
+	} else if (xen_cpuid_base()) {
+		int i;
+outb_print:
+		for (i = 0; i < len; i++)
+			outb(str[i], 0xe9);
+#endif
+	}
 }
 
 void xen_raw_printk(const char *fmt, ...)
-- 
1.8.3.1

