Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaA0FO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 00:14:59 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52536 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaA0FO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 00:14:58 -0500
X-AuditID: 9c930197-b7b7cae000000e34-fb-52e5eb4f6ceb
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Weird plugin paths in perf and perf.so binaries with 3.14 merge window
References: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
	<20140122113630.GA1132@krava.brq.redhat.com>
Date: Mon, 27 Jan 2014 14:14:55 +0900
In-Reply-To: <20140122113630.GA1132@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 22 Jan 2014 12:36:30 +0100")
Message-ID: <87bnyy6m5s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri and Josh,

On Wed, 22 Jan 2014 12:36:30 +0100, Jiri Olsa wrote:
> On Tue, Jan 21, 2014 at 03:02:43PM -0500, Josh Boyer wrote:
>> Hi All,
>> 
>> I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
>> resulted in RPM complaining that the perf and perf.so binaries had
>> strings in them that matched the RPM_BUILD_ROOT string.  That fails
>> the RPM build.
>> 
>> Looking over the logs, I see that the traceevent plugins are getting a
>> rather weird -DPLUGIN_DIR define passed to them.  E.g.:
>> 
>> gcc -c -g -Wall   -I. -I
>> /home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/../../include
>>  '-DPLUGIN_DIR="/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64//usr//usr/lib64/traceevent/plugins"'
>>  -D_GNU_SOURCE -std=gnu99 -fPIC
>> /home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/parse-filter.c
>> -o parse-filter.o
>> 
>> We're building perf like so:
>> 
>> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
>> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
>> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
>> all
>> 
>> and installing it via:
>> 
>> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
>> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
>> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
>> install-bin
>> 
>> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
>> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
>> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
>> install-python_ext
>> 
>> This has worked for all the builds up until this point.
>> 
>> Somehow the perf and perf.so binaries are getting the string being
>> passed via -DPLUGIN_DIR into them, likely through the libtraceevent.a
>> link.  I'm pretty sure that (1) the string being passed is totally
>> broken and should be "/usr/lib64/traceevent/plugins" and (2) that I
>> haven't come close to deciphering how to fix this.
>> 
>> So, could you please look this over and see where the define is
>> getting messed up?

I found three things on the issue:

  1. perf defines plugin_dir if DESTDIR is set like below:

    ifdef DESTDIR
    plugindir=$(libdir)/traceevent/plugins
    plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
    endif

   But this is wrong since $plugindir includes $libdir and $libdir
   includes $prefix in it.  So there'll be two $prefix's in
   $plugindir_SQ as you can see above (...//usr//usr/...).


  2. And libtraceevent prepends DESTDIR to the plugindir:

    ifeq ($(set_plugin_dir),1)
    PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
    PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
    endif

   I don't know if it's desired but as Josh reported it seems not.
   Maybe we'd better adding just $prefix part not the $DESTDIR.


  3. libtraceevent's default plugin_dir is set like:

    ifeq ($(prefix),$(HOME))
    override plugin_dir = $(HOME)/.traceevent/plugins
    set_plugin_dir := 0
    else
    override plugin_dir = $(prefix)/lib/traceevent/plugins
    endif

   But it'd better using lib64/ instead of lib/ on 64 bit machines.  We
   can reuse same logic (libdir) in the perf Makefile but it's not a big
   deal as we can set it on the cmdline so I won't insist strongly. ;-)


Thanks,
Namhyung
