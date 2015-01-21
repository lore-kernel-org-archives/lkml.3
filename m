Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbbAUV7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:59:43 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45796 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAUV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:59:37 -0500
Message-ID: <54C0216F.3080404@gmail.com>
Date: Wed, 21 Jan 2015 15:00:15 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Victor Kamensky <victor.kamensky@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Will Deacon <will.deacon@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH 2/2] perf symbols: debuglink should take symfs option
 into account
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>	<1421168344-5363-2-git-send-email-victor.kamensky@linaro.org> <CAA3XUr1BnS=8RTVyxtVOm4Ahb2DQXUuJJQC1w2SvT5fycjRcEQ@mail.gmail.com>
In-Reply-To: <CAA3XUr1BnS=8RTVyxtVOm4Ahb2DQXUuJJQC1w2SvT5fycjRcEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/15 10:50 AM, Victor Kamensky wrote:
>> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
>> index 45be944..6a2f663 100644
>> --- a/tools/perf/util/dso.c
>> +++ b/tools/perf/util/dso.c
>> @@ -42,19 +42,30 @@ int dso__read_binary_type_filename(const struct dso *dso,
>>          size_t len;
>>
>>          switch (type) {
>> -       case DSO_BINARY_TYPE__DEBUGLINK: {
>> +       case DSO_BINARY_TYPE__DEBUGLINK:
>> +       {
>>                  char *debuglink;
>> -
>> -               strncpy(filename, dso->long_name, size);
>> -               debuglink = filename + dso->long_name_len;
>> -               while (debuglink != filename && *debuglink != '/')
>> -                       debuglink--;
>> -               if (*debuglink == '/')
>> -                       debuglink++;
>> -               ret = filename__read_debuglink(dso->long_name, debuglink,
>> -                                              size - (debuglink - filename));
>> -               }
>> +               char *filename_copy;
>> +
>> +               filename_copy = malloc(PATH_MAX);
>> +               if (filename_copy) {
>> +                       len = __symbol__join_symfs(filename, size,
>> +                                                  dso->long_name);
>> +                       strncpy(filename_copy, filename, PATH_MAX);
>> +                       debuglink = filename + len;
>> +                       while (debuglink != filename && *debuglink != '/')
>> +                               debuglink--;
>> +                       if (*debuglink == '/')
>> +                               debuglink++;
>> +                       ret = filename__read_debuglink(filename_copy, debuglink,
>> +                                                      size - (debuglink -
>> +                                                              filename));
>> +                       free(filename_copy);
>> +               } else
>> +                       ret = -1;
>>                  break;
>> +       }
>> +

I do not believe the filename_copy is needed; just add the symfs path to 
filename and pass filename to read_debuglink

David

