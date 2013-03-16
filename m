Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3CPRmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 13:42:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43781 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751890Ab3CPRms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:42:48 -0400
Message-ID: <1363455766.2023.36.camel@joe-AO722>
Subject: Re: [RFC PATCH] seq_file: Use seq_puts when seq_printf has only a
 format with no args
From: Joe Perches <joe@perches.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 16 Mar 2013 10:42:46 -0700
In-Reply-To: <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
References: <1363441844.2023.17.camel@joe-AO722>
	 <CAErSpo4xN9K+aasX-3v-1PeAJpF+3Vg1WrxFaAKNUA43N3bWBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 09:43 -0600, Bjorn Helgaas wrote:
> Checkpatch could look for additions of seq_printf() with constant formats.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Joe Perches <joe@perches.com>
---

I don't know what perl version introduced $-[0] and $+[0]
so this may not work with older perl.

 scripts/checkpatch.pl | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..e5b50c5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -628,6 +628,13 @@ sub sanitise_line {
 	return $res;
 }
 
+sub get_quoted_string {
+	my ($line, $rawline) = @_;
+
+	return "" if ($line !~ m/(\"[X]+\")/g);
+	return substr($rawline, $-[0], $+[0] - $-[0]);
+}
+
 sub ctx_statement_block {
 	my ($linenr, $remain, $off) = @_;
 	my $line = $linenr - 1;
@@ -3372,6 +3379,15 @@ sub process {
 			     "struct spinlock should be spinlock_t\n" . $herecurr);
 		}
 
+# check for seq_printf uses that could be seq_puts
+		if ($line =~ /\bseq_printf\s*\(/) {
+			my $fmt = get_quoted_string($line, $rawline);
+			if ($fmt !~ /[^\\]\%/) {
+				WARN("PREFER_SEQ_PUTS",
+				     "Prefer seq_puts to seq_printf\n" . $herecurr);
+			}
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&


