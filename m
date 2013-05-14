Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab3ENEgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 00:36:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38328 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750759Ab3ENEgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 00:36:50 -0400
Message-ID: <1368506210.17660.11.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: add check for wrong "if
 (IS_ERR_OR_NULL(<foo>)) return PTR_ERR(<foo>)" uses
From: Joe Perches <joe@perches.com>
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 21:36:50 -0700
In-Reply-To: <1368492098-3140-1-git-send-email-ruslan.bilovol@ti.com>
References: <1368492098-3140-1-git-send-email-ruslan.bilovol@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 03:41 +0300, Ruslan Bilovol wrote:
> This was many times discussed by Russell King
> and I also was about wrong usage of IS_ERR_OR_NULL()
> in my patch. So I added this check and other people will
> be at least warned about potentially wrong usage
> of mentioned macro.
[]
> Tested on:
> +	if (IS_ERR_OR_NULL(soc_dev))
> +		return PTR_ERR(soc_dev);
> +
> +	if (IS_ERR_OR_NULL(soc_dev))en
> +		return soc_dev ? PTR_ERR(soc_dev) : -ENODEV;

I did a grep for IS_ERR_OR_NULL and this misses variants like:

		if (unlikely(IS_ERR_OR_NULL(etc...

Perhaps something like this?
---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b954de5..18c7d8c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2184,6 +2184,15 @@ sub process {
 				WARN("SUSPECT_CODE_INDENT",
 				     "suspect code indent for conditional statements ($indent, $sindent)\n" . $herecurr . "$stat_real\n");
 			}
+
+# check for misuses of IS_ERR_OR_NULL
+			if ($stat =~ /^\+.*\bIS_ERR_OR_NULL\s*\(\s*($Lval)\s*\)/) {
+				my $test = $1;
+				if ($stat =~ /\bPTR_ERR\s*\(\s*${test}\s*\)/) {
+					WARN("IS_ERR_OR_NULL",
+					     "Use of IS_ERR_OR_NULL($test) with PTR_ERR($test) is usually wrong: see http://permalink.gmane.org/gmane.linux.ports.arm.omap/97874\n" . $herecurr . "$stat_real\n");
+				}
+			}
 		}
 
 		# Track the 'values' across context and added lines.


