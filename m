Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaAUUCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:02:48 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:62930 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaAUUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:02:43 -0500
MIME-Version: 1.0
Date: Tue, 21 Jan 2014 15:02:43 -0500
X-Google-Sender-Auth: g0niCmgL8RN4JlfPwlvV19zC9s8
Message-ID: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
Subject: Weird plugin paths in perf and perf.so binaries with 3.14 merge window
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
resulted in RPM complaining that the perf and perf.so binaries had
strings in them that matched the RPM_BUILD_ROOT string.  That fails
the RPM build.

Looking over the logs, I see that the traceevent plugins are getting a
rather weird -DPLUGIN_DIR define passed to them.  E.g.:

gcc -c -g -Wall   -I. -I
/home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/../../include
 '-DPLUGIN_DIR="/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64//usr//usr/lib64/traceevent/plugins"'
 -D_GNU_SOURCE -std=gnu99 -fPIC
/home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/parse-filter.c
-o parse-filter.o

We're building perf like so:

make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
all

and installing it via:

make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
install-bin

make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
install-python_ext

This has worked for all the builds up until this point.

Somehow the perf and perf.so binaries are getting the string being
passed via -DPLUGIN_DIR into them, likely through the libtraceevent.a
link.  I'm pretty sure that (1) the string being passed is totally
broken and should be "/usr/lib64/traceevent/plugins" and (2) that I
haven't come close to deciphering how to fix this.

So, could you please look this over and see where the define is
getting messed up?

josh
