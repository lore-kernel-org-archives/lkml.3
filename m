Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaAOKsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:48:24 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61463 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaAOKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:48:21 -0500
Message-ID: <1389782899.2128.15.camel@x220>
Subject: [PATCH] headers_check: special case seqbuf_dump()
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Jan 2014 11:48:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2014 10:48:19.0629 (UTC) FILETIME=[4DB795D0:01CF11DF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make headers_check" warns about soundcard.h for (at least) five years
now:
    [...]/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel

We're apparently stuck with providing OSSlib-3.8 compatibility, so let's
special case this declaration just to silence it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Support for OSSlib post 3.8 was already removed in commit 43a990765a
("sound: Remove OSSlib stuff from linux/soundcard.h"). Five years have
passed since that commit: do people still care about OSSlib-3.8? If not,
quite a bit of code could be remove from soundcard.h (and probably
ultrasound.h).

2) By the way, what is actually meant by:
    It is no longer possible to actually link against OSSlib with this
    header, but we still provide these macros for programs using them.

Doesn't that mean compatibility to OSSlib isn't even useful?

3) Anyhow, a previous discussion soundcard.h, which led to that commit,
starts at https://lkml.org/lkml/2009/1/20/349 .

4) And, yes, I sneaked in a whitespace fix.

 scripts/headers_check.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 64ac238..62320f9 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -65,7 +65,11 @@ sub check_include
 
 sub check_declarations
 {
-	if ($line =~m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
+	# soundcard.h is what it is
+	if ($line =~ m/^void seqbuf_dump\(void\);/) {
+		return;
+	}
+	if ($line =~ m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
 			      "userspace cannot reference function or " .
 			      "variable defined in the kernel\n";
-- 
1.8.4.2

