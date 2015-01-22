Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbbAVAeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:34:17 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:41934 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbAVAeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:34:11 -0500
MIME-Version: 1.0
In-Reply-To: <54C0216F.3080404@gmail.com>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
	<1421168344-5363-2-git-send-email-victor.kamensky@linaro.org>
	<CAA3XUr1BnS=8RTVyxtVOm4Ahb2DQXUuJJQC1w2SvT5fycjRcEQ@mail.gmail.com>
	<54C0216F.3080404@gmail.com>
Date: Wed, 21 Jan 2015 16:34:10 -0800
Message-ID: <CAA3XUr0uXykCTVuw-sYmkhsFZ-cimeuJkXTXNdJyhJh7976xEQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf symbols: debuglink should take symfs option into account
From: Victor Kamensky <victor.kamensky@linaro.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Thank you for response!

On 21 January 2015 at 14:00, David Ahern <dsahern@gmail.com> wrote:
> On 1/19/15 10:50 AM, Victor Kamensky wrote:
>>>
>>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>>> index 45be944..6a2f663 100644
>>> --- a/tools/perf/util/dso.c
>>> +++ b/tools/perf/util/dso.c
>>> @@ -42,19 +42,30 @@ int dso__read_binary_type_filename(const struct dso
>>> *dso,
>>>          size_t len;
>>>
>>>          switch (type) {
>>> -       case DSO_BINARY_TYPE__DEBUGLINK: {
>>> +       case DSO_BINARY_TYPE__DEBUGLINK:
>>> +       {
>>>                  char *debuglink;
>>> -
>>> -               strncpy(filename, dso->long_name, size);
>>> -               debuglink = filename + dso->long_name_len;
>>> -               while (debuglink != filename && *debuglink != '/')
>>> -                       debuglink--;
>>> -               if (*debuglink == '/')
>>> -                       debuglink++;
>>> -               ret = filename__read_debuglink(dso->long_name, debuglink,
>>> -                                              size - (debuglink -
>>> filename));
>>> -               }
>>> +               char *filename_copy;
>>> +
>>> +               filename_copy = malloc(PATH_MAX);
>>> +               if (filename_copy) {
>>> +                       len = __symbol__join_symfs(filename, size,
>>> +                                                  dso->long_name);
>>> +                       strncpy(filename_copy, filename, PATH_MAX);
>>> +                       debuglink = filename + len;
>>> +                       while (debuglink != filename && *debuglink !=
>>> '/')
>>> +                               debuglink--;
>>> +                       if (*debuglink == '/')
>>> +                               debuglink++;
>>> +                       ret = filename__read_debuglink(filename_copy,
>>> debuglink,
>>> +                                                      size - (debuglink
>>> -
>>> +
>>> filename));
>>> +                       free(filename_copy);
>>> +               } else
>>> +                       ret = -1;
>>>                  break;
>>> +       }
>>> +
>
>
> I do not believe the filename_copy is needed; just add the symfs path to
> filename and pass filename to read_debuglink

My first version of the fix did not create filename_copy and
looked like as patch below. But then I noticed that
filename__read_debuglink function receives two pointers:

'filename' first parameter pointer to executable path from which
.gnu_debuglink sections content will be read

'debuglink' path to directory that will be updated by the function
(note  strncpy at line 531) to point to debug symbol file.

Before my change offset within 'filename' parameter of
dso__read_binary_type_filename function is passed as
'debuglink' parameter and it will be updated, and
dso->long_name is separate, passed as 'filename'
parameter to filename__read_debuglink function.

When in the first version of patch, as below, I pass filename
buffer to both (filename to open first and pointer within
filename to be updated as debuglink) as in patch
below, it will work with current implementation because
open happens first but update happens after that. But that
is specific dependency on current implementation of
filename__read_debuglink function. It did not feel quite
right to me, but practically it could be OK.

Here is the first version of the without filename_copy.
Practically I am OK with it. Please let me know if
you prefer this version:

>From cafc06d95886f1d82f7b127af58a51384c0fe931 Mon Sep 17 00:00:00 2001
From: Victor Kamensky <victor.kamensky@linaro.org>
Date: Mon, 12 Jan 2015 17:33:06 -0800
Subject: [PATCH 2/2] perf symbols: debuglink should take symfs option into
 account

Currently code that tries to read corresponding debug symbol
file from .gnu_debuglink section (DSO_BINARY_TYPE__DEBUGLINK)
does not take in account symfs option, so filename__read_debuglink
function cannot open ELF file, if symfs option is used.

Fix is to add proper handling of symfs as it is done in other
places: use __symbol__join_symfs function to get real file name
of target ELF file.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
---
 tools/perf/util/dso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..ca8d8d5 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -45,13 +45,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
     case DSO_BINARY_TYPE__DEBUGLINK: {
         char *debuglink;

-        strncpy(filename, dso->long_name, size);
-        debuglink = filename + dso->long_name_len;
+        len = __symbol__join_symfs(filename, size, dso->long_name);
+        debuglink = filename + len;
         while (debuglink != filename && *debuglink != '/')
             debuglink--;
         if (*debuglink == '/')
             debuglink++;
-        ret = filename__read_debuglink(dso->long_name, debuglink,
+        ret = filename__read_debuglink(filename, debuglink,
                            size - (debuglink - filename));
         }
         break;
-- 
1.9.3

Thanks,
Victor

> David
>
