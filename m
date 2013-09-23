Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab3IWURa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:17:30 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:37893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753537Ab3IWUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:17:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3353:3622:3653:3867:3868:3870:3871:3873:4321:5007:7576:7652:7903:9545:10004:10026:10400:10848:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: night75_40ebe6823d152
X-Filterd-Recvd-Size: 2751
Message-ID: <1379967444.3575.56.camel@joe-AO722>
Subject: Re: checkpatch guide for newbies
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2013 13:17:24 -0700
In-Reply-To: <1379959611.3575.40.camel@joe-AO722>
References: <20130923090100.GE6192@mwanda>
	 <1379959611.3575.40.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 11:06 -0700, Joe Perches wrote:
> Maybe I'll submit some auto-neatening script eventually
> and see what you think.

Maybe something like:

From: Joe Perches <joe@perches.com>
Subject: [PATCH] scripts/fix_with_checkpatch.sh: Add a trivial script to fix simple style defects

Add a few whitespace and style corrections to individual files.

Create git commits for those changes too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/fix_with_checkpatch.sh | 52 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100755 scripts/fix_with_checkpatch.sh

diff --git a/scripts/fix_with_checkpatch.sh b/scripts/fix_with_checkpatch.sh
new file mode 100755
index 0000000..c47b111b
--- /dev/null
+++ b/scripts/fix_with_checkpatch.sh
@@ -0,0 +1,50 @@
+#/bin/sh
+
+whitespace_types="spacing space_before_tab pointer_location"
+changecode_types="c99_comments prefer_packed prefer_aligned avoid_externs parenthesis_alignment"
+
+checkpatch_update ()
+{
+    local file="$1"
+    type="$2"
+
+    ./scripts/checkpatch.pl --file --fix --strict --types=$type $file
+    if [ ! -f $file.EXPERIMENTAL-checkpatch-fixes ] ; then
+	return;
+    fi
+
+    mv $file.EXPERIMENTAL-checkpatch-fixes $file
+
+    git diff --stat -p $file | cat
+
+    obj="$(echo $file|sed 's/\.c$/\.o/')"
+
+    make $obj
+
+    tmpfile=$(mktemp git_commit.XXXXXX)
+    echo "$file: checkpatch neatening for $2" > $tmpfile
+    echo "" >> $tmpfile
+    echo "" >> $tmpfile
+
+    git commit -s -F $tmpfile -e $file
+
+    rm -f $tmpfile
+}
+
+for file in "$@"
+do
+
+    if [ ! -f $file ] ; then 
+	echo "Argument '$file' is not a file"
+	continue
+    fi
+
+    for type in $whitespace_types ; do
+	checkpatch_update $file $type
+    done
+
+    for type in $changecode_types ; do
+	checkpatch_update $file $type
+    done
+
+done
-- 
1.8.1.2.459.gbcd45b4.dirty



