Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaKCPBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:01:49 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37047 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaKCPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141103135116.GC29906@krava.brq.redhat.com>
References: <1414999678-31377-1-git-send-email-namhyung@kernel.org>
 <1414999678-31377-2-git-send-email-namhyung@kernel.org> <20141103135116.GC29906@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 4 Nov 2014 00:01:26 +0900
X-Google-Sender-Auth: vBOSRFHsd2PYqoGbNrehlqDYiGY
Message-ID: <CAM9d7cgY=nAxa-Az7BaZPUd0cmXK5e3stKw23VYMRxpyzGO6EA@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf tools: Preparation for compressed kernel module support
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, Nov 3, 2014 at 10:51 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Mon, Nov 03, 2014 at 04:27:51PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +static int decompress_dummy(const char *input __maybe_unused,
>> +                         int output __maybe_unused)
>> +{
>> +     return -1;
>> +}
>> +
>> +static const struct {
>> +     const char *fmt;
>> +     int (*decompress)(const char *input, int output);
>> +} compressions[] = {
>> +     { "gz", decompress_dummy },
>> +};
>> +
>> +bool is_supported_compression(const char *ext)
>> +{
>> +     unsigned i;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(compressions); i++) {
>> +             if (!strcmp(ext, compressions[i].fmt))
>> +                     return true;
>> +     }
>> +     return false;
>> +}
>> +
>> +bool is_kmodule_extension(const char *ext)
>> +{
>> +     if (!strcmp(ext, "ko"))
>> +             return true;
>> +
>> +     if (ext[2] == '\0' || (ext[2] == '.' && is_supported_compression(ext+3)))
>> +             return true;
>
> I got stuck in here.. so any 2 chars string is kernel module extension?

Oops, the first check should be:

    if (strncmp(ext, "ko", 2))
        return false;


> plus how do u know ext[3] (or [2]) is valid memory?

Hmm.. if it ends at ext[0] or ext[1], it should be checked in the
first check above.  And I check ext[2] first, and then access ext[3]
and so on.

Thanks,
Namhyung
