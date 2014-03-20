Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaCTJoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:44:16 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39961 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbaCTJoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:44:10 -0400
Subject: [PATCH 32/33] Socket and Service files.
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
Date: Thu, 20 Mar 2014 15:13:55 +0530
Message-ID: <20140320094355.14878.93423.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-5140-0000-0000-000004C01E92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The socket and service files for systemd are created.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 Makefile.am      |   15 +++++++++++++++
 configure.ac     |    1 +
 gencore.service  |    9 +++++++++
 gencore.socket   |   10 ++++++++++
 gencore.spec.in  |   21 +++++++++++++++++++++
 gencore@.service |    9 +++++++++
 6 files changed, 65 insertions(+)
 create mode 100644 gencore.service
 create mode 100644 gencore.socket
 create mode 100644 gencore@.service

diff --git a/Makefile.am b/Makefile.am
index 30e86f5..4c6c269 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,5 +3,20 @@ SUBDIRS = src doc
 
 EXTRA_DIST = src/coredump.h src/elf.c src/elf-compat.h doc/gencore.1 doc/gencore.3 Changelog COPYING.LIBGENCORE
 
+if HAVE_SYSTEMD_SOCKET_SUPPORT 
+EXTRA_DIST += gencore.socket gencore@.service
+else
+EXTRA_DIST += gencore.service
+endif
+
 pkgconfigdir = $(libdir)/pkgconfig
 pkgconfig_DATA = libgencore.pc
+
+systemddir = /usr/lib/systemd
+systemdir = /usr/lib/systemd/system
+
+if HAVE_SYSTEMD_SOCKET_SUPPORT
+system_DATA = gencore@.service gencore.socket
+else
+system_DATA = gencore.service
+endif
diff --git a/configure.ac b/configure.ac
index 6245ae1..39d7902 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,4 +4,5 @@ AM_INIT_AUTOMAKE([-Wall -Werror foreign])
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_CC
 AC_CONFIG_FILES(Makefile gencore.spec libgencore.pc)
+AM_CONDITIONAL(HAVE_SYSTEMD_SOCKET_SUPPORT, test "have_systemd_socket_support" = false)
 AC_OUTPUT(src/Makefile doc/Makefile)
diff --git a/gencore.service b/gencore.service
new file mode 100644
index 0000000..79220ff
--- /dev/null
+++ b/gencore.service
@@ -0,0 +1,9 @@
+[Unit]
+Description=Gencore service
+
+[Service]
+Type=forking
+ExecStart=/usr/bin/gencore --daemon
+
+[Install]
+WantedBy=multi-user.target
diff --git a/gencore.socket b/gencore.socket
new file mode 100644
index 0000000..b9afce8
--- /dev/null
+++ b/gencore.socket
@@ -0,0 +1,10 @@
+[Unit]
+Description=Gencore socket
+
+[Socket]
+ListenStream=/var/run/gencored.socket
+Accept=true
+
+[Install]
+WantedBy=socket.target
+
diff --git a/gencore.spec.in b/gencore.spec.in
index 58c699e..3937edb 100644
--- a/gencore.spec.in
+++ b/gencore.spec.in
@@ -1,3 +1,5 @@
+%define HAVE_SYSTEMD_SOCKET_SUPPORT 0
+
 Name: gencore
 Version: @VERSION@
 Release: 0
@@ -39,10 +41,19 @@ make
 %install
 make DESTDIR=$RPM_BUILD_ROOT install
 
+%preun
+systemctl stop gencore.service
+
 %files
 %doc README COPYING Changelog
 %{_bindir}/gencore
 %{_mandir}/man1/gencore.1*
+%if %HAVE_SYSTEMD_SOCKET_SUPPORT
+%{_unitdir}/gencore@.service
+%{_unitdir}/gencore.socket
+%else
+%{_unitdir}/gencore.service
+%endif
 
 %files -n libgencore
 %doc COPYING.LIBGENCORE
@@ -56,6 +67,16 @@ make DESTDIR=$RPM_BUILD_ROOT install
 %{_libdir}/libgencore.la
 %{_libdir}/pkgconfig/libgencore.pc
 
+%post
+systemctl --system daemon-reload
+%if %HAVE_SYSTEMD_SOCKET_SUPPORT
+systemctl enable gencore.socket
+systemctl start gencore.socket 
+%else
+systemctl enable gencore.service
+systemctl start gencore.service 
+%endif
+
 %post -n libgencore
 ldconfig -n %{_libdir}/libgencore.so.*
 
diff --git a/gencore@.service b/gencore@.service
new file mode 100644
index 0000000..4dcfb1c
--- /dev/null
+++ b/gencore@.service
@@ -0,0 +1,9 @@
+[Unit]
+Description=Gencore service
+
+[Service]
+Type=forking
+ExecStart=/usr/bin/gencore --socket
+
+[Install]
+WantedBy=multi-user.target

