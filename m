Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaBCITi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:19:38 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42891 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaBCITh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:19:37 -0500
Message-ID: <52EF5112.4020305@hitachi.com>
Date: Mon, 03 Feb 2014 17:19:30 +0900
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
Subject: Re: [PATCH -tip v2 1/8] [BUGFIX] perf-probe: Fix to do exit call
 for symbol maps
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <20140129091452.22141.36766.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <87iosw3ao8.fsf@sejong.aot.lge.com>
In-Reply-To: <87iosw3ao8.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/03 16:41), Namhyung Kim wrote:
> Hi Masami,
> 
> On Wed, 29 Jan 2014 09:14:52 +0000, Masami Hiramatsu wrote:
>> Some perf-probe commands do symbol_init() but doesn't
>> do exit call. This fixes that to call symbol_exit()
>> and relase machine if needed.
>> This also merges init_vmlinux() and init_user_exec()
>> because both of them are doing similar things.
>> (init_user_exec() just skips init vmlinux related
>>  symbol maps)
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  tools/perf/util/probe-event.c |  110 +++++++++++++++++++++++------------------
>>  1 file changed, 61 insertions(+), 49 deletions(-)
>>
>> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
>> index a8a9b6c..14c649df 100644
>> --- a/tools/perf/util/probe-event.c
>> +++ b/tools/perf/util/probe-event.c
>> @@ -73,31 +73,35 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
>>  static int convert_name_to_addr(struct perf_probe_event *pev,
>>  				const char *exec);
>>  static void clear_probe_trace_event(struct probe_trace_event *tev);
>> -static struct machine machine;
>> +static struct machine *host_machine;
>>  
>>  /* Initialize symbol maps and path of vmlinux/modules */
>> -static int init_vmlinux(void)
>> +static int init_symbol_maps(bool user_only)
>>  {
>>  	int ret;
>>  
>>  	symbol_conf.sort_by_name = true;
>> -	if (symbol_conf.vmlinux_name == NULL)
>> -		symbol_conf.try_vmlinux_path = true;
>> -	else
>> -		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
>> +	if (user_only)
>> +		symbol_conf.try_vmlinux_path = false;
>> +	else {
>> +		if (symbol_conf.vmlinux_name == NULL)
>> +			symbol_conf.try_vmlinux_path = true;
> 
> This looks unnecessary and duplicate since we already have following
> code in __cmd_probe().
> 
> 	/*
> 	 * Only consider the user's kernel image path if given.
> 	 */
> 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);

Ah, I see :)
OK, I'll remove that part not to setting symbol_conf in probe-event.c.

Thank you!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


