Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab3IOA6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 20:58:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40271 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3IOA6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 20:58:33 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH V4 12/15] Hibernate: show the verification time for monitor performance
Date: Sun, 15 Sep 2013 08:56:58 +0800
Message-Id: <1379206621-18639-13-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show the verification time for monitor the performance of SHA256 and RSA
verification.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/snapshot.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 8a166e1..804feb6 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2529,6 +2529,8 @@ static void snapshot_fill_sig_forward_info(int sig_check_ret)
 
 int snapshot_image_verify(void)
 {
+	struct timeval start;
+	struct timeval stop;
 	struct crypto_shash *tfm = NULL
 	struct shash_desc *desc;
 	u8 *digest = NULL;
@@ -2560,6 +2562,8 @@ int snapshot_image_verify(void)
 	desc->tfm = tfm;
 	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
+	do_gettimeofday(&start);
+
 	ret = crypto_shash_init(desc);
 	if (ret < 0)
 		goto error_shash;
@@ -2580,6 +2584,9 @@ int snapshot_image_verify(void)
 	else
 		pr_info("PM: snapshot signature check SUCCESS!\n");
 
+	do_gettimeofday(&stop);
+	swsusp_show_speed(&start, &stop, nr_copy_pages, "Verified");
+
 forward_ret:
 	/* forward check result when pass or not enforce verify success */
 	if (!ret || !sig_enforced()) {
-- 
1.6.0.2

