Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab3DPCOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 22:14:38 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54683 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934994Ab3DPCOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 22:14:37 -0400
X-AuditID: 9c930179-b7bd8ae000004629-3e-516cb4090b8c
From: Namhyung Kim <namhyung@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Witten <mfwitten@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] perf requires python-devel to compile
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
Date: Tue, 16 Apr 2013 11:14:33 +0900
In-Reply-To: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 15 Apr 2013 13:58:50 +0300")
Message-ID: <87mwszb4s6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Mon, 15 Apr 2013 13:58:50 +0300, Pekka Enberg wrote:
> Hello,
>
> I'm seeing this when I try to build perf in v3.9-rc7:
>
> [penberg@golgotha perf]$ make
>     CHK -fstack-protector-all
>     CHK -Wstack-protector
>     CHK -Wvolatile-register-var
>     CHK -D_FORTIFY_SOURCE=2
>     CHK bionic
>     CHK libelf
>     CHK libdw
> Makefile:584: No libdw.h found or old libdw.h found or elfutils is
> older than 0.138, disables dwarf support. Please install new
> elfutils-devel/libdw-dev
>     CHK libunwind
>     CHK -DLIBELF_MMAP
>     CHK libaudit
>     CHK libnewt
> Makefile:673: newt not found, disables TUI support. Please install
> newt-devel or libnewt-dev
>     CHK gtk2
>     CHK -DHAVE_GTK_INFO_BAR
>     CHK perl
> Makefile:755: The path '/usr/bin/python-config' is not executable.
> Makefile:755: *** Please set 'PYTHON_CONFIG' appropriately.  Stop.
>
> The problem is that I didn't have python-devel package installed and
> get-executable-or-default decides to error out instead of letting the
> Makefile disable Python support.

Right.  I think the get-executable-or-default should not error out in
this case but just emit a warning and keep building.

Does following patch fix your problem?

-----------8<-------------8<-------------
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 8ef3bd30a549..3b8036f8aca4 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -177,7 +177,7 @@ $(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
 endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
-_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
+_gea_err  = $(if $(1),$(warning Please set '$(1)' appropriately))
 
 # try-cc
 # Usage: option = $(call try-cc, source-to-build, cc-options, msg)


