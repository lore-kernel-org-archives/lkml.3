Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaGJVXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:23:01 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49283 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbaGJVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:22:59 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd: add install_libs target to trace-cmd
Date: Thu, 10 Jul 2014 17:22:46 -0400
Message-ID: <1405027367-26570-2-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405027367-26570-1-git-send-email-jbacik@fb.com>
References: <1405027367-26570-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-10_07:2014-07-10,2014-07-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.39887054664933e-10 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407100242
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to be able to build and link against libtracecmd, so add a make target
to build libtracecmd and install it into lib as well as the supporting header
files.  This allows me to be able to make stand alone apps that build and link
against trace-cmd for custom trace tools that don't have a place in the generic
trace-cmd tool.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 Makefile | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index cbe0eb9..df5ec72 100644
--- a/Makefile
+++ b/Makefile
@@ -47,7 +47,10 @@ html_install = $(prefix)/share/kernelshark/html
 html_install_SQ = '$(subst ','\'',$(html_install))'
 img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
-libdir ?= lib
+libdir ?= $(prefix)/lib
+libdir_SQ = '$(subst ','\'',$(libdir))'
+includedir = $(prefix)/include/trace-cmd
+includedir_SQ = '$(subst ','\'',$(includedir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
@@ -57,8 +60,8 @@ ifeq ($(prefix),$(HOME))
 plugin_dir = $(HOME)/.trace-cmd/plugins
 python_dir = $(HOME)/.trace-cmd/python
 else
-plugin_dir = $(prefix)/$(libdir)/trace-cmd/plugins
-python_dir = $(prefix)/$(libdir)/trace-cmd/python
+plugin_dir = $(libdir)/trace-cmd/plugins
+python_dir = $(libdir)/trace-cmd/python
 PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PYTHON_DIR = -DPYTHON_DIR="$(python_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
@@ -399,6 +402,8 @@ libtracecmd.so: $(TCMD_LIB_OBJS)
 libtracecmd.a: $(TCMD_LIB_OBJS)
 	$(Q)$(do_build_static_lib)
 
+libs: libtracecmd.so libparsevent.so
+
 trace-util.o: trace_plugin_dir
 
 $(PLUGIN_OBJS): %.o : $(src)/%.c
@@ -558,6 +563,12 @@ install_gui: install_cmd gui
 	$(Q)$(call do_install,trace-graph,$(bindir_SQ))
 	$(Q)$(call do_install,kernelshark,$(bindir_SQ))
 
+install_libs: libs
+	$(Q)$(call do_install,libtracecmd.so,$(libdir_SQ))
+	$(Q)$(call do_install,libparsevent.so,$(libdir_SQ))
+	$(Q)$(call do_install,event-parse.h,$(includedir_SQ))
+	$(Q)$(call do_install,trace-cmd.h,$(includedir_SQ))
+
 doc:
 	$(MAKE) -C $(src)/Documentation all
 
-- 
1.8.3.1

