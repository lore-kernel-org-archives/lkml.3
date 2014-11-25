Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbaKYOfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:35:13 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32905 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYOfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:35:11 -0500
Date: Tue, 25 Nov 2014 14:35:00 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Ian Campbell <ijc@debian.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] of: support passing console options with stdout-path
Message-ID: <20141125143500.GE2361@bivouac.eciton.net>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
 <20141125103504.GA21525@leverpostej>
 <20141125111724.GC2361@bivouac.eciton.net>
 <1416917249.32327.15.camel@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416917249.32327.15.camel@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:07:29PM +0000, Ian Campbell wrote:
> My concern is that this is Linux specific, other OSes may have different
> ideas about how stdout options should be formatted within this property.
> (At least I don't know of any standardisation of the 115200n8 thing --
> I'd love to be corrected!)
> 
> If I were a firmware author I'd be wary of specifying a stdout-path with
> a Linux specific suffix.
 
> Search ePAPR for baud it seems that the generic serial binding includes
> a current-speed property in 6.2.1.2. It then goes on a bit ambiguously
> to talk about the NS16550 in 6.2.2 but I think 6.2.1.2 was intended to
> be generic. No mention of stop-bits/parity etc though, they are assumed
> to be set already I think
> 
> One thought I had was to define a dt-stdout "pseudo-console" so that
> console=dt-stdout,115200n8 or something could be used.

I'll wait for others to comment on the above.
 
> Anyway I applied your patch to v3.18-rc5 and ran it on a Mustang and it
> didn't work for some reason. I'm using:
> 
>         fdt set /chosen stdout-path "/soc/serial@1c020000:115200"
>         setenv bootargs "earlycon=uart8250,mmio32,0x1c020000 root=/dev/sda3 rw debug"
> 
> So I get earlycon but then no proper console. Removing earlycon just
> makes that stop working.

Right, so having debugged this a bit offline, I'm amazed I booted
anything at all, given how badly I broke path scanning...
Please ignore previous version - a fixed one follows:

/
	Leif

>From aef87fd958902afe881720286d525e10997462b8 Mon Sep 17 00:00:00 2001
From: Leif Lindholm <leif.lindholm@linaro.org>
Date: Mon, 24 Nov 2014 22:23:58 +0000
Subject: [PATCH] of: support passing console options with stdout-path

Support specifying console options (like with console=ttyXN,<options>)
by appending them to the stdout-path property after a separating ':'.

Example:
	stdout-path = "uart0:115200";

This patch also modifies of_find_node_by_path() to match only the
portion of the path before a ':'.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/of/base.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 3823edf..ecd6290 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -37,6 +37,7 @@ EXPORT_SYMBOL(of_allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 struct device_node *of_stdout;
+static char *of_stdout_options;
 
 struct kset *of_kset;
 
@@ -699,10 +700,15 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 {
 	struct device_node *child;
 	int len = strchrnul(path, '/') - path;
+	int term;
 
 	if (!len)
 		return NULL;
 
+	term = strchrnul(path, ':') - path;
+	if (term < len)
+		len = term;
+
 	__for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
 		if (WARN(!name, "malformed device_node %s\n", child->full_name))
@@ -742,11 +748,16 @@ struct device_node *of_find_node_by_path(const char *path)
 	if (*path != '/') {
 		char *p = strchrnul(path, '/');
 		int len = p - path;
+		int term;
 
 		/* of_aliases must not be NULL */
 		if (!of_aliases)
 			return NULL;
 
+		term = strchrnul(path, ':') - path;
+		if (term < len)
+			len = term;
+
 		for_each_property_of_node(of_aliases, pp) {
 			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
 				np = of_find_node_by_path(pp->value);
@@ -1830,8 +1841,12 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 			name = of_get_property(of_chosen, "linux,stdout-path", NULL);
 		if (IS_ENABLED(CONFIG_PPC) && !name)
 			name = of_get_property(of_aliases, "stdout", NULL);
-		if (name)
+		if (name) {
 			of_stdout = of_find_node_by_path(name);
+			of_stdout_options = strchr(name, ':');
+			if (of_stdout_options != NULL)
+				of_stdout_options++;
+		}
 	}
 
 	if (!of_aliases)
@@ -1957,7 +1972,7 @@ bool of_console_check(struct device_node *dn, char *name, int index)
 {
 	if (!dn || dn != of_stdout || console_set_on_cmdline)
 		return false;
-	return !add_preferred_console(name, index, NULL);
+	return !add_preferred_console(name, index, of_stdout_options);
 }
 EXPORT_SYMBOL_GPL(of_console_check);
 
-- 
1.7.10.4

