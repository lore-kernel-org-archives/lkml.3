Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBQLoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:44:12 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39161 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaBQLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:44:11 -0500
Message-ID: <5301F603.8010605@hitachi.com>
Date: Mon, 17 Feb 2014 20:44:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v3 01/11] [BUGFIX] perf-probe: Fix to do exit call
 for symbol maps
References: <20140206053201.29635.99095.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <20140206053204.29635.28334.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <87bny6xjdj.fsf@sejong.aot.lge.com>
In-Reply-To: <87bny6xjdj.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/17 16:56), Namhyung Kim wrote:
> Hi Masami,
> 
> On Thu, 06 Feb 2014 05:32:04 +0000, Masami Hiramatsu wrote:
>> Some perf-probe commands do symbol_init() but doesn't
>> do exit call. This fixes that to call symbol_exit()
>> and releases machine if needed.
>> This also merges init_vmlinux() and init_user_exec()
>> because both of them are doing similar things.
>> (init_user_exec() just skips init vmlinux related
>>  symbol maps)
>>
>> Changes from v2:
>>  - Not to set symbol_conf.try_vmlinux_path in init_symbol_maps()
>>    (Thanks to Namhyung Kim!)
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> [SNIP]
>> -int show_line_range(struct line_range *lr, const char *module)
>> +static int __show_line_range(struct line_range *lr, const char *module)
>>  {
>>  	int l = 1;
>>  	struct line_node *ln;
>> @@ -573,10 +568,6 @@ int show_line_range(struct line_range *lr, const char *module)
>>  	char *tmp;
>>  
>>  	/* Search a line range */
>> -	ret = init_vmlinux();
>> -	if (ret < 0)
>> -		return ret;
>> -
>>  	dinfo = open_debuginfo(module);
>>  	if (!dinfo) {
>>  		pr_warning("Failed to open debuginfo file.\n");
>> @@ -646,6 +637,19 @@ end:
>>  	return ret;
>>  }
>>  
>> +int show_line_range(struct line_range *lr, const char *module)
>> +{
>> +	int ret;
>> +
>> +	ret = init_symbol_maps(false);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = __show_line_range(lr, module);
>> +	exit_symbol_maps();
> 
> Wouldn't it be better moving init/exit_symbol_maps() to a common
> location if they're used by every operations?

Oh, that's a good idea.:)
Since this just introduces init/exit_symbol_maps() to fix issue
by replacing old one. I think it's better to be done after this series.

Thank you,



-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


