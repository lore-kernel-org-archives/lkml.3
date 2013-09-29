Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3I2PKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:10:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39481 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab3I2PKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:10:51 -0400
Date: Sun, 29 Sep 2013 17:10:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: qemu, numa: non-contiguous cpusets
Message-ID: <20130929151044.GB5426@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw,

while I got your attention, on a not-really related topic: how do we
feel about adding support for specifying a non-contiguous set of cpus
for a numa node in qemu with the -numa option? I.e., like this, for
example:

x86_64-softmmu/qemu-system-x86_64 -smp 8 -numa node,nodeid=0,cpus=0\;2\;4-5 -numa node,nodeid=1,cpus=1\;3\;6-7

The ';' needs to be escaped from the shell but I'm open for better
suggestions.

Here's a diff:

---
diff --git a/vl.c b/vl.c
index 4e709d5c1c20..82a6c8451fb0 100644
--- a/vl.c
+++ b/vl.c
@@ -1261,9 +1261,27 @@ char *get_boot_devices_list(size_t *size)
     return list;
 }
 
+static int __numa_set_cpus(unsigned long *map, int start, int end)
+{
+    if (end >= MAX_CPUMASK_BITS) {
+        end = MAX_CPUMASK_BITS - 1;
+        fprintf(stderr,
+            "qemu: NUMA: A max of %d VCPUs are supported\n",
+             MAX_CPUMASK_BITS);
+        return -EINVAL;
+    }
+
+    if (end < start) {
+        return -EINVAL;
+    }
+
+    bitmap_set(map, start, end-start+1);
+    return 0;
+}
+
 static void numa_node_parse_cpus(int nodenr, const char *cpus)
 {
-    char *endptr;
+    char *endptr, *ptr = (char *)cpus;
     unsigned long long value, endvalue;
 
     /* Empty CPU range strings will be considered valid, they will simply
@@ -1273,7 +1291,8 @@ static void numa_node_parse_cpus(int nodenr, const char *cpus)
         return;
     }
 
-    if (parse_uint(cpus, &value, &endptr, 10) < 0) {
+fromthetop:
+    if (parse_uint(ptr, &value, &endptr, 10) < 0) {
         goto error;
     }
     if (*endptr == '-') {
@@ -1282,22 +1301,22 @@ static void numa_node_parse_cpus(int nodenr, const char *cpus)
         }
     } else if (*endptr == '\0') {
         endvalue = value;
-    } else {
-        goto error;
-    }
+    } else if (*endptr == ';') {
+	if (__numa_set_cpus(node_cpumask[nodenr], value, value) < 0) {
+		goto error;
+	}
+	endptr++;
+        if (*endptr == '\0')
+	    return;
 
-    if (endvalue >= MAX_CPUMASK_BITS) {
-        endvalue = MAX_CPUMASK_BITS - 1;
-        fprintf(stderr,
-            "qemu: NUMA: A max of %d VCPUs are supported\n",
-             MAX_CPUMASK_BITS);
-    }
+	ptr = endptr;
 
-    if (endvalue < value) {
+	goto fromthetop;
+    } else {
         goto error;
     }
 
-    bitmap_set(node_cpumask[nodenr], value, endvalue-value+1);
+    __numa_set_cpus(node_cpumask[nodenr], value, endvalue);
     return;
 
 error:
--

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
