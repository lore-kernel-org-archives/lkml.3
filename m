Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaI2Ep2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:45:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38356 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaI2Ep1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:45:27 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4] perf tools: Fix build-id matching on vmlinux
References: <1411373053-24250-1-git-send-email-namhyung@kernel.org>
	<20140924073356.GB1962@gmail.com>
Date: Mon, 29 Sep 2014 13:45:23 +0900
In-Reply-To: <20140924073356.GB1962@gmail.com> (Ingo Molnar's message of "Wed,
	24 Sep 2014 09:33:56 +0200")
Message-ID: <874mvrhw64.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Arnaldo,

On Wed, 24 Sep 2014 09:33:56 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> @@ -1062,8 +1063,26 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>>  		 * Should be there already, from the build-id table in
>>  		 * the header.
>>  		 */
>> -		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
>> -						     kmmap_prefix);
>> +		struct dso *kernel = NULL;
>> +		struct dso *dso;
>> +
>> +		list_for_each_entry(dso, &machine->kernel_dsos, node) {
>> +			const char *suffix;
>> +			size_t len = strlen(dso->long_name);
>> +
>> +			if (WARN_ONCE(len <= 3, "Too short dso name"))
>> +				continue;
>> +
>> +			suffix = dso->long_name + len - 3;
>> +			if (strcmp(suffix, ".ko")) {
>> +				kernel = dso;
>> +				break;
>> +			}

I just noticed that the modules can be gzip'ed on some system
(e.g. Arch) so that it no longer has the ".ko" suffix.

  $ ls /lib/modules/`uname -r`/kernel/fs/btrfs/
  btrfs.ko.gz


Actually in this case, the dso->long_name cannot be set since when perf
record synthesizes module map events, it checks the ".ko" suffix
also. :/

And I also guess that if one loads a custom module not in a canonical
path, it again cannot find the long name (absolute path) of the module
and it results in no ".ko" suffix in the long name - so the check will
be broken too.


>> +		}
>> +
>> +		if (kernel == NULL)
>> +			kernel = __dsos__findnew(&machine->kernel_dsos,
>> +						 kmmap_prefix);
>
> Please don't break the line just to pacify checkpatch.pl. Other 
> than that:

For non string literals too?  Anyway in this case, it's already broken. :)


>
> Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks anyway! :)

Namhyung
