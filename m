Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaGNVit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:38:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54414 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756915AbaGNVih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:38:37 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] test: add "fd" firmware loading test to selftests
Date: Mon, 14 Jul 2014 14:38:17 -0700
Message-Id: <1405373897-31671-8-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds tests for the new "fd" interface to the firmware selftests.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/firmware/fw_userhelper.sh |   34 ++++++++++++++++++---
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/firmware/fw_userhelper.sh b/tools/testing/selftests/firmware/fw_userhelper.sh
index 6efbade12139..e2766613e5b5 100644
--- a/tools/testing/selftests/firmware/fw_userhelper.sh
+++ b/tools/testing/selftests/firmware/fw_userhelper.sh
@@ -25,6 +25,7 @@ load_fw()
 {
 	local name="$1"
 	local file="$2"
+	local fd="$3"
 
 	# This will block until our load (below) has finished.
 	echo -n "$name" >"$DIR"/trigger_request &
@@ -40,9 +41,16 @@ load_fw()
 		fi
 	done
 
-	echo 1 >"$DIR"/"$name"/loading
-	cat "$file" >"$DIR"/"$name"/data
-	echo 0 >"$DIR"/"$name"/loading
+	if [ -z "$fd" ]; then
+		echo 1 >"$DIR"/"$name"/loading
+		cat "$file" >"$DIR"/"$name"/data
+		echo 0 >"$DIR"/"$name"/loading
+	else
+		if ! echo "$fd" <"$file" >"$DIR"/"$name"/fd 2>/dev/null ; then
+			# If the echo fails, abort to avoid timeout.
+			echo -1 > "$DIR"/"$name"/loading
+		fi
+	fi
 
 	# Wait for request to finish.
 	wait
@@ -83,7 +91,25 @@ if ! diff -q "$FW" /dev/test_firmware >/dev/null ; then
 	echo "$0: firmware was not loaded" >&2
 	exit 1
 else
-	echo "$0: user helper firmware loading works"
+	echo "$0: user helper firmware via 'loading' works"
+fi
+
+# Request a bad file descriptor, expected to fail.
+load_fw "$NAME" "$FW" 100
+if diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not expected to match" >&2
+	exit 1
+else
+	echo "$0: bad file descriptor correctly fails"
+fi
+
+# Request with the correct file descriptor.
+load_fw "$NAME" "$FW" 0
+if ! diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: failed to load with good fd" >&2
+	exit 1
+else
+	echo "$0: user helper firmware via 'fd' works"
 fi
 
 exit 0
-- 
1.7.9.5

