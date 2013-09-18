Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab3IRKCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:02:35 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37921 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3IRKCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130918092444.GA2778@gmail.com> <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 18 Sep 2013 12:02:12 +0200
Message-ID: <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again Ingo:

Perhaps this is even more clear than v2:

len = snprintf(file, size, "%s", symbol_conf.symfs);
size -= len;
file += len;
len = snprintf(file, MIN(size,(last_slash - dso->long_name) + 2),
"%s",  dso->long_name);
size -= len;
file += len;
len = snprintf(file, size, ".debug%s",  last_slash);

Just tell me if you prefer this and I send v3.

Thanks!

On Wed, Sep 18, 2013 at 11:47 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello Ingo
>
> Incredible how many code style rules I can break in 20 lines of code
> :). I have just uploaded v2
>
> Thanks for your comments.
>
> On Wed, Sep 18, 2013 at 11:24 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> wrote:
>>
>>> On OpenEmbedded the symbol files are located under a .debug folder on
>>> the same folder as the binary file.
>>>
>>> This patch adds support for such files.
>>
>> It would be nice to cite before/after perf report output, to see how this
>> improved things and to see the output format you picked.
>>
>>>
>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> ---
>>>  tools/perf/util/dso.c    | 16 ++++++++++++++++
>>>  tools/perf/util/dso.h    |  1 +
>>>  tools/perf/util/symbol.c |  1 +
>>>  3 files changed, 18 insertions(+)
>>>
>>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>>> index c4374f0..bab18b7 100644
>>> --- a/tools/perf/util/dso.c
>>> +++ b/tools/perf/util/dso.c
>>> @@ -14,6 +14,7 @@ char dso__symtab_origin(const struct dso *dso)
>>>               [DSO_BINARY_TYPE__BUILD_ID_CACHE]       = 'B',
>>>               [DSO_BINARY_TYPE__FEDORA_DEBUGINFO]     = 'f',
>>>               [DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]     = 'u',
>>> +             [DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO] = 'o',
>>>               [DSO_BINARY_TYPE__BUILDID_DEBUGINFO]    = 'b',
>>>               [DSO_BINARY_TYPE__SYSTEM_PATH_DSO]      = 'd',
>>>               [DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]  = 'K',
>>
>> Stylistic nit: if a new entry breaks vertical alignment then re-align the
>> other entries as well so that it still looks nice after your change ...
>>
>>> @@ -64,6 +65,21 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
>>>                        symbol_conf.symfs, dso->long_name);
>>>               break;
>>>
>>> +     case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:{
>>
>> /: {
>>
>>> +             char *last_slash;
>>> +
>>> +             last_slash = dso->long_name + dso->long_name_len;
>>> +             while (last_slash != dso->long_name && *last_slash != '/')
>>> +                     last_slash--;
>>> +
>>> +             snprintf(file, MIN(size, strlen(symbol_conf.symfs) +
>>> +                             (last_slash - dso->long_name) + 2), "%s%s",
>>> +                             symbol_conf.symfs, dso->long_name);
>>> +             snprintf(file + strlen(file), size-strlen(file), ".debug%s",
>>> +                             last_slash);
>>
>> So the way such multi-snprintf() sequences are implemented in the kernel
>> is not this unreadable, fragile, repetitive concatenation of length
>> calculations, but an adjustment of 'size':
>>
>>                 size -= snprintf(..., size, ...);
>>
>> that way 'size' always tracks the remaining limit of the output string,
>> each snprintf consumes from it.
>>
>>> +             }
>>> +             break;
>>
>> Small nit: we generally put the final break inside the block.
>>
>> Besides the details it looks like a useful patch.
>>
>> Thanks,
>>
>>         Ingo
>
>
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
