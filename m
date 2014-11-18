Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbaKRSDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:03:00 -0500
Received: from mout.web.de ([212.227.17.12]:61673 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaKRSC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:02:59 -0500
Message-ID: <546B89C6.4070308@users.sourceforge.net>
Date: Tue, 18 Nov 2014 19:02:46 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 2/2] fs-udf: One function call less in udf_fill_super() after
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546B8814.2030701@users.sourceforge.net>
In-Reply-To: <546B8814.2030701@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:4GIXmE7p9QbXZz15SZNPRx7U4MmLqgcQ5oSJgGTq5mHurrbIIcX
 S1bcfKxt3LJnuvpB869nn+VOitol7rJYdZy4hNrOJUX1o/kBkfHMkCAQfJE7+jbtMyyd+fO
 UCrOxDJ4rnak2y/MnyQi9tIGQSvJpLg6T3u0uOQETzywRZx05UivrJDQd+Fg8k2TmLpplMD
 SSMLJjjinF56MEz4ZWHaQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 18 Nov 2014 18:29:10 +0100

The iput() function was called in up to three cases by the udf_fill_super()
function during error handling even if the passed data structure element
contained still a null pointer. This implementation detail could be improved
by the introduction of another jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/udf/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index f93c65d..3ccb2f1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2082,12 +2082,12 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	mutex_init(&sbi->s_alloc_mutex);
 
 	if (!udf_parse_options((char *)options, &uopt, false))
-		goto error_out;
+		goto parse_options_failure;
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
 	    uopt.flags & (1 << UDF_FLAG_NLS_MAP)) {
 		udf_err(sb, "utf8 cannot be combined with iocharset\n");
-		goto error_out;
+		goto parse_options_failure;
 	}
 #ifdef CONFIG_UDF_NLS
 	if ((uopt.flags & (1 << UDF_FLAG_NLS_MAP)) && !uopt.nls_map) {
@@ -2238,6 +2238,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 error_out:
 	iput(sbi->s_vat_inode);
+parse_options_failure:
 #ifdef CONFIG_UDF_NLS
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP))
 		unload_nls(sbi->s_nls_map);
-- 
2.1.3

