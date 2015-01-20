Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbbATKar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:30:47 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:56348 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbATKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:30:45 -0500
Date: Tue, 20 Jan 2015 11:30:40 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: schwidefsky@de.ibm.com, rhoppe@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] s390: char: Free memory on error path.
Message-ID: <20150120103040.GA3928@osiris>
References: <1421704920-29820-1-git-send-email-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421704920-29820-1-git-send-email-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012010-0041-0000-0000-000002F50A7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 11:02:00PM +0100, Christophe Jaillet wrote:
> Free allocated page in case of error returned by hmcdrv_ftp_startup.
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Thanks, I applied the version below.

>From e38409df9fdbe8b4667cc2ee0e44ff5825ed7049 Mon Sep 17 00:00:00 2001
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Date: Mon, 19 Jan 2015 23:02:00 +0100
Subject: [PATCH] s390/hmcdrv: free memory on error path

Free allocated page in case of error returned by hmcdrv_ftp_startup.

[heiko.carstens@de.ibm.com]: slightly changed Christophe's patch

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/s390/char/hmcdrv_ftp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ftp.c
index 4bd63322fc29..d4b61d9088fb 100644
--- a/drivers/s390/char/hmcdrv_ftp.c
+++ b/drivers/s390/char/hmcdrv_ftp.c
@@ -200,10 +200,9 @@ int hmcdrv_ftp_probe(void)
 	rc = hmcdrv_ftp_startup();
 
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = hmcdrv_ftp_do(&ftp);
-	free_page((unsigned long) ftp.buf);
 	hmcdrv_ftp_shutdown();
 
 	switch (rc) {
@@ -216,7 +215,8 @@ int hmcdrv_ftp_probe(void)
 			rc = 0; /* clear length (success) */
 		break;
 	} /* switch */
-
+out:
+	free_page((unsigned long) ftp.buf);
 	return rc;
 }
 EXPORT_SYMBOL(hmcdrv_ftp_probe);
-- 
2.1.4

