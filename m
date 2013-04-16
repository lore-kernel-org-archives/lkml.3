Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab3DPRLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:11:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58705 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab3DPRLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:11:42 -0400
Subject: Re: [PROBLEM] perf requires python-devel to compile
From: Michael Witten <mfwitten@gmail.com>
Date: Tue, 16 Apr 2013 17:08:33 -0000
To: David Ahern <dsahern@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <cd2c2e9aae554739b6bcd93513078f80-mfwitten@gmail.com>
In-Reply-To: <516CD300.6070201@gmail.com>
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
            <87mwszb4s6.fsf@sejong.aot.lge.com>
            <516CD300.6070201@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013 21:26:40 -0700, David Ahern wrote:

> On 4/15/13 7:14 PM, Namhyung Kim wrote:
>>> Makefile:755: The path '/usr/bin/python-config' is not executable.
>>> Makefile:755: *** Please set 'PYTHON_CONFIG' appropriately.  Stop.
>>>
>>> The problem is that I didn't have python-devel package installed and
>>> get-executable-or-default decides to error out instead of letting the
>>> Makefile disable Python support.
>>
>> Right.  I think the get-executable-or-default should not error out in
>> this case but just emit a warning and keep building.
>>
>> Does following patch fix your problem?
>>
>> -----------8<-------------8<-------------
>> diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
>> index 8ef3bd30a549..3b8036f8aca4 100644
>> --- a/tools/perf/config/utilities.mak
>> +++ b/tools/perf/config/utilities.mak
>> @@ -177,7 +177,7 @@ $(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
>>   endef
>>   _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
>>   _gea_warn = $(warning The path '$(1)' is not executable.)
>> -_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
>> +_gea_err  = $(if $(1),$(warning Please set '$(1)' appropriately))
>
> In this case you don't want a warning, you just want python support 
> disabled and move on. I've been getting around this in a minimal install 
> of F18 in a VM using PYTHON_CONFIG=/bin/false; haven't had time to 
> search for the proper solution.

You should probably disable python support more directly:

  make NO_LIBPYTHON=1

That being said, this issue was introduced with the following commit:

  31160d7feab786c991780d7f0ce2755a469e0e5e

namely due to:

  ... Also fix an issue where _get_attempt was called with only
  one argument. This prevented the error message from printing
  the name of the variable that can be used to fix the problem.

specifically:

  -$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
  +$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))

The "missing" argument was in fact missing on purpose; it's a signal
that the error message should be skipped, because the failure was due
to the default value, not the user-supplied value.

That being said, I think there's room for improvement; for instance,
the error handling should perhaps not belong there. I will look into
it presently.

Sincerely,
Michael Witten
