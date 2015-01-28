Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbbA2J3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:29:45 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:55577 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbbA2J3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:29:41 -0500
Date: Wed, 28 Jan 2015 13:18:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150128121833.GE4633@osiris>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
 <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
 <20150126093701.699763dc@gandalf.local.home>
 <20150127061941.GA4591@linux.vnet.ibm.com>
 <20150127094228.50e642fc@gandalf.local.home>
 <20150128053645.GA4633@osiris>
 <20150128065754.4466f07b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128065754.4466f07b@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012812-0025-0000-0000-000003A48671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 06:57:54AM -0500, Steven Rostedt wrote:
> On Wed, 28 Jan 2015 06:36:45 +0100
> Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> 
> > On Tue, Jan 27, 2015 at 09:42:28AM -0500, Steven Rostedt wrote:
> > > On Tue, 27 Jan 2015 07:19:42 +0100
> > > Dominik Vogt <vogt@linux.vnet.ibm.com> wrote:
> > >  
> > > > While the kernel may use only profiling or hotpatch at the same
> > > > time, Gcc is able to generate both for the same function.
> > > 
> > > Understood, but would that be useful for the kernel?
> > 
> > Right now not. We may change that anyway in the future if needed.
> > 
> > Steven, how do we proceed with this small series?
> > 
> > Since there don't seem to be any objections, I'll repost with the
> > changed notrace define. However I think the whole stuff should go
> > upstream via the ftrace tree. Is that ok with you?
> 
> I can take it or you can, I'm fine either way. If you want to take it,
> just add my Acked-by. If you prefer me to take it, just let me know.

Ok, then we'll put that on the s390 tree for the next merge window, so
we can fix any potential fallout easier.
I'll add your Acked-by to all three patches. The notrace patch is the
only one that I changed (see below).

Thanks!

>From a24aba18536b64f5395d4901499152191cbc4fae Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Sun, 18 Jan 2015 16:45:42 +0100
Subject: [PATCH 1/3] ftrace: let notrace function attribute disable
 hotpatching if necessary

gcc supports an s390 specific function attribute called "hotpatch".
It can be used to specify the number of halfwords that shall be added before
and after a function and which shall be filled with nops for runtime patching.

s390 will use the hotpatch attribute for function tracing, therefore make
sure that the notrace function attribute either disables the mcount call
or in case of hotpatch nop generation.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/compiler.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 33063f872ee3..1a31ab4fbdca 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -54,7 +54,11 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #include <linux/compiler-gcc.h>
 #endif
 
+#ifdef CC_USING_HOTPATCH
+#define notrace __attribute__((hotpatch(0,0)))
+#else
 #define notrace __attribute__((no_instrument_function))
+#endif
 
 /* Intel compiler defines __GNUC__. So we will overwrite implementations
  * coming from above header files here
-- 
2.1.4

