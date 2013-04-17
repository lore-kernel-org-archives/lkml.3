Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965741Ab3DQDxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 23:53:05 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:53082 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965725Ab3DQDxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 23:53:03 -0400
Subject: [PATCH] perf tools: Revert regression in configuration of Python support
Date: Wed, 17 Apr 2013 02:23:16 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, Al Cooper <alcooperx@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <39a0c238e038432d898d4673f5cf9df6-mfwitten@gmail.com>
In-Reply-To: <516dba78.8695320a.583d.0722@mx.google.com>
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
            <87mwszb4s6.fsf@sejong.aot.lge.com>
            <516CD300.6070201@gmail.com>
            <cd2c2e9aae554739b6bcd93513078f80-mfwitten@gmail.com>
            <516DB548.7010703@gmail.com>
            <516dba78.8695320a.583d.0722@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Apr 2013 20:41:59 -0000, Michael Witten wrote:

> On Tue, 16 Apr 2013 13:32:08 -0700, David Ahern wrote:
>
>> On 4/16/13 10:08 AM, Michael Witten wrote:
>>> You should probably disable python support more directly:
>>>
>>>    make NO_LIBPYTHON=1
>> 
>> sure, but I should not have to do anything. The intent of the existing 
>> auto-probing code is to figure out what is installed and build a binary 
>> with those capabilities. In this case not having python installed causes 
>> it to blow up.
>
> That's certainly how it behaved up until the regression.
>
> To make matters worse, the NO_LIBPYTHON variable is checked only *after* 
> probing for an executable `python'; in the case that no python is installed
> at all, the workaround is to double up on your current trick:
>
>   make PYTHON=false PYTHON_CONFIG=false

I'm probably going to submit a small patch series to improve this
configuration code in general, but there's no reason to wait for
me to do this.

Thus, I think the simplest thing to do right away is just to revert
the one-line change that led to the regression, thereby restoring
the old behavior which has hitherto worked well enough.

The following patch applies to at least the following commit:

  bb33db7a076f4719dc68c235e187dd4bfb16b621

To apply this patch, save this email to:

  /path/to/email

and then run:

  git am --scissors /path/to/email

Sincerely,
Michael Witten

8<-----------8<-----------8<-----------8<-----------8<-----------8<-----------
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
index 8ef3bd3..3e89719 100644
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
