Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3KPAf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:35:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59557 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3KPAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 01/28] rcutorture: Add KVM-based test framework
Date: Fri, 15 Nov 2013 16:35:14 -0800
Message-Id: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20131116003517.GA31563@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-000003563795
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the test framework that I used to test RCU under KVM.
This consists of a group of scripts and Kconfig fragments.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 MAINTAINERS                                        |   6 +
 tools/testing/selftests/rcutorture/.gitignore      |   6 +
 .../selftests/rcutorture/bin/config2frag.sh        |  25 +++
 .../selftests/rcutorture/bin/configNR_CPUS.sh      |  45 +++++
 .../selftests/rcutorture/bin/configcheck.sh        |  54 ++++++
 .../testing/selftests/rcutorture/bin/configinit.sh |  83 +++++++++
 tools/testing/selftests/rcutorture/bin/cpus2use.sh |  41 +++++
 .../testing/selftests/rcutorture/bin/functions.sh  |  42 +++++
 .../testing/selftests/rcutorture/bin/kvm-build.sh  |  71 ++++++++
 .../selftests/rcutorture/bin/kvm-recheck.sh        |  46 +++++
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     | 189 +++++++++++++++++++++
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 173 +++++++++++++++++++
 .../selftests/rcutorture/bin/parse-build.sh        |  47 +++++
 .../selftests/rcutorture/bin/parse-console.sh      |  39 +++++
 .../selftests/rcutorture/bin/parse-rcutorture.sh   | 104 ++++++++++++
 .../rcutorture/configs/N1-S-T-NH-SD-SMP-HP         |  19 +++
 .../rcutorture/configs/N2-2-t-nh-sd-SMP-hp         |  20 +++
 .../rcutorture/configs/N3-3-T-nh-SD-SMP-hp         |  22 +++
 .../rcutorture/configs/N4-A-t-NH-sd-SMP-HP         |  18 ++
 .../rcutorture/configs/N5-U-T-NH-sd-SMP-hp         |  22 +++
 .../rcutorture/configs/N6---t-nh-SD-smp-hp         |  19 +++
 .../rcutorture/configs/N7-4-T-NH-SD-SMP-HP         |  26 +++
 .../rcutorture/configs/N8-2-T-NH-SD-SMP-HP         |  22 +++
 tools/testing/selftests/rcutorture/configs/NT1-nh  |  23 +++
 tools/testing/selftests/rcutorture/configs/NT3-NH  |  20 +++
 .../rcutorture/configs/P1-S-T-NH-SD-SMP-HP         |  20 +++
 .../rcutorture/configs/P2-2-t-nh-sd-SMP-hp         |  20 +++
 .../rcutorture/configs/P3-3-T-nh-SD-SMP-hp         |  20 +++
 .../rcutorture/configs/P4-A-t-NH-sd-SMP-HP         |  22 +++
 .../rcutorture/configs/P5-U-T-NH-sd-SMP-hp         |  28 +++
 .../rcutorture/configs/P6---t-nh-SD-smp-hp         |  18 ++
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-HP         |  30 ++++
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all     |  30 ++++
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none    |  30 ++++
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-hp         |  30 ++++
 tools/testing/selftests/rcutorture/configs/PT1-nh  |  23 +++
 tools/testing/selftests/rcutorture/configs/PT2-NH  |  22 +++
 .../rcutorture/configs/sysidleN.2013.06.19a        |  23 +++
 .../rcutorture/configs/sysidleY.2013.06.19a        |  26 +++
 tools/testing/selftests/rcutorture/doc/initrd.txt  |  90 ++++++++++
 .../selftests/rcutorture/doc/rcu-test-image.txt    |  42 +++++
 41 files changed, 1656 insertions(+)
 create mode 100644 tools/testing/selftests/rcutorture/.gitignore
 create mode 100644 tools/testing/selftests/rcutorture/bin/config2frag.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/configcheck.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/configinit.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/cpus2use.sh
 create mode 100644 tools/testing/selftests/rcutorture/bin/functions.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-build.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
 create mode 100644 tools/testing/selftests/rcutorture/bin/kvm.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-build.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-console.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/NT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/NT3-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP
 create mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all
 create mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none
 create mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/PT1-nh
 create mode 100644 tools/testing/selftests/rcutorture/configs/PT2-NH
 create mode 100644 tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a
 create mode 100644 tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a
 create mode 100644 tools/testing/selftests/rcutorture/doc/initrd.txt
 create mode 100644 tools/testing/selftests/rcutorture/doc/rcu-test-image.txt

diff --git a/MAINTAINERS b/MAINTAINERS
index 28f2478b6794..ad574ec44b92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6905,6 +6905,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcu/torture.c
 
+RCUTORTURE TEST FRAMEWORK
+M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
+S:	Supported
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
+F:	tools/testing/selftests/rcutorture
+
 RDC R-321X SoC
 M:	Florian Fainelli <florian@openwrt.org>
 S:	Maintained
diff --git a/tools/testing/selftests/rcutorture/.gitignore b/tools/testing/selftests/rcutorture/.gitignore
new file mode 100644
index 000000000000..05838f6f2ebe
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/.gitignore
@@ -0,0 +1,6 @@
+initrd
+linux-2.6
+b[0-9]*
+rcu-test-image
+res
+*.swp
diff --git a/tools/testing/selftests/rcutorture/bin/config2frag.sh b/tools/testing/selftests/rcutorture/bin/config2frag.sh
new file mode 100644
index 000000000000..252f769c17ba
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/config2frag.sh
@@ -0,0 +1,25 @@
+#!/bin/sh
+# Usage: sh config2frag.sh < .config > configfrag
+#
+# Converts the "# CONFIG_XXX is not set" to "CONFIG_XXX=n" so that the
+# resulting file becomes a legitimate Kconfig fragment.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+LANG=C sed -e 's/^# CONFIG_\([a-zA-Z0-9_]*\) is not set$/CONFIG_\1=n/'
diff --git a/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh b/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh
new file mode 100755
index 000000000000..9e8b11206dcc
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/configNR_CPUS.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+#
+# Extract the number of CPUs expected from the specified Kconfig-file
+# fragment by checking CONFIG_SMP and CONFIG_NR_CPUS.  If the specified
+# file gives no clue, base the number on the number of idle CPUs on
+# the system.
+#
+# Usage: configNR_CPUS.sh config-frag
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+cf=$1
+if test ! -r $cf
+then
+	echo Unreadable config fragment $cf 1>&2
+	exit -1
+fi
+if grep -q '^CONFIG_SMP=n$' $cf
+then
+	echo 1
+	exit 0
+fi
+if grep -q '^CONFIG_NR_CPUS=' $cf
+then
+	grep '^CONFIG_NR_CPUS=' $cf | 
+		sed -e 's/^CONFIG_NR_CPUS=\([0-9]*\).*$/\1/'
+	exit 0
+fi
+cpus2use.sh
diff --git a/tools/testing/selftests/rcutorture/bin/configcheck.sh b/tools/testing/selftests/rcutorture/bin/configcheck.sh
new file mode 100755
index 000000000000..a3e5b9272b46
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/configcheck.sh
@@ -0,0 +1,54 @@
+#!/bin/sh
+# Usage: sh configcheck.sh .config .config-template
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/abat-chk-config.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
+cat $1 > $T/.config
+
+cat $2 | sed -e 's/\(.*\)=n/# \1 is not set/' -e 's/^#CHECK#//' |
+awk	'
+BEGIN	{
+		print "if grep -q \"" $0 "\" < '"$T/.config"'";
+		print "then";
+		print "\t:";
+		print "else";
+		if ($1 == "#") {
+			print "\tif grep -q \"" $2 "\" < '"$T/.config"'";
+			print "\tthen";
+			print "\t\tif test \"$firsttime\" = \"\""
+			print "\t\tthen"
+			print "\t\t\tfirsttime=1"
+			print "\t\tfi"
+			print "\t\techo \":" $2 ": improperly set\"";
+			print "\telse";
+			print "\t\t:";
+			print "\tfi";
+		} else {
+			print "\tif test \"$firsttime\" = \"\""
+			print "\tthen"
+			print "\t\tfirsttime=1"
+			print "\tfi"
+			print "\techo \":" $0 ": improperly set\"";
+		}
+		print "fi";
+	}' | sh
diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
new file mode 100755
index 000000000000..1f09d599e9d9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -0,0 +1,83 @@
+#!/bin/sh
+#
+# sh configinit.sh config-spec-file [ build output dir ]
+#
+# Create a .config file from the spec file.  Run from the kernel source tree.
+# Exits with 0 if all went well, with 1 if all went well but the config
+# did not match, and some other number for other failures.
+#
+# The first argument is the .config specification file, which contains
+# desired settings, for example, "CONFIG_NO_HZ=y".  For best results,
+# this should be a full pathname.
+#
+# The second argument is a optional path to a build output directory,
+# for example, "O=/tmp/foo".  If this argument is omitted, the .config
+# file will be generated directly in the current directory.
+
+echo configinit.sh $*
+
+T=/tmp/configinit.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
+# Capture config spec file.
+
+c=$1
+buildloc=$2
+builddir=
+if test -n $buildloc
+then
+	if echo $buildloc | grep -q '^O='
+	then
+		builddir=`echo $buildloc | sed -e 's/^O=//'`
+		if test ! -d $builddir
+		then
+			mkdir $builddir
+		fi
+	else
+		echo Bad build directory: \"$builddir\"
+		exit 2
+	fi
+fi
+
+sed -e 's/^\(CONFIG[0-9A-Z_]*\)=.*$/grep -v "^# \1" |/' < $c > $T/u.sh
+sed -e 's/^\(CONFIG[0-9A-Z_]*=\).*$/grep -v \1 |/' < $c >> $T/u.sh
+grep '^grep' < $T/u.sh > $T/upd.sh
+echo "cat - $c" >> $T/upd.sh
+make mrproper
+make $buildloc distclean > $builddir/Make.distclean 2>&1
+make $buildloc defconfig > $builddir/Make.defconfig.out 2>&1
+mv $builddir/.config $builddir/.config.sav
+sh $T/upd.sh < $builddir/.config.sav > $builddir/.config
+cp $builddir/.config $builddir/.config.new
+yes '' | make $buildloc oldconfig > $builddir/Make.modconfig.out 2>&1
+
+# verify new config matches specification.
+
+sed -e 's/"//g' < $c > $T/c
+sed -e 's/"//g' < $builddir/.config > $T/.config
+sed -e 's/\(.*\)=n/# \1 is not set/' -e 's/^#CHECK#//' < $c |
+awk	'
+	{
+		print "if grep -q \"" $0 "\" < '"$T/.config"'";
+		print "then";
+		print "\t:";
+		print "else";
+		if ($1 == "#") {
+			print "\tif grep -q \"" $2 "\" < '"$T/.config"'";
+			print "\tthen";
+			print "\t\techo \":" $2 ": improperly set\"";
+			print "\telse";
+			print "\t\t:";
+			print "\tfi";
+		} else {
+			print "\techo \":" $0 ": improperly set\"";
+		}
+		print "fi";
+	}' | sh > $T/diagnostics
+if test -s $T/diagnostics
+then
+	cat $T/diagnostics
+	exit 1
+fi
+exit 0
diff --git a/tools/testing/selftests/rcutorture/bin/cpus2use.sh b/tools/testing/selftests/rcutorture/bin/cpus2use.sh
new file mode 100755
index 000000000000..277a3f6c8210
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/cpus2use.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+#
+# Get an estimate of how CPU-hoggy to be.
+#
+# Usage: cpus2use.sh
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+ncpus=`grep '^processor' /proc/cpuinfo | wc -l`
+idlecpus=`mpstat | tail -1 | \
+	awk -v ncpus=$ncpus '{ print ncpus * ($7 + $12) / 100 }'`
+awk -v ncpus=$ncpus -v idlecpus=$idlecpus < /dev/null '
+BEGIN {
+	cpus2use = idlecpus;
+	if (cpus2use < 1)
+		cpus2use = 1;
+	if (cpus2use < ncpus / 10)
+		cpus2use = ncpus / 10;
+	if (cpus2use == int(cpus2use))
+		cpus2use = int(cpus2use)
+	else
+		cpus2use = int(cpus2use) + 1
+	print cpus2use;
+}'
+
diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
new file mode 100644
index 000000000000..db1c32acdcf6
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -0,0 +1,42 @@
+#!/bin/bash
+#
+# Shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# bootparam_hotplug_cpu bootparam-string
+#
+# Returns 1 if the specified boot-parameter string tells rcutorture to
+# test CPU-hotplug operations.
+bootparam_hotplug_cpu () {
+	echo "$1" | grep -q "rcutorture\.onoff_"
+}
+
+# configfrag_hotplug_cpu config-fragment-file
+#
+# Returns 1 if the config fragment specifies hotplug CPU.
+configfrag_hotplug_cpu () {
+	cf=$1
+	if test ! -r $cf
+	then
+		echo Unreadable config fragment $cf 1>&2
+		exit -1
+	fi
+	grep -q '^CONFIG_HOTPLUG_CPU=y$' $cf
+}
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-build.sh b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
new file mode 100755
index 000000000000..07bbeccb5a28
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-build.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
+#
+# Build a kvm-ready Linux kernel from the tree in the current directory.
+#
+# Usage: sh kvm-build.sh config-template build-dir more-configs
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+config_template=${1}
+if test -z "$config_template" -o ! -f "$config_template" -o ! -r "$config_template"
+then
+	echo "kvm-build.sh :$config_template: Not a readable file"
+	exit 1
+fi
+builddir=${2}
+if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
+then
+	echo "kvm-build.sh :$builddir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+moreconfigs=${3}
+if test -z "$moreconfigs" -o ! -r "$moreconfigs"
+then
+	echo "kvm-build.sh :$moreconfigs: Not a readable file"
+	exit 1
+fi
+
+T=/tmp/test-linux.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
+cat ${config_template} | grep -v CONFIG_RCU_TORTURE_TEST > $T/config
+cat << ___EOF___ >> $T/config
+CONFIG_INITRAMFS_SOURCE="$KVM/initrd"
+CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_CONSOLE=y
+___EOF___
+cat $moreconfigs >> $T/config
+
+configinit.sh $T/config O=$builddir
+retval=$?
+if test $retval -gt 1
+then
+	exit 2
+fi
+ncpus=`cpus2use.sh`
+make O=$builddir -j$ncpus > $builddir/Make.out 2>&1
+retval=$?
+if test $retval -ne 0 || grep "rcu[^/]*": < $builddir/Make.out | egrep -q "Stop|Error|error:|warning:" || egrep -q "Stop|Error|error:" < $builddir/Make.out
+then
+	echo Kernel build error
+	egrep "Stop|Error|error:|warning:" < $builddir/Make.out
+	echo Run aborted.
+	exit 3
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
new file mode 100755
index 000000000000..0876af75b66b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+#
+# Given the results directories for previous KVM runs of rcutorture,
+# check the build and console output for errors.  Given a directory
+# containing results directories, this recursively checks them all.
+#
+# Usage: sh kvm-recheck.sh configdir resdir ...
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
+configdir=${1}
+shift
+for rd in "$@"
+do
+	dirs=`find $rd -name Make.defconfig.out -print | sort | sed -e 's,/[^/]*$,,' | sort -u`
+	for i in $dirs
+	do
+		configfile=`echo $i | sed -e 's/^.*\///'`
+		echo $i
+		configcheck.sh $i/.config $configdir/$configfile
+		parse-build.sh $i/Make.out $configfile
+		parse-rcutorture.sh $i/console.log $configfile
+		parse-console.sh $i/console.log $configfile
+		if test -r $i/Warnings
+		then
+			cat $i/Warnings
+		fi
+	done
+done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
new file mode 100755
index 000000000000..ae5c2ff4c0ce
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -0,0 +1,189 @@
+#!/bin/bash
+#
+# Run a kvm-based test of the specified tree on the specified configs.
+# Fully automated run and error checking, no graphics console.
+#
+# Execute this in the source tree.  Do not run it as a background task
+# because qemu does not seem to like that much.
+#
+# Usage: sh kvm-test-1-rcu.sh config builddir resdir minutes qemu-args bootargs
+#
+# qemu-args defaults to "" -- you will want "-nographic" if running headless.
+# bootargs defaults to	"root=/dev/sda noapic selinux=0 console=ttyS0"
+#			"initcall_debug debug rcutorture.stat_interval=15"
+#			"rcutorture.shutdown_secs=$((minutes * 60))"
+#			"rcutorture.rcutorture_runnable=1"
+#
+# Anything you specify for either qemu-args or bootargs is appended to
+# the default values.  The "-smp" value is deduced from the contents of
+# the config fragment.
+#
+# More sophisticated argument parsing is clearly needed.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+grace=120
+
+T=/tmp/kvm-test-1-rcu.sh.$$
+trap 'rm -rf $T' 0
+
+. $KVM/bin/functions.sh
+
+config_template=${1}
+title=`echo $config_template | sed -e 's/^.*\///'`
+builddir=${2}
+if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
+then
+	echo "kvm-test-1-rcu.sh :$builddir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+resdir=${3}
+if test -z "$resdir" -o ! -d "$resdir" -o ! -w "$resdir"
+then
+	echo "kvm-test-1-rcu.sh :$resdir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+cp $config_template $resdir/ConfigFragment
+echo ' ---' `date`: Starting build
+cat << '___EOF___' >> $T
+CONFIG_RCU_TORTURE_TEST=y
+___EOF___
+# Optimizations below this point
+# CONFIG_USB=n
+# CONFIG_SECURITY=n
+# CONFIG_NFS_FS=n
+# CONFIG_SOUND=n
+# CONFIG_INPUT_JOYSTICK=n
+# CONFIG_INPUT_TABLET=n
+# CONFIG_INPUT_TOUCHSCREEN=n
+# CONFIG_INPUT_MISC=n
+# CONFIG_INPUT_MOUSE=n
+# # CONFIG_NET=n # disables console access, so accept the slower build.
+# CONFIG_SCSI=n
+# CONFIG_ATA=n
+# CONFIG_FAT_FS=n
+# CONFIG_MSDOS_FS=n
+# CONFIG_VFAT_FS=n
+# CONFIG_ISO9660_FS=n
+# CONFIG_QUOTA=n
+# CONFIG_HID=n
+# CONFIG_CRYPTO=n
+# CONFIG_PCCARD=n
+# CONFIG_PCMCIA=n
+# CONFIG_CARDBUS=n
+# CONFIG_YENTA=n
+if kvm-build.sh $config_template $builddir $T
+then
+	cp $builddir/Make*.out $resdir
+	cp $builddir/.config $resdir
+	cp $builddir/arch/x86/boot/bzImage $resdir
+	parse-build.sh $resdir/Make.out $title
+else
+	cp $builddir/Make*.out $resdir
+	echo Build failed, not running KVM, see $resdir.
+	exit 1
+fi
+minutes=$4
+seconds=$(($minutes * 60))
+qemu_args=$5
+boot_args=$6
+
+cd $KVM
+kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
+echo ' ---' `date`: Starting kernel
+if file linux-2.6/*.o | grep -q 64-bit
+then
+	QEMU=qemu-system-x86_64
+else
+	QEMU=qemu-system-i386
+fi
+
+# Generate -smp qemu argument.
+cpu_count=`configNR_CPUS.sh $config_template`
+ncpus=`grep '^processor' /proc/cpuinfo | wc -l`
+if test $cpu_count -gt $ncpus
+then
+	echo CPU count limited from $cpu_count to $ncpus
+	touch $resdir/Warnings
+	echo CPU count limited from $cpu_count to $ncpus >> $resdir/Warnings
+	cpu_count=$ncpus
+fi
+if echo $qemu_args | grep -q -e -smp
+then
+	echo CPU count specified by caller
+else
+	qemu_args="$qemu_args -smp $cpu_count"
+fi
+
+# Generate CPU-hotplug boot parameters
+if ! bootparam_hotplug_cpu "$bootargs"
+then
+	if configfrag_hotplug_cpu $builddir/.config
+	then
+		echo Kernel configured for CPU hotplug, adding rcutorture.
+		bootargs="$bootargs rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30"
+	fi
+fi
+
+echo $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args\" > $resdir/qemu-cmd
+$QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args" &
+qemu_pid=$!
+commandcompleted=0
+echo Monitoring qemu job at pid $qemu_pid
+for ((i=0;i<$seconds;i++))
+do
+	if kill -0 $qemu_pid > /dev/null 2>&1
+	then
+		sleep 1
+	else
+		commandcompleted=1
+		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
+		if test $kruntime -lt $seconds
+		then
+			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
+		else
+			echo ' ---' `date`: Kernel done
+		fi
+		break
+	fi
+done
+if test $commandcompleted -eq 0
+then
+	echo Grace period for qemu job at pid $qemu_pid
+	for ((i=0;i<=$grace;i++))
+	do
+		if kill -0 $qemu_pid > /dev/null 2>&1
+		then
+			sleep 1
+		else
+			break
+		fi
+		if test $i -eq $grace
+		then
+			kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }'`
+			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
+			kill -KILL $qemu_pid
+		fi
+	done
+fi
+
+cp $builddir/console.log $resdir
+parse-rcutorture.sh $resdir/console.log $title >> $resdir/Warnings 2>&1
+parse-console.sh $resdir/console.log $title >> $resdir/Warnings 2>&1
+cat $resdir/Warnings
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
new file mode 100644
index 000000000000..46c75ee2f528
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -0,0 +1,173 @@
+#!/bin/bash
+#
+# Run a series of 14 tests under KVM.  These are not particularly
+# well-selected or well-tuned, but are the current set.  Run from the
+# top level of the source tree.
+#
+# Edit the definitions below to set the locations of the various directories,
+# as well as the test duration.
+#
+# Usage: sh kvm.sh [ options ]
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+scriptname=$0
+
+dur=30
+KVM=`pwd`/tools/testing/selftests/rcutorture; export KVM
+builddir=${KVM}/b1
+resdir=""
+configs=" sysidleY.2013.06.19a \
+	  sysidleN.2013.06.19a \
+	  P1-S-T-NH-SD-SMP-HP \
+	  P2-2-t-nh-sd-SMP-hp \
+	  P3-3-T-nh-SD-SMP-hp \
+	  P4-A-t-NH-sd-SMP-HP \
+	  P5-U-T-NH-sd-SMP-hp \
+	  P6---t-nh-SD-smp-hp \
+	  N1-S-T-NH-SD-SMP-HP \
+	  N2-2-t-nh-sd-SMP-hp \
+	  N3-3-T-nh-SD-SMP-hp \
+	  N4-A-t-NH-sd-SMP-HP \
+	  N5-U-T-NH-sd-SMP-hp \
+	  PT1-nh \
+	  PT2-NH \
+	  NT1-nh \
+	  NT3-NH"
+
+usage () {
+	echo "Usage: $scriptname optional arguments:"
+	echo "       --builddir absolute-pathname"
+	echo "       --configs \"config-file list\""
+	echo "       --duration minutes"
+	echo "       --rcu-kvm absolute-pathname"
+	echo "       --results absolute-pathname"
+	echo "       --relbuilddir relative-pathname"
+	exit 1
+}
+
+# checkarg --argname argtype $# arg mustmatch cannotmatch
+checkarg () {
+	if test $3 -le 1
+	then
+		echo $1 needs argument $2 matching \"$5\"
+		usage
+	fi
+	if echo "$4" | grep -q -e "$5"
+	then
+		:
+	else
+		echo $1 $2 \"$4\" must match \"$5\"
+		usage
+	fi
+	if echo "$4" | grep -q -e "$6"
+	then
+		echo $1 $2 \"$4\" must not match \"$6\"
+		usage
+	fi
+}
+
+while test $# -gt 0
+do
+	echo ":$1:"
+	case "$1" in
+	--builddir)
+		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' error
+		builddir=$2
+		gotbuilddir=1
+		shift
+		;;
+	--configs)
+		checkarg --configs "(list of config files)" "$#" "$2" '^[^/]*$' '^--'
+		configs="$2"
+		shift
+		;;
+	--duration)
+		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' error
+		dur=$2
+		shift
+		;;
+	--rcu-kvm)
+		checkarg --rcu-kvm "(absolute pathname)" "$#" "$2" '^/' error
+		KVM=$2; export KVM
+		if -z "$gotbuilddir"
+		then
+			builddir=${KVM}/b1
+		fi
+		if -n "$gotrelbuilddir"
+		then
+			builddir=${KVM}/${relbuilddir}
+		fi
+		shift
+		;;
+	--relbuilddir)
+		checkarg --relbuilddir "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
+		relbuilddir=$2
+		gotrelbuilddir=1
+		builddir=${KVM}/${relbuilddir}
+		shift
+		;;
+	--results)
+		checkarg --results "(absolute pathname)" "$#" "$2" '^/' error
+		resdir=$2
+		shift
+		;;
+	*)
+		usage
+		;;
+	esac
+	shift
+done
+
+echo "builddir=$builddir"
+echo "dur=$dur"
+echo "KVM=$KVM"
+echo "resdir=$resdir"
+
+PATH=${KVM}/bin:$PATH; export PATH
+CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
+
+if test -z "$resdir"
+then
+	resdir=$KVM/res
+	mkdir $resdir || :
+	ds=`date +%Y.%m.%d-%H:%M:%S`
+	mkdir $resdir/$ds
+	echo Datestamp: $ds
+else
+	mkdir -p "$resdir"
+	ds=""
+fi
+pwd > $resdir/$ds/testid.txt
+if test -d .git
+then
+	git status >> $resdir/$ds/testid.txt
+	git rev-parse HEAD >> $resdir/$ds/testid.txt
+fi
+builddir=$KVM/b1
+mkdir $builddir || :
+
+for CF in $configs
+do
+	rd=$resdir/$ds/$CF
+	mkdir $rd || :
+	echo Results directory: $rd
+	kvm-test-1-rcu.sh $CONFIGFRAG/$CF $builddir $rd $dur "-nographic" "rcutorture.test_no_idle_hz=1 rcutorture.n_barrier_cbs=4 rcutorture.verbose=1"
+done
+# Tracing: trace_event=rcu:rcu_nocb_grace_period,rcu:rcu_grace_period,rcu:rcu_grace_period_init,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_torture_read,rcu:rcu_invoke_callback,rcu:rcu_fqs,rcu:rcu_dyntick,rcu:rcu_unlock_preempted_task
diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
new file mode 100755
index 000000000000..2e0e9f7ebbb0
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
@@ -0,0 +1,47 @@
+#!/bin/sh
+#
+# Check the build output from an rcutorture run for goodness.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# The file must contain kernel build output.
+#
+# Usage:
+#	sh parse-build.sh file title
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=$1
+title=$2
+
+if grep -q CC < $T
+then
+	:
+else
+	echo $title no build
+	exit 1
+fi
+
+if egrep -q "error:|rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+then
+	echo $title build errors:
+	egrep "error:|rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+	exit 2
+fi
+exit 0
diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
new file mode 100755
index 000000000000..bc1496fa1263
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -0,0 +1,39 @@
+#!/bin/sh
+#
+# Check the console output from an rcutorture run for oopses.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# Usage:
+#	sh parse-console.sh file title
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/abat-chk-badness.sh.$$
+trap 'rm -f $T' 0
+
+file="$1"
+title="$2"
+
+egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
+if test -s $T
+then
+	echo Assertion failure in $file $title
+	cat $T
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
new file mode 100755
index 000000000000..37368a046a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
@@ -0,0 +1,104 @@
+#!/bin/sh
+#
+# Check the console output from an rcutorture run for goodness.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# The file must contain rcutorture output, but can be interspersed
+# with other dmesg text.
+#
+# Usage:
+#	sh parse-rcutorture.sh file title
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/parse-rcutorture.sh.$$
+file="$1"
+title="$2"
+
+trap 'rm -f $T.seq' 0
+
+# check for presence of rcutorture.txt file
+
+if test -f "$file" -a -r "$file"
+then
+	:
+else
+	echo $title unreadable rcutorture.txt file: $file
+	exit 1
+fi
+
+# check for abject failure
+
+if grep -q FAILURE $file || grep -q -e '-torture.*!!!' $file
+then
+	nerrs=`grep --binary-files=text '!!!' $file | tail -1 | awk '{for (i=NF-8;i<=NF;i++) sum+=$i; } END {print sum}'`
+	echo $title FAILURE, $nerrs instances
+	echo "   " $url
+	exit
+fi
+
+grep --binary-files=text 'torture:.*ver:' $file | grep --binary-files=text -v '(null)' | sed -e 's/^(initramfs)[^]]*] //' -e 's/^\[[^]]*] //' |
+awk '
+BEGIN	{
+	ver = 0;
+	badseq = 0;
+	}
+
+	{
+	if (!badseq && ($5 + 0 != $5 || $5 <= ver)) {
+		badseqno1 = ver;
+		badseqno2 = $5;
+		badseqnr = NR;
+		badseq = 1;
+	}
+	ver = $5
+	}
+
+END	{
+	if (badseq) {
+		if (badseqno1 == badseqno2 && badseqno2 == ver)
+			print "RCU GP HANG at " ver " rcutorture stat " badseqnr;
+		else
+			print "BAD SEQ " badseqno1 ":" badseqno2 " last:" ver " RCU version " badseqnr;
+	}
+	}' > $T.seq
+
+if grep -q SUCCESS $file
+then
+	if test -s $T.seq
+	then
+		echo WARNING $title `cat $T.seq`
+		echo "   " $file
+		exit 2
+	fi
+else
+	if grep -q RCU_HOTPLUG $file
+	then
+		echo WARNING: HOTPLUG FAILURES $title `cat $T.seq`
+		echo "   " $file
+		exit 3
+	fi
+	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful RCU version messages
+	if test -s $T.seq
+	then
+		echo WARNING $title `cat $T.seq`
+	fi
+	exit 2
+fi
diff --git a/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..d81e11d280aa
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..02e418572b1b
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b3100f69c8cf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..c56b44530725
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..90d924fea9e9
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp
new file mode 100644
index 000000000000..0ccc36d72738
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp
@@ -0,0 +1,19 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_NR_CPUS=1
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..3f640cf84973
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,26 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..285da2dd8ac3
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=14
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/NT1-nh b/tools/testing/selftests/rcutorture/configs/NT1-nh
new file mode 100644
index 000000000000..023f312a931c
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/NT1-nh
@@ -0,0 +1,23 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/NT3-NH b/tools/testing/selftests/rcutorture/configs/NT3-NH
new file mode 100644
index 000000000000..6fd0235dae73
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/NT3-NH
@@ -0,0 +1,20 @@
+#CHECK#CONFIG_TINY_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..9647c44cf4b7
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp
new file mode 100644
index 000000000000..0f3b667d2a9f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=4
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp
new file mode 100644
index 000000000000..b035e141bf2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp
@@ -0,0 +1,20 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=n
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP
new file mode 100644
index 000000000000..3ccf6a9447f5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP
@@ -0,0 +1,22 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp
new file mode 100644
index 000000000000..ef624ce73d8e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp
@@ -0,0 +1,28 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=6
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_RT_MUTEXES=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp
new file mode 100644
index 000000000000..f4c9175828bf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp
@@ -0,0 +1,18 @@
+CONFIG_RCU_TRACE=n
+CONFIG_NO_HZ=n
+CONFIG_SMP=n
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP
new file mode 100644
index 000000000000..77a8c5b75763
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all
new file mode 100644
index 000000000000..0eecebc6e95f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none
new file mode 100644
index 000000000000..0eecebc6e95f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_RCU_NOCB_CPU_ZERO=n
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp
new file mode 100644
index 000000000000..588bc70420cd
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp
@@ -0,0 +1,30 @@
+CONFIG_RCU_TRACE=y
+CONFIG_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=2
+CONFIG_NR_CPUS=16
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=n
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_RCU_NOCB_CPU_ALL=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_SLUB=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/PT1-nh b/tools/testing/selftests/rcutorture/configs/PT1-nh
new file mode 100644
index 000000000000..e3361c3894a1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/PT1-nh
@@ -0,0 +1,23 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=n
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/PT2-NH b/tools/testing/selftests/rcutorture/configs/PT2-NH
new file mode 100644
index 000000000000..64abfc3b4d94
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/PT2-NH
@@ -0,0 +1,22 @@
+CONFIG_TINY_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+#
+CONFIG_SMP=n
+#
+CONFIG_HOTPLUG_CPU=n
+#
+CONFIG_NO_HZ=y
+#
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a b/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a
new file mode 100644
index 000000000000..9dbcde3a517e
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a
@@ -0,0 +1,23 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_SYSIDLE=n
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
diff --git a/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a b/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a
new file mode 100644
index 000000000000..d24dd6148ebf
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a
@@ -0,0 +1,26 @@
+CONFIG_RCU_TRACE=y
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_NO_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_SYSIDLE=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_SMP=y
+CONFIG_RCU_FANOUT=8
+CONFIG_NR_CPUS=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_RCU_TORTURE_TEST=m
+CONFIG_MODULE_UNLOAD=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_PRINTK_TIME=y
+
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+
diff --git a/tools/testing/selftests/rcutorture/doc/initrd.txt b/tools/testing/selftests/rcutorture/doc/initrd.txt
new file mode 100644
index 000000000000..49d134c25c04
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/initrd.txt
@@ -0,0 +1,90 @@
+This document describes one way to create the initrd directory hierarchy
+in order to allow an initrd to be built into your kernel.  The trick
+here is to steal the initrd file used on your Linux laptop, Ubuntu in
+this case.  There are probably much better ways of doing this.
+
+That said, here are the commands:
+
+------------------------------------------------------------------------
+zcat /initrd.img > /tmp/initrd.img.zcat
+mkdir initrd
+cd initrd
+cpio -id < /tmp/initrd.img.zcat
+------------------------------------------------------------------------
+
+Interestingly enough, if you are running rcutorture, you don't really
+need userspace in many cases.  Running without userspace has the
+advantage of allowing you to test your kernel independently of the
+distro in place, the root-filesystem layout, and so on.  To make this
+happen, put the following script in the initrd's tree's "/init" file,
+with 0755 mode.
+
+------------------------------------------------------------------------
+#!/bin/sh
+
+[ -d /dev ] || mkdir -m 0755 /dev
+[ -d /root ] || mkdir -m 0700 /root
+[ -d /sys ] || mkdir /sys
+[ -d /proc ] || mkdir /proc
+[ -d /tmp ] || mkdir /tmp
+mkdir -p /var/lock
+mount -t sysfs -o nodev,noexec,nosuid sysfs /sys
+mount -t proc -o nodev,noexec,nosuid proc /proc
+# Some things don't work properly without /etc/mtab.
+ln -sf /proc/mounts /etc/mtab
+
+# Note that this only becomes /dev on the real filesystem if udev's scripts
+# are used; which they will be, but it's worth pointing out
+if ! mount -t devtmpfs -o mode=0755 udev /dev; then
+	echo "W: devtmpfs not available, falling back to tmpfs for /dev"
+	mount -t tmpfs -o mode=0755 udev /dev
+	[ -e /dev/console ] || mknod --mode=600 /dev/console c 5 1
+	[ -e /dev/kmsg ] || mknod --mode=644 /dev/kmsg c 1 11
+	[ -e /dev/null ] || mknod --mode=666 /dev/null c 1 3
+fi
+
+mkdir /dev/pts
+mount -t devpts -o noexec,nosuid,gid=5,mode=0620 devpts /dev/pts || true
+mount -t tmpfs -o "nosuid,size=20%,mode=0755" tmpfs /run
+mkdir /run/initramfs
+# compatibility symlink for the pre-oneiric locations
+ln -s /run/initramfs /dev/.initramfs
+
+# Export relevant variables
+export ROOT=
+export ROOTDELAY=
+export ROOTFLAGS=
+export ROOTFSTYPE=
+export IP=
+export BOOT=
+export BOOTIF=
+export UBIMTD=
+export break=
+export init=/sbin/init
+export quiet=n
+export readonly=y
+export rootmnt=/root
+export debug=
+export panic=
+export blacklist=
+export resume=
+export resume_offset=
+export recovery=
+
+for i in /sys/devices/system/cpu/cpu*/online
+do
+	case $i in
+	'/sys/devices/system/cpu/cpu0/online')
+		;;
+	'/sys/devices/system/cpu/cpu*/online')
+		;;
+	*)
+		echo 1 > $i
+		;;
+	esac
+done
+
+while :
+do
+	sleep 10
+done
diff --git a/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt b/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt
new file mode 100644
index 000000000000..66efb59a1bd1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/rcu-test-image.txt
@@ -0,0 +1,42 @@
+This document describes one way to created the rcu-test-image file
+that contains the filesystem used by the guest-OS kernel.  There are
+probably much better ways of doing this, and this filesystem could no
+doubt be smaller.  It is probably also possible to simply download
+an appropriate image from any number of places.
+
+That said, here are the commands:
+
+------------------------------------------------------------------------
+dd if=/dev/zero of=rcu-test-image bs=400M count=1
+mkfs.ext3 ./rcu-test-image
+sudo mount -o loop ./rcu-test-image /mnt
+
+# Replace "precise" below with your favorite Ubuntu release.
+# Empirical evidence says this image will work for 64-bit, but...
+# Note that debootstrap does take a few minutes to run.  Or longer.
+sudo debootstrap --verbose --arch i386 precise /mnt http://archive.ubuntu.com/ubuntu
+cat << '___EOF___' | sudo dd of=/mnt/etc/fstab
+# UNCONFIGURED FSTAB FOR BASE SYSTEM
+#
+/dev/vda        /               ext3    defaults        1 1
+dev             /dev            tmpfs   rw              0 0
+tmpfs           /dev/shm        tmpfs   defaults        0 0
+devpts          /dev/pts        devpts  gid=5,mode=620  0 0
+sysfs           /sys            sysfs   defaults        0 0
+proc            /proc           proc    defaults        0 0
+___EOF___
+sudo umount /mnt
+------------------------------------------------------------------------
+
+
+References:
+
+	http://sripathikodi.blogspot.com/2010/02/creating-kvm-bootable-fedora-system.html
+	https://help.ubuntu.com/community/KVM/CreateGuests
+	https://help.ubuntu.com/community/JeOSVMBuilder
+	http://wiki.libvirt.org/page/UbuntuKVMWalkthrough
+	http://www.moe.co.uk/2011/01/07/pci_add_option_rom-failed-to-find-romfile-pxe-rtl8139-bin/ -- "apt-get install kvm-pxe"
+	http://www.landley.net/writing/rootfs-howto.html
+	http://en.wikipedia.org/wiki/Initrd
+	http://en.wikipedia.org/wiki/Cpio
+	http://wiki.libvirt.org/page/UbuntuKVMWalkthrough
-- 
1.8.1.5

