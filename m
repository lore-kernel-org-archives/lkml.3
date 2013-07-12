Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3GLIwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:52:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab3GLIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:52:45 -0400
Date: Fri, 12 Jul 2013 01:52:34 -0700
From: tip-bot for Michael Witten <tipbot@zytor.com>
Message-ID: <tip-a363a9da65d253fa7354ce5fd630f4f94df934cc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mfwitten@gmail.com, penberg@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mfwitten@gmail.com, penberg@kernel.org, tglx@linutronix.de
In-Reply-To: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Revert regression in configuration of Python support
Git-Commit-ID: a363a9da65d253fa7354ce5fd630f4f94df934cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:52:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a363a9da65d253fa7354ce5fd630f4f94df934cc
Gitweb:     http://git.kernel.org/tip/a363a9da65d253fa7354ce5fd630f4f94df934cc
Author:     Michael Witten <mfwitten@gmail.com>
AuthorDate: Wed, 17 Apr 2013 02:23:16 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Jul 2013 17:29:01 -0300

perf tools: Revert regression in configuration of Python support

Among other things, the following:

  commit 31160d7feab786c991780d7f0ce2755a469e0e5e
  Date:   Tue Jan 8 16:22:36 2013 -0500
  perf tools: Fix GNU make v3.80 compatibility issue

attempts to aid the user by tapping into an existing error message,
as described in the commit message:

  ... Also fix an issue where _get_attempt was called with only
  one argument. This prevented the error message from printing
  the name of the variable that can be used to fix the problem.

or more precisely:

  -$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
  +$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))

However, The "missing" argument was in fact missing on purpose; it's
absence is a signal that the error message should be skipped, because
the failure would be due to the default value, not any user-supplied
value.  This can be seen in how `_ge_attempt' uses `gea_err' (in the
config/utilities.mak file):

  _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
  _gea_warn = $(warning The path '$(1)' is not executable.)
  _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))

That is, because the argument is no longer missing, the value `$(1)'
(associated with `_gea_err') always evaluates to true, thus always
triggering the error condition that is meant to be reserved for
only the case when a user explicitly supplies an invalid value.

Concretely, the result is a regression in the Makefile's configuration
of python support; rather than gracefully disable support when the
relevant executables cannot be found according to default values, the
build process halts in error as though the user explicitly supplied
the values.

This new commit simply reverts the offending one-line change.

Reported-by: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com
Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 tools/perf/config/utilities.mak | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index faffb52..94d2d4f 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -173,7 +173,7 @@ _ge-abspath = $(if $(is-executable),$(1))
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
 #
 define get-executable-or-default
-$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
 endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
