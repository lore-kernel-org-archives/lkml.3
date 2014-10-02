Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaJBSzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:55:06 -0400
Received: from hofr.at ([212.69.189.236]:43676 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbaJBSzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:55:05 -0400
Date: Thu, 2 Oct 2014 20:55:02 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] limit _shipped to c,h and S files
Message-ID: <20141002185502.GA18068@opentech.at>
References: <20141001133659.GC5560@opentech.at> <542C07BF.6030703@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542C07BF.6030703@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2014, Michal Marek wrote:

> On 2014-10-01 15:36, Nicholas Mc Guire wrote:
> > 
> > limit _shipped to c,h and S files
> > 
> > _shipped targets are intended for generated source files which should
> > not permit .o binary blobs which is currently the case. This patch
> > simply restricts _shipped targets to .c, .h and .S files.
> 
> Patches 1/3 and 3/3 are fine, but I'm not convinced about this one.
> Sure, binary blobs are often distributed as *.o_shipped, but they are
> not going away if you remove support for _shipped.
> 
> 
> > Note that this patch breaks the handline of drivers/net/wan/wanxlfw.inc_shipped
> > which probably really should be moved to a loadable firmware and use
> > request_firmware - a short term fix could be to move it to a .h file.
> 
> At a minimum, the patch series should address this before limiting
> support for *_shipped.
>

Krzysztof Halasa <khc@pm.waw.pl> who is the author of drivers/net/wan/wanxl
(CCed) noted that "This is a driver for an old obscure early PCI 2 Mbit/s 
WAN board" so the probability of getting this migrated to the firmware 
interface is quite low.

Not sure if this form of addressing it is accpetable, it simply adds
a 4th case for the .inc_shipped with a INFO message noting it as
deprecated. 

proposed alternative for 2/3 below.

thx !
hofrat


limit _shipped to c,h and S files

_shipped targets are intended for generated source files which should
not permit .o binary blobs which is currently the case. This patch
simply restricts _shipped targets to .c, .h and .S files.

Note that limiting it to .c, .h and .S only would breaks the handling
of drivers/net/wan/wanxlfw.inc_shipped which is named .inc for mainly
historic reasons as a work around the .inc_shipped is treated as
expected but an additional note is printed indicating that this is
deprecated.

  INFO: use of .inc_shipped files is deprecated
  SHIPPED drivers/net/wan/wanxlfw.inc

This patch is against Linux 3.17.0-rc7

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/Makefile.lib |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 260bf8a..2281ad9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -207,7 +207,17 @@ endif
 quiet_cmd_shipped = SHIPPED $@
 cmd_shipped = cat $< > $@
 
-$(obj)/%: $(src)/%_shipped
+$(obj)/%.c: $(src)/%.c_shipped
+	$(call cmd,shipped)
+
+$(obj)/%.h: $(src)/%.h_shipped
+	$(call cmd,shipped)
+
+$(obj)/%.S: $(src)/%.S_shipped
+	$(call cmd,shipped)
+
+$(obj)/%.inc: $(src)/%.inc_shipped
+	@echo '  INFO: use of .inc_shipped files is deprecated'
 	$(call cmd,shipped)
 
 # Commands useful for building a boot image
-- 
1.7.10.4

