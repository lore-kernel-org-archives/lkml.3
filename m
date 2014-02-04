Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaBDJuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:50:14 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41647 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaBDJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:50:10 -0500
Message-ID: <52F0B7C5.8080609@hitachi.com>
Date: Tue, 04 Feb 2014 18:49:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH -tip v2 4/8] perf-probe: Use _stext based address
 instead of the symbol name
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <20140129091459.22141.29467.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <87d2j43aav.fsf@sejong.aot.lge.com> <52EF541E.8040802@hitachi.com>
In-Reply-To: <52EF541E.8040802@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/03 17:32), Masami Hiramatsu wrote:
> (2014/02/03 16:49), Namhyung Kim wrote:
>> On Wed, 29 Jan 2014 09:14:59 +0000, Masami Hiramatsu wrote:
>>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>>> index 4a9f43b..120954b 100644
>>> --- a/tools/perf/util/probe-event.c
>>> +++ b/tools/perf/util/probe-event.c
>>> @@ -387,6 +387,44 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
>>>  	return ret;
>>>  }
>>>  
>>> +/* Post processing the probe events */
>>> +static int post_process_probe_trace_events(struct probe_trace_event *tevs,
>>> +					   int ntevs, const char *module,
>>> +					   bool uprobe)
>>> +{
>>> +	struct symbol *sym;
>>> +	struct map *map;
>>> +	unsigned long stext = 0;
>>> +	char *tmp;
>>> +	int i;
>>> +
>>> +	if (uprobe)
>>> +		return add_exec_to_probe_trace_events(tevs, ntevs, module);
>>> +
>>> +	/* Note that currently _stext based probe is not for drivers */
>>> +	if (module)
>>> +		return add_module_to_probe_trace_events(tevs, ntevs, module);
>>> +
>>> +	sym = __find_kernel_function_by_name("_stext", &map);
>>
>> Couldn't we just use kmap->ref_reloc_sym instead of the hard-coded
>> "_stext"?  You might want to check the Adrian's recent kaslr fixes (now
>> in tip/perf/urgent).
> 
> Yeah, I just found Adrian's work and this series must be updated for that,
> because symbol's address is now based on the real (relocated) address.
> OK, I'll try to use a symbol in ref_reloc_sym. ;) Thank you for pointed it out!

Hmm, I've tested using ref_reloc_sym for new version, setting probes was OK,
but getting the address of "_text" always failed. It seems that the kmaps
doesn't make a symbol for "_text", on the other hand, "_stext" seems always
available. So I think there are two ways to fix this, use "_stext" as this
version, or use "_text" and fix dso__load_sym to load "_text" as a function
symbol if exist.
I'm not sure why the "_text" is not loaded, is that a policy?

Note that as we need to show all the existing probes, I must use
machine__get_kernel_function_by_name() even if the reference symbol
is "_text", because user may set their own probes based on different
symbols by hand.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


