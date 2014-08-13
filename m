Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbaHMHF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:05:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:40333 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMHF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:05:26 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 01/13] perf script: Fix possible memory leaks
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
	<1407825645-24586-2-git-send-email-namhyung@kernel.org>
	<53EB03EB.4040606@intel.com>
Date: Wed, 13 Aug 2014 16:05:24 +0900
In-Reply-To: <53EB03EB.4040606@intel.com> (Adrian Hunter's message of "Wed, 13
	Aug 2014 09:21:31 +0300")
Message-ID: <87y4usdg3v.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 09:21:31 +0300, Adrian Hunter wrote:
> On 08/12/2014 09:40 AM, Namhyung Kim wrote:
>>  		input = open(file.path, O_RDONLY);	/* input_name */
>>  		if (input < 0) {
>>  			perror("failed to open file");
>> -			return -1;
>> +			err = -errno;
>
> Need to get errno before calling perror().

Argh, right.

>
>> +			goto out_delete;
>>  		}
>>  
>>  		err = fstat(input, &perf_stat);
>>  		if (err < 0) {
>>  			perror("failed to stat file");
>> -			return -1;
>> +			goto out_delete;
>>  		}
>>  
>>  		if (!perf_stat.st_size) {
>>  			fprintf(stderr, "zero-sized file, nothing to do!\n");
>> -			return 0;
>> +			goto out_delete;
>>  		}
>>  
>>  		scripting_ops = script_spec__lookup(generate_script_lang);
>>  		if (!scripting_ops) {
>>  			fprintf(stderr, "invalid language specifier");
>> -			return -1;
>> +			err = -ENOENT;
>> +			goto out_delete;
>>  		}
>>  
>>  		err = scripting_ops->generate_script(session->tevent.pevent,
>>  						     "perf-script");
>> -		goto out;
>> +		goto out_delete;
>>  	}
>>  
>>  	if (script_name) {
>>  		err = scripting_ops->start_script(script_name, argc, argv);
>>  		if (err)
>> -			goto out;
>> +			goto out_delete;
>>  		pr_debug("perf script started with script %s\n\n", script_name);
>> +		script_started = true;
>>  	}
>>  
>>  
>>  	err = perf_session__check_output_opt(session);
>>  	if (err < 0)
>> -		goto out;
>> +		goto out_delete;
>>  
>>  	err = __cmd_script(&script);
>>  
>> +out_delete:
>
> I added a flush method in a patch which acme has stashed in his
> tmp.perf/core branch.  It would go here:
>
> 	if (script_started)
> 		flush_scripting();

Thanks for the info.  I'll update once it's merged into acme/perf/core.

Thanks,
Namhyung


>
>>  	perf_session__delete(session);
>> -	cleanup_scripting();
>> +
>> +	if (script_started)
>> +		cleanup_scripting();
>>  out:
>>  	return err;
>>  }
>> 
