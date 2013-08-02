Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650Ab3HBKMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:12:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030633Ab3HBKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:12:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Michael Witten <mfwitten@gmail.com>,
        Mark Brown <broonie@sirena.org.uk>
Subject: [ 97/99] perf tools: Revert regression in configuration of Python support
Date: Fri,  2 Aug 2013 18:08:50 +0800
Message-Id: <20130802100239.448050092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Witten <mfwitten@gmail.com>

commit a363a9da65d253fa7354ce5fd630f4f94df934cc upstream.

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
Cc: Mark Brown <broonie@sirena.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/config/utilities.mak |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -173,7 +173,7 @@ _ge-abspath = $(if $(is-executable),$(1)
 # Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
 #
 define get-executable-or-default
-$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
 endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)


