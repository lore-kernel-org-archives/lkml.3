Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaAVA6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:58:46 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35761 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaAVA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:58:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
References: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
Date: Tue, 21 Jan 2014 19:58:41 -0500
X-Google-Sender-Auth: AX1xs1h0rgkH3acxaVYERRZYXQQ
Message-ID: <CA+5PVA5SWV-pWxfisAVXB-PkARqRsHiaWOne2sXiG7r1D5M6Rg@mail.gmail.com>
Subject: Re: Weird plugin paths in perf and perf.so binaries with 3.14 merge window
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=089e015366b44166b404f084a043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e015366b44166b404f084a043
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 21, 2014 at 3:02 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Hi All,
>
> I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
> resulted in RPM complaining that the perf and perf.so binaries had
> strings in them that matched the RPM_BUILD_ROOT string.  That fails
> the RPM build.
>
> Looking over the logs, I see that the traceevent plugins are getting a
> rather weird -DPLUGIN_DIR define passed to them.  E.g.:
>
> gcc -c -g -Wall   -I. -I
> /home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/../../include
>  '-DPLUGIN_DIR="/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64//usr//usr/lib64/traceevent/plugins"'
>  -D_GNU_SOURCE -std=gnu99 -fPIC
> /home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/parse-filter.c
> -o parse-filter.o
>
> We're building perf like so:
>
> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
> all
>
> and installing it via:
>
> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
> install-bin
>
> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
> install-python_ext
>
> This has worked for all the builds up until this point.
>
> Somehow the perf and perf.so binaries are getting the string being
> passed via -DPLUGIN_DIR into them, likely through the libtraceevent.a
> link.  I'm pretty sure that (1) the string being passed is totally
> broken and should be "/usr/lib64/traceevent/plugins" and (2) that I
> haven't come close to deciphering how to fix this.
>
> So, could you please look this over and see where the define is
> getting messed up?

With the patch below (also attached because I'm sure gmail is going to
mess this up), I get a much more sane PLUGIN_DIR value:

gcc -c -g -Wall   -I. -I
/home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/../../include
 '-DPLUGIN_DIR="/usr/lib64/traceevent/plugins"'  -D_GNU_SOURCE -fPIC
-o plugin_scsi.o
/home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/plugin_scsi.c

I'm not sure why DESTDIR is included in the -DPLUGIN_DIR definition in
tools/lib/traceevent/Makefile, nor why $(prefix) is in plugindir_SQ in
tools/perf/config/Makefile.

josh

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56d52a3..005c9cc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -63,7 +63,7 @@ endif
 endif

 ifeq ($(set_plugin_dir),1)
-PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
+PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d604e50..c48d449 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -600,5 +600,5 @@ perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 # Otherwise we install plugins into the global $(libdir).
 ifdef DESTDIR
 plugindir=$(libdir)/traceevent/plugins
-plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
+plugindir_SQ= $(subst ','\'',$(plugindir))
 endif

--089e015366b44166b404f084a043
Content-Type: text/x-patch; charset=US-ASCII; name="plugin-dir-perf.patch"
Content-Disposition: attachment; filename="plugin-dir-perf.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hqpvvaag0

ZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi90cmFjZWV2ZW50L01ha2VmaWxlIGIvdG9vbHMvbGliL3Ry
YWNlZXZlbnQvTWFrZWZpbGUKaW5kZXggNTZkNTJhMy4uMDA1YzljYyAxMDA2NDQKLS0tIGEvdG9v
bHMvbGliL3RyYWNlZXZlbnQvTWFrZWZpbGUKKysrIGIvdG9vbHMvbGliL3RyYWNlZXZlbnQvTWFr
ZWZpbGUKQEAgLTYzLDcgKzYzLDcgQEAgZW5kaWYKIGVuZGlmCiAKIGlmZXEgKCQoc2V0X3BsdWdp
bl9kaXIpLDEpCi1QTFVHSU5fRElSID0gLURQTFVHSU5fRElSPSIkKERFU1RESVIpLyQocGx1Z2lu
X2RpcikiCitQTFVHSU5fRElSID0gLURQTFVHSU5fRElSPSIkKHBsdWdpbl9kaXIpIgogUExVR0lO
X0RJUl9TUSA9ICckKHN1YnN0ICcsJ1wnJywkKFBMVUdJTl9ESVIpKScKIGVuZGlmCiAKZGlmZiAt
LWdpdCBhL3Rvb2xzL3BlcmYvY29uZmlnL01ha2VmaWxlIGIvdG9vbHMvcGVyZi9jb25maWcvTWFr
ZWZpbGUKaW5kZXggZDYwNGU1MC4uYzQ4ZDQ0OSAxMDA2NDQKLS0tIGEvdG9vbHMvcGVyZi9jb25m
aWcvTWFrZWZpbGUKKysrIGIvdG9vbHMvcGVyZi9jb25maWcvTWFrZWZpbGUKQEAgLTYwMCw1ICs2
MDAsNSBAQCBwZXJmZXhlY19pbnN0ZGlyX1NRID0gJChzdWJzdCAnLCdcJycsJChwZXJmZXhlY19p
bnN0ZGlyKSkKICMgT3RoZXJ3aXNlIHdlIGluc3RhbGwgcGx1Z2lucyBpbnRvIHRoZSBnbG9iYWwg
JChsaWJkaXIpLgogaWZkZWYgREVTVERJUgogcGx1Z2luZGlyPSQobGliZGlyKS90cmFjZWV2ZW50
L3BsdWdpbnMKLXBsdWdpbmRpcl9TUT0gJChzdWJzdCAnLCdcJycsJChwcmVmaXgpLyQocGx1Z2lu
ZGlyKSkKK3BsdWdpbmRpcl9TUT0gJChzdWJzdCAnLCdcJycsJChwbHVnaW5kaXIpKQogZW5kaWYK
--089e015366b44166b404f084a043--
