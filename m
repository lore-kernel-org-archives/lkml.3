Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101AbaKNDmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:42:15 -0500
Received: from ozlabs.org ([103.22.144.67]:43415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934141AbaKNDmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:42:14 -0500
Message-ID: <1415936530.26378.2.camel@concordia>
Subject: Re: kdbus: add selftests
From: Michael Ellerman <mpe@ellerman.id.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Date: Fri, 14 Nov 2014 14:42:10 +1100
In-Reply-To: <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	 <1414620056-6675-13-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 15:00 -0700, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@zonque.org>
> 
> This patch adds a quite extensive test suite for kdbus that checks
> the most important code pathes in the driver. The idea is to extend
> the test suite over time.
> 
> Also, this code can serve as an example implementation to show how to
> use the kernel API from userspace.

Great to see selftests included.

I needed this to get them building:

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index b70237e8bc37..b1438a02e49f 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -210,6 +210,7 @@ header-y += ixjuser.h
 header-y += jffs2.h
 header-y += joystick.h
 header-y += kd.h
+header-y += kdbus.h
 header-y += kdev_t.h
 header-y += kernel-page-flags.h
 header-y += kernel.h
diff --git a/tools/testing/selftests/kdbus/Makefile b/tools/testing/selftests/kdbus/Makefile
index 0f6a745202af..96766c12a6e3 100644
--- a/tools/testing/selftests/kdbus/Makefile
+++ b/tools/testing/selftests/kdbus/Makefile
@@ -2,7 +2,7 @@ CFLAGS += -I../../../../usr/include/
 CFLAGS += -I../../../../include/uapi/
 CFLAGS += -std=gnu99
 CFLAGS += -DKBUILD_MODNAME=\"kdbus\" -D_GNU_SOURCE
-LDFLAGS = -pthread -lcap
+LDLIBS = -pthread -lcap
 
 OBJS= \
        kdbus-enum.o            \
@@ -37,7 +37,7 @@ all: kdbus-test
        gcc $(CFLAGS) -c $< -o $@
 
 kdbus-test: $(OBJS)
-       gcc $(CFLAGS) $(LDFLAGS) $^ -o $@
+       gcc $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@
 
 run_tests:
        ./kdbus-test


And with that it's all happy on ppc64le:

Testing bus make functions (bus-make) .................................. OK
Testing the HELLO command (hello) ...................................... OK
Testing the BYEBYE command (byebye) .................................... OK
Testing a chat pattern (chat) .......................................... OK
Testing a simple dameon (daemon) ....................................... OK
Testing file descriptor passing (fd-passing) ........................... OK
Testing custom endpoint (endpoint) ..................................... OK
Testing monitor functionality (monitor) ................................ OK
Testing basic name registry functions (name-basics) .................... OK
Testing name registry conflict details (name-conflict) ................. OK
Testing queuing of names (name-queue) .................................. OK
Testing basic message handling (message-basic) ......................... OK
Testing handling of messages with priority (message-prio) .............. OK
Testing timeout (timeout) .............................................. OK
Testing synchronous replies vs. BYEBYE (sync-byebye) ................... OK
Testing synchronous replies (sync-reply) ............................... OK
Testing freeing of memory (message-free) ............................... OK
Testing retrieving connection information (connection-info) ............ OK
Testing updating connection information (connection-update) ............ OK
Testing verifying pools are never writable (writable-pool) ............. OK
Testing policy (policy) ................................................ OK
Testing unprivileged bus access (policy-priv) .......................... OK
Testing policy in user namespaces (policy-ns) .......................... OK
Testing metadata in user namespaces (metadata-ns) ...................... OK
Testing adding of matches by id (match-id-add) ......................... OK
Testing removing of matches by id (match-id-remove) .................... OK
Testing adding of matches by name (match-name-add) ..................... OK
Testing removing of matches by name (match-name-remove) ................ OK
Testing matching for name changes (match-name-change) .................. OK
Testing matching with bloom filters (match-bloom) ...................... OK
Testing activator connections (activator) .............................. OK
Testing creating a domain (domain-make) ................................ OK
Testing benchmark (benchmark) .......................................... OK
Testing race multiple byebyes (race-byebye) ............................ OK
Testing race byebye vs match removal (race-byebye-match) ............... OK

SUMMARY: 35 tests passed, 0 skipped, 0 failed


cheers


