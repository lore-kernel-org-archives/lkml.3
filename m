Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab3A2HAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:00:10 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54067 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3A2HAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:00:08 -0500
X-AuditID: 9c930179-b7d01ae000004006-c6-51077375c735
From: Namhyung Kim <namhyung@kernel.org>
To: Thomas Backlund <tmb@mageia.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        irina.tirdea@intel.com, acme@redhat.com
Subject: Re: the patch "perf tools: Update Makefile for Android" broke 3.8-rc perf build.
References: <20121212031346.B5BB366071F@gitolite.kernel.org>
	<510745D9.9000209@mageia.org>
Date: Tue, 29 Jan 2013 16:00:04 +0900
In-Reply-To: <510745D9.9000209@mageia.org> (Thomas Backlund's message of "Tue,
	29 Jan 2013 05:45:29 +0200")
Message-ID: <87r4l4v5hn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, 29 Jan 2013 05:45:29 +0200, Thomas Backlund wrote:
> Linux Kernel Mailing List skrev 12.12.2012 05:13:
>> Gitweb:     http://git.kernel.org/linus/;a=commit;h=d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
>> Commit:     d816ec2d1bea55cfeac373f0ab0ab8a3105e49b4
>> Parent:     78da39faf7c903bb6e3c20a726fde1bf98d10af8
>> Author:     Irina Tirdea <irina.tirdea@intel.com>
>> AuthorDate: Mon Oct 8 09:43:27 2012 +0300
>> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
>> CommitDate: Mon Oct 8 17:42:16 2012 -0300
>>
>>      perf tools: Update Makefile for Android
>>
>>      For cross-compiling on Android, some specific changes are needed in
>>      the Makefile.
>>
>
> The above patch broke perf build on i586 and x86_64:
>
> [tmb@tmb linux-3.8-rc5]$ make -C tools/perf -s V=1
> HAVE_CPLUS_DEMANGLE=1 prefix=%{_prefix} all
>     CHK -fstack-protector-all
>     CHK -Wstack-protector
>     CHK -Wvolatile-register-var
>     CHK bionic
> <stdin>:1:31: fatal error: android/api-level.h: No such file or directory
> compilation terminated.

Are you sure does it break your build?  In my case, it only hid the
compilation from user and kept the work behind us.  When I run a clean
build I could see a final perf binary there.

It's because QUIET_{CC,LINK,...} honour the -s option but TRY_CC_MSG not
and maybe we need something like this:



>From 5015f5f4961006e31b9298caeb86b3cc0e31bcf7 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 29 Jan 2013 15:48:36 +0900
Subject: [PATCH] perf tools: Hide feature test result on make -s

Other commands like QUIET_CC already honour -s option of make so the
try-cc should do the same.  Make it really quiet if -s option is given
and ignore V=1 (it's only meaningful without -s option).

Reported-by: Thomas Backlund <tmb@mageia.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/config/utilities.mak | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index e5413125e6bb..9d202fce1306 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -181,10 +181,13 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options, msg)
-ifndef V
 TRY_CC_OUTPUT= > /dev/null 2>&1
-endif
+ifneq ($(findstring $(MAKEFLAGS),s),s)
 TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
+ifdef V
+TRY_CC_OUTPUT=
+endif
+endif
 
 try-cc = $(shell sh -c						  \
 	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
-- 
1.7.11.7

