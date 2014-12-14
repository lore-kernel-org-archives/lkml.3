Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbaLNTVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 14:21:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48226 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLNTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:21:27 -0500
Date: Sun, 14 Dec 2014 20:21:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: Re: bluetooth: Add hci_h4p driver
Message-ID: <20141214192124.GA22392@amd>
References: <20141213223727.GA13894@amd>
 <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > Hacks surrounding bluetooth address were removed; this results in
> > working driver with address that is probably not unique.
> 
> Just set HCI_QUIRK_INVALID_BDADDR and let someone deal with that in userspace. You can use the btmgmt public-addr command for testing.
> 

Ok, it took me a while to figure out that --enable-experimental is
needed.

Then help was playing tricks with me:

For more information on the usage of each command use:
    btmgmt <command> --help
root@n900:/my/bluez-5.26/tools# ./btmgmt public-addr --help
Set Public Address for hci0 failed with status 0x0b (Rejected)
root@n900:/my/bluez-5.26/tools# ./btmgmt public-addr
Usage: btmgmt public-addr <address>


root@n900:/my/bluez-5.26/tools# ./btmgmt public-addr 01:02:03:04:05:06
Set Public Address for hci0 failed with status 0x0b (Rejected)

Hmm. Since setting public address only works when interface is down,
and we lose all the settings during up, this does not work at all,
right?

Anyway, you might want to apply this to lessen the confusion.

diff -ur bluez-5.26.ofic/tools/btmgmt.c bluez-5.26/tools/btmgmt.c
--- bluez-5.26.ofic/tools/btmgmt.c	2014-12-14 12:32:19.742595000 +0100
+++ bluez-5.26/tools/btmgmt.c	2014-12-14 20:06:40.432497000 +0100
@@ -2603,7 +2603,7 @@
 
 static void static_addr_usage(void)
 {
-	printf("Usage: btmgmt static-addr <address>\n");
+	printf("Usage: btmgmt static-addr ??:??:??:??:??:??\n");
 }
 
 static void cmd_static_addr(struct mgmt *mgmt, uint16_t index,
@@ -2660,7 +2660,8 @@
 	struct mgmt_cp_set_public_address cp;
 
 	if (argc < 2) {
-		printf("Usage: btmgmt public-addr <address>\n");
+		printf("Usage: btmgmt public-addr ??:??:??:??:??:??\n"
+		       "Note: interface must be down for this to work\n");
 		exit(EXIT_FAILURE);
 	}
 
@@ -2934,7 +2935,7 @@
 
 static void add_device_usage(void)
 {
-	printf("Usage: btmgmt add-device [-a action] [-t type] <address>\n");
+	printf("Usage: btmgmt add-device [-a action] [-t type] ??:??:??:??:??:??\n");
 }
 
 static struct option add_device_options[] = {
@@ -3007,7 +3008,7 @@
 
 static void del_device_usage(void)
 {
-	printf("Usage: btmgmt del-device [-t type] <address>\n");
+	printf("Usage: btmgmt del-device [-t type] ??:??:??:??:??:??\n");
 }
 
 static struct option del_device_options[] = {
@@ -3153,7 +3154,7 @@
 
 	printf("\n"
 		"For more information on the usage of each command use:\n"
-		"\tbtmgmt <command> --help\n" );
+		"\tbtmgmt <command>\n" );
 }
 
 static struct option main_options[] = {
Only in bluez-5.26/tools: btmgmt.c~


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
