Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaCTJoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:44:00 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36616 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaCTJn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:43:57 -0400
Subject: [PATCH 31/33] Spec file
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:13:37 +0530
Message-ID: <20140320094337.14878.60232.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-3568-0000-0000-00000520E713
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the Spec file for the package

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 Makefile.am      |    5 ++++
 configure.ac     |    2 +-
 gencore.spec.in  |   67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libgencore.pc.in |    8 ++++++
 4 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 gencore.spec.in
 create mode 100644 libgencore.pc.in

diff --git a/Makefile.am b/Makefile.am
index 8b31e4f..30e86f5 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,2 +1,7 @@
 AUTOMAKE_OPTIONS = foreign
 SUBDIRS = src doc
+
+EXTRA_DIST = src/coredump.h src/elf.c src/elf-compat.h doc/gencore.1 doc/gencore.3 Changelog COPYING.LIBGENCORE
+
+pkgconfigdir = $(libdir)/pkgconfig
+pkgconfig_DATA = libgencore.pc
diff --git a/configure.ac b/configure.ac
index 9e130e0..6245ae1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,5 +3,5 @@ LT_INIT()
 AM_INIT_AUTOMAKE([-Wall -Werror foreign])
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_CC
-AC_CONFIG_FILES(Makefile)
+AC_CONFIG_FILES(Makefile gencore.spec libgencore.pc)
 AC_OUTPUT(src/Makefile doc/Makefile)
diff --git a/gencore.spec.in b/gencore.spec.in
new file mode 100644
index 0000000..58c699e
--- /dev/null
+++ b/gencore.spec.in
@@ -0,0 +1,67 @@
+Name: gencore
+Version: @VERSION@
+Release: 0
+License: GPLv2
+Group: Applications/System
+Source: %{name}-%{version}.tar.gz
+Summary: Tool for capturing application core dump non-disruptively.
+
+%package -n libgencore
+Group: System Environment/Libraries
+Summary: Library interface for generating non-disruptive core dump.
+Requires: gencore == %{version}
+ 
+%package -n libgencore-devel
+Group: Development/Libraries
+Summary: libgencore development files
+
+%description
+This package, helps in taking non-disruptive coredumps of a process,
+when requested for. When the PID of a process is passed to this command,
+this command takes a dump of that process and stores the dump in the
+filename specified or by default core.pid in the current working directory.
+
+%description -n libgencore
+The library libgencore, sets up the interface for such dump
+requests and provides an API for initiating a dump of the running
+program via gencore daemon.
+
+%description -n libgencore-devel
+This package contains necessary header files for libgencore.
+
+%prep
+%setup
+
+%build
+%configure
+make
+
+%install
+make DESTDIR=$RPM_BUILD_ROOT install
+
+%files
+%doc README COPYING Changelog
+%{_bindir}/gencore
+%{_mandir}/man1/gencore.1*
+
+%files -n libgencore
+%doc COPYING.LIBGENCORE
+%{_libdir}/libgencore.so.*
+%{_mandir}/man3/gencore.3*
+
+%files -n libgencore-devel
+%{_includedir}/gencore.h
+%{_libdir}/libgencore.so
+%{_libdir}/libgencore.a
+%{_libdir}/libgencore.la
+%{_libdir}/pkgconfig/libgencore.pc
+
+%post -n libgencore
+ldconfig -n %{_libdir}/libgencore.so.*
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%changelog
+* Mon Dec 23 2013  - Janani Venkataraman <jananive@linux.vnet.ibm.com>
+- Initial Version
diff --git a/libgencore.pc.in b/libgencore.pc.in
new file mode 100644
index 0000000..b24dc0e
--- /dev/null
+++ b/libgencore.pc.in
@@ -0,0 +1,8 @@
+prefix=@prefix@
+exec_prefix=@exec_prefix@
+libdir=@libdir@
+includedir=@includedir@
+
+Name: libgencore
+Libs:-L${libdir} -lgencore
+Cflags: -I${includedir}

