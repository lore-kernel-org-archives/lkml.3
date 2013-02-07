Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3BGXNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:13:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3BGXNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:13:35 -0500
Date: Thu, 7 Feb 2013 15:13:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/3 v3] selftests: Add tests for efivarfs
Message-Id: <20130207151333.f01d415c.akpm@linux-foundation.org>
In-Reply-To: <1360162088.143076.913706486688.1.gpush@pecola>
References: <1360162088.142733.191120808822.0.gpush@pecola>
	<1360162088.143076.913706486688.1.gpush@pecola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2013 22:48:08 +0800
Jeremy Kerr <jk@ozlabs.org> wrote:

> This change adds a few initial efivarfs tests to the
> tools/testing/selftests directory.
> 
> The open-unlink test is based on code from
> Lingzhu Xiang <lxiang@redhat.com>.
> 
> ...
>
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,4 +1,4 @@
> -TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
> +TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs

bah.  This sort of Makefile construct is a wonderful source of patch
rejects and fixups.  I'll covert this to

--- a/tools/testing/selftests/Makefile~a
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,11 @@
-TARGETS = breakpoints epoll kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
+TARGETS = breakpoints
+TARGETS += epoll
+TARGETS += kcmp
+TARGETS += mqueue
+TARGETS += vm
+TARGETS += cpu-hotplug
+TARGETS += memory-hotplug
+TARGETS += efivarfs
 
 all:
 	for TARGET in $(TARGETS); do \

> new file mode 100644
> index 0000000..1a943ee
> --- /dev/null
> +++ b/tools/testing/selftests/efivarfs/Makefile
> @@ -0,0 +1,12 @@
> +CC = $(CROSS_COMPILE)gcc
> +CFLAGS = -Wall
> +
> +test_objs = open-unlink
> +
> +all: $(test_objs)
> +
> +run_tests: all
> +	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"

Problem.  When I apply the patch, ./efivarfs.sh doesn't have execute
permissions.  I don't think there's a way of (reliably?) transporting
this with patch and diff.

So we should explicitly invoke sh or /bin/sh or $SHELL or whatever
here.  This problem is common to several Makefiles in tools/testing/selftests/

I'll do this for now:

--- a/tools/testing/selftests/efivarfs/Makefile~selftests-add-tests-for-efivarfs-fix
+++ a/tools/testing/selftests/efivarfs/Makefile
@@ -6,7 +6,7 @@ test_objs = open-unlink
 all: $(test_objs)
 
 run_tests: all
-	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+	@/bin/sh ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
 
 clean:
 	rm -f $(test_objs)

but I'm not sure I did it right :(


The general ruleset for selftests is: do as much as you can if you're not
root and don't take too long and don't break the build on any
architecture and don't cause the top-level "make run_tests" to fail if
your feature is unconfigured.

Does this code pass all that?
