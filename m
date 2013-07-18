Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3GRQry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:47:54 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50890 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308Ab3GRQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:47:52 -0400
Date: Thu, 18 Jul 2013 18:47:46 +0200
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix 'make tools/perf'
Message-ID: <20130718164746.GN8731@rric.localhost>
References: <1370964158-4135-1-git-send-email-rric@kernel.org>
 <tip-107de3724eff5a6fa6474a4d2aa5460b63749ebf@git.kernel.org>
 <20130712093909.GD8731@rric.localhost>
 <20130716145036.GH8731@rric.localhost>
 <20130717153118.GC2071@ghostprotocols.net>
 <20130717154001.GA4454@pd.tnic>
 <20130717161051.GJ8731@rric.localhost>
 <20130718121924.GL8731@rric.localhost>
 <20130718161913.GA2288@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718161913.GA2288@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.13 13:19:13, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jul 18, 2013 at 02:19:24PM +0200, Robert Richter escreveu:
> > I noticed you applied the patch to acme/perf/core, but it should be
> > instead in urgent since mainline is broken.
> 
> I did it because there are alternative ways to build the tools that
> don't require this fix, i.e. this is not _strictly_ needed to build the
> tools.
> 
> What do you guys think: a case like this always needs to go to the
> current release candidate? Ingo?

Since it worked before with v3.10 this is a regression in v3.11.

> > No issues noticed, accept that doc is built when running the 'install'
> > target, not 'all'.

There is another problem building the doc with xmlto. I noticed odd
timestamps leading *.1 files to be rebuilt (note that the .xml file is
newer than *.1):

 -rw-r--r-- 1 robert robert  5049 2013-07-18 14:57:27.000000000 +0200 perf-diff.1
 -rw-r--r-- 1 robert robert  6771 2013-07-18 14:57:27.000207803 +0200 perf-diff.xml

The reason is that xmlto builds the files in /tmp. In my system /tmp
is ext3 while /home is ext4. Only ext4 supports nanosecond
timestamps. Thus, timestamps are not quite comparable and make is
confused a bit.

This would fix this, but I am not sure if we really want this change:

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index 47df22d..1d6e045 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -273,7 +273,8 @@ $(MAN_HTML): $(OUTPUT)%.html : %.txt
 
 $(OUTPUT)%.1 $(OUTPUT)%.5 $(OUTPUT)%.7 : $(OUTPUT)%.xml
 	$(QUIET_XMLTO)$(RM) $@ && \
-	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
+	$(XMLTO) -o $(OUTPUT). -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $< && \
+	touch $@
 
 $(OUTPUT)%.xml : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \

If so, I will send a patch.

Thanks,

-Robert
