Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaGNVjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:39:39 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33231 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbaGNVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:38:45 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/7] test: add firmware_class loader test
Date: Mon, 14 Jul 2014 14:38:12 -0700
Message-Id: <1405373897-31671-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a simple interface to trigger the firmware_class loader
to test built-in, filesystem, and user helper modes. Additionally adds
tests via the new interface to the selftests tree.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug                                 |   13 +++
 lib/Makefile                                      |    1 +
 lib/test_firmware.c                               |  117 +++++++++++++++++++++
 tools/testing/selftests/Makefile                  |    1 +
 tools/testing/selftests/firmware/Makefile         |   27 +++++
 tools/testing/selftests/firmware/fw_filesystem.sh |   62 +++++++++++
 tools/testing/selftests/firmware/fw_userhelper.sh |   89 ++++++++++++++++
 7 files changed, 310 insertions(+)
 create mode 100644 lib/test_firmware.c
 create mode 100644 tools/testing/selftests/firmware/Makefile
 create mode 100644 tools/testing/selftests/firmware/fw_filesystem.sh
 create mode 100644 tools/testing/selftests/firmware/fw_userhelper.sh

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7a638aa3545b..213cd9f7e957 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1649,6 +1649,19 @@ config TEST_BPF
 
 	  If unsure, say N.
 
+config TEST_FIRMWARE
+	tristate "Test firmware loading via userspace interface"
+	default n
+	depends on FW_LOADER
+	help
+	  This builds the "test_firmware" module that creates a userspace
+	  interface for testing firmware loading. This can be used to
+	  control the triggering of firmware loading without needing an
+	  actual firmware-using device. The contents can be rechecked by
+	  userspace.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
diff --git a/lib/Makefile b/lib/Makefile
index ba967a19edba..230b4b1456d6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_MODULE) += test_module.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
+obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/test_firmware.c b/lib/test_firmware.c
new file mode 100644
index 000000000000..86374c1c49a4
--- /dev/null
+++ b/lib/test_firmware.c
@@ -0,0 +1,117 @@
+/*
+ * This module provides an interface to trigger and test firmware loading.
+ *
+ * It is designed to be used for basic evaluation of the firmware loading
+ * subsystem (for example when validating firmware verification). It lacks
+ * any extra dependencies, and will not normally be loaded by the system
+ * unless explicitly requested by name.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/firmware.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+static DEFINE_MUTEX(test_fw_mutex);
+static const struct firmware *test_firmware;
+
+static ssize_t test_fw_misc_read(struct file *f, char __user *buf,
+				 size_t size, loff_t *offset)
+{
+	ssize_t rc = 0;
+
+	mutex_lock(&test_fw_mutex);
+	if (test_firmware)
+		rc = simple_read_from_buffer(buf, size, offset,
+					     test_firmware->data,
+					     test_firmware->size);
+	mutex_unlock(&test_fw_mutex);
+	return rc;
+}
+
+static const struct file_operations test_fw_fops = {
+	.owner          = THIS_MODULE,
+	.read           = test_fw_misc_read,
+};
+
+static struct miscdevice test_fw_misc_device = {
+	.minor          = MISC_DYNAMIC_MINOR,
+	.name           = "test_firmware",
+	.fops           = &test_fw_fops,
+};
+
+static ssize_t trigger_request_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int rc;
+	char *name;
+
+	name = kzalloc(count + 1, GFP_KERNEL);
+	if (!name)
+		return -ENOSPC;
+	memcpy(name, buf, count);
+
+	pr_info("loading '%s'\n", name);
+
+	mutex_lock(&test_fw_mutex);
+	release_firmware(test_firmware);
+	test_firmware = NULL;
+	rc = request_firmware(&test_firmware, name, dev);
+	if (rc)
+		pr_info("load of '%s' failed: %d\n", name, rc);
+	pr_info("loaded: %zu\n", test_firmware ? test_firmware->size : 0);
+	mutex_unlock(&test_fw_mutex);
+
+	kfree(name);
+
+	return count;
+}
+static DEVICE_ATTR_WO(trigger_request);
+
+static int __init test_firmware_init(void)
+{
+	int rc;
+
+	rc = misc_register(&test_fw_misc_device);
+	if (rc) {
+		pr_err("could not register misc device: %d\n", rc);
+		return rc;
+	}
+	rc = device_create_file(test_fw_misc_device.this_device,
+				&dev_attr_trigger_request);
+	if (rc) {
+		pr_err("could not create sysfs interface: %d\n", rc);
+		goto dereg;
+	}
+
+	pr_warn("interface ready\n");
+
+	return 0;
+dereg:
+	misc_deregister(&test_fw_misc_device);
+	return rc;
+}
+
+module_init(test_firmware_init);
+
+static void __exit test_firmware_exit(void)
+{
+	release_firmware(test_firmware);
+	device_remove_file(test_fw_misc_device.this_device,
+			   &dev_attr_trigger_request);
+	misc_deregister(&test_fw_misc_device);
+	pr_warn("removed interface\n");
+}
+
+module_exit(test_firmware_exit);
+
+MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index e66e710cc595..5c2bf8ec18f3 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -11,6 +11,7 @@ TARGETS += vm
 TARGETS += powerpc
 TARGETS += user
 TARGETS += sysctl
+TARGETS += firmware
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
new file mode 100644
index 000000000000..e23cce0bbc3a
--- /dev/null
+++ b/tools/testing/selftests/firmware/Makefile
@@ -0,0 +1,27 @@
+# Makefile for firmware loading selftests
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
+all:
+
+fw_filesystem:
+	@if /bin/sh ./fw_filesystem.sh ; then \
+                echo "fw_filesystem: ok"; \
+        else \
+                echo "fw_filesystem: [FAIL]"; \
+                exit 1; \
+        fi
+
+fw_userhelper:
+	@if /bin/sh ./fw_userhelper.sh ; then \
+                echo "fw_userhelper: ok"; \
+        else \
+                echo "fw_userhelper: [FAIL]"; \
+                exit 1; \
+        fi
+
+run_tests: all fw_filesystem fw_userhelper
+
+# Nothing to clean up.
+clean:
+
+.PHONY: all clean run_tests fw_filesystem fw_userhelper
diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/testing/selftests/firmware/fw_filesystem.sh
new file mode 100644
index 000000000000..3fc6c10c2479
--- /dev/null
+++ b/tools/testing/selftests/firmware/fw_filesystem.sh
@@ -0,0 +1,62 @@
+#!/bin/sh
+# This validates that the kernel will load firmware out of its list of
+# firmware locations on disk. Since the user helper does similar work,
+# we reset the custom load directory to a location the user helper doesn't
+# know so we can be sure we're not accidentally testing the user helper.
+set -e
+
+modprobe test_firmware
+
+DIR=/sys/devices/virtual/misc/test_firmware
+
+OLD_TIMEOUT=$(cat /sys/class/firmware/timeout)
+OLD_FWPATH=$(cat /sys/module/firmware_class/parameters/path)
+
+FWPATH=$(mktemp -d)
+FW="$FWPATH/test-firmware.bin"
+
+test_finish()
+{
+	echo "$OLD_TIMEOUT" >/sys/class/firmware/timeout
+	echo -n "$OLD_PATH" >/sys/module/firmware_class/parameters/path
+	rm -f "$FW"
+	rmdir "$FWPATH"
+}
+
+trap "test_finish" EXIT
+
+# Turn down the timeout so failures don't take so long.
+echo 1 >/sys/class/firmware/timeout
+# Set the kernel search path.
+echo -n "$FWPATH" >/sys/module/firmware_class/parameters/path
+
+# This is an unlikely real-world firmware content. :)
+echo "ABCD0123" >"$FW"
+
+NAME=$(basename "$FW")
+
+# Request a firmware that doesn't exist, it should fail.
+echo -n "nope-$NAME" >"$DIR"/trigger_request
+if diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not expected to match" >&2
+	exit 1
+else
+	echo "$0: timeout works"
+fi
+
+# This should succeed via kernel load or will fail after 1 second after
+# being handed over to the user helper, which won't find the fw either.
+if ! echo -n "$NAME" >"$DIR"/trigger_request ; then
+	echo "$0: could not trigger request" >&2
+	exit 1
+fi
+
+# Verify the contents are what we expect.
+if ! diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not loaded" >&2
+	exit 1
+else
+	echo "$0: filesystem loading works"
+fi
+
+exit 0
diff --git a/tools/testing/selftests/firmware/fw_userhelper.sh b/tools/testing/selftests/firmware/fw_userhelper.sh
new file mode 100644
index 000000000000..6efbade12139
--- /dev/null
+++ b/tools/testing/selftests/firmware/fw_userhelper.sh
@@ -0,0 +1,89 @@
+#!/bin/sh
+# This validates that the kernel will fall back to using the user helper
+# to load firmware it can't find on disk itself. We must request a firmware
+# that the kernel won't find, and any installed helper (e.g. udev) also
+# won't find so that we can do the load ourself manually.
+set -e
+
+modprobe test_firmware
+
+DIR=/sys/devices/virtual/misc/test_firmware
+
+OLD_TIMEOUT=$(cat /sys/class/firmware/timeout)
+
+FWPATH=$(mktemp -d)
+FW="$FWPATH/test-firmware.bin"
+
+test_finish()
+{
+	echo "$OLD_TIMEOUT" >/sys/class/firmware/timeout
+	rm -f "$FW"
+	rmdir "$FWPATH"
+}
+
+load_fw()
+{
+	local name="$1"
+	local file="$2"
+
+	# This will block until our load (below) has finished.
+	echo -n "$name" >"$DIR"/trigger_request &
+
+	# Give kernel a chance to react.
+	local timeout=10
+	while [ ! -e "$DIR"/"$name"/loading ]; do
+		sleep 0.1
+		timeout=$(( $timeout - 1 ))
+		if [ "$timeout" -eq 0 ]; then
+			echo "$0: firmware interface never appeared" >&2
+			exit 1
+		fi
+	done
+
+	echo 1 >"$DIR"/"$name"/loading
+	cat "$file" >"$DIR"/"$name"/data
+	echo 0 >"$DIR"/"$name"/loading
+
+	# Wait for request to finish.
+	wait
+}
+
+trap "test_finish" EXIT
+
+# This is an unlikely real-world firmware content. :)
+echo "ABCD0123" >"$FW"
+NAME=$(basename "$FW")
+
+# Test failure when doing nothing (timeout works).
+echo 1 >/sys/class/firmware/timeout
+echo -n "$NAME" >"$DIR"/trigger_request
+if diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not expected to match" >&2
+	exit 1
+else
+	echo "$0: timeout works"
+fi
+
+# Put timeout high enough for us to do work but not so long that failures
+# slow down this test too much.
+echo 4 >/sys/class/firmware/timeout
+
+# Load this script instead of the desired firmware.
+load_fw "$NAME" "$0"
+if diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not expected to match" >&2
+	exit 1
+else
+	echo "$0: firmware comparison works"
+fi
+
+# Do a proper load, which should work correctly.
+load_fw "$NAME" "$FW"
+if ! diff -q "$FW" /dev/test_firmware >/dev/null ; then
+	echo "$0: firmware was not loaded" >&2
+	exit 1
+else
+	echo "$0: user helper firmware loading works"
+fi
+
+exit 0
-- 
1.7.9.5

