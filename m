Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbaIQRzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:55:13 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38655 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbaIQRzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:55:11 -0400
Message-ID: <5419CAFC.4040604@hp.com>
Date: Wed, 17 Sep 2014 13:55:08 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v2] perf mem: improves DSO long names search speed with
 RB tree
References: <1410894499-27609-1-git-send-email-Waiman.Long@hp.com> <1410894499-27609-2-git-send-email-Waiman.Long@hp.com> <20140917145102.GA2770@kernel.org>
In-Reply-To: <20140917145102.GA2770@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 10:51 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Sep 16, 2014 at 03:08:19PM -0400, Waiman Long escreveu:
>> +++ b/tools/perf/util/dso.c
>> @@ -611,17 +611,93 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>>   	return dso;
>>   }
>>
>> +/*
>> + * RB root of DSOs sorted by the long name
>> + */
>> +static struct rb_root dso__longname_root = { NULL };
> Use RB_ROOT, like in:
>
> [acme@zoo linux]$ grep -w rb_root mm/vmalloc.c
> static struct rb_root vmap_area_root = RB_ROOT;
> [acme@zoo linux]$

I don't use RB_ROOT here because it gave compilation error.

> But then can't this be made non-static, i.e. at the 'struct machine'
> level? I.e.  it is more likely that DSOs with the same long name are
> really the same thing on a single 'struct machine', not accross multiple
> ones or even multiple sessions (i.e. across multiple 'struct machines').
>
> IIRC Adrian also pointed this out.
>
> - Arnaldo
>
>

Yes, I am going to put the rb_root in the machine structure level as 
suggested by Adrian. So the static rb_root will be gone. I also found 
out that the dso__load_sym() function in util/symbol-elf.c may create 
DSOs of the same long name which can be either "[kernel.allsyms]" or 
"/lib/modules/.../vmlinux".

Cheers,
Longman
