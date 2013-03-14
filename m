Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3CNQSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:18:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44891 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab3CNQSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:18:06 -0400
Message-ID: <1363277885.2146.3.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add check for reuse of krealloc arg
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 09:18:05 -0700
In-Reply-To: <1363267820.4853.41.camel@i7.infradead.org>
References: <1363267820.4853.41.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 13:30 +0000, David Woodhouse wrote:
> If krealloc() returns NULL, it *doesn't* free the original. So any code
> of the form 'foo = krealloc(foo, …);' is almost certainly a bug.

So add a check for it to checkpatch.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..7ef2b4b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3476,6 +3476,13 @@ sub process {
 			     "unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for krealloc arg reuse
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
+			WARN("KREALLOC_ARG_REUSE",
+			     "Reusing the krealloc arg is almost always a bug\n" . $herecurr);
+		}
+
 # check for alloc argument mismatch
 		if ($line =~ /\b(kcalloc|kmalloc_array)\s*\(\s*sizeof\b/) {
 			WARN("ALLOC_ARRAY_ARGS",


